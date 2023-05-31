pageextension 50009 JobPlanningLinesPageExt extends "Job Planning Lines"
{
    layout
    {
        addlast(content)
        {
            field("EK-Auslöse"; Rec."EK-Auslöse")
            {
                ApplicationArea = All;
            }
            field("EK-Fremdarbeitenkosten"; Rec."EK-Fremdarbeitenkosten")
            {
                ApplicationArea = All;
            }
            field("EK-Fremdlieferungkosten"; Rec."EK-Fremdlieferungkosten")
            {
                ApplicationArea = All;
            }
            field("EK-Hotelkosten"; Rec."EK-Hotelkosten")
            {
                ApplicationArea = All;
            }
            field("EK-Lohnkosten"; Rec."EK-Lohnkosten")
            {
                ApplicationArea = All;
            }
            field("EK-Reisekosten"; Rec."EK-Reisekosten")
            {
                ApplicationArea = All;
            }
            field("EK-Transport"; Rec."EK-Transport")
            {
                ApplicationArea = All;
            }
        }
    }
}
