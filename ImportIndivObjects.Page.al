pageextension 50008 "Import Indiv Objects" extends "Config. Package Card"
{
    actions
    {
        addlast("F&unctions")
        {
            action("Import Individualfelder")
            {
                RunObject = xmlport ImportIndividualFields;
                Caption = 'Import Individualfelder';
                ApplicationArea = All;
            }
        }
    }
}
