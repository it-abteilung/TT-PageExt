page 50086 "Job Custom API"
{
    PageType = API;
    APIPublisher = 'cnette';
    APIGroup = 'demo';
    APIVersion = 'v2.0';
    EntityCaption = 'JobCustom';
    EntitySetCaption = 'JobCustom';
    EntityName = 'jobCustom';
    EntitySetName = 'jobCustom';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    SourceTable = Job;
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    Caption = 'No';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(jobType; Rec."Job Type")
                {
                    Caption = 'Job Type';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(hyperlink; Rec.Hyperlink)
                {
                    Caption = 'Hyperlink';
                }
            }
        }
    }
}