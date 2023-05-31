page 61013 "Werkzeuganforderungzeile API"
{
    PageType = API;
    APIPublisher = 'cnette';
    APIGroup = 'demo';
    APIVersion = 'v2.0';
    EntityCaption = 'WerkzeuganforderungZeile';
    EntitySetCaption = 'WerkzeuganforderungZeile';
    EntityName = 'werkzeuganforderungZeile';
    EntitySetName = 'werkzeuganforderungZeile';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    SourceTable = "Werkzeuganforderungzeile";
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."Lfd Nr")
                {
                    Caption = 'No';
                }
                field(JobNo; Rec."Projekt Nr")
                {
                    Caption = 'Job No.';
                }
                field(ItemNo; Rec."Artikel Nr")
                {
                    Caption = 'Item No';
                }
                field(Description; Rec.Beschreibung)
                {
                    Caption = 'Description';
                }
                field(Description2; Rec."Beschreibung 2")
                {
                    Caption = 'Description2';
                }
                field(Quantity; Rec.Menge)
                {
                    Caption = 'Quantity';
                }
                field(ContainsHazardousSubstance; Rec."Contains Hazardous Substance")
                {
                    Caption = 'Contains Hazardous Substance';
                }
                field(HazardAcceptedBy; Rec."Hazard Accepted By")
                {
                    Caption = 'Hazard Accepted By';
                }
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'System ID';
                    Editable = false;
                }
                field(Supervisor; Supervisor)
                {

                }
            }
        }
    }

    var
        Supervisor: Text;

    trigger OnAfterGetRecord()
    var
    // Job: Record Job;
    // Resource: Record Resource;
    begin
        // Job.Reset();
        // Resource.Reset();
        // if Job.Get(Rec."Projekt Nr") then
        //     if Resource.Get(Job.Verfasser) then
        //         Supervisor := Resource."E-Mail";
    end;
}