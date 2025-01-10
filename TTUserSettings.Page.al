page 50092 "TT User Settings"
{
    ApplicationArea = All;
    Caption = 'TT Benutzereinstellungen';
    PageType = List;
    SourceTable = "TT User Setting";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("User Name"; Rec."User Name")
                {
                    Caption = 'Benutzer';
                }
                field("Profile ID"; Rec."Profile ID")
                {
                    Caption = 'Profil';
                }
                field("Resource No."; Rec."Resource No.")
                {
                    Caption = 'Ressource';


                    trigger OnValidate()
                    var
                        Resource_L: Record Resource;
                    begin
                        if Resource_L.Get(Rec."Resource No.") then begin
                            Resource_L."User ID" := Rec."User Name";
                            Resource_L.Modify();
                        end;
                    end;
                }
                field("Salesperson/Purchaser"; Rec."Salesperson/Purchaser")
                {
                    Caption = 'Einkäufer/Verkäufer';
                }
                field("Warehouse Locations"; Rec."Warehouse Locations")
                {
                    Caption = 'Zugeordnete Lagerorte';
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Promoted)
        {
            actionref(OpenProfiles; Open_Profiles) { }
            actionref(OpenResources; Open_Resources) { }
            actionref(OpenSalespersonPurchaser; Open_Salesperson_Purchaser) { }
            actionref(ApplyWarehouseLocations; Apply_Warehouse_Locations) { }
        }
        area(Processing)
        {
            action(Apply_Warehouse_Locations)
            {
                ApplicationArea = All;
                Caption = 'Lagerorte zuordnen';
                Image = WorkTax;

                RunObject = Page "Warehouse Employees";
                RunPageLink = "User ID" = field("User Name");
            }
            action(Open_Resources)
            {
                ApplicationArea = All;
                Caption = 'Zu Ressourcen';
                Image = Employee;

                RunObject = Page "Resource List";
            }
            action(Open_Profiles)
            {
                ApplicationArea = All;
                Caption = 'Zu Profilen';
                Image = Employee;

                RunObject = Page "Profile List";
            }
            action("Open_Salesperson_Purchaser")
            {
                ApplicationArea = All;
                Caption = 'Zu Einkäufer/Verkäufer';
                Image = PurchaseTaxStatement;

                RunObject = Page "Salespersons/Purchasers";
            }
        }
    }
}