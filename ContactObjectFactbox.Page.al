page 50117 "Contact Object Factbox"
{
    ApplicationArea = all;
    Caption = 'Contact Object Factbox';
    PageType = ListPart;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTable = "Contact Object Relation";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Object Code"; Rec."Object Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(ObjectName_G; ObjectName_G)
                {
                    ApplicationArea = All;
                    Caption = 'Object Name';

                    trigger OnDrillDown()
                    var
                        MultiTable_L: Record "Multi Table";
                    begin
                        if MultiTable_L.Get('SCHIFF', Rec."Object Code") then
                            Page.RunModal(Page::"Object Card", MultiTable_L);
                    end;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(ContactName_G; ContactName_G)
                {
                    ApplicationArea = All;
                    Caption = 'Contact Name';

                    trigger OnDrillDown()
                    var
                        Contact_L: Record "Contact";
                    begin
                        if Contact_L.Get(Rec."Contact No.") then
                            Page.RunModal(Page::"Contact Card", Contact_L);
                    end;
                }
                field(Role; Rec.Role)
                {
                    ApplicationArea = All;
                    Caption = 'Role';
                }
            }
        }
    }


    var
        ObjectName_G: Text;
        ContactName_G: Text;

    trigger OnOpenPage()
    begin
    end;

    trigger OnAfterGetRecord()
    var
        MultiTable_L: Record "Multi Table";
        Contact_L: Record Contact;
    begin
        ObjectName_G := '-';
        ContactName_G := '-';

        if MultiTable_L.Get('SCHIFF', Rec."Object Code") then
            ObjectName_G := MultiTable_L.Description;
        if Contact_L.Get(Rec."Contact No.") then
            ContactName_G := Contact_L.Name;
    end;
}