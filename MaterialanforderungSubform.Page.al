Page 50066 "Materialanforderung Subform"
{
    // 001 HF  17.10.19  new fields Liefertermin,"zusätzliche Anforderungen"

    Editable = true;
    PageType = ListPart;
    SourceTable = Materialanforderungzeile;

    layout
    {
        area(content)
        {
            repeater(Anforderungen)
            {
                field("Artikel Nr"; Rec."Artikel Nr")
                {
                    ApplicationArea = Basic;
                    TableRelation = Item."No." where(Blocked = filter(false));

                    trigger OnValidate()
                    var
                        ItemCategory_l: Record "Item Category";
                        ERR_01: label 'The description 2 must be filled.';
                    begin
                        //G-ERP.RS 2019-07-25 +++
                        //IF Item.GET("Artikel Nr") THEN
                        if Item.Get(Rec."Artikel Nr") then begin
                            Rec.Einheit := Item."Base Unit of Measure";

                            /*//G-ERP.RS 2021-05-21 +
                            IF Item."Item Category Code" = 'BLECH' THEN
                              IF Item."Description 2" = '' THEN
                                ERROR(ERR_01);
                            *///G-ERP.RS 2021-05-21 -
                        end;
                        //G-ERP.RS 2019-07-25 ---

                    end;
                }
                field(Beschreibung; Rec.Beschreibung)
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field("Beschreibung 2"; Rec."Beschreibung 2")
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field("Beschreibung 3"; Rec."Beschreibung 3")
                {
                    ApplicationArea = Basic;
                }
                field("Beschreibung 4"; Rec."Beschreibung 4")
                {
                    ApplicationArea = Basic;
                    Caption = 'Zusätzliche Anforderungen 1';

                    trigger OnAssistEdit()
                    var
                        Eingabe_l: Page Eingabe;
                    begin
                        Eingabe_l.SetCaptionText_ML(Rec.FieldCaption("Beschreibung 4"));
                        Eingabe_l.SetValueText_ML(Rec."Beschreibung 4");
                        if Eingabe_l.RunModal() = Action::OK then
                            Rec."Beschreibung 4" := Eingabe_l.GetValueText_ML();
                    end;
                }
                field("Beschreibung 5"; Rec."Beschreibung 5")
                {
                    ApplicationArea = Basic;
                    Caption = 'Zusätzliche Anforderungen 2';

                    trigger OnAssistEdit()
                    var
                        Eingabe_l: Page Eingabe;
                    begin
                        Eingabe_l.SetCaptionText_ML(Rec.FieldCaption("Beschreibung 5"));
                        Eingabe_l.SetValueText_ML(Rec."Beschreibung 5");
                        if Eingabe_l.RunModal() = Action::OK then
                            Rec."Beschreibung 5" := Eingabe_l.GetValueText_ML();
                    end;
                }
                field(MengeWHM; MengeWHM)
                {
                    ApplicationArea = Basic;
                    Caption = 'Menge auf Lager';
                    Editable = false;
                    Enabled = false;

                    trigger OnAssistEdit()
                    var
                        itemLedgerEntry: Record "Item Ledger Entry";
                    begin
                        //G-ERP.RS 2021-07-07 +++ Anfrage#2312202
                        itemLedgerEntry.SetRange("Item No.", Rec."Artikel Nr");
                        itemLedgerEntry.SetRange("Location Code", InventorySetup."Picking Location");
                        //G-ERP.RS 2021-07-09 +++ Anfrage#2312202
                        itemLedgerEntry.SetRange(Open, true);
                        itemLedgerEntry.SetFilter("Remaining Quantity", '<>%1', 0);
                        //G-ERP.RS 2021-07-09 --- Anfrage#2312202
                        Page.RunModal(0, itemLedgerEntry);
                        //G-ERP.RS 2021-07-07 --- Anfrage#2312202
                    end;
                }
                field(Menge; Rec.Menge)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field(Einheit; Rec.Einheit)
                {
                    ApplicationArea = Basic;
                }
                field("Anfrage erstellt"; Rec."Anfrage erstellt")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Liefertermin; Rec.Liefertermin)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup1000000013)
            {
                action("Materialanforderung drucken")
                {
                    ApplicationArea = Basic;

                    trigger OnAction()
                    begin
                        Report.RunModal(50030, true, false, Rec);
                    end;
                }
                action("RecordID finden ")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Scope = Repeater;
                    Visible = false;

                    trigger OnAction()
                    var
                        RecordLink: Record "Record Link";
                    begin
                        if Rec.HasLinks then begin
                            Message('Link vorhanden');
                            RecordLink.SetFilter("Record ID", Format(Rec.RecordId));
                            RecordLink.FindFirst;
                            Message('Das ist die Datensatzverknüpfung: %1', RecordLink."Record ID");
                        end;
                    end;
                }
                action("Anfrage erstellen")
                {
                    ApplicationArea = Basic;
                    Scope = Repeater;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLine: Record "Purchase Line";
                        Vendor: Record Vendor;
                        RecordLink: Record "Record Link";
                    begin
                        PurchaseHeader.Init;
                        PurchaseHeader.Validate("Document Type", PurchaseHeader."document type"::Quote);

                        Vendor.SetRange(Blocked, Vendor.Blocked::" ");
                        if Page.RunModal(27, Vendor) = Action::LookupOK then
                            PurchaseHeader.Validate("Buy-from Vendor No.", Vendor."No.");

                        PurchaseHeader.Validate("Job No.", Projektnr);
                        PurchaseHeader.Insert(true);

                        PurchaseLine.Init;
                        PurchaseLine.Validate("Document Type", PurchaseLine."document type"::Quote);
                        PurchaseLine.Validate("Document No.", PurchaseHeader."No.");
                        PurchaseLine.Validate(Type, PurchaseLine.Type::Item);
                        PurchaseLine.Validate("No.", Rec."Artikel Nr");
                        PurchaseLine.Validate(Quantity, Rec.Menge);
                        PurchaseLine.Validate("Unit of Measure", Rec.Einheit);
                        PurchaseLine.CopyLinks(Rec);
                        PurchaseLine.Insert(true);

                        Rec."Anfrage erstellt" := true;
                        Rec."Anfrage Nr" := PurchaseHeader."No.";
                        Rec.Modify;

                        Page.Run(49, PurchaseHeader);
                    end;
                }
                action("Bestellung erstellen")
                {
                    ApplicationArea = Basic;
                    Scope = Repeater;
                    Visible = false;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLine: Record "Purchase Line";
                        Vendor: Record Vendor;
                        RecordLink: Record "Record Link";
                    begin
                        //G-ERP.RS 2021-07-14 +++
                        // PurchaseHeader.INIT;
                        // PurchaseHeader.VALIDATE("Document Type", PurchaseHeader."Document Type"::Order);
                        //
                        // Vendor.SETRANGE(Blocked, Vendor.Blocked::" ");
                        // IF PAGE.RUNMODAL(27, Vendor) = ACTION::LookupOK THEN
                        //  PurchaseHeader.VALIDATE("Buy-from Vendor No.", Vendor."No.");
                        //
                        // PurchaseHeader.VALIDATE("Job No.", Projektnr);
                        // PurchaseHeader.INSERT(TRUE);
                        //
                        // PurchaseLine.INIT;
                        // PurchaseLine.VALIDATE("Document Type", PurchaseLine."Document Type"::Order);
                        // PurchaseLine.VALIDATE("Document No.", PurchaseHeader."No.");
                        // PurchaseLine.VALIDATE(Type, PurchaseLine.Type::Item);
                        // PurchaseLine.VALIDATE("No.", "Artikel Nr");
                        // PurchaseLine.VALIDATE(Quantity, Menge);
                        // PurchaseLine.VALIDATE("Unit of Measure", Einheit);
                        // PurchaseLine.COPYLINKS(Rec);
                        // PurchaseLine.INSERT(TRUE);
                        //
                        // Rec."Anfrage erstellt" := TRUE;
                        // Rec."Anfrage Nr" := PurchaseHeader."No.";
                        // Rec.MODIFY;
                        //
                        // PAGE.RUN(49, PurchaseHeader);
                        //G-ERP.RS 2021-07-14 ---
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        itemLedgerEntry: Record "Item Ledger Entry";
    begin
        //G-ERP.RS 2021-07-07 +++ Anfrage# 2312202
        MengeWHM := 0;
        itemLedgerEntry.SetRange("Item No.", Rec."Artikel Nr");
        itemLedgerEntry.SetRange("Location Code", InventorySetup."Picking Location");
        itemLedgerEntry.SetRange(Open, true); //G-ERP.RS 2021-07-09
        if itemLedgerEntry.FindSet() then begin
            //G-ERP.RS 2021-07-09 +++ Anfrage# 2312202
            //itemLedgerEntry.CALCSUMS(Quantity);
            //MengeWHM := itemLedgerEntry.Quantity;
            itemLedgerEntry.CalcSums("Remaining Quantity");
            MengeWHM := itemLedgerEntry."Remaining Quantity";
            //G-ERP.RS 2021-07-09 --- Anfrage# 2312202
        end;
        //G-ERP.RS 2021-07-07 --- Anfrage# 2312202
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        itemLedgerEntry: Record "Item Ledger Entry";
    begin
        if Rec."Projekt Nr" <> '' then begin
            Materialanforderung2.SetRange("Projekt Nr", Rec."Projekt Nr");
            Materialanforderung2.SetRange("Lfd Nr", Rec."Lfd Nr");
            if Materialanforderung2.FindLast then
                Lfd := Materialanforderung2."Zeilen Nr"
            else
                Lfd := 0;
            Lfd += 10000;
            Rec."Zeilen Nr" := Lfd;
            Rec.Anforderungsdatum := Today;
        end;

        //G-ERP.RS 2021-07-07 +++ Anfrage# 2312202
        MengeWHM := 0;
        itemLedgerEntry.SetRange("Item No.", Rec."Artikel Nr");
        itemLedgerEntry.SetRange("Location Code", InventorySetup."Picking Location");
        itemLedgerEntry.SetRange(Open, true); //G-ERP.RS 2021-07-09
        if itemLedgerEntry.FindSet() then begin
            //G-ERP.RS 2021-07-09 +++ Anfrage# 2312202
            //itemLedgerEntry.CALCSUMS(Quantity);
            //MengeWHM := itemLedgerEntry.Quantity;
            itemLedgerEntry.CalcSums("Remaining Quantity");
            MengeWHM := itemLedgerEntry."Remaining Quantity";
            //G-ERP.RS 2021-07-09 --- Anfrage# 2312202
        end;
        //G-ERP.RS 2021-07-07 --- Anfrage# 2312202
    end;

    trigger OnOpenPage()
    begin
        InventorySetup.Get();
        InventorySetup.TestField("Picking Location");
    end;

    var
        Projektnr: Code[20];
        Menge: Decimal;
        MengeWHM: Decimal;
        Anfordern: Boolean;
        MaterialanforderungZeile: Record Materialanforderungzeile;
        Materialanforderung2: Record Materialanforderungzeile;
        Lfd: Integer;
        Text1: label 'Projektnr. muss gefüllt sein.';
        Item: Record Item;
        BOMComp: Record "BOM Component";
        BOMComp_tmp: Record "BOM Component" temporary;
        InventorySetup: Record "Inventory Setup";
        lfdnr: Integer;
}

