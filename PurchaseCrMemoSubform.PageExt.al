pageextension 50015 pageextension50015 extends "Purch. Cr. Memo Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field(Leistungsart; Rec.Leistungsart)
            {
                ApplicationArea = All;
                Caption = 'Leistungsart';
            }
            field(Leistungszeitraum; Rec.Leistungszeitraum)
            {
                ApplicationArea = All;
                Caption = 'Leistungszeitraum';
            }
        }
    }
}
