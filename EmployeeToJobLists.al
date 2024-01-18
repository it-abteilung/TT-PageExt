page 50103 "Employee To Job Lists"
{
    ApplicationArea = All;
    Caption = 'Mitarbeiter zu Projekttyp';
    PageType = List;
    SourceTable = "Employee To Job Type";
    UsageCategory = Administration;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field("Job Type"; Rec."Job Type")
                {
                    ToolTip = 'Specifies the value of the Job Type field.';
                }
            }
        }
    }
}