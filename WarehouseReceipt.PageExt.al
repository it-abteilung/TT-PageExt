PageExtension 50054 pageextension50054 extends "Warehouse Receipt"
{
    layout
    {
        addafter("Sorting Method")
        {
            field("Job No"; Rec."Job No")
            {
                ApplicationArea = Basic;
            }
            field(Ressource; Rec.Ressource)
            {
                ApplicationArea = Basic;
            }
        }
    }
}

