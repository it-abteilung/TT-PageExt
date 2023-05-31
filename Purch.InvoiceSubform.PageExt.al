PageExtension 50025 pageextension50025 extends "Purch. Invoice Subform"
{
    layout
    {
        addfirst(PurchDetailLine)
        {
            field(Baugruppe; Rec.Baugruppe)
            {
                ApplicationArea = Basic;
            }
            field(Pos; Rec.Pos)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("No.")
        {
            field("LOT-Nr. / Chargennr."; Rec."LOT-Nr. / Chargennr.")
            {
                ApplicationArea = Basic;
            }
        }

        addafter("Line No.")
        {
            field("CO2 Menge in Kilogramm"; Rec."CO2 Menge in Kilogramm")
            {
                ApplicationArea = Basic;
            }
            field(Leistungsart; Rec.Leistungsart)
            {
                ApplicationArea = Basic;
            }
            field(Leistungszeitraum; Rec.Leistungszeitraum)
            {
                ApplicationArea = basic;
            }
        }
        moveafter("Unit Price (LCY)"; "Line Amount")
    }
}

