Page 50066 "Materialanforderung Subform"
{
    // 001 HF  17.10.19  new fields Liefertermin,"zusätzliche Anforderungen"

    Editable = true;
    PageType = ListPart;
    SourceTable = Materialanforderungzeile;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(Anforderungen)
            {

                field("Artikel Nr"; Rec."Artikel Nr")
                {
                    ApplicationArea = Basic;
                    Caption = 'TT-Artikel-Nr.';
                    Editable = IsEditable;
                    TableRelation = Item."No." where(Blocked = filter(false));
                    ToolTip = 'Nur notwendig, wenn Artikel bereits angelegt.';

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
                    Caption = 'Bezeichnung (tech. Angaben, DIN, SDB 1.1, ...)';
                    Editable = IsEditable;
                    QuickEntry = false;

                    trigger OnValidate()
                    var
                        Item: Record Item;
                    begin
                        if NOT Rec."Is Item No." then
                            exit;
                        if Item.Get(Rec."Artikel Nr") then
                            Rec."Artikel Nr" := ''
                        else
                            if Rec.Einheit = '' then begin
                                Rec.Einheit := 'STÜCK';
                            end;
                    end;
                }
                field("Beschreibung 2"; Rec."Beschreibung 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Artikelbeschreibung 2';
                    Editable = false;
                    QuickEntry = false;
                }
                field("Beschreibung 3"; Rec."Beschreibung 3")
                {
                    ApplicationArea = Basic;
                    Caption = 'Artikelbeschreibung 3';
                    Editable = false;
                    QuickEntry = false;
                }
                field("Beschreibung 4"; Rec."Beschreibung 4")
                {
                    ApplicationArea = Basic;
                    Caption = 'Zusätzliche Anforderungen 1';
                    Editable = IsEditable;

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
                    Editable = IsEditable;

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
                field(Menge; Rec.Menge)
                {
                    ApplicationArea = Basic;
                    Caption = 'Angeforderte Menge';
                    Editable = IsEditable;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Requested Quantity"; Rec."Quoted Quantity")
                {
                    ApplicationArea = Basic;
                    Caption = 'Angefragte Menge';
                    Editable = IsPurchaser;
                }
                field(Einheit; Rec.Einheit)
                {
                    ApplicationArea = Basic;
                    Editable = IsEditable;
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
                field("Has Substitute"; Rec."Has Substitute")
                {
                    ApplicationArea = Basic;
                    Caption = 'Hat Alternative';
                    Editable = false;
                    // Visible = false;
                }
                field("Is Substitute"; Rec."Is Substitute")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ist Alternative';
                    Editable = false;
                    // Visible = false;
                }
                field("Zeilen Nr"; Rec."Zeilen Nr")
                {
                    ApplicationArea = Basic;
                    Caption = 'Zeile';
                    Editable = false;
                }
                field("Substitute To Line No."; Rec."Substitute To Line No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Alternative zu Zeile';
                }
                field(VendorText; VendorText)
                {
                    ApplicationArea = Basic;
                    Caption = 'Anfragen';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLine: Record "Purchase Line";
                        MaterialToQuote: Record "Material To Quote";
                        MaterialsToQuote: Page "Materials To Quote";
                    begin
                        Clear(MaterialToQuote);
                        Clear(PurchaseHeader);
                        MaterialToQuote.SetRange("Material No.", Rec."Projekt Nr");
                        MaterialToQuote.SetRange("Material Entry No.", Rec."Lfd Nr");
                        MaterialToQuote.SetRange("Item No.", Rec."Artikel Nr");
                        if MaterialToQuote.FindSet() then
                            repeat
                                PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Quote);
                                PurchaseHeader.SetRange(Serienanfragennr, MaterialToQuote."Serial Quote No.");
                                if PurchaseHeader.FindSet() then begin
                                    repeat
                                        Clear(PurchaseLine);
                                        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                                        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                                        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                                        PurchaseLine.SetRange("No.", Rec."Artikel Nr");
                                        if PurchaseLine.FindSet() then begin
                                            PurchaseHeader.Mark(true);
                                        end;

                                    until PurchaseHeader.Next() = 0;
                                end;
                            until MaterialToQuote.Next() = 0;
                        PurchaseHeader.SetRange(Serienanfragennr);
                        PurchaseHeader.MarkedOnly(true);
                        MaterialsToQuote.SetTableView(PurchaseHeader);
                        MaterialsToQuote.RunModal();
                    end;
                }
                field(Abgehakt; Rec.Abgehakt)
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
            group(Einkauf)
            {
                Visible = IsPurchaser;
                Enabled = IsPurchaser;

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
                    Image = Quote;

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
                                            Materialanforderungszeile."Anfrage erstellt" := true;
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
                    Image = Order;

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
                action(Substitute)
                {
                    ApplicationArea = all;
                    Caption = 'Substitute';
                    Image = ItemSubstitution;

                    trigger OnAction()
                    var
                        Item: Record Item;
                        ItemList: Page "Item List";
                        MaterialZeile: Record Materialanforderungzeile;
                        MaterialZeileNew: Record Materialanforderungzeile;
                        LineNoNew: Integer;
                    begin
                        Item.SetRange(Blocked, false);
                        if Page.RunModal(Page::"Item List", Item) = Action::LookupOK then begin
                            MaterialZeile.Ascending(true);
                            MaterialZeile.SetRange("Projekt Nr", Rec."Projekt Nr");
                            MaterialZeile.SetRange("Lfd Nr", Rec."Lfd Nr");
                            MaterialZeile.SetFilter("Zeilen Nr", '> %1', Rec."Zeilen Nr");
                            if MaterialZeile.FindFirst() then
                                LineNoNew := (Rec."Zeilen Nr" + MaterialZeile."Zeilen Nr") / 2
                            else
                                LineNoNew := Rec."Zeilen Nr" + 10000;

                            MaterialZeileNew.Init();
                            MaterialZeileNew."Projekt Nr" := Rec."Projekt Nr";
                            MaterialZeileNew."Lfd Nr" := Rec."Lfd Nr";
                            MaterialZeileNew."Zeilen Nr" := LineNoNew;
                            MaterialZeileNew.Insert(true);
                            MaterialZeileNew.Validate("Artikel Nr", Item."No.");
                            MaterialZeileNew.Validate(Menge, 0);
                            MaterialZeileNew."Quoted Quantity" := Rec.Menge;
                            MaterialZeileNew."Is Substitute" := true;
                            MaterialZeileNew."Substitute To Line No." := Rec."Zeilen Nr";
                            MaterialZeileNew.Modify();
                            Rec."Quoted Quantity" := 0;
                            Rec."Has Substitute" := true;
                            Rec.Modify();
                        end;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        UserPermissions: Codeunit "User Permissions";
    begin
        InventorySetup.Get();
        InventorySetup.TestField("Picking Location");
        if UserPermissions.HasUserPermissionSetAssigned(UserSecurityId(), CompanyName, 'TT EINKAUF', 1, '00000000-0000-0000-0000-000000000000') then begin
            isPurchaser := true;
        end;
        IsEditable := true;
    end;

    trigger OnAfterGetRecord()
    var
        MaterialKopf: Record Materialanforderungskopf;
        MaterialToQuote: Record "Material To Quote";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        itemLedgerEntry: Record "Item Ledger Entry";
        Counter: Integer;
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
        if MaterialKopf.Get(Rec."Projekt Nr", Rec."Lfd Nr") then
            IsEditable := MaterialKopf.Status = MaterialKopf.Status::erfasst;

        Counter := 0;
        VendorText := '';
        Clear(MaterialToQuote);
        MaterialToQuote.SetRange("Material No.", Rec."Projekt Nr");
        MaterialToQuote.SetRange("Material Entry No.", Rec."Lfd Nr");
        MaterialToQuote.SetRange("Item No.", Rec."Artikel Nr");
        if MaterialToQuote.FindSet() then
            Counter := MaterialToQuote.Count();
        VendorText := Format(Counter) + ' Kreditoren'
    end;


    trigger OnNewRecord(BelowxRec: Boolean)
    var
        itemLedgerEntry: Record "Item Ledger Entry";
    begin
        if Rec."Projekt Nr" <> '' then begin
            // Materialanforderung2.SetRange("Projekt Nr", Rec."Projekt Nr");
            // Materialanforderung2.SetRange("Lfd Nr", Rec."Lfd Nr");
            // if Materialanforderung2.FindLast then
            //     Lfd := Materialanforderung2."Zeilen Nr"
            // else
            //     Lfd := 0;
            // Lfd += 10000;
            // Rec."Zeilen Nr" := Lfd;
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
        IsPurchaser: Boolean;
        IsEditable: Boolean;
        VendorText: Text;
}

