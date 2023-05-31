PageExtension 50059 pageextension50059 extends "Bin Content"
{
    layout
    {
        addafter("Variant Code")
        {
            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Item Description 2"; Rec."Item Description 2")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Item Description 3"; Rec."Item Description 3")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
}

