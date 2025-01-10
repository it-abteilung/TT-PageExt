page 50087 "Workflow Context API"
{
    PageType = API;
    APIPublisher = 'cnette';
    APIGroup = 'demo';
    APIVersion = 'v2.0';
    EntityCaption = 'workflowContext';
    EntitySetCaption = 'workflowContext';
    EntityName = 'workflowContext';
    EntitySetName = 'workflowContext';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    SourceTable = "Workflow Approval Data";
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(recordId; Rec."Record Id")
                {
                    Caption = 'Record Id';
                }
                field(handled; Rec.Handled)
                {
                    Caption = 'Handled';
                }
                field(prevStatus; Rec."Prev Status")
                {
                    Caption = 'Prev Status';
                }
                field(rejectionReason; Rec."Rejection Reason")
                {
                    Caption = 'Rejection Reason';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(workflowContext; Rec."Workflow Context")
                {
                    Caption = 'Workflow Context';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}