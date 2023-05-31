Page 50090 "Liquidity Planning"
{
    AutoSplitKey = true;
    Caption = 'Liquiditätsplanung';
    PageType = List;
    SourceTable = "Liquidity Planning";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Basic;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Planned invoice date"; Rec."Planned invoice date")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posted Invoice No."; Rec."Posted Invoice No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

