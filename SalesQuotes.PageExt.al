PageExtension 50066 pageextension50066 extends "Sales Quotes"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

