PageExtension 50005 pageextension50005 extends "Customer Card"
{
    layout
    {
        addafter("Last Date Modified")
        {
            field(DATEV; Rec.DATEV)
            {
                ApplicationArea = Basic;
                ShowMandatory = true;
            }
        }
        moveafter("Address 2"; "Post Code")
        moveafter("Copy Sell-to Addr. to Qte From"; "Gen. Bus. Posting Group")
    }
    actions
    {

    }

    var
        AgedAccReceivable: Codeunit "Aged Acc. Receivable";

    var
        ApplicationAreaSetup: Record "Application Area Setup";

    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";

}

