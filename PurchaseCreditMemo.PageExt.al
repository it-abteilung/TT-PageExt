PageExtension 50022 pageextension50022 extends "Purchase Credit Memo"
{

    layout
    {
        addafter(Status)
        {
            field(Leistung; Rec.Leistung)
            {
                ApplicationArea = Basic;
            }
            field("Job No."; Rec."Job No.")
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

