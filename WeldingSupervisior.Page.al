page 50104 "Welding Supervisiors"
{
    PageType = List;
    Caption = 'Schweißaufsichten';
    SourceTable = "Welding Supervisior";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                    Caption = 'Benutzer';
                }
            }
        }
    }
}