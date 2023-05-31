PageExtension 50027 pageextension50027 extends "Resource List"
{
    Caption = 'Resource List';
    layout
    {
        addafter("Default Deferral Template Code")
        {
            field(Vendor; Rec.Vendor)
            {
                ApplicationArea = Basic;
            }
        }
    }
}

