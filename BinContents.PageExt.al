PageExtension 50062 pageextension50062 extends "Bin Contents"
{
    layout
    {
        addafter("Item No.")
        {
            field("Item Description 2"; Rec."Item Description 2")
            {
                ApplicationArea = Basic;
            }
            field("Item Description 3"; Rec."Item Description 3")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Tariff No."; Rec."Tariff No.")
            {
                ApplicationArea = Basic;
            }
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = Basic;
            }
            field("Unit Cost"; Rec."Unit Cost")
            {
                ApplicationArea = Basic;
            }
            field("Item Description ENU"; Rec."Item Description ENU")
            {
                ApplicationArea = Basic;
            }
            field("Item Description 2 ENU"; Rec."Item Description 2 ENU")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

