page 50111 "Zeiterfassung API"
{
    PageType = API;
    APIPublisher = 'cnette';
    APIGroup = 'demo';
    APIVersion = 'v2.0';
    EntityCaption = 'timeControlTT';
    EntitySetCaption = 'timeControlTT';
    EntityName = 'timeControlTT';
    EntitySetName = 'timeControlTT';
    ChangeTrackingAllowed = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    ODataKeyFields = SystemId;
    SourceTable = "Job";
    SourceTableView = where("Job Type" = filter('10000 | 30000 | 90000'), SystemModifiedAt = filter('010124..'));
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'description';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}