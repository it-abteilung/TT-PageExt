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
            action("Rename Jobs")
            {
                ApplicationArea = All;
                Caption = 'Rename Jobs';

                trigger OnAction()
                var
                    Job_L: Record Job;
                    Job2_L: Record Job;
                    Bin_L: Record Bin;
                    JobNo_L: Code[20];
                    JobNo2_L: Code[20];
                    NewJobNo_L: Code[20];
                    NewJobNo2_L: Code[20];
                    InventorySetup_L: Record "Inventory Setup";
                    JobList_L: List of [Code[20]];
                begin
                    Job_L.SetFilter("No.", '26-*.*-*');
                    if Job_L.FindSet() then begin
                        repeat
                            Job_L.MainProjektNo := CopyStr(Job_L."No.", 1, 8);
                            Job_L.Modify();

                            if Format(Job_L."No.").EndsWith('-000') then begin
                                if Job2_L.Get(CopyStr(Job_L."No.", 1, 8)) then begin
                                    Job2_L."Status" := Job_L.Status;
                                    Job2_L.Modify();
                                end;
                            end;

                        until Job_L.Next() = 0;
                    end;
                end;
            }

            action("Rename Bins")
            {
                ApplicationArea = All;
                Caption = 'Rename Bins';

                trigger OnAction()
                var
                    Bin_L: Record Bin;
                    Bin2_L: Record Bin;
                    BinCode_L: Code[20];
                    Job_L: Record Job;
                    BinList_L: List of [Code[20]];
                begin
                    Bin_L.SetRange("Location Code", 'PROJEKT');
                    Bin_L.SetFilter("Code", '26-*');
                    if Bin_L.FindSet() then begin
                        repeat
                            BinList_L.Add(Bin_L."Code");
                        until Bin_L.Next() = 0;

                        foreach BinCode_L in BinList_L do begin
                            Clear(Job_L);
                            Job_L.SetFilter("No.", CopyStr(BinCode_L, 1, 6) + '*');
                            if Job_L.FindFirst() then begin
                                if Bin_L.Get('PROJEKT', BinCode_L) then begin
                                    if NOT Bin2_L.Get('PROJEKT', CopyStr(BinCode_L, 1, 6) + GetJobTypeSuffix(Job_L."Job Type") + CopyStr(BinCode_L, 7)) then
                                        Bin_L.Rename('PROJEKT', CopyStr(BinCode_L, 1, 6) + GetJobTypeSuffix(Job_L."Job Type") + CopyStr(BinCode_L, 7));
                                end
                            end
                        end;
                    end;
                end;
            }

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

    local procedure GetJobTypeSuffix(JobType_L: Code[20]) JobTypeSuffix: Code[4]
    begin
        JobTypeSuffix := '';
        case "JobType_L" of
            '10000':
                JobTypeSuffix += '.1';
            '20000':
                JobTypeSuffix += '.2';
            '30000':
                JobTypeSuffix += '.3';
            '40000':
                JobTypeSuffix += '.4';
            '50000':
                JobTypeSuffix += '.5';
            '60000':
                JobTypeSuffix += '.6';
            '70000':
                JobTypeSuffix += '.7';
            '80000':
                JobTypeSuffix += '.8';
            '90000':
                JobTypeSuffix += '.9';
        end;
        Exit(JobTypeSuffix);
    end;

}