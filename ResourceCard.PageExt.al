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
        moveafter("Address 2"; "Post Code")
    }
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
}

