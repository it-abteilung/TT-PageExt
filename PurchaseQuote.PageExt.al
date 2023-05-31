PageExtension 50019 pageextension50019 extends "Purchase Quote"
{
    layout
    {
        addafter("Buy-from Contact")
        {
            field("Angebotsabgabe bis"; Rec."Angebotsabgabe bis")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("No. of Archived Versions")
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Basic;
            }
            field(Leistung; Rec.Leistung)
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Status)
        {
            field("Keine Angebotsabgabe"; Rec."Keine Angebotsabgabe")
            {
                ApplicationArea = Basic;
            }
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = Basic;
                Caption = 'Your Reference';
            }
            field(Bestellnummer; Rec.Bestellnummer)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("CO2 Menge in Kilogramm"; Rec."CO2 Menge in Kilogramm")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        modify(Release)
        {
            trigger OnAfterAction()
            var
                ReleasePurchDoc: Codeunit "Release Purchase Document";
            begin
                ReleasePurchDoc.PerformManualRelease(Rec);
                //G-ERP.KBS 2017-09-04 +
                IF Rec."Document Type" = Rec."Document Type"::Quote THEN BEGIN
                    PurchaseLine.SETRANGE("Document Type", Rec."Document Type");
                    PurchaseLine.SETRANGE("Document No.", Rec."No.");
                    PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                    IF PurchaseLine.FINDSET THEN
                        REPEAT
                            CLEAR(PurchasePrice);
                            PurchasePrice.SETRANGE("Item No.", PurchaseLine."No.");
                            PurchasePrice.SETRANGE("Vendor No.", Rec."Buy-from Vendor No.");
                            IF PurchasePrice.FINDSET THEN
                                REPEAT
                                    IF PurchasePrice."Ending Date" = 0D THEN BEGIN
                                        PurchasePrice."Ending Date" := TODAY;
                                        PurchasePrice.MODIFY;
                                    END;
                                UNTIL PurchasePrice.NEXT = 0;
                            CLEAR(PurchasePrice);
                            PurchasePrice."Item No." := PurchaseLine."No.";
                            PurchasePrice."Vendor No." := Rec."Buy-from Vendor No.";
                            PurchasePrice."Direct Unit Cost" := PurchaseLine."Direct Unit Cost";
                            PurchasePrice."Starting Date" := TODAY;
                            IF PurchasePrice.INSERT THEN;
                            IF PurchaseLine."Vendor Item No." <> '' THEN BEGIN
                                ItemVendor.SETRANGE("Item No.", PurchaseLine."No.");
                                ItemVendor.SETRANGE("Vendor No.", Rec."Buy-from Vendor No.");
                                IF NOT ItemVendor.GET(PurchaseLine."No.") THEN BEGIN
                                    ItemVendor."Item No." := PurchaseLine."No.";
                                    ItemVendor."Vendor No." := Rec."Buy-from Vendor No.";
                                    ItemVendor."Vendor Item No." := PurchaseLine."Vendor Item No.";
                                    ItemVendor.Description := PurchaseLine.Description;
                                    ItemVendor."Description 2" := PurchaseLine."Description 2";
                                    IF ItemVendor.INSERT THEN;
                                END
                                //G-ERP.KBS 2018-08-28 + lt. Anfrage#230674: NAV 2017 - Anfrage/Update Artikeldaten
                                ELSE BEGIN
                                    ItemVendor."Vendor Item No." := PurchaseLine."Vendor Item No.";
                                    ItemVendor.Description := PurchaseLine.Description;
                                    ItemVendor."Description 2" := PurchaseLine."Description 2";
                                    ItemVendor.MODIFY;
                                END;
                                //G-ERP.KBS 2018-08-28 -
                            END;
                        UNTIL PurchaseLine.NEXT = 0;
                END;
                //G-ERP.KBS 2017-09-04 -

            end;

        }
        addafter(Approval)
        {
            action("Print TP")
            {
                ApplicationArea = Basic;
                Caption = 'Drucken TP';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    l_PurchaseHeader: Record "Purchase Header";
                begin
                    CurrPage.SetSelectionFilter(l_PurchaseHeader);
                    Report.RunModal(50028, true, false, l_PurchaseHeader);
                end;
            }
            action("Serienanfrage erstellen")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                var
                    l_PurchaseHeader: Record "Purchase Header";
                    PurchaseLine: Record "Purchase Line";
                    ItemVendor: Record "Item Vendor";
                    VendorSerienanfrage: Record "Vendor - Serienanfrage";
                begin
                    if Rec.Serienanfragennr <> '' then begin
                        l_PurchaseHeader.Get(Rec."Document Type", Rec.Serienanfragennr);
                        Page.RunModal(50060, l_PurchaseHeader, l_PurchaseHeader."No.");
                    end else begin
                        PurchaseLine.SetRange("Document Type", Rec."Document Type");
                        PurchaseLine.SetRange("Document No.", Rec."No.");
                        if PurchaseLine.FindSet then begin
                            repeat
                                ItemVendor.SetRange("Item No.", PurchaseLine."No.");
                                if ItemVendor.FindSet then
                                    repeat
                                        VendorSerienanfrage.Validate("No.", ItemVendor."Vendor No.");
                                        VendorSerienanfrage.Serienanfragenr := Rec."No.";
                                        if VendorSerienanfrage.Insert then;
                                    until ItemVendor.Next = 0;
                            until PurchaseLine.Next = 0;
                        end;
                        Commit;
                        CurrPage.SetSelectionFilter(l_PurchaseHeader);
                        Page.RunModal(50060, l_PurchaseHeader, Rec."No.");
                    end;
                end;
            }
            action(Serienanfragenmatrix)
            {
                ApplicationArea = Basic;

                trigger OnAction()
                var
                    l_PurchaseHeader: Record "Purchase Header";
                    Text001: label 'Zu der Einkaufsanfrage gibt es keine Serienanfragen.';
                begin
                    if Rec.Serienanfragennr <> '' then begin
                        //CurrPage.SETSELECTIONFILTER(l_PurchaseHeader);
                        l_PurchaseHeader.Get(Rec."Document Type", Rec.Serienanfragennr);
                        Page.RunModal(50054, l_PurchaseHeader, l_PurchaseHeader."No.");
                        //PAGE.RUNMODAL(50054,l_PurchaseHeader,Serienanfragennr);
                    end else
                        Error(Text001);
                end;
            }
            action("Serienanfragen drucken")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                var
                    l_PurchaseHeader: Record "Purchase Header";
                begin
                    l_PurchaseHeader.SetRange(Serienanfragennr, Rec."No.");
                    Report.RunModal(50001, true, false, l_PurchaseHeader);
                end;
            }
        }
    }

    var
        ApprovalEntries: Page "Approval Entries";
        PurchasePrice: Record "Purchase Price";
        PurchaseLine: Record "Purchase Line";
        ItemVendor: Record "Item Vendor";
        CreateIncomingDocumentEnabled: Boolean;
}

