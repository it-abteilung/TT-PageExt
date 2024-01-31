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
                    Editable = false;
                    QuickEntry = false;
                }
                field("Beschreibung 3"; Rec."Beschreibung 3")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    QuickEntry = false;
                }
                field("Beschreibung 4"; Rec."Beschreibung 4")
                {
                    ApplicationArea = Basic;
                    Caption = 'Zusätzliche Anforderungen 1';

                    // trigger OnAssistEdit()
                    // var
                    //     Eingabe_l: Page Eingabe;
                    // begin
                    //     Eingabe_l.SetCaptionText_ML(Rec.FieldCaption("Beschreibung 4"));
                    //     Eingabe_l.SetValueText_ML(Rec."Beschreibung 4");
                    //     if Eingabe_l.RunModal() = Action::OK then
                    //         Rec."Beschreibung 4" := Eingabe_l.GetValueText_ML();
                    // end;
                }
                field("Beschreibung 5"; Rec."Beschreibung 5")
                {
                    ApplicationArea = Basic;
                    Caption = 'Zusätzliche Anforderungen 2';

                    // trigger OnAssistEdit()
                    // var
                    //     Eingabe_l: Page Eingabe;
                    // begin
                    //     Eingabe_l.SetCaptionText_ML(Rec.FieldCaption("Beschreibung 5"));
                    //     Eingabe_l.SetValueText_ML(Rec."Beschreibung 5");
                    //     if Eingabe_l.RunModal() = Action::OK then
                    //         Rec."Beschreibung 5" := Eingabe_l.GetValueText_ML();
                    // end;
                }
                field(MengeWHM; MengeWHM)
                {
                    ApplicationArea = Basic;
                    Caption = 'Menge auf Lager';
                    Editable = false;
                    Enabled = false;

                    trigger OnAssistEdit()
                    var
                        ItemLedgerEntry: Record "Item Ledger Entry";
                    begin
                        //G-ERP.RS 2021-07-07 +++ Anfrage#2312202
                        ItemLedgerEntry.SetRange("Item No.", Rec."Artikel Nr");
                        ItemLedgerEntry.SetRange("Location Code", InventorySetup."Picking Location");
                        //G-ERP.RS 2021-07-09 +++ Anfrage#2312202
                        ItemLedgerEntry.SetRange(Open, true);
                        ItemLedgerEntry.SetFilter("Remaining Quantity", '<>%1', 0);
                        //G-ERP.RS 2021-07-09 --- Anfrage#2312202
                        Page.RunModal(0, ItemLedgerEntry);
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
            group(Funktionen)
            {
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
                        Materialanforderungskopf: Record Materialanforderungskopf;
                        Materialanforderungszeile: Record Materialanforderungzeile;
                        RecRef: RecordRef;
                        SelectionFilterManagement: Codeunit SelectionFilterManagement;
                        Quantity: Decimal;
                        LineCounter: Integer;
                    begin
                        Materialanforderungskopf.Reset();
                        Materialanforderungszeile.Reset();
                        Vendor.Reset();

                        Materialanforderungskopf.SetRange("Projekt Nr", Rec."Projekt Nr");
                        Materialanforderungskopf.SetRange("Lfd Nr", Rec."Lfd Nr");
                        CurrPage.SetSelectionFilter(Materialanforderungszeile);
                        RecRef.GetTable(Materialanforderungszeile);
                        Materialanforderungszeile.SetFilter("Lfd Nr", SelectionFilterManagement.GetSelectionFilter(RecRef, Materialanforderungszeile.FieldNo("Lfd Nr")));

                        Vendor.SetRange(Blocked, Vendor.Blocked::" ");
                        if Materialanforderungskopf.FindFirst() then
                            if Page.RunModal(27, Vendor) = Action::LookupOK then begin

                                PurchaseHeader.Init();
                                PurchaseHeader.Validate("Document Type", PurchaseHeader."Document Type"::Quote);
                                PurchaseHeader.Insert(true);

                                PurchaseHeader.Validate("Job No.", Materialanforderungskopf."Projekt Nr");
                                PurchaseHeader.Validate("Buy-from Vendor No.", Vendor."No.");
                                PurchaseHeader.Validate("Buy-from Vendor Name", Vendor.Name);
                                PurchaseHeader.Modify();

                                if NOT Materialanforderungszeile.IsEmpty() then
                                    if Materialanforderungszeile.FindSet() then
                                        repeat
                                            Quantity := Materialanforderungszeile.Menge;

                                            LineCounter += 10000;
                                            PurchaseLine.Init();
                                            PurchaseLine.Validate("Document Type", PurchaseLine."Document Type"::Quote);
                                            PurchaseLine.Validate("Document No.", PurchaseHeader."No.");
                                            PurchaseLine.Validate("Line No.", LineCounter);
                                            PurchaseLine.Insert(true);
                                            PurchaseLine.Validate("Type", PurchaseLine.Type::Item);
                                            PurchaseLine.Validate("No.", Materialanforderungszeile."Artikel Nr");
                                            PurchaseLine.Validate(Quantity, Materialanforderungszeile.Menge);
                                            PurchaseLine.Validate("Unit of Measure", Materialanforderungszeile.Einheit);
                                            PurchaseLine.Validate("Unit of Measure Code", Materialanforderungszeile.Einheit);
                                            PurchaseLine.Validate("Description 4", Materialanforderungszeile."Beschreibung 4");
                                            PurchaseLine.Validate("Description 5", Materialanforderungszeile."Beschreibung 5");
                                            PurchaseLine.Modify();
                                            Materialanforderungszeile.Validate("Anfrage erstellt", true);
                                            Materialanforderungszeile.Modify();
                                        until Materialanforderungszeile.Next() = 0;
                                Page.Run(49, PurchaseHeader);
                            end;
                    end;
                }
                action("Bestellung erstellen")
                {
                    ApplicationArea = Basic;
                    Scope = Repeater;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLine: Record "Purchase Line";
                        Vendor: Record Vendor;
                        Materialanforderungskopf: Record Materialanforderungskopf;
                        Materialanforderungszeile: Record Materialanforderungzeile;
                        RecRef: RecordRef;
                        SelectionFilterManagement: Codeunit SelectionFilterManagement;
                        Quantity: Decimal;
                        LineCounter: Integer;
                    begin
                        Materialanforderungskopf.Reset();
                        Materialanforderungszeile.Reset();
                        Vendor.Reset();

                        Materialanforderungskopf.SetRange("Projekt Nr", Rec."Projekt Nr");
                        Materialanforderungskopf.SetRange("Lfd Nr", Rec."Lfd Nr");
                        CurrPage.SetSelectionFilter(Materialanforderungszeile);
                        RecRef.GetTable(Materialanforderungszeile);
                        Materialanforderungszeile.SetFilter("Lfd Nr", SelectionFilterManagement.GetSelectionFilter(RecRef, Materialanforderungszeile.FieldNo("Lfd Nr")));

                        Vendor.SetRange(Blocked, Vendor.Blocked::" ");
                        if Materialanforderungskopf.FindFirst() then
                            if Page.RunModal(27, Vendor) = Action::LookupOK then begin

                                PurchaseHeader.Init();
                                PurchaseHeader.Validate("Document Type", PurchaseHeader."Document Type"::Order);
                                PurchaseHeader.Insert(true);

                                PurchaseHeader.Validate("Job No.", Materialanforderungskopf."Projekt Nr");
                                PurchaseHeader.Validate("Buy-from Vendor No.", Vendor."No.");
                                PurchaseHeader.Validate("Buy-from Vendor Name", Vendor.Name);
                                PurchaseHeader.Modify();

                                if NOT Materialanforderungszeile.IsEmpty() then
                                    if Materialanforderungszeile.FindSet() then
                                        repeat
                                            Quantity := Materialanforderungszeile.Menge;

                                            LineCounter += 10000;
                                            PurchaseLine.Init();
                                            PurchaseLine.Validate("Document Type", PurchaseLine."Document Type"::Order);
                                            PurchaseLine.Validate("Document No.", PurchaseHeader."No.");
                                            PurchaseLine.Validate("Line No.", LineCounter);
                                            PurchaseLine.Insert(true);
                                            PurchaseLine.Validate("Type", PurchaseLine.Type::Item);
                                            PurchaseLine.Validate("No.", Materialanforderungszeile."Artikel Nr");
                                            PurchaseLine.Validate(Quantity, Materialanforderungszeile.Menge);
                                            PurchaseLine.Validate("Unit of Measure", Materialanforderungszeile.Einheit);
                                            PurchaseLine.Validate("Unit of Measure Code", Materialanforderungszeile.Einheit);
                                            PurchaseLine.Validate("Description 4", Materialanforderungszeile."Beschreibung 4");
                                            PurchaseLine.Validate("Description 5", Materialanforderungszeile."Beschreibung 5");
                                            PurchaseLine.Modify();
                                            Materialanforderungszeile.Validate("Anfrage erstellt", true);
                                            Materialanforderungszeile.Modify();
                                        until Materialanforderungszeile.Next() = 0;
                                Page.Run(49, PurchaseHeader);
                            end;
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
        MaterialanforderungZeile: Record Materialanforderungzeile;
        Materialanforderung2: Record Materialanforderungzeile;
        Lfd: Integer;
        Text1: label 'Projektnr. muss gefüllt sein.';
        Item: Record Item;
        InventorySetup: Record "Inventory Setup";
}

