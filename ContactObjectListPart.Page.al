page 50113 "Contact Object ListPart"
{
    Caption = 'Contact Object ListPart';
    PageType = ListPart;
    SourceTable = "Contact Object";
    SourceTableView = sorting("Company Contact No.");

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    Editable = false;
                    Visible = false;
                }
                field("Company Contact No."; Rec."Company Contact No.")
                {
                    ApplicationArea = All;
                    Caption = 'Company Contact No.';
                    Editable = false;
                    Visible = false;
                }
                field("Object No."; Rec."Object No.")
                {
                    ApplicationArea = All;
                    Caption = 'Object No.';
                    trigger OnValidate()
                    var
                        Object_L: Record "Multi Table";
                    begin
                        ObjectDescription_G := '';
                        if Object_L.Get('SCHIFF', Rec."Object No.") then
                            ObjectDescription_G := Object_L.Description;
                        if Rec."Person Contact No." = '' then
                            ContactName_G := '';
                    end;

                    trigger OnDrillDown()
                    var
                        Object_L: Record "Multi Table";
                    begin
                        Object_L.SetRange(Code, Rec."Object No.");
                        Page.RunModal(Page::"Object Card", Object_L);
                    end;
                }
                field(ObjectDescription_G; ObjectDescription_G)
                {
                    ApplicationArea = All;
                    Caption = 'Object Description';
                    Editable = false;
                    trigger OnDrillDown()
                    var
                        Object_L: Record "Multi Table";
                    begin
                        Object_L.SetRange(Code, Rec."Object No.");
                        Page.RunModal(Page::"Object Card", Object_L);
                    end;
                }
                field("Person Contact No."; Rec."Person Contact No.")
                {
                    ApplicationArea = All;
                    Caption = 'Person Contact No.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Contact_L: Record Contact;
                        ContactLookup_P: Page "Contact Lookup";
                        NoContactsFound_Err: Label 'No contacts found for the selected company.';
                    begin
                        Contact_L.SetRange("Company No.", Rec."Company Contact No.");
                        if Contact_L.FindSet() then begin
                            ContactLookup_P.SetTableView(Contact_L);
                            if ContactLookup_P.RunModal() = Action::OK then begin
                                ContactLookup_P.GetRecord(Contact_L);
                                Rec."Person Contact No." := Contact_L."No.";
                                ContactName_G := Contact_L.Name;
                            end;
                        end else begin
                            Message(NoContactsFound_Err);
                        end;
                    end;

                    trigger OnValidate()
                    var
                        Contact_L: Record Contact;
                    begin
                        ContactName_G := '';
                        ObjectDescription_G := '';
                        if Contact_L.Get(Rec."Person Contact No.") then
                            ContactName_G := Contact_L.Name;
                        if Rec."Object No." = '' then
                            ObjectDescription_G := '';
                    end;
                }
                field(ContactName_G; ContactName_G)
                {
                    ApplicationArea = All;
                    Caption = 'Contact Name';
                    Editable = false;
                }
                field("Is Department Head"; Rec."Is Department Head")
                {
                    ApplicationArea = All;
                    Caption = 'Is Department Head';
                    trigger OnValidate()
                    begin
                        ChangeRoleInObject(true, false, false, false, false, false);
                    end;
                }
                field("Is Clerk"; Rec."Is Clerk")
                {
                    ApplicationArea = All;
                    Caption = 'Is Clerk';
                    trigger OnValidate()
                    begin
                        ChangeRoleInObject(false, true, false, false, false, false);
                    end;
                }
                field("Is Super Intendent"; Rec."Is Super Intendent")
                {
                    ApplicationArea = All;
                    Caption = 'Is Super Intendent';
                    trigger OnValidate()
                    begin
                        ChangeRoleInObject(false, false, true, false, false, false);
                    end;
                }
                field("Is Fleet Manager"; Rec."Is Fleet Manager")
                {
                    ApplicationArea = All;
                    Caption = 'Is Fleet Manager';
                    trigger OnValidate()
                    begin
                        ChangeRoleInObject(false, false, false, true, false, false);
                    end;
                }
                field("Is Manager"; Rec."Is Manager")
                {
                    ApplicationArea = All;
                    Caption = 'Is Manager';
                    trigger OnValidate()
                    begin
                        ChangeRoleInObject(false, false, false, false, true, false);
                    end;
                }
                field("Is Bare Boat Charterer"; Rec."Is Bare Boat Charterer")
                {
                    ApplicationArea = All;
                    Caption = 'Is Bare Boat Charterer';
                    trigger OnValidate()
                    begin
                        ChangeRoleInObject(false, false, false, false, false, true);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Open Object")
            {
                ApplicationArea = All;
                Caption = 'Open Object';
                Image = Open;

                trigger OnAction()
                var
                    Object_L: Record "Multi Table";
                begin
                    if Object_L.Get('SCHIFF', Rec."Object No.") then
                        Page.RunModal(Page::"Object Card", Object_L);
                end;
            }
        }
    }

    var
        ContactName_G: Text;
        ObjectDescription_G: Text;

    trigger OnAfterGetRecord()
    var
        Contact_L: Record Contact;
        Object_L: Record "Multi Table";
    begin
        ContactName_G := '';
        ObjectDescription_G := '';
        if Contact_L.Get(Rec."Person Contact No.") then
            ContactName_G := Contact_L.Name;
        if Object_L.Get('SCHIFF', Rec."Object No.") then
            ObjectDescription_G := Object_L.Description;
    end;

    local procedure ChangeRoleInObject(IsDepartmentHead: Boolean; IsClerk: Boolean; IsSuperIntendent: Boolean; IsFleetManager: Boolean; IsManager: Boolean; IsBareBoatCharterer: Boolean)
    var
        Object_L: Record "Multi Table";
        ContactObject_L: Record "Contact Object";
    begin
        Rec.TestField("Object No.");
        Rec.TestField("Person Contact No.");

        if Object_L.Get('SCHIFF', Rec."Object No.") then begin
            ContactObject_L.SetRange("Object No.", Rec."Object No.");
            if ContactObject_L.FindSet() then
                repeat
                    if ContactObject_L."Entry No." <> Rec."Entry No." then begin
                        if IsDepartmentHead then
                            ContactObject_L."Is Department Head" := false;
                        if IsClerk then
                            ContactObject_L."Is Clerk" := false;
                        if IsSuperIntendent then
                            ContactObject_L."Is Super Intendent" := false;
                        if IsFleetManager then
                            ContactObject_L."Is Fleet Manager" := false;
                        if IsManager then
                            ContactObject_L."Is Manager" := false;
                        if IsBareBoatCharterer then
                            ContactObject_L."Is Bare Boat Charterer" := false;
                        ContactObject_L.Modify();
                    end else begin
                        if IsDepartmentHead then
                            Object_L.Abteilungsleiter := Rec."Person Contact No.";
                        if IsClerk then
                            Object_L.Sachbearbeiter := Rec."Person Contact No.";
                        if IsSuperIntendent then
                            Object_L.Superintendent := Rec."Person Contact No.";
                        if IsFleetManager then
                            Object_L.Fleetmanager := Rec."Person Contact No.";
                        if IsManager then
                            Object_L.Manager := Rec."Person Contact No.";
                        if IsBareBoatCharterer then
                            Object_L.Charterer := Rec."Person Contact No.";
                        Object_L.Modify();
                    end;
                until ContactObject_L.Next() = 0;
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
    end;
}