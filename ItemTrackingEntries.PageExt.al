PageExtension 50058 pageextension50058 extends "Item Tracking Entries"
{
    layout
    {
        addfirst(Control1)
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

