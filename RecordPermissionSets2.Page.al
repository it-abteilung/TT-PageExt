page 50056 "Record Permission Sets 2"
{
    ApplicationArea = All;
    Caption = 'Aufzeichnung - Berechtigungssätze (Manuell)';
    AdditionalSearchTerms = 'Aufzeichnung,Berechtigung,Rechte,Log,Logging';
    PageType = Card;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;
                field(TextBox; TextBox)
                {
                    ShowCaption = false;
                }
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref(StartRecording; Start_Recording) { }
            actionref(StopRecording; Stop_Recording) { }
        }
        area(Processing)
        {
            action(Start_Recording)
            {
                ApplicationArea = All;
                Caption = 'Start';
                Enabled = RecordSwitch;

                trigger OnAction()
                begin
                    LogTablePermissions.Start();
                    RecordSwitch := not RecordSwitch;
                end;
            }
            action(Stop_Recording)
            {
                ApplicationArea = All;
                Caption = 'Stop';
                Enabled = Not RecordSwitch;

                trigger OnAction()
                var
                    TempTablePermissionBuffer: Record "Tenant Permission" temporary;
                begin
                    LogTablePermissions.Stop(TempTablePermissionBuffer);
                    AddLoggedPermissions(TempTablePermissionBuffer);
                    Message('Speicherung der Berechtigungssätze abgeschlossen.');
                    RecordSwitch := not RecordSwitch;
                end;
            }
            action(Open_RoleCenter)
            {
                ApplicationArea = All;
                Caption = 'Role Center';

                trigger OnAction()
                var
                    MySessionSettings: SessionSettings;
                begin
                    MySessionSettings.Init();
                    if MySessionSettings.ProfileId = 'BUSINESS MANAGER' then
                        Page.Run(9022);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        TenantPermissionSet: Record "Tenant Permission Set";
        PermissionPagesMgt: Codeunit "Permission Pages Mgt.";
        ZeroGUID: Guid;
    begin
        RecordSwitch := true;
        TenantPermissionSet.SetRange("App ID", ZeroGUID);
        TenantPermissionSet.SetRange("Role ID", UserId.Replace('.', '_'));
        if TenantPermissionSet.IsEmpty then begin
            TenantPermissionSet.Init();
            PermissionPagesMgt.DisallowEditingPermissionSetsForNonAdminUsers();
            PermissionPagesMgt.VerifyPermissionSetRoleID(UserId.Replace('.', '_'));

            TenantPermissionSet.Init();
            TenantPermissionSet."App ID" := ZeroGUID;
            TenantPermissionSet."Role ID" := UserId.Replace('.', '_');
            TenantPermissionSet.Name := UserId.Replace('.', '_');
            TenantPermissionSet.Insert();
        end;
    end;

    trigger OnClosePage()
    var
        TempTablePermissionBuffer: Record "Tenant Permission" temporary;
    begin
        if NOT RecordSwitch then
            if Confirm('Die Aufzeichnung wurde nicht gestoppt, soll die Änderungen gespeichert werden?') then begin
                LogTablePermissions.Stop(TempTablePermissionBuffer);
                AddLoggedPermissions(TempTablePermissionBuffer);
                Message('Speicherung der Berechtigungssätze abgeschlossen.');
            end;
    end;

    local procedure AddLoggedPermissions(var TablePermissionBuffer: Record "Tenant Permission" temporary)
    var
        TenantPermission: Record "Tenant Permission";
        LogActivityPermissions: Codeunit "Log Activity Permissions";
    begin
        if TablePermissionBuffer.FindSet() then
            repeat
                TenantPermission.LockTable();
                if not TenantPermission.Get('00000000-0000-0000-0000-000000000000', UserId.Replace('.', '_'), TablePermissionBuffer."Object Type", TablePermissionBuffer."Object ID") then begin
                    TenantPermission."App ID" := '00000000-0000-0000-0000-000000000000';
                    TenantPermission."Role ID" := UserId.Replace('.', '_');
                    TenantPermission."Object Type" := TablePermissionBuffer."Object Type";
                    TenantPermission."Object ID" := TablePermissionBuffer."Object ID";
                    TenantPermission."Read Permission" := TablePermissionBuffer."Read Permission";
                    TenantPermission."Insert Permission" := TablePermissionBuffer."Insert Permission";
                    TenantPermission."Modify Permission" := TablePermissionBuffer."Modify Permission";
                    TenantPermission."Delete Permission" := TablePermissionBuffer."Delete Permission";
                    TenantPermission."Execute Permission" := TablePermissionBuffer."Execute Permission";
                    TenantPermission.Insert();
                end else begin
                    TenantPermission."Read Permission" := GetMaxPermission(TenantPermission."Read Permission", TablePermissionBuffer."Read Permission");
                    TenantPermission."Insert Permission" := GetMaxPermission(TenantPermission."Insert Permission", TablePermissionBuffer."Insert Permission");
                    TenantPermission."Modify Permission" := GetMaxPermission(TenantPermission."Modify Permission", TablePermissionBuffer."Modify Permission");
                    TenantPermission."Delete Permission" := GetMaxPermission(TenantPermission."Delete Permission", TablePermissionBuffer."Delete Permission");
                    TenantPermission."Execute Permission" := GetMaxPermission(TenantPermission."Execute Permission", TablePermissionBuffer."Execute Permission");
                    TenantPermission.Modify();
                end;
            until TablePermissionBuffer.Next() = 0;
        TablePermissionBuffer.DeleteAll();
    end;

    internal procedure GetMaxPermission(CurrentPermission: Option; NewPermission: Option): Integer
    begin
        if IsFirstPermissionHigherThanSecond(CurrentPermission, NewPermission) then
            exit(CurrentPermission);
        exit(NewPermission);
    end;

    local procedure IsFirstPermissionHigherThanSecond(First: Option; Second: Option): Boolean
    var
        TempExpandedPermission: Record "Expanded Permission" temporary;
    begin
        case First of
            TempExpandedPermission."Read Permission"::" ":
                exit(false);
            TempExpandedPermission."Read Permission"::Indirect:
                exit(Second = TempExpandedPermission."Read Permission"::" ");
            TempExpandedPermission."Read Permission"::Yes:
                exit(Second in [TempExpandedPermission."Read Permission"::Indirect, TempExpandedPermission."Read Permission"::" "]);
        end;
    end;

    var
        LogTablePermissions: Codeunit "Log Activity Permissions";
        TextBox: Label 'Die Aktion "Start" löst die Aufzeichnung von den Berechtigungen aus. Die Aktion "Stop" speichert die Berechtigungen.';
        RecordSwitch: Boolean;
}