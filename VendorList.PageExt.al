pageextension 50016 "pageexntension50016" extends "Vendor List"
{
    layout
    {
        addlast(Control1)
        {
            field(DATEV; Rec.DATEV)
            {
                Caption = 'DATEV';
                ApplicationArea = All;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
