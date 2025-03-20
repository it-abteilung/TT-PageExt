page 50099 "Resource APIV2"
{
    PageType = API;
    APIPublisher = 'cnette';
    APIGroup = 'demo';
    APIVersion = 'v2.0';
    EntityCaption = 'Resource';
    EntitySetCaption = 'Resource';
    EntityName = 'resource';
    EntitySetName = 'resource';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    SourceTable = "Resource";
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'System ID';
                    Editable = false;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = all;
                    Caption = 'EmployeeId';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Name"));
                    end;
                }
                field(Name; Rec."Name")
                {
                    ApplicationArea = all;
                    Caption = 'Name';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Name"));
                    end;
                }
                field(IdCard; Rec."Id Card")
                {
                    ApplicationArea = all;
                    Caption = 'Id Card';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Id Card"));
                    end;
                }
                field(IdIssuedOn; Rec."Id Issued On")
                {
                    ApplicationArea = all;
                    Caption = 'Id Issued On';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Id Issued On"));
                    end;
                }
                field(IdExpiresOn; Rec."Id Expires On")
                {
                    ApplicationArea = all;
                    Caption = 'Id Expires On';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Id Expires On"));
                    end;
                }

                field(NextRowId; NextRowId)
                {
                    ApplicationArea = all;
                    Caption = 'Next Row Id';
                }
            }
        }
    }
    var
        TempFieldSet: Record Field temporary;
        NextRowId: GUID;

    trigger OnAfterGetRecord()
    var
        Resource: Record Resource;
    begin
        Resource.SetFilter("No.", '>%1', Rec."No.");
        Resource.SetCurrentKey("No.");
        Resource.Ascending();
        if Resource.FindFirst() then
            NextRowId := Resource.SystemId;
    end;

    local procedure RegisterFieldSet(FieldNumber: Integer)
    begin
        if TempFieldSet.Get(Database::Job, FieldNumber) then
            exit;

        TempFieldSet.Init();
        TempFieldSet.TableNo := Database::Job;
        TempFieldSet."No." := FieldNumber;
        TempFieldSet.Insert();
    end;
}