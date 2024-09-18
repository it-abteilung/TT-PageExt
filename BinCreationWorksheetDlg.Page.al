page 50013 "Bin Creation Worksheet Dialog"
{
    PageType = StandardDialog;
    Caption = 'Neue Lagerplatzbeschreibung';

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;
                field(NewDescription; NewDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Neue Beschreibung';
                }
            }
        }
    }

    var
        NewDescription: Text[100];

    procedure GetNewDescription(): Text
    begin
        exit(NewDescription);
    end;
}