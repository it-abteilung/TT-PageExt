page 61012 "WerkzeugTracker API"
{
    PageType = API;
    APIPublisher = 'cnette';
    APIGroup = 'demo';
    APIVersion = 'v2.0';
    EntityCaption = 'WerkzeugTracker';
    EntitySetCaption = 'WerkzeugTracker';
    EntityName = 'werkzeugTracker';
    EntitySetName = 'werkzeugTracker';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    SourceTable = "Werkzeuganf. Tracker";
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
                field(WerkNo; WerkNo)
                {
                    Caption = 'Werk Job No.';
                }
                field(WerkJobNo; WerkJobNo)
                {
                    Caption = 'Werk No.';
                }
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'System ID';
                    Editable = false;
                }
            }
        }
    }

    var
        WorkflowFlag: Boolean;
        WerkJobNo: Code[20];
        WerkNo: Integer;

    trigger OnAfterGetRecord()
    var
    // Werkzeuganforderungskopf: Record Werkzeuganforderungskopf;
    begin
        // Werkzeuganforderungskopf.Reset();
        // Werkzeuganforderungskopf.SetRange(SystemId, Rec."No.");
        // if NOT Werkzeuganforderungskopf.IsEmpty() then begin
        //     if Werkzeuganforderungskopf.FindFirst() then begin
        //         WerkJobNo := Werkzeuganforderungskopf."Projekt Nr";
        //         WerkNo := Werkzeuganforderungskopf."Lfd Nr";
        //     end;
        // end;
    end;
}