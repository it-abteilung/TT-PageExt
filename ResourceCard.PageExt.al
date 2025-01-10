PageExtension 50026 pageextension50026 extends "Resource Card"
{
    layout
    {
        addafter("Time Sheet Approver User ID")
        {
            field(Vendor; Rec.Vendor)
            {
                ApplicationArea = Basic;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = Basic;
            }
        }
        addlast("Personal Data")
        {
            field("User ID"; Rec."User Id")
            {
                ApplicationArea = All;
                Caption = 'Benutzer-ID';
            }
        }
        moveafter("Address 2"; "Post Code")
    }
}

