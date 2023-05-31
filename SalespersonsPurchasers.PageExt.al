PageExtension 50002 pageextension50002 extends "Salespersons/Purchasers"
{
    Caption = 'Salespersons/Purchasers';
    layout
    {
        addafter("Phone No.")
        {
            field("Fax No. TT"; Rec."Fax No. TT")
            {
                ApplicationArea = Basic;
            }
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = Basic;
            }
            field(Durchwahlnummer; Rec.Durchwahlnummer)
            {
                ApplicationArea = Basic;
            }
        }
    }
}

