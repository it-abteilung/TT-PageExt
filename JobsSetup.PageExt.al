PageExtension 50045 pageextension50045 extends "Jobs Setup"
{
    layout
    {
        modify("Apply Usage Link by Default")
        {
            ApplicationArea = Jobs;
        }

        addafter(Numbering)
        {
            group(Ordner)
            {
                Caption = 'Ordner';
                field(Folder; Rec.Folder)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    {

        addfirst(processing)
        {
            action("Standard Projekt Ordner")
            {
                ApplicationArea = Basic;
                Caption = 'Standard Projekt Ordner';
                RunObject = Page Job_DefaultFolder;
                RunPageView = sorting(Code, Index);
            }
        }
    }
}

