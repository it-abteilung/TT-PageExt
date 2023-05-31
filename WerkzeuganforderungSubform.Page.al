#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50078 "Werkzeuganforderung Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    Editable = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = Werkzeuganforderungzeile;

    layout
    {
        area(content)
        {
            repeater(Anforderungen)
            {
                field("Zeilen Nr"; Rec."Zeilen Nr")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Artikel Nr"; Rec."Artikel Nr")
                {
                    ApplicationArea = Basic;
                    TableRelation = Item."No." where(Blocked = filter(false));

                    trigger OnValidate()
                    var
                        ItemCategory_l: Record "Item Category";
                        ERR_01: label 'The description 2 must be filled.';
                        Item: Record Item;
                    begin
                        //G-ERP.RS 2019-07-25 +++
                        //IF Item.GET("Artikel Nr") THEN
                        if Item.Get(Rec."Artikel Nr") then begin
                            Rec.Einheit := Item."Base Unit of Measure";

                            if Item."Item Category Code" = 'BLECH' then
                                if Item."Description 2" = '' then
                                    Error(ERR_01);
                        end;
                        //G-ERP.RS 2019-07-25 ---

                        Item.Reset();
                        if Rec."Artikel Nr" <> '' then
                            if Item.Get(Rec."Artikel Nr") then
                                if Item."Blocked Tool Requirement" then begin
                                    Error('Der ausgewählte Artikel ist nicht für die Werkzeuganforderung zugelassen');

                                end;
                    end;
                }
                field(Beschreibung; Rec.Beschreibung)
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                    Editable = false;
                }
                field("Beschreibung 2"; Rec."Beschreibung 2")
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                    Editable = false;
                }
                field(Menge; Rec.Menge)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    var
                        Item: Record Item;
                        Quantity: Decimal;
                    begin
                        if Item.Get(Rec."Artikel Nr") then begin
                            Item.CalcFields(Inventory);
                            Quantity := Rec.Menge - Item.Inventory;
                            if Quantity > 0 then
                                Rec.Delta := Quantity
                            else
                                Rec.Delta := 0;
                            CurrPage.Update();
                        end;
                    end;
                }
                field(Delta; Rec.Delta)
                {
                    ApplicationArea = all;
                    Caption = 'Unterdeckung';
                    Editable = false;
                    StyleExpr = StyleExprText;
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
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(MultiLine)
            {
                Caption = 'Mehrfachauswahl';

                action(MultiLineAction1)
                {
                    ApplicationArea = all;
                    Caption = 'Mehrfachauswahl';
                    Image = ItemLines;

                    trigger OnAction()
                    var
                        LfdNr: Integer;
                        Item: Record Item;
                        BinContent: Record "Bin Content";
                        WerkzeugAuswahl: Page "Werkzeuganf. Auswahl";
                        WerkzeuganforderungKopf: Record WerkzeuganforderungsKopf;
                        WerkzeuganforderungZeile: Record Werkzeuganforderungzeile;
                        TempWerkzeuganforderung: Record "Temp. Werkzeuganforderung" temporary;
                        PrevValue: Code[20];
                        Quantity: Decimal;
                        Counter: Integer;
                    begin
                        PrevValue := '';
                        BinContent.Reset();
                        Item.Reset();
                        BinContent.SetCurrentKey("Item No.");
                        BinContent.SetAscending("Item No.", true);
                        BinContent.SetFilter("Bin Code", '%1 | %2', 'CV*', 'CH*');
                        if Rec."Projekt Nr" <> '' then begin
                            if BinContent.FindSet() then
                                repeat
                                    if Item.Get(BinContent."Item No.") then begin
                                        if PrevValue <> BinContent."Item No." then
                                            if NOT Item."Blocked Tool Requirement" then
                                                if Item."Item Category Code" <> 'BLECH' then begin
                                                    Item.CalcFields(Inventory);
                                                    TempWerkzeuganforderung."No." := Item."No.";
                                                    TempWerkzeuganforderung.Description := Item.Description;
                                                    TempWerkzeuganforderung."Description 2" := Item."Description 2";
                                                    TempWerkzeuganforderung."Base Unit of Measure" := Item."Base Unit of Measure";
                                                    TempWerkzeuganforderung."Item Category Code" := Item."Item Category Code";
                                                    TempWerkzeuganforderung."Required Quantity" := 0;
                                                    TempWerkzeuganforderung."On-Stock Quantity" := Item."Inventory";
                                                    // TempWerkzeuganforderung."Hazardous Substance" := Item."Hazardous Substance";
                                                    TempWerkzeuganforderung.Insert();
                                                end;
                                        PrevValue := BinContent."Item No.";
                                    end;
                                until BinContent.Next() = 0;
                            WerkzeuganforderungKopf.SetRange("Projekt Nr", Rec."Projekt Nr");
                            Counter := 0;
                            if WerkzeuganforderungKopf.Count() <= 15 then begin
                                if WerkzeuganforderungKopf.FindSet() then
                                    repeat
                                        if counter > 1 then break;
                                        if (Counter = 0) or (Counter = 1) then LfdNr := WerkzeuganforderungKopf."Lfd Nr";
                                        Counter += 1;
                                    until WerkzeuganforderungKopf.Next() = 0;
                            end
                            else
                                if WerkzeuganforderungKopf.FindLast() then LfdNr := WerkzeuganforderungKopf."Lfd Nr";
                            if Page.RunModal(61011, TempWerkzeuganforderung) = Action::LookupOK then begin
                                TempWerkzeuganforderung.SetFilter("Required Quantity", '<> %1', 0);
                                if TempWerkzeuganforderung.FindSet() then
                                    repeat
                                        Clear(WerkzeuganforderungZeile);
                                        WerkzeuganforderungZeile.Reset();
                                        WerkzeuganforderungZeile.Init();
                                        WerkzeuganforderungZeile."Projekt Nr" := Rec."Projekt Nr";
                                        WerkzeuganforderungZeile."Artikel Nr" := TempWerkzeuganforderung."No.";
                                        WerkzeuganforderungZeile.Beschreibung := TempWerkzeuganforderung.Description;
                                        WerkzeuganforderungZeile."Beschreibung 2" := TempWerkzeuganforderung."Description 2";
                                        WerkzeuganforderungZeile.Einheit := TempWerkzeuganforderung."Base Unit of Measure";
                                        WerkzeuganforderungZeile.Menge := TempWerkzeuganforderung."Required Quantity";
                                        Quantity := TempWerkzeuganforderung."Required Quantity" - TempWerkzeuganforderung."On-Stock Quantity";
                                        if Quantity > 0 then WerkzeuganforderungZeile.Delta := Quantity;
                                        WerkzeuganforderungZeile."Lfd Nr" := LfdNr;
                                        WerkzeuganforderungZeile.Anforderungsdatum := Today();
                                        // WerkzeuganforderungZeile."Contains Hazardous Substance" := TempWerkzeuganforderung."Hazardous Substance";
                                        WerkzeuganforderungZeile.Insert();
                                    until TempWerkzeuganforderung.Next() = 0;
                                CurrPage.Update();
                            end;
                        end
                        else
                            Error('Mehrauswahl nur mit Projektnummer möglich');
                    end;
                }
            }
            group(ActionGroup1000000013)
            {
                Caption = 'Sonstiges';
                action("Werkzeuganforderung drucken")
                {
                    ApplicationArea = all;
                    Caption = 'Werkzeuganforderung drucken';

                    trigger OnAction()
                    begin
                        Report.RunModal(50066, true, false, Rec);
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

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLine: Record "Purchase Line";
                        Vendor: Record Vendor;
                        RecordLink: Record "Record Link";
                    begin
                        PurchaseHeader.Init;
                        PurchaseHeader.Validate("Document Type", PurchaseHeader."document type"::Order);

                        Vendor.SetRange(Blocked, Vendor.Blocked::" ");
                        if Page.RunModal(27, Vendor) = Action::LookupOK then
                            PurchaseHeader.Validate("Buy-from Vendor No.", Vendor."No.");

                        PurchaseHeader.Validate("Job No.", Projektnr);
                        PurchaseHeader.Insert(true);

                        PurchaseLine.Init;
                        PurchaseLine.Validate("Document Type", PurchaseLine."document type"::Order);
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
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec."Projekt Nr" <> '' then begin
            Materialanforderung2.SetRange("Projekt Nr", Rec."Projekt Nr");
            Materialanforderung2.SetRange("Lfd Nr", Rec."Lfd Nr");
            if Materialanforderung2.FindLast then
                Lfd := Materialanforderung2."Zeilen Nr"
            else
                Lfd := 0;
            Lfd += 10000;
            // "Zeilen Nr" := Lfd;  // G-ERP.RS 2020-07-29
            Rec.Anforderungsdatum := Today;
        end;
    end;

    trigger OnAfterGetRecord()
    var
        Item: Record Item;
    begin
        if Rec.Delta > 0 then
            StyleExprText := 'Unfavorable'
        else
            StyleExprText := 'Favorable';
    end;

    var
        StyleExprText: Text;
        Projektnr: Code[20];
        Menge: Decimal;
        Anfordern: Boolean;
        MaterialanforderungZeile: Record Materialanforderungzeile;
        Materialanforderung2: Record Materialanforderungzeile;
        Lfd: Integer;
        Text1: label 'Projektnr. muss gefüllt sein.';
        Item: Record Item;
        BOMComp: Record "BOM Component";
        BOMComp_tmp: Record "BOM Component" temporary;
        lfdnr: Integer;
}

