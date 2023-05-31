PageExtension 50006 pageextension50006 extends "Customer List"
{
    Caption = 'Customer List';
    layout
    {
        addafter("No.")
        {
            field(DATEV; Rec.DATEV)
            {
                ApplicationArea = Basic;
                Caption = 'Datev';
            }
        }
    }
    actions
    {

        addafter(Sales)
        {
            group(Finance)
            {
                Caption = 'Finance';
                Image = "Report";
                action("Customer - Detail Trial Bal.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer - Detail Trial Bal.';
                    Image = "Report";
                    RunObject = Report "Customer - Detail Trial Bal.";
                }
                action("Customer - Summary Aging")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer - Summary Aging';
                    Image = "Report";
                    RunObject = Report "Customer - Summary Aging";
                }
                action("Customer Detailed Aging")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Detailed Aging';
                    Image = "Report";
                    RunObject = Report "Customer Detailed Aging";
                }
            }
        }
        addafter(Reminder)
        {
            action("Customer - Trial Balance")
            {
                ApplicationArea = Basic;
                Caption = 'Customer - Trial Balance';
                Image = "Report";
                RunObject = Report "Customer - Trial Balance";
            }
        }
        moveafter(ReportAgedAccountsReceivable; General)
    }
}

