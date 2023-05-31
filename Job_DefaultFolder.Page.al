#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50036 Job_DefaultFolder
{
    AutoSplitKey = true;
    Caption = 'Standard Projekt Ordner';
    PageType = List;
    SourceTable = Job_DefaultFolder;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field("Folder Name"; Rec."Folder Name")
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

