#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50061 "Serienanfragen 2"
{
    DeleteAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = "Serienanfragen erstellen";

    layout
    {
        area(content)
        {
            group(Control1000000010)
            {
                field("Projekt Nr"; Rec."Projekt Nr")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000001; "Serienanfrage - SubPage")
            {
                SubPageLink = Serienanfragenr = field("Projekt Nr");
                SubPageView = where("Serienanfrage erstellt" = filter(false));
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Erstellen)
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    erster: Boolean;
                begin
                    erster := true;
                    VendorSerienanfrage.SetRange(Serienanfragenr, Rec."Projekt Nr");
                    VendorSerienanfrage.SetRange("Serienanfrage erstellt", false);
                    if VendorSerienanfrage.FindSet then begin
                        repeat
                            if erster then begin
                                Clear(PurchaseHeader);
                                PurchaseHeader."Document Type" := PurchaseHeader."document type"::Quote;
                                PurchaseHeader.Insert(true);
                                Anfragenr := PurchaseHeader."No.";
                                Kopfdatenuebergabe;
                                Zeilenuebergabe;
                                erster := false;
                            end else begin
                                Clear(PurchaseHeader);
                                PurchaseHeader."Document Type" := PurchaseHeader."document type"::Quote;
                                PurchaseHeader.Insert(true);
                                Kopfdatenuebergabe;
                                Zeilenuebergabe;
                            end;
                        until VendorSerienanfrage.Next = 0;
                        Rec.SetRange("Projekt Nr", Rec."Projekt Nr");
                        Rec.SetRange("Serienanfragen erstellt", false);
                        Rec."Serienanfragen erstellt" := true;
                        Rec.Modify;
                        VendorSerienanfrage.SetRange("Serienanfrage erstellt");
                        if VendorSerienanfrage.FindSet then
                            repeat
                                if not VendorSerienanfrage."Serienanfrage erstellt" then begin
                                    VendorSerienanfrage2 := VendorSerienanfrage;
                                    VendorSerienanfrage2.Serienanfragenr := Anfragenr;
                                    VendorSerienanfrage2."Serienanfrage erstellt" := true;
                                    VendorSerienanfrage2.Insert;
                                    VendorSerienanfrage.Delete;
                                end;
                            until VendorSerienanfrage.Next = 0;
                        Message('Serienanfragen erstellt!');
                        Commit;
                        PurchaseHeader.Get(PurchaseHeader."document type"::Quote, Anfragenr);
                        Page.RunModal(50060, PurchaseHeader, PurchaseHeader."No.");
                    end;
                end;
            }
            action("Mail senden")
            {
                ApplicationArea = Basic;
                Caption = 'Serienanfragen Mail';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    l_PurchaseHeader: Record "Purchase Header";
                    l_Cont: Record Contact;
                    l_Vendor: Record Vendor;
                    Mail: Codeunit Mail;
                    Name: Text[250];
                    FileName: Text[250];
                    ToFile: Text[250];
                    GERW: Codeunit 50001;
                begin
                    // l_PurchaseHeader.SETRANGE("Document Type", "Document Type");
                    // l_PurchaseHeader.SETRANGE(Serienanfragennr, "No.");
                    //
                    // IF l_PurchaseHeader.FINDSET THEN BEGIN
                    //  REPEAT
                    //    l_Vendor.GET(l_PurchaseHeader."Buy-from Vendor No.");
                    //    Name := LOWERCASE(l_PurchaseHeader."Job No.") + '-' + l_PurchaseHeader."No." + '-' +
                    //            LOWERCASE(COPYSTR(l_Vendor."Search Name",1,STRPOS(l_Vendor."Search Name",' ')))
                    //            + '.pdf';
                    //    ToFile := Name;
                    //    FileName := TEMPORARYPATH + ToFile;
                    //    REPORT.SAVEASPDF(50001, FileName, l_PurchaseHeader);
                    //    ToFile := GERW.DownloadToClientFileName(FileName, ToFile);
                    //    l_Cont.GET(l_PurchaseHeader."Buy-from Contact No.");
                    //    IF "Language Code" = 'ENU' THEN
                    //      Mail.NewMessage(l_Cont."E-Mail",'','','Our Inquiry ' + l_PurchaseHeader."Job No." + '/' + l_PurchaseHeader."No.",
                    //                      '',ToFile,TRUE)
                    //    ELSE
                    //      Mail.NewMessage(l_Cont."E-Mail",'','','Unsere Anfrage ' + l_PurchaseHeader."Job No." + '/' + l_PurchaseHeader."No.",
                    //                      '',ToFile,TRUE);
                    //    FILE.COPY(FileName,'C:\Tageskopie\' + Name);
                    //    FILE.ERASE(FileName);
                    //  UNTIL l_PurchaseHeader.NEXT = 0;
                    // END;
                end;
            }
        }
    }

    var
        PurchaseHeader: Record "Purchase Header";
        Vendor: Record Vendor;
        PurchaseLine: Record "Purchase Line";
        NewPurchaseLine: Record "Purchase Line";
        VendorSerienanfrage: Record "Vendor - Serienanfrage";
        VendorSerienanfrage2: Record "Vendor - Serienanfrage";
        ItemVendor: Record "Item Vendor";
        Anfragenr: Code[20];

    local procedure Kopfdatenuebergabe()
    begin
        PurchaseHeader.Serienanfragennr := Anfragenr;
        PurchaseHeader."Document Date" := WorkDate;
        PurchaseHeader.Status := PurchaseHeader.Status::Open;
        PurchaseHeader.Validate("Buy-from Vendor No.", VendorSerienanfrage."No.");
        PurchaseHeader."Buy-from Vendor Name" := VendorSerienanfrage.Name;
        PurchaseHeader."Buy-from Vendor Name 2" := VendorSerienanfrage."Name 2";
        PurchaseHeader."Buy-from Address" := VendorSerienanfrage.Address;
        PurchaseHeader."Buy-from Address 2" := VendorSerienanfrage."Address 2";
        PurchaseHeader."Buy-from Post Code" := VendorSerienanfrage."Post Code";
        PurchaseHeader."Buy-from Contact No." := VendorSerienanfrage."Buy-from Contact No.";
        PurchaseHeader."Buy-from Contact" := VendorSerienanfrage."Buy-from Contact";
        PurchaseHeader."Job No." := Rec."Projekt Nr";
        PurchaseHeader.Modify;
    end;

    local procedure Zeilenuebergabe()
    begin
        Rec.SetRange("Projekt Nr", Rec."Projekt Nr");
        Rec.SetRange("Serienanfragen erstellt", false);
        if Rec.FindSet then
            repeat
                Clear(PurchaseLine);
                PurchaseLine.Validate("Document Type", PurchaseHeader."Document Type");
                PurchaseLine.Validate("Document No.", PurchaseHeader."No.");
                PurchaseLine.Validate("Line No.", Rec.Zeilennr);
                PurchaseLine.Insert(true);
                PurchaseLine.Validate(Type, PurchaseLine.Type::Item);
                PurchaseLine.Validate("No.", Rec."Artikelnr.");
                PurchaseLine.Validate(Description, Rec.Beschreibung);
                PurchaseLine.Validate("Description 2", Rec."Beschreibung 2");
                PurchaseLine.Validate(Quantity, Rec.Menge);
                PurchaseLine.Validate("Unit of Measure", Rec.Einheit);
                PurchaseLine.Validate("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                PurchaseLine.Validate("Pay-to Vendor No.", PurchaseHeader."Pay-to Vendor No.");
                PurchaseLine."Direct Unit Cost" := 0;
                PurchaseLine."Line Amount" := 0;
                PurchaseLine.Modify;
            until Rec.Next = 0;
    end;
}

