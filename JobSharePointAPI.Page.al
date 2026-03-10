page 50112 "Job SharePoint API"
{
    PageType = API;
    APIPublisher = 'cnette';
    APIGroup = 'demo';
    APIVersion = 'v2.0';
    EntityCaption = 'JobSharePoint';
    EntitySetCaption = 'JobSharePoint';
    EntityName = 'jobSharePoint';
    EntitySetName = 'jobSharePoint';
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
                field(no; Rec."No.") { }
                field(description; Rec.Description) { }
                field(status; Rec.Status) { }
                field(cleanDescription; JobDescription_G) { }
                field(jobType; Rec."Job Type") { }
                field(systemId; Rec.SystemId) { }
                field(hyperlink; Rec.Hyperlink) { }
            }
        }
    }

    var
        JobDescription_G: Text;

    trigger OnAfterGetCurrRecord()
    begin
        JobDescription_G := DelChr(Rec.Description, '=', '<>:"/\|?*');
        JobDescription_G := JobDescription_G.Replace('ä', 'ae');
        JobDescription_G := JobDescription_G.Replace('ö', 'oe');
        JobDescription_G := JobDescription_G.Replace('ü', 'ue');
    end;
}