PageExtension 50001 pageextension50001 extends "Company Information"
{
    layout
    {
        addafter(Picture)
        {
            field("Picture 1"; Rec."Picture 1")
            {
                ApplicationArea = Basic;
            }
            field("Picture 2"; Rec."Picture 2")
            {
                ApplicationArea = Basic;
            }
            field("Picture 3"; Rec."Picture 3")
            {
                ApplicationArea = Basic;
            }
        }
    }

}

