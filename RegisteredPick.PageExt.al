PageExtension 50056 pageextension50056 extends "Registered Pick"
{
    layout
    {

        addafter("No. Printed")
        {
            field("Job No"; Rec."Job No")
            {
                ApplicationArea = Basic;
                Editable = false;
                Lookup = false;

                trigger OnDrillDown()
                var
                    Job_l: Record Job;
                begin
                    if Job_l.Get(Rec."Job No") then
                        Page.RunModal(88, Job_l);
                end;
            }
            field(Ressource; Rec.Ressource)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
    }
}

