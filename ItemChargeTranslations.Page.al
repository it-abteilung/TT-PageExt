Page 50095 "Item Charge Translations"
{
    // AC01 02.02.2022 DAP Created.

    Caption = 'Item Charge Translations';
    DataCaptionFields = "Charge No.";
    PageType = List;
    SourceTable = "Item Charge Translation";

    layout
    {
        area(content)
        {
            repeater(Control1000000001)
            {
                field("Charge No."; Rec."Charge No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }

    }

    actions
    {
    }
}

