#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50029 "Item Seriennr Factbox"
{
    Caption = 'Item Serialno.';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Artikel-Seriennr";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Serial No. Description"; Rec."Serial No. Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the item attribute.';
                }
                field("Serial No. Description 2"; Rec."Serial No. Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the item attribute.';
                }
            }
        }
    }

    actions
    {
    }
}

