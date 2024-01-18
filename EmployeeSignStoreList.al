page 50102 "Employee Sign Store List"
{
    ApplicationArea = all;
    Caption = 'Mitarbeitersignaturen';
    PageType = List;
    SourceTable = "Employee Sign Store";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User Name field.';

                    trigger OnValidate()
                    var
                        EmployeeSignStore: Record "Employee Sign Store";
                    begin
                        EmployeeSignStore.SetRange("User Name", Rec."User Name");
                        if EmployeeSignStore.FindFirst() then
                            Error('Ex existiert bereits ein Eintrag für diesen Benutzer.');
                    end;
                }
                field(Signature; Rec.Signature)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Signature field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ImportMedia)
            {
                ApplicationArea = All;
                Caption = 'Import Media';
                Image = Import;

                trigger OnAction()
                var
                    FromFileName: Text;
                    InStreamPic: Instream;
                begin
                    if UploadIntoStream('Import', '', 'All Files (*.*)|*.*', FromFileName, InStreamPic) then begin
                        Rec.Signature.ImportStream(InStreamPic, FromFileName);
                        Rec.Modify(true);
                    end;
                end;
            }

            action(ExportMedia)
            {
                ApplicationArea = all;
                Caption = 'Export Media';
                Image = Export;

                trigger OnAction()
                var
                    TenantMedia: Record "Tenant Media";
                    InStreamPic: InStream;
                    ImageLbl: Label '%1_Image.jpg';
                    FileName: Text;
                begin
                    if not Rec.Signature.HasValue then
                        exit;

                    if TenantMedia.Get(Rec.Signature.MediaId) then begin
                        TenantMedia.CalcFields(Content);
                        if TenantMedia.Content.HasValue then begin
                            FileName := StrSubstNo(ImageLbl, Rec.TableCaption);
                            TenantMedia.Content.CreateInStream(InStreamPic);
                            DownloadFromStream(InStreamPic, '', '', '', FileName);
                        end;
                    end;
                end;
            }
        }
    }
}