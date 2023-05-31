#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50028 "Inventur-Funktion"
{
    PageType = NavigatePage;

    layout
    {
        area(content)
        {
            field(Scannung; Scan)
            {
                ApplicationArea = Basic;
                Caption = 'Scannung';

                trigger OnValidate()
                begin
                    ArtikelNr := CopyStr(Scan, 1, 6);
                    SerienNr := CopyStr(Scan, 7);
                    if SerienNr = '0000' then
                        SerienNr := '';
                    if SerienNr <> '' then
                        if StrLen(SerienNr) <> 4 then
                            Error('Seriennr. darf nur 4-stellig sein!');

                    Item.Get(ArtikelNr);
                    ItemUnitofMeasure.Get(ArtikelNr, Item."Base Unit of Measure");
                end;
            }
            field(ArtikelNr; ArtikelNr)
            {
                ApplicationArea = Basic;
                Caption = 'Artikel Nr.';
                QuickEntry = false;
                TableRelation = Item."No.";

                trigger OnValidate()
                begin
                    Clear(Item);
                    if not Item.Get(ArtikelNr) then begin
                        Message(Text001, ArtikelNr);
                        Clear(SerienNr);
                        Clear(Menge);
                    end;

                    ItemUnitofMeasure.Get(ArtikelNr, Item."Base Unit of Measure");
                end;
            }
            field(Beschreibung; Item.Description)
            {
                ApplicationArea = Basic;
                Editable = false;
                ShowCaption = false;
            }
            field(SerienNr; SerienNr)
            {
                ApplicationArea = Basic;
                Caption = 'Seriennummer';
                QuickEntry = false;

                trigger OnValidate()
                begin
                    if SerienNr <> '' then begin
                        Menge := 1;
                        if StrLen(SerienNr) <> 4 then
                            Error('Seriennr. darf nur 4-stellig sein!');
                        //  IF NOT ArtikelSeriennr.GET(Artikelnr,Seriennr) THEN
                        //    ERROR('Seriennr. nicht vorhanden!');

                    end;
                end;
            }
            field(Lagerort; Lagerort)
            {
                ApplicationArea = Basic;
                TableRelation = Location.Code;
            }
            field(Menge; Menge)
            {
                ApplicationArea = Basic;
                Caption = 'Menge';
            }
            field(Einheit; ItemUnitofMeasure.Code)
            {
                ApplicationArea = Basic;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    ItemUnitofMeasure.SetRange("Item No.", ArtikelNr);
                    if Page.RunModal(0, ItemUnitofMeasure) = Action::LookupOK then;
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Buchen ")
            {
                ApplicationArea = Basic;
                InFooterBar = true;
                ShortCutKey = 'F9';

                trigger OnAction()
                begin
                    if Lagerort = '' then
                        Lagerort := 'WHV';
                    if SerienNr <> '' then begin

                        ArtikelSeriennr."Item No." := ArtikelNr;
                        ArtikelSeriennr."Serial No." := SerienNr;
                        ArtikelSeriennr.Bestand := true;
                        if ArtikelSeriennr.Insert then;

                        Clear(ItemLedgerEntry);
                        ItemLedgerEntry.SetRange("Item No.", ArtikelNr);
                        ItemLedgerEntry.SetRange("Serial No.", SerienNr);
                        ItemLedgerEntry.SetRange(Open, true);
                        if ItemLedgerEntry.FindFirst then begin
                            if ItemLedgerEntry."Location Code" = Lagerort then begin

                                ArtikelNr := '';
                                SerienNr := '';
                                Menge := 0;
                                // ??? Lagerort := '';
                                Clear(ItemUnitofMeasure);
                                Clear(Item);

                                Message('Fertig!');
                                exit;
                            end
                            else begin
                                Clear(ItemJournalLine);
                                ItemJournalLine.SetRange("Journal Template Name", 'ARTIKEL');
                                ItemJournalLine.SetRange("Journal Batch Name", 'Inventur');
                                if ItemJournalLine.FindLast then
                                    LineNo := ItemJournalLine."Line No.";
                                LineNo += 10000;

                                Clear(ItemJournalLine);
                                ItemJournalLine."Journal Template Name" := 'ARTIKEL';
                                ItemJournalLine."Journal Batch Name" := 'Inventur';
                                ItemJournalLine.Validate("Line No.", LineNo);
                                ItemJournalLine.Validate("Posting Date", Today);
                                ItemJournalLine.Validate("Entry Type", ItemJournalLine."entry type"::"Negative Adjmt.");
                                ItemJournalLine.Validate("Document No.", ItemLedgerEntry."Document No.");
                                ItemJournalLine.Validate("Item No.", ArtikelNr);
                                ItemJournalLine.Validate("Location Code", 'Proj');
                                ItemJournalLine.Validate(Quantity, 1);
                                ItemJournalLine.Validate("Serial No.", SerienNr);
                                ItemJournalLine.Validate("Applies-to Entry", ItemLedgerEntry."Entry No.");
                                ItemJournalLine.Insert(true);

                                Clear(AusstattungPosten2);
                                AusstattungPosten2.SetRange("Artikel Nr", ArtikelNr);
                                AusstattungPosten2.SetRange(Seriennummer, SerienNr);
                                AusstattungPosten2.SetRange(Offen, true);
                                if AusstattungPosten2.FindLast then begin

                                    Clear(AusstattungPosten);
                                    if AusstattungPosten.FindLast then
                                        LfdNrBuchen := AusstattungPosten."Lfd Nr"
                                    else
                                        LfdNrBuchen := 0;
                                    Clear(AusstattungPosten);

                                    LfdNrBuchen += 1;
                                    AusstattungPosten.TransferFields(AusstattungPosten2);
                                    AusstattungPosten."Lfd Nr" := LfdNrBuchen;
                                    AusstattungPosten.Menge := -AusstattungPosten.Menge;
                                    AusstattungPosten.Restmenge := 0;
                                    AusstattungPosten.gebucht := true;
                                    AusstattungPosten.Offen := false;
                                    AusstattungPosten.Buchungsdatum := CurrentDatetime;
                                    AusstattungPosten.Insert;

                                    AusstattungPosten2.Restmenge := 0;
                                    AusstattungPosten2.Offen := false;

                                    AusstattungPosten2.Modify;

                                end;
                            end;
                        end;

                        Clear(ItemJournalLine);
                        ItemJournalLine.SetRange("Journal Template Name", 'ARTIKEL');
                        ItemJournalLine.SetRange("Journal Batch Name", 'Inventur');
                        if ItemJournalLine.FindLast then
                            LineNo := ItemJournalLine."Line No.";
                        LineNo += 10000;

                        Clear(ItemJournalLine);
                        ItemJournalLine."Journal Template Name" := 'ARTIKEL';
                        ItemJournalLine."Journal Batch Name" := 'Inventur';
                        ItemJournalLine.Validate("Line No.", LineNo);
                        ItemJournalLine.Validate("Posting Date", Today);
                        ItemJournalLine.Validate("Entry Type", ItemJournalLine."entry type"::"Positive Adjmt.");
                        ItemJournalLine.Validate("Document No.", 'INVENTUR');
                        ItemJournalLine.Validate("Item No.", ArtikelNr);
                        ItemJournalLine.Validate("Location Code", Lagerort);
                        ItemJournalLine.Validate(Quantity, 1);
                        ItemJournalLine.Validate("Serial No.", SerienNr);
                        ItemJournalLine.Insert(true);

                    end
                    else begin
                        LineNo := 0;
                        Clear(ItemJournalLine);
                        ItemJournalLine.SetRange("Journal Template Name", 'Artikel');
                        ItemJournalLine.SetRange("Journal Batch Name", 'Inventur');
                        if ItemJournalLine.FindLast then
                            LineNo := ItemJournalLine."Line No.";
                        LineNo += 10000;

                        Item.Get(ArtikelNr);
                        Item.CalcFields(Inventory);

                        if Item."Base Unit of Measure" <> ItemUnitofMeasure.Code then
                            Menge := Menge * ItemUnitofMeasure."Qty. per Unit of Measure";

                        if Menge <> Item.Inventory then begin
                            Clear(ItemJournalLine);
                            ItemJournalLine.Validate("Journal Template Name", 'Artikel');
                            ItemJournalLine.Validate("Journal Batch Name", 'Inventur');
                            ItemJournalLine.Validate("Line No.", LineNo);
                            ItemJournalLine.Validate("Posting Date", Today);
                            ItemJournalLine.Validate("Document No.", 'INVENTUR');
                            if Menge < Item.Inventory then
                                ItemJournalLine.Validate("Entry Type", ItemJournalLine."entry type"::"Negative Adjmt.")
                            else
                                ItemJournalLine.Validate("Entry Type", ItemJournalLine."entry type"::"Positive Adjmt.");
                            ItemJournalLine.Validate("Item No.", ArtikelNr);
                            ItemJournalLine.Validate("Location Code", Lagerort);
                            if Menge < Item.Inventory then
                                ItemJournalLine.Validate(Quantity, Item.Inventory - Menge)
                            else
                                ItemJournalLine.Validate(Quantity, Menge - Item.Inventory);
                            ItemJournalLine.Insert(true);
                        end;
                    end;

                    ArtikelNr := '';
                    SerienNr := '';
                    Menge := 0;
                    // ??? Lagerort := '';
                    Clear(ItemUnitofMeasure);
                    Clear(Item);

                    Message('Fertig!');
                end;
            }
        }
    }

    var
        ItemJournalLine: Record "Item Journal Line";
        Ausstattung_Posten: Record Ausstattung_Posten;
        AusstattungPosten: Record Ausstattung_Posten;
        AusstattungPosten2: Record Ausstattung_Posten;
        ArtikelSeriennr: Record "Artikel-Seriennr";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ArtikelNr: Code[20];
        SerienNr: Code[20];
        Menge: Decimal;
        Lagerort: Code[10];
        Item: Record Item;
        Text001: label 'Der Artikel %1 existiert nicht!';
        ItemUnitofMeasure: Record "Item Unit of Measure";
        LineNo: Integer;
        LfdNrBuchen: Integer;
        Scan: Code[40];
}

