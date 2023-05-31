PageExtension 50021 pageextension50021 extends "Purchase Invoice"
{
    layout
    {
        addafter("Job Queue Status")
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Basic;
            }
            field(Leistung; Rec.Leistung)
            {
                ApplicationArea = Basic;
            }
            field(Leistungsart; Rec.Leistungsart)
            {
                ApplicationArea = Basic;
            }
            field(Leistungszeitraum; Rec.Leistungszeitraum)
            {
                ApplicationArea = Basic;
            }
            field("CO2 Menge in Kilogramm"; Rec."CO2 Menge in Kilogramm")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

