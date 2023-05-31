Page 50004 "Material-/Werkzeug-Rücknahme"
{
    DeleteAllowed = false;
    InsertAllowed = false;
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
                    field("Projekt Nr."; Projektnr)
                    {
                        ApplicationArea = Basic;
                        TableRelation = Job."No.";

                        trigger OnValidate()
                        begin
                            CurrPage."AusstattungPosten-SubPage".Page.Werteuebergeben(Projektnr, Mitarbeiternr, Artikelnr, Seriennr);
                            Job.Get(Projektnr);
                            CurrPage.Update(false);
                        end;
                    }
                    field(Projektbeschreibung; Job.Description + ' ' + Job."Description 2")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Projektbeschreibung';
                        Editable = false;
                        MultiLine = false;
                        Width = 1000000;
                    }
                    field("Mitarbeiter Nr."; Mitarbeiternr)
                    {
                        ApplicationArea = Basic;
                        TableRelation = Resource."No.";

                        trigger OnValidate()
                        begin
                            // IF Projektnr = '' THEN
                            //  ERROR('Projektnr. muss eingeben werden!'); //Auskommentiert lt. Tobias Habsch (telefonisch) G-ERP.KBS 2018-08-06

                            CurrPage."AusstattungPosten-SubPage".Page.Werteuebergeben(Projektnr, Mitarbeiternr, Artikelnr, Seriennr);
                            CurrPage.Update(false);
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
                                Error('Bitte Projektnr. eingeben!');                  // Habsch telefonisch 08.06.18 11:30 Uhr
                            Artikelnr := CopyStr(Scan, 1, 6);
                            Seriennr := CopyStr(Scan, 7);
                            if Seriennr = '0000' then
                                Seriennr := '';
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
                        TableRelation = Item."No.";

                        trigger OnValidate()
                        begin
                            // IF STRPOS(Artikelnr, '-') <> 0 THEN BEGIN
                            //  Seriennr := COPYSTR(Artikelnr, STRPOS(Artikelnr, '-') + 1);
                            //  Artikelnr := COPYSTR(Artikelnr, 1, STRPOS(Artikelnr, '-') - 1);
                            // END;

                            /*G-ERP.KBS 2018-10-24 + lt. Tobias Habsch Mail vom 24.10.2018
                            IF Projektnr = '' THEN
                              ERROR('Projektnr. muss eingeben werden!');
                            *///G-ERP.KBS 2018-10-24 -

                            CurrPage."AusstattungPosten-SubPage".Page.Werteuebergeben(Projektnr, Mitarbeiternr, Artikelnr, Seriennr);
                            CurrPage.Update(false);
                            Item.Init;
                            if Item.Get(Artikelnr) then
                                Einheit := Item."Base Unit of Measure";

                        end;
                    }
                    field(Beschreibung; Item.Description)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Beschreibung';
                        Editable = false;
                        QuickEntry = false;
                    }
                    field("Beschreibung 2"; Item."Description 2")
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
                            /*G-ERP.KBS 2018-10-24 + lt. Tobias Habsch Mail vom 24.10.2018
                            IF Projektnr = '' THEN
                              ERROR('Projektnr. muss eingeben werden!');
                            *///G-ERP.KBS 2018-10-24 -
                            if StrLen(Seriennr) <> 4 then
                                Error('Seriennr. darf nur 4-stellig sein!');

                            CurrPage."AusstattungPosten-SubPage".Page.Werteuebergeben(Projektnr, Mitarbeiternr, Artikelnr, Seriennr);
                            CurrPage.Update(false);

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
                    field(Eintragen; Eintragen)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Eintragen';

                        trigger OnValidate()
                        begin
                            if Eintragen then begin
                                // G-ERP.AG 20181107+
                                if (Seriennr <> '') and (Projektnr = '') then begin
                                    Clear(AusstattungPosten2);
                                    AusstattungPosten2.SetRange("Artikel Nr", Artikelnr);
                                    AusstattungPosten2.SetRange(Seriennummer, Seriennr);
                                    AusstattungPosten2.SetRange(Offen, true);
                                    if not AusstattungPosten2.FindLast then begin
                                        AusstattungPosten2.SetRange(Offen);
                                        if not AusstattungPosten2.FindLast then;
                                    end;
                                    Projektnr := AusstattungPosten2."Projekt Nr";
                                    if Projektnr = '' then
                                        Error('Projektnr. muss eingeben werden!');
                                end;
                                // G-ERP.AG 20181107+
                                if Seriennr <> '' then begin
                                    if StrLen(Seriennr) <> 4 then
                                        Error('Seriennr. darf nur 4-stellig sein!');
                                    if not ArtikelSeriennr.Get(Artikelnr, Seriennr) then begin
                                        Error('Seriennr. nicht vorhanden!');
                                        exit;
                                    end;
                                end;

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
                                AusstattungZeile.Postenart := 'RÜCKGABE';
                                AusstattungZeile.Offen := true;
                                AusstattungZeile.Insert;
                            end;

                            Clear(Item);
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
                ShowFilter = false;
                ApplicationArea = all;
            }
            part("AusstattungPosten-SubPage"; "AusstattungPosten-SubPage")
            {
                Caption = 'Posten-Zeilen';
                Editable = true;
                ShowFilter = false;
                SubPageView = where(Offen = filter(true));
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Buchen)
            {
                ApplicationArea = Basic;
                Caption = 'Buchen';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ItemJournalLine: Record "Item Journal Line";
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    LineNo: Integer;
                begin
                    Clear(AusstattungPosten);
                    if AusstattungPosten.FindLast then
                        LfdNrBuchen := AusstattungPosten."Lfd Nr"
                    else
                        LfdNrBuchen := 0;
                    Clear(AusstattungPosten);

                    ProgressWindow.Open('#1######');
                    if AusstattungZeile.FindSet then
                        repeat
                            if AusstattungZeile."Artikel Nr" <> '' then begin
                                LfdNrBuchen += 1;
                                ProgressWindow.Update(1, Lfdnr);
                                AusstattungPosten.TransferFields(AusstattungZeile);
                                AusstattungPosten."Lfd Nr" := LfdNrBuchen;
                                AusstattungPosten.Menge := -AusstattungPosten.Menge;
                                AusstattungPosten.Restmenge := -AusstattungPosten.Restmenge;
                                AusstattungPosten.gebucht := true;
                                AusstattungPosten.Buchungsdatum := CurrentDatetime;
                                AusstattungPosten.Insert;
                                if AusstattungZeile.Restmenge > 0 then begin
                                    Clear(AusstattungPosten2);
                                    AusstattungPosten2.SetRange("Artikel Nr", AusstattungZeile."Artikel Nr");
                                    AusstattungPosten2.SetRange(Seriennummer, AusstattungZeile.Seriennummer);
                                    if AusstattungZeile.Seriennummer = '' then
                                        AusstattungPosten2.SetRange("Projekt Nr", AusstattungZeile."Projekt Nr");
                                    AusstattungPosten2.SetRange(Offen, true);
                                    if AusstattungPosten2.FindLast then begin
                                        AusstattungPosten."Projekt Nr" := AusstattungPosten2."Projekt Nr";
                                        AusstattungPosten."Mitarbeiter Nr" := AusstattungPosten2."Mitarbeiter Nr";
                                        AusstattungPosten.Restmenge := 0;
                                        AusstattungPosten.Offen := false;
                                        AusstattungPosten.Modify;
                                        AusstattungPosten2.Restmenge := 0;
                                        AusstattungPosten2.Offen := false;
                                        AusstattungPosten2.Modify;
                                    end;
                                    if AusstattungPosten2.FindSet then begin
                                        repeat
                                            AusstattungPosten2.Restmenge := 0;
                                            AusstattungPosten2.Offen := false;
                                            AusstattungPosten2.Modify;
                                        until AusstattungPosten2.Next = 0;
                                    end;
                                end;
                            end;
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
                                    ItemJournalLine.Validate("Document No.", AusstattungZeile."Projekt Nr");
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
                        until AusstattungZeile.Next = 0;

                    Clear(AusstattungPosten2);
                    AusstattungPosten2.SetRange(Offen, true);
                    AusstattungPosten2.SetRange(Ausbuchen, true);
                    if AusstattungPosten2.FindSet then
                        repeat
                            if AusstattungPosten2."Menge zurueck" <= AusstattungPosten2.Restmenge then begin
                                LfdNrBuchen += 1;
                                ProgressWindow.Update(1, Lfdnr);
                                AusstattungPosten := AusstattungPosten2;
                                AusstattungPosten."Lfd Nr" := LfdNrBuchen;
                                AusstattungPosten.Postenart := 'RÜCKGABE';
                                AusstattungPosten.Menge := -AusstattungPosten2."Menge zurueck";
                                AusstattungPosten.Restmenge := 0;
                                AusstattungPosten.Offen := false;
                                AusstattungPosten.gebucht := true;
                                AusstattungPosten.Buchungsdatum := CurrentDatetime;
                                AusstattungPosten.Insert;
                                AusstattungPosten2.Restmenge := AusstattungPosten2.Restmenge - AusstattungPosten2."Menge zurueck";
                                AusstattungPosten2.Offen := (AusstattungPosten2.Restmenge <> 0);
                                AusstattungPosten2.Ausbuchen := false;
                                AusstattungPosten2."Menge zurueck" := 0;
                                AusstattungPosten2.Modify;
                            end;
                        until AusstattungPosten2.Next = 0;

                    ProgressWindow.Close;
                    if ItemJournalLine.FindSet then
                        Codeunit.Run(23, ItemJournalLine);                                   // G-ERP.AG 20181107
                    AusstattungZeile.DeleteAll;
                    Clear(AusstattungZeile);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        Projektnr: Code[20];
        Mitarbeiternr: Code[20];
        Artikelnr: Code[20];
        Seriennr: Code[20];
        Menge: Decimal;
        Item: Record Item;
        Job: Record Job;
        AusstattungZeile: Record Ausstattung_Zeile;
        Eintragen: Boolean;
        Lfdnr: Integer;
        ProgressWindow: Dialog;
        AusstattungPosten: Record Ausstattung_Posten;
        AusstattungPosten2: Record Ausstattung_Posten;
        LfdNrBuchen: Integer;
        Scan: Code[40];
        Einheit: Code[10];
        ItemUnitofMeasure: Record "Item Unit of Measure";
        ArtikelSeriennr: Record "Artikel-Seriennr";
}

