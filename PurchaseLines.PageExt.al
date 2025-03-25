PageExtension 50046 pageextension50046 extends "Purchase Lines"
{
    layout
    {
        addafter("Amt. Rcd. Not Invoiced (LCY)")
        {
            field("CO2 Menge in Kilogramm"; Rec."CO2 Menge in Kilogramm")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(Filter_IT)
            {
                ApplicationArea = All;
                Caption = 'Filter IT';

                trigger OnAction()
                begin
                    Rec.SetFilter("Job No.", '%1 | %2 | %3 | %4', '6063', '6087', '6088', '6188');
                    Rec.SetFilter(SystemCreatedAt, '>%1 & <%2', CreateDateTime(20240101D, 0T), CreateDateTime(20250101D, 0T));
                end;
            }
        }
    }
}

