#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50082 "Logistik Art Verbindung modify"
{
    DeleteAllowed = true;
    Editable = true;
    PageType = List;
    Permissions = TableData "Whse. Item Entry Relation" = rimd;
    SourceTable = "Whse. Item Entry Relation";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Entry No."; Rec."Item Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field("Source Subtype"; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                }
                field("Source ID"; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                }
                field("Source Batch Name"; Rec."Source Batch Name")
                {
                    ApplicationArea = Basic;
                }
                field("Source Prod. Order Line"; Rec."Source Prod. Order Line")
                {
                    ApplicationArea = Basic;
                }
                field("Source Ref. No."; Rec."Source Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = Basic;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic;
                }
                field("Order Line No."; Rec."Order Line No.")
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

