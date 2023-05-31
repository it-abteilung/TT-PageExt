pageextension 50012 pageextension50012 extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field(Leistungsart; Rec.Leistungsart)
            {
                ApplicationArea = basic;
                Editable = false;
            }
            field(Leistungszeitraum; Rec.Leistungszeitraum)
            {
                ApplicationArea = basic;
                Editable = false;
            }
        }
    }
}
