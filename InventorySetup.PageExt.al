PageExtension 50044 pageextension50044 extends "Inventory Setup"
{
    layout
    {
        addafter("Internal Movement Nos.")
        {
            group(Control100000003)
            {
                Caption = 'Location';
                field("Picking Location"; Rec."Picking Location")
                {
                    ApplicationArea = Basic;
                }
                field("Transit Location"; Rec."Transit Location")
                {
                    ApplicationArea = Basic;
                }
                field("Project Location"; Rec."Project Location")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
}

