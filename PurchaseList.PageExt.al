PageExtension 50023 pageextension50023 extends "Purchase List"
{
    layout
    {

        addafter("Currency Code")
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

