#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50031 "Artikel-Seriennr-SubPage"
{
    PageType = ListPart;
    SourceTable = "Artikel-Seriennr";
    SourceTableView = where(Bestand = const(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(Hersteller; Rec.Hersteller)
                {
                    ApplicationArea = Basic;
                }
                field("Hersteller Typ"; Rec."Hersteller Typ")
                {
                    ApplicationArea = Basic;
                }
                field("Hersteller Seriennr."; Rec."Hersteller Seriennr.")
                {
                    ApplicationArea = Basic;
                }
                field(Strom; Rec.Strom)
                {
                    ApplicationArea = Basic;
                    Visible = VisibleEGeraete;
                }
                field(Spannung; Rec.Spannung)
                {
                    ApplicationArea = Basic;
                    Visible = VisibleEGeraete;
                }
                field(Leistung; Rec.Leistung)
                {
                    ApplicationArea = Basic;
                    Visible = VisibleEGeraete;
                }
                field("Nächste Prüfung"; Rec."Nächste Prüfung")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Baujahr; Rec.Baujahr)
                {
                    ApplicationArea = Basic;
                }
                field("Gewicht (kg)"; Rec."Gewicht (kg)")
                {
                    ApplicationArea = Basic;
                }
                field(Traglast; Rec.Traglast)
                {
                    ApplicationArea = Basic;
                    Visible = VisibleHebezeuge;
                }
                field("Hubhöhe"; Rec.Hubhöhe)
                {
                    ApplicationArea = Basic;
                    Visible = VisibleHebezeuge;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                }
                field(ZG; Rec.ZG)
                {
                    ApplicationArea = Basic;
                }
                field(Lagerort; Lagerort)
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
        Lagerort := 'WHV';
        Clear(Ausstattung_Posten);
        Ausstattung_Posten.SetRange("Artikel Nr", Rec."Item No.");
        Ausstattung_Posten.SetRange(Offen, true);
        Ausstattung_Posten.SetRange(Seriennummer, Rec."Serial No.");
        if Ausstattung_Posten.FindLast then
            Lagerort := Ausstattung_Posten."Projekt Nr";
    end;

    var
        Ausstattung_Posten: Record Ausstattung_Posten;
        Lagerort: Code[20];
        VisibleEGeraete: Boolean;
        VisibleHebezeuge: Boolean;


    procedure SetVisibleSpalten(var Artikelnr: Code[20])
    var
        Item: Record Item;
    begin
        if not Item.Get(Artikelnr) then;
        // Sichtbarkeit Spalten für E-Werkzeug/-Material
        if (CopyStr(Item."No.", 1, 2) = '35') or (CopyStr(Item."No.", 1, 2) = '40') then
            VisibleEGeraete := true
        else
            VisibleEGeraete := false;

        // Sichtbarkeit Spalten für Hebezeuge
        if CopyStr(Item."No.", 1, 2) = '64' then
            VisibleHebezeuge := true
        else
            VisibleHebezeuge := false;
    end;
}

