PageExtension 50014 pageextension50014 extends "Sales Quote"
{
    layout
    {
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
            begin
                if Customer.Get(Rec."Sell-to Customer No.") then
                    HasAddressOnCustomer := Customer."Name 2" <> '';
            end;
        }
        addafter("Sell-to Customer Name")
        {

            field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
            {
                ApplicationArea = Basic;
                Editable = NOT HasAddressOnCustomer;

                ToolTip = 'Der Wert wird nicht auf dem Bericht gedruckt.';
            }
            field(Salutation; Rec.Salutation)
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Status)
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Basic;
                Caption = 'Projektnr.';

                trigger OnValidate()
                var
                    Job: Record Job;
                begin
                    if Job.Get(Rec."Job No.") then begin
                        Rec."External Document No." := Job."External Document No.";
                        Rec."Your Reference" := Job."Your Reference";
                    end;
                end;
            }
            field(Unterschriftscode; Rec.Unterschriftscode)
            {
                ApplicationArea = Basic;

                trigger OnValidate()
                begin
                    Rec."Status Approval 1" := false;
                end;
            }
            field("Status Approval 1"; Rec."Status Approval 1")
            {
                ApplicationArea = Basic;
                Caption = 'Genehmigt';
                Editable = false;
            }
            field("Unterschriftscode 2"; Rec."Unterschriftscode 2")
            {
                ApplicationArea = Basic;
                trigger OnValidate()
                begin
                    Rec."Status Approval 2" := false;
                end;
            }
            field("Status Approval 2"; Rec."Status Approval 2")
            {
                ApplicationArea = Basic;
                Caption = 'Genehmigt 2';
                Editable = false;
            }
            field("Validity (DAYS)"; Rec."Validity (DAYS)")
            {
                ApplicationArea = Basic;
            }
            field(Delivery; Rec.Delivery)
            {
                ApplicationArea = Basic;
            }
            field(Preisstellung; Rec.Preisstellung)
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {

        addfirst(Promoted)
        {
            group("TT Aprrovals")
            {
                Caption = 'Genehmigung anfordern';
                actionref(SubmitProposal; Submit_Proposal)
                {
                }
                actionref(RevokeProposal; Revoke_Proposal)
                {
                }
            }
            group("TT Release")
            {

                Caption = 'Genehmigung freigeben';
                actionref(AcceptProposal; Accept_Proposal)
                {
                }
                actionref(RejectProposal; Reject_Proposal)
                {
                }
            }
        }

        modify(SendApprovalRequest)
        {
            Enabled = false;
        }
        addafter(Print)
        {
            action(Submit_Proposal)
            {
                ApplicationArea = All;
                Caption = 'Genehmigungsanfrage senden';
                // Enabled = Rec.Status = Rec.Status::Created;
                Image = SendApprovalRequest;

                trigger OnAction()
                var
                    SalespersonPurchaser: Record "Salesperson/Purchaser";
                begin
                    Rec.TestField(Unterschriftscode);
                    Rec.TestField("Unterschriftscode 2");

                    // if Rec."Unterschriftscode" = Rec."Unterschriftscode 2" then
                    //     Error(RequesterIsApproverErr);

                    SalespersonPurchaser.SetRange("User ID", UserId);
                    if SalespersonPurchaser.FindFirst() then begin
                        if Rec.Unterschriftscode <> SalespersonPurchaser.Code then
                            Error(WrongSalespersonCodeError, Rec.Unterschriftscode, UserId());
                    end;

                    // Rec."Status Flag" := 'Pending Approval';
                    // TriggerWorkflowContext(Rec, 'Submit');
                end;
            }
            action(Revoke_Proposal)
            {
                ApplicationArea = All;
                Caption = 'Genehmigungsanfrage stornieren';
                // Enabled = Rec.Status = Rec.Status::Open;
                Image = CancelApprovalRequest;

                trigger OnAction()
                begin
                    Rec."Status Flag" := 'Open';
                    TriggerWorkflowContext(Rec, 'Revoke');
                end;
            }
            action(Accept_Proposal)
            {
                ApplicationArea = All;
                Caption = 'Akzeptieren';
                // Enabled = Rec.Status = Rec.Status::Open;
                Image = Approve;

                trigger OnAction()
                var
                    ReleaseSalesDoc: Codeunit "Release Sales Document";
                begin
                    ReleaseSalesDoc.PerformManualRelease(Rec);
                    CurrPage.SalesLines.PAGE.ClearTotalSalesHeader();

                    Rec."Status Flag" := 'Released';
                    TriggerWorkflowContext(Rec, 'Approve');
                end;
            }
            action(Reject_Proposal)
            {
                ApplicationArea = All;
                Caption = 'Ablehnen';
                // Enabled = Rec.Status = Rec.Status::Open;
                Image = Reject;

                trigger OnAction()
                begin
                    Rec."Status Flag" := 'Open';
                    TriggerWorkflowContext(Rec, 'Reject');
                end;
            }
            action("Print TP")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Drucken TP';
                Ellipsis = true;
                Image = Print;

                trigger OnAction()
                var
                    L_SalesHeader: Record "Sales Header";
                begin
                    L_SalesHeader := Rec;
                    L_SalesHeader.SetRecfilter();
                    Report.RunModal(50026, true, false, L_SalesHeader);
                end;
            }
            action(ForceApproval)
            {
                ApplicationArea = all;
                Caption = 'Force Approval';

                trigger OnAction()
                begin
                    rec."Status Approval 1" := true;
                    rec."Status Approval 2" := true;
                    Rec.Modify();
                end;
            }
        }

        addfirst(Category_New)
        {
            actionref(NewCopyHeader; "New Copy Header") { }
            actionref(NewCopyHeaderLines; "New Copy Header Lines") { }

        }
        addfirst(navigation)
        {
            action("New Copy Header")
            {
                ApplicationArea = All;
                Caption = 'Neue Kopie - Kopf';
                Visible = true;
                Enabled = true;
                Image = Add;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesQuotePage: Page "Sales Quote";
                    CopyDocumentMgt: Codeunit "Copy Document Mgt.";
                    SalesSetup: Record "Sales & Receivables Setup";
                    SalesLine: Record "Sales Line";
                begin
                    SalesSetup.Get();
                    CopyDocumentMgt.SetProperties(true, false, false, true, false, SalesSetup."Exact Cost Reversing Mandatory", false);
                    CopyDocumentMgt.CopySalesDoc("Sales Document Type From"::Quote, Rec."No.", SalesHeader);

                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                    if SalesLine.FindSet() then SalesLine.DeleteAll();

                    SalesQuotePage.SetRecord(SalesHeader);
                    SalesQuotePage.Run();
                end;
            }
            action("New Copy Header Lines")
            {
                ApplicationArea = All;
                Caption = 'Neue Kopie - Kopf und Zeilen';
                Visible = true;
                Enabled = true;
                Image = Add;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesQuotePage: Page "Sales Quote";
                    CopyDocumentMgt: Codeunit "Copy Document Mgt.";
                    SalesSetup: Record "Sales & Receivables Setup";
                begin
                    SalesSetup.Get();
                    CopyDocumentMgt.SetProperties(true, false, false, true, false, SalesSetup."Exact Cost Reversing Mandatory", false);
                    CopyDocumentMgt.CopySalesDoc("Sales Document Type From"::Quote, Rec."No.", SalesHeader);

                    SalesQuotePage.SetRecord(SalesHeader);
                    SalesQuotePage.Run();
                end;
            }
        }
    }

    var
        HasAddressOnCustomer: Boolean;
        RequesterIsApproverErr: Label 'Die Felder "Unterschriftencode" und "Unterschriftencode 2" dürfen nicht identisch sein.';
        WrongSalespersonCodeError: Label 'Der Unterschriftencode %1 kann von %2 nicht verwendet werden.';

    // Wird aktuell nicht benötigt
    trigger OnOpenPage()
    var
        TenantMedia: Record "Tenant Media";
        EmployeeSignStore: Record "Employee Sign Store";
    begin
        if NOT Rec."Status Approval 1" then begin
            EmployeeSignStore.SetRange("User Name", UserId);
            if EmployeeSignStore.FindFirst() then begin
                if TenantMedia.Get(EmployeeSignStore.Signature.MediaId) then begin
                    TenantMedia.CalcFields(Content);
                end;
            end
        end;
    end;

    local procedure TriggerWorkflowContext(var SalesHeader_L: Record "Sales Header"; WorkflowContext_L: Text)
    var
        WorkflowApprovalData: Record "Workflow Approval Data";
    begin
        if WorkflowApprovalData.Get(Rec.SystemId) then WorkflowApprovalData.Delete();
        WorkflowApprovalData.Init();
        WorkflowApprovalData."Record Id" := Rec.SystemId;
        WorkflowApprovalData."Workflow Context" := WorkflowContext_L;
        WorkflowApprovalData.Insert(true);
    end;
}

