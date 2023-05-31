#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50006 "Packliste Erfassung"
{
    PageType = NavigatePage;

    layout
    {
        area(content)
        {
            group(Control1000000004)
            {
                field(Packmittel; Packmittel_v)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    QuickEntry = false;
                }
                field("Projektnr."; ProjektNr)
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                    TableRelation = Job."No.";
                }
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

                        // Item.GET(Artikelnr);
                        // Einheit := Item."Base Unit of Measure";
                    end;
                }
                field("Artikelnr."; ArtikelNr)
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                    TableRelation = Item."No.";
                }
                field("Seriennr."; SerienNr)
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field(Menge; Menge_v)
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
            action(Erfassen)
            {
                ApplicationArea = Basic;
                InFooterBar = true;

                trigger OnAction()
                var
                    L_Ausstattung_Posten: Record Ausstattung_Posten;
                    L_Item: Record Item;
                    L_JobJournalLine: Record "Job Journal Line";
                    L_lfdnr: Integer;
                    PackmittelArtikelNr: Code[20];
                    PackmittelSerienNr: Code[20];
                begin
                    Clear(PacklisteErfassung);
                    PacklisteErfassung.SetRange("Projektnr.", ProjektNr);
                    if PacklisteErfassung.FindLast then
                        LfdNr := PacklisteErfassung."Zeilennr."
                    else
                        LfdNr := 0;
                    Clear(PacklisteErfassung);

                    PacklisteErfassung.Packmittel := Packmittel_v;
                    PacklisteErfassung."Projektnr." := ProjektNr;
                    PacklisteErfassung."Artikelnr." := ArtikelNr;
                    PacklisteErfassung."Seriennr." := SerienNr;
                    PacklisteErfassung.Menge := Menge_v;
                    PacklisteErfassung."Zeilennr." := LfdNr + 100;
                    PacklisteErfassung.Insert;

                    //Packmittel miterfassen
                    PackmittelArtikelNr := CopyStr(Packmittel_v, 1, 6);
                    PackmittelSerienNr := CopyStr(Packmittel_v, 7);
                    Clear(PacklisteErfassung);
                    PacklisteErfassung.SetRange("Projektnr.", ProjektNr);
                    PacklisteErfassung.SetRange("Artikelnr.", PackmittelArtikelNr);
                    PacklisteErfassung.SetRange("Seriennr.", PackmittelSerienNr);
                    if not PacklisteErfassung.FindFirst then begin
                        PacklisteErfassung.Packmittel := Packmittel_v;
                        PacklisteErfassung."Projektnr." := ProjektNr;
                        PacklisteErfassung."Artikelnr." := PackmittelArtikelNr;
                        PacklisteErfassung."Seriennr." := PackmittelSerienNr;
                        PacklisteErfassung.Menge := 1;
                        PacklisteErfassung."Zeilennr." := LfdNr + 200;
                        PacklisteErfassung.Insert;
                    end;

                    ProjektNr_sicher := ProjektNr;

                    //In Projekt Buch.-Blatt Zeilen schreiben
                    Clear(PacklisteErfassung);
                    PacklisteErfassung.SetRange("Projektnr.", ProjektNr_sicher);
                    PacklisteErfassung.SetRange(Gebucht, false);
                    if PacklisteErfassung.FindSet then
                        repeat
                            L_Item.Get(PacklisteErfassung."Artikelnr.");
                            if L_lfdnr = 0 then begin
                                Clear(L_JobJournalLine);
                                L_JobJournalLine.SetRange("Journal Template Name", 'PROJEKT');
                                L_JobJournalLine.SetRange("Journal Batch Name", 'PACKLISTE');
                                if L_JobJournalLine.FindLast then
                                    L_lfdnr := L_JobJournalLine."Line No.";
                            end;
                            L_lfdnr += 10000;
                            Clear(L_JobJournalLine);
                            L_JobJournalLine.Validate("Journal Template Name", 'PROJEKT');
                            L_JobJournalLine.Validate("Journal Batch Name", 'PACKLISTE');
                            L_JobJournalLine.Validate("Line No.", L_lfdnr);
                            L_JobJournalLine.Insert(true);
                            L_JobJournalLine.Validate("Posting Date", Today);
                            L_JobJournalLine.Validate("Document No.", 'Packliste' + PacklisteErfassung.Packmittel);
                            L_JobJournalLine.Validate("Job No.", PacklisteErfassung."Projektnr.");
                            L_JobJournalLine.Validate(Type, L_JobJournalLine.Type::Item);
                            L_JobJournalLine.Validate("No.", PacklisteErfassung."Artikelnr.");
                            L_JobJournalLine.Validate(Quantity, PacklisteErfassung.Menge);
                            //      L_JobJournalLine.VALIDATE("Unit of Measure Code",PacklisteErfassung.Einheit);
                            if PacklisteErfassung."Seriennr." <> '' then
                                L_JobJournalLine.Validate("Serial No.", PacklisteErfassung."Seriennr.");
                            L_JobJournalLine.Modify(true);
                            PacklisteErfassung.Gebucht := true;
                            PacklisteErfassung.Modify;
                        until PacklisteErfassung.Next = 0;

                    Scan := '';
                    ArtikelNr := '';
                    SerienNr := '';
                    Menge_v := 0;
                end;
            }
            action(Packmittelscannung)
            {
                ApplicationArea = Basic;
                InFooterBar = true;

                trigger OnAction()
                begin
                    Clear(ScannungEingabefenster);
                    if ScannungEingabefenster.RunModal = Action::OK then begin
                        ScannungEingabefenster.Wertholen(Packmittel_v);
                    end;
                end;
            }
        }
    }

    var
        ProjektNr: Code[10];
        ProjektNr_sicher: Code[10];
        ArtikelNr: Code[20];
        Packmittel_v: Code[20];
        Scan: Code[40];
        SerienNr: Code[20];
        Menge_v: Decimal;
        ScannungEingabefenster: Page "Scannung - Eingabefenster";
        PacklisteErfassung: Record "Packliste Erfassung";
        LfdNr: Integer;
}

