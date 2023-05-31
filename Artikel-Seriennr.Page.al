#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50030 "Artikel-Seriennr"
{
    PageType = List;
    SourceTable = "Artikel-Seriennr";

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
                }
                field(Spannung; Rec.Spannung)
                {
                    ApplicationArea = Basic;
                }
                field(Leistung; Rec.Leistung)
                {
                    ApplicationArea = Basic;
                }
                field("Nächste Prüfung"; Rec."Nächste Prüfung")
                {
                    ApplicationArea = Basic;
                }
                field(Baujahr; Rec.Baujahr)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Description 2"; Rec."Description 2")
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
}

