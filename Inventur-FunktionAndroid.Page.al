#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50035 "Inventur-Funktion Android"
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
            action("Inventur-Buchen")
            {
                ApplicationArea = Basic;
                InFooterBar = true;
                ShortCutKey = 'F9';

                trigger OnAction()
                begin
                    GerwingERPTool.ArtikelInventurBuchung(ArtikelNr, SerienNr, Menge, ItemUnitofMeasure.Code);
                    Message('Fertig!');
                end;
            }
            action("Zugang-Buchen")
            {
                ApplicationArea = Basic;
                InFooterBar = true;

                trigger OnAction()
                begin
                    GerwingERPTool.ArtikelZugangBuchen(ArtikelNr, SerienNr, Menge, ItemUnitofMeasure.Code);
                    Message('Fertig!');
                end;
            }
        }
    }

    var
        GerwingERPTool: Codeunit 50001;
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

