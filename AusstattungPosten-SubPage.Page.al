#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50003 "AusstattungPosten-SubPage"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = ListPart;
    SourceTable = Ausstattung_Posten;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Projekt Nr"; Rec."Projekt Nr")
                {
                    ApplicationArea = Basic;
                    AssistEdit = false;
                    Editable = false;
                }
                field("Mitarbeiter Nr"; Rec."Mitarbeiter Nr")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Mitarbeiter Name"; Rec."Mitarbeiter Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Artikel Nr"; Rec."Artikel Nr")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("ItemRec.Description"; ItemRec.Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Beschreibung';
                    Editable = false;
                }
                field("ItemRec.""Description 2"""; ItemRec."Description 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Beschreibung 2';
                    Editable = false;
                }
                field(Seriennummer; Rec.Seriennummer)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Restmenge; Rec.Restmenge)
                {
                    ApplicationArea = Basic;
                    Caption = 'Menge';
                    Editable = false;
                }
                field(Einheit; Rec.Einheit)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Ausb; Ausb)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ausbuchen';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        Rec.Ausbuchen := Ausb;
                        Clear(Ausstattung_Posten);
                        if Rec.Ausbuchen then begin
                            Ausstattung_Posten.Get(Rec."Lfd Nr");
                            MengZur := Ausstattung_Posten.Restmenge;
                            Rec."Menge zurueck" := MengZur;
                        end else begin
                            MengZur := 0;
                            Rec."Menge zurueck" := MengZur;
                        end;
                    end;
                }
                field(MengZur; MengZur)
                {
                    ApplicationArea = Basic;
                    Caption = 'Menge zurück';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        Rec."Menge zurueck" := MengZur;
                    end;
                }
                field(Buchungsdatum; Rec.Buchungsdatum)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Ausb := Rec.Ausbuchen;
        MengZur := Rec."Menge zurueck";
        Clear(ItemRec);
        if ItemRec.Get(Rec."Artikel Nr") then begin
            if (Rec."Artikel Nr" = '1') or (Rec."Artikel Nr" = '2') then begin
                ItemRec.Description := Rec.Beschreibung;
                ItemRec."Description 2" := Rec."Beschreibung 2";
            end;
        end;
    end;

    var
        Ausstattung_Posten: Record Ausstattung_Posten;
        ItemRec: Record Item;
        Ausb: Boolean;
        MengZur: Decimal;


    procedure Werteuebergeben(Projektnr: Code[20]; Mitarbeiternr: Code[20]; Artikelnr: Code[20]; Seriennr: Code[20])
    begin
        Rec.SetRange("Projekt Nr");
        Rec.SetRange("Mitarbeiter Nr");
        Rec.SetRange("Artikel Nr");
        Rec.SetRange(Seriennummer);
        if Projektnr <> '' then
            Rec.SetRange("Projekt Nr", Projektnr);

        if Mitarbeiternr <> '' then
            Rec.SetRange("Mitarbeiter Nr", Mitarbeiternr);

        if Artikelnr <> '' then
            Rec.SetRange("Artikel Nr", Artikelnr);

        if Seriennr <> '' then
            Rec.SetRange(Seriennummer, Seriennr);

        CurrPage.Update(false);
    end;
}

