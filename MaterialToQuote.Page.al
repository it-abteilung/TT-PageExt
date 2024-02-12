page 50105 "Materials To Quote"
{
    Caption = 'Anfragen und Kreditoren';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Purchase Header";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        PurchaseHeader: Record "Purchase Header";
                    begin
                        if IsPurchaser then begin
                            PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Quote);
                            PurchaseHeader.SetRange("No.", Rec."No.");
                            if PurchaseHeader.FindFirst() then
                                Page.Run(Page::"Purchase Quote", PurchaseHeader);
                        end else
                            Message('Einkaufsanfrage %1', Rec."No.");
                    end;
                }
                field("Serial No."; Rec.Serienanfragennr)
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    Caption = 'Projekt-Nr.';
                }
                field(Leistung; Rec.Leistung)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        IsPurchaser: Boolean;

    trigger OnOpenPage()
    var
        UserPermissions: Codeunit "User Permissions";
    begin
        if UserPermissions.HasUserPermissionSetAssigned(UserSecurityId(), CompanyName, 'TT EINKAUF', 1, '00000000-0000-0000-0000-000000000000') then begin
            IsPurchaser := true;
        end;
    end;
}