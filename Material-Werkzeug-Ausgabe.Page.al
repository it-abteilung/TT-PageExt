Page 50001 "Material-/Werkzeug-Ausgabe"
{
    PageType = Card;
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1000000000)
            {
                group(Control1000000015)
                {
                    field(Projektnr; Projektnr)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Projekt';
                        TableRelation = Job."No.";

                        trigger OnValidate()
                        begin
                            Job.Get(Projektnr);
                        end;
                    }
                    field("Job.Description + ' ' + Job.""Description 2"""; Job.Description + ' ' + Job."Description 2")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Projektbeschreibung';
                        Editable = false;
                        MultiLine = false;
                        Width = 1000000;
                    }
                    field(Mitarbeiternr; Mitarbeiternr)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Mitarbeiter';
                        TableRelation = Resource."No." where(Type = const(Person));

                        trigger OnValidate()
                        begin
                            if Projektnr = '' then
                                Error('Projektnr. muss eingeben werden!');
                        end;
                    }
                }
                group(Control1000000014)
                {
                    field(Scannung; Scan)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Scannung';

                        trigger OnValidate()
                        begin
                            if Projektnr = '' then
                                Error('Projektnr. muss eingeben werden!');

                            Artikelnr := CopyStr(Scan, 1, 6);
                            Seriennr := CopyStr(Scan, 7);
                            if (Seriennr = '0000') or (Seriennr = '') then
                                Seriennr := '';

                            if Seriennr <> '' then
                                if StrLen(Seriennr) <> 4 then
                                    Error('Seriennr. darf nur 4-stellig sein!');

                            Item.Get(Artikelnr);
                            Einheit := Item."Base Unit of Measure";
                        end;
                    }
                    field(Artikelnr; Artikelnr)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Artikel Nr.';
                        QuickEntry = false;
                        TableRelation = Item."No." where(Blocked = const(false));

                        trigger OnValidate()
                        begin
                            // MESSAGE(Artikelnr);
                            // IF STRPOS(Artikelnr, '-') <> 0 THEN BEGIN
                            //  Seriennr := COPYSTR(Artikelnr, STRPOS(Artikelnr, '-') + 1);
                            //  Artikelnr := COPYSTR(Artikelnr, 1, STRPOS(Artikelnr, '-') - 1);
                            //  MESSAGE('Seriennr: %1, Artikelnr: %2', Seriennr, Artikelnr);
                            // END;
                            if Projektnr = '' then
                                Error('Projektnr. muss eingeben werden!');

                            Item.Get(Artikelnr);
                            if Item.Blocked = true then
                                Error('Artikel %1 ist gesperrt!', Item."No.");
                            Einheit := Item."Base Unit of Measure";
                        end;
                    }
                    field("Item.Description"; Item.Description)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Beschreibung';
                        Editable = false;
                        QuickEntry = false;
                    }
                    field("Item.""Description 2"""; Item."Description 2")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Beschreibung 2';
                        Editable = false;
                        QuickEntry = false;
                    }
                    field(Seriennr; Seriennr)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Seriennr.';
                        QuickEntry = false;

                        trigger OnValidate()
                        begin
                            if Projektnr = '' then
                                Error('Projektnr. muss eingeben werden!');

                            if Seriennr <> '' then                                // G-ERP.AG 20181107
                                if StrLen(Seriennr) <> 4 then
                                    Error('Seriennr. darf nur 4-stellig sein!');

                            if not ArtikelSeriennr.Get(Artikelnr, Seriennr) then
                                Error('Seriennr. nicht vorhanden!');

                            if Seriennr <> '' then
                                Menge := 1
                            else
                                Menge := 0;
                        end;
                    }
                    field(Menge; Menge)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Menge';
                    }
                    field(Einheit; Einheit)
                    {
                        ApplicationArea = Basic;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            ItemUnitofMeasure.SetRange("Item No.", Artikelnr);
                            if ItemUnitofMeasure.FindFirst then
                                if Page.RunModal(0, ItemUnitofMeasure) = Action::LookupOK then
                                    Einheit := ItemUnitofMeasure.Code;
                        end;

                        trigger OnValidate()
                        begin
                            if not ItemUnitofMeasure.Get(Artikelnr, Einheit) then
                                Error('Artikeleinheit nicht vorhanden.');
                        end;
                    }
                    field(Chargennr; Chargennr)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Chargennr.';
                    }
                    field(Eintragen; Eintragen)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Eintragen';

                        trigger OnValidate()
                        begin


                            if Eintragen then begin
                                if Projektnr = '' then
                                    Error('Projektnr. muss eingeben werden!');

                                // G-ERP.AG+ 20181107
                                if Seriennr <> '' then begin
                                    if StrLen(Seriennr) <> 4 then
                                        Error('Seriennr. darf nur 4-stellig sein!');
                                    if not ArtikelSeriennr.Get(Artikelnr, Seriennr) then begin
                                        Error('Seriennr. nicht vorhanden!');
                                        exit;
                                    end;
                                end;
                                // G-ERP.AG- 20181107

                                Clear(AusstattungZeile);
                                if AusstattungZeile.FindLast then
                                    Lfdnr := AusstattungZeile."Lfd Nr"
                                else
                                    Lfdnr := 0;
                                Lfdnr += 1;
                                Clear(AusstattungZeile);
                                AusstattungZeile."Lfd Nr" := Lfdnr;
                                AusstattungZeile."Projekt Nr" := Projektnr;
                                AusstattungZeile."Mitarbeiter Nr" := Mitarbeiternr;
                                AusstattungZeile."Artikel Nr" := Artikelnr;
                                AusstattungZeile.Beschreibung := Item.Description;
                                AusstattungZeile."Beschreibung 2" := Item."Description 2";
                                AusstattungZeile.Seriennummer := Seriennr;
                                AusstattungZeile.Menge := Menge;
                                AusstattungZeile.Restmenge := Menge;
                                AusstattungZeile.Einheit := Einheit;
                                AusstattungZeile.Postenart := 'AUSGABE';
                                AusstattungZeile.Offen := true;
                                AusstattungZeile."Lot No." := Chargennr; //G-ERP.RS 2019-03-18
                                AusstattungZeile.Insert;
                            end;

                            Clear(Item);
                            Scan := '';
                            Artikelnr := '';
                            Seriennr := '';
                            Menge := 0;
                            Einheit := '';
                            Eintragen := false;
                            CurrPage.Update(false);
                        end;
                    }
                }
            }
            part(Control1000000010; "AusstattungZeile-SubPage")
            {
                Caption = 'Zeilen';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Zeilen buchen")
            {
                ApplicationArea = Basic;
                Caption = 'Zeilen buchen';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    AusstattungPosten: Record Ausstattung_Posten;
                    AusstattungPosten2: Record Ausstattung_Posten;
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    ItemJournalLine: Record "Item Journal Line";
                    LfdNrBuchen: Integer;
                    LineNo: Integer;
                begin
                    Clear(AusstattungPosten);
                    if AusstattungPosten.FindLast then
                        LfdNrBuchen := AusstattungPosten."Lfd Nr"
                    else
                        LfdNrBuchen := 0;
                    Clear(AusstattungPosten);

                    ProgressWindow.Open('#1######');
                    AusstattungZeile.FindFirst;
                    repeat
                        if AusstattungZeile."Artikel Nr" <> '' then begin
                            LfdNrBuchen += 1;
                            ProgressWindow.Update(1, Lfdnr);
                            if AusstattungZeile.Seriennummer <> '' then begin
                                Clear(AusstattungPosten2);
                                AusstattungPosten2.SetRange("Artikel Nr", AusstattungZeile."Artikel Nr");
                                AusstattungPosten2.SetRange(Seriennummer, AusstattungZeile.Seriennummer);
                                AusstattungPosten2.SetRange(Offen, true);
                                if AusstattungPosten2.FindFirst then begin
                                    AusstattungPosten := AusstattungPosten2;
                                    AusstattungPosten."Lfd Nr" := LfdNrBuchen;
                                    AusstattungPosten.Offen := false;
                                    AusstattungPosten.Postenart := 'RÜCKGABE';
                                    AusstattungPosten.Menge := -AusstattungPosten2.Menge;
                                    AusstattungPosten.Restmenge := 0;
                                    AusstattungPosten.Buchungsdatum := CurrentDatetime;
                                    AusstattungPosten.Insert;
                                    LfdNrBuchen += 1;
                                    AusstattungPosten2.Restmenge := 0;
                                    AusstattungPosten2.Offen := false;
                                    AusstattungPosten2.Modify;
                                end;
                            end;
                            AusstattungPosten.TransferFields(AusstattungZeile);
                            AusstattungPosten."Lfd Nr" := LfdNrBuchen;
                            AusstattungPosten.gebucht := true;
                            AusstattungPosten.Buchungsdatum := CurrentDatetime;
                            AusstattungPosten.Insert;

                            if AusstattungZeile.Seriennummer <> '' then begin
                                Clear(ItemJournalLine);
                                ItemJournalLine.SetRange("Journal Template Name", 'ARTIKEL');
                                ItemJournalLine.SetRange("Journal Batch Name", 'SYSTEM');
                                if ItemJournalLine.FindLast then
                                    LineNo := ItemJournalLine."Line No.";
                                LineNo += 10000;
                                Clear(ItemLedgerEntry);
                                ItemLedgerEntry.SetRange("Item No.", AusstattungZeile."Artikel Nr");
                                ItemLedgerEntry.SetRange("Serial No.", AusstattungZeile.Seriennummer);
                                ItemLedgerEntry.SetRange(Open, true);
                                if ItemLedgerEntry.FindFirst then begin
                                    Clear(ItemJournalLine);
                                    ItemJournalLine."Journal Template Name" := 'ARTIKEL';
                                    ItemJournalLine."Journal Batch Name" := 'SYSTEM';
                                    ItemJournalLine.Validate("Line No.", LineNo);
                                    ItemJournalLine.Validate("Posting Date", Today);
                                    ItemJournalLine.Validate("Entry Type", ItemJournalLine."entry type"::"Negative Adjmt.");
                                    if ItemLedgerEntry."Location Code" = 'WHV' then
                                        ItemJournalLine.Validate("Document No.", ItemLedgerEntry."Location Code")
                                    else
                                        ItemJournalLine.Validate("Document No.", ItemLedgerEntry."Document No.");
                                    ItemJournalLine.Validate("Item No.", AusstattungZeile."Artikel Nr");
                                    ItemJournalLine.Validate("Location Code", ItemLedgerEntry."Location Code");
                                    ItemJournalLine.Validate(Quantity, 1);
                                    ItemJournalLine.Validate("Serial No.", AusstattungZeile.Seriennummer);
                                    ItemJournalLine.Validate("Applies-to Entry", ItemLedgerEntry."Entry No.");
                                    ItemJournalLine.Insert(true);
                                    LineNo += 10000;
                                end;
                                Clear(ItemJournalLine);
                                ItemJournalLine."Journal Template Name" := 'ARTIKEL';
                                ItemJournalLine."Journal Batch Name" := 'SYSTEM';
                                ItemJournalLine.Validate("Line No.", LineNo);
                                ItemJournalLine.Validate("Posting Date", Today);
                                ItemJournalLine.Validate("Entry Type", ItemJournalLine."entry type"::"Positive Adjmt.");
                                ItemJournalLine.Validate("Document No.", AusstattungZeile."Projekt Nr");
                                ItemJournalLine.Validate("Item No.", AusstattungZeile."Artikel Nr");
                                ItemJournalLine.Validate("Location Code", 'PROJ');
                                ItemJournalLine.Validate(Quantity, 1);
                                ItemJournalLine.Validate("Serial No.", AusstattungZeile.Seriennummer);
                                ItemJournalLine.Insert(true);
                            end;

                            if UpperCase(UserId) = 'TURBO-TECHNIK\GERWING-ERP' then begin
                                if AusstattungZeile."Lot No." <> '' then begin
                                    Clear(ItemJournalLine);
                                    ItemJournalLine.SetRange("Journal Template Name", 'ARTIKEL');
                                    ItemJournalLine.SetRange("Journal Batch Name", 'SYSTEM');
                                    if ItemJournalLine.FindLast then
                                        LineNo := ItemJournalLine."Line No.";
                                    LineNo += 10000;
                                    Clear(ItemLedgerEntry);
                                    ItemLedgerEntry.SetRange("Item No.", AusstattungZeile."Artikel Nr");
                                    ItemLedgerEntry.SetRange("Lot No.", AusstattungZeile."Lot No.");
                                    ItemLedgerEntry.SetFilter("Remaining Quantity", '>%1', AusstattungZeile.Menge);
                                    ItemLedgerEntry.SetRange(Open, true);
                                    if ItemLedgerEntry.FindFirst then begin
                                        Clear(ItemJournalLine);
                                        ItemJournalLine."Journal Template Name" := 'ARTIKEL';
                                        ItemJournalLine."Journal Batch Name" := 'SYSTEM';
                                        ItemJournalLine.Validate("Line No.", LineNo);
                                        ItemJournalLine.Validate("Posting Date", Today);
                                        ItemJournalLine.Validate("Entry Type", ItemJournalLine."entry type"::"Negative Adjmt.");
                                        if ItemLedgerEntry."Location Code" = 'WHV' then
                                            ItemJournalLine.Validate("Document No.", ItemLedgerEntry."Location Code")
                                        else
                                            ItemJournalLine.Validate("Document No.", ItemLedgerEntry."Document No.");
                                        ItemJournalLine.Validate("Item No.", AusstattungZeile."Artikel Nr");
                                        ItemJournalLine.Validate("Location Code", ItemLedgerEntry."Location Code");
                                        ItemJournalLine.Validate(Quantity, 1);
                                        ItemJournalLine.Validate("Lot No.", AusstattungZeile."Lot No.");
                                        ItemJournalLine.Validate("Applies-to Entry", ItemLedgerEntry."Entry No.");
                                        ItemJournalLine.Insert(true);
                                        LineNo += 10000;
                                    end else
                                        Error(ERR_01, AusstattungZeile."Artikel Nr", AusstattungZeile."Lot No.", AusstattungZeile.Menge);

                                    Clear(ItemJournalLine);
                                    ItemJournalLine."Journal Template Name" := 'ARTIKEL';
                                    ItemJournalLine."Journal Batch Name" := 'SYSTEM';
                                    ItemJournalLine.Validate("Line No.", LineNo);
                                    ItemJournalLine.Validate("Posting Date", Today);
                                    ItemJournalLine.Validate("Entry Type", ItemJournalLine."entry type"::"Positive Adjmt.");
                                    ItemJournalLine.Validate("Document No.", AusstattungZeile."Projekt Nr");
                                    ItemJournalLine.Validate("Item No.", AusstattungZeile."Artikel Nr");
                                    ItemJournalLine.Validate("Location Code", 'PROJ');
                                    ItemJournalLine.Validate(Quantity, 1);
                                    ItemJournalLine.Validate("Lot No.", AusstattungZeile."Lot No.");
                                    ItemJournalLine.Insert(true);
                                end;
                            end;

                        end;
                    until AusstattungZeile.Next = 0;
                    ProgressWindow.Close;

                    if ItemJournalLine.FindSet then
                        Codeunit.Run(23, ItemJournalLine);                     // G-ERP.AG 20181107

                    AusstattungZeile.DeleteAll;
                    Clear(AusstattungZeile);
                end;
            }
        }
    }

    var
        Projektnr: Code[20];
        Mitarbeiternr: Code[20];
        Artikelnr: Code[20];
        Seriennr: Code[20];
        Chargennr: Code[20];
        Menge: Decimal;
        Item: Record Item;
        Job: Record Job;
        AusstattungZeile: Record Ausstattung_Zeile;
        Eintragen: Boolean;
        Lfdnr: Integer;
        ProgressWindow: Dialog;
        Scan: Code[40];
        Einheit: Code[10];
        ItemUnitofMeasure: Record "Item Unit of Measure";
        ArtikelSeriennr: Record "Artikel-Seriennr";
        ChargenNrVisible: Boolean;
        ERR_01: label 'Es wurden keine offnen Artikelposten von dem Artikel %1 mit der Chargen Nr. %2 und der Restmenge %3 gefunden.';
}

