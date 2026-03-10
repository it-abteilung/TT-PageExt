page 50115 "Object Card"
{
    ApplicationArea = all;
    Caption = 'Object Card';
    PageType = List;
    SourceTable = "Multi Table";
    SourceTableView = where(Kennzeichen = const('SCHIFF'));

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Allgemein';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Objektname';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Baujahr; Rec.Baujahr)
                {
                    ApplicationArea = Basic;
                }
                field(Hersteller; Rec.Hersteller)
                {
                    ApplicationArea = Basic;
                    Caption = 'Yard';
                }
                field(Owner; Rec.Owner)
                {
                    ApplicationArea = Basic;
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = Basic;
                }
                field(Info; Rec.Info)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Sachbearbeiter; Rec.Sachbearbeiter)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;

                    trigger OnValidate()
                    var
                        ContactObjectRelation_L: Record "Contact Object Relation";
                    begin
                        if Rec.Sachbearbeiter <> xRec.Sachbearbeiter then begin
                            SetContactObjectRelation(Rec.Sachbearbeiter, xRec.Sachbearbeiter, Rec.Code, ContactObjectRelation_L.Role::Clerk);
                        end;
                    end;
                }
                field(Abteilungsleiter; Rec.Abteilungsleiter)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;

                    trigger OnValidate()
                    var
                        ContactObjectRelation_L: Record "Contact Object Relation";
                    begin
                        if Rec.Abteilungsleiter <> xRec.Abteilungsleiter then begin
                            SetContactObjectRelation(Rec.Charterer, xRec.Charterer, Rec.Code, ContactObjectRelation_L.Role::"Department Head");
                        end;
                    end;
                }
                field("Technische Info"; Rec."Technische Info")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(TDW; Rec.TDW)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Length; Rec.Length)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Width; Rec.Width)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Depth; Rec.Depth)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Area"; Rec.Area)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Main Engine"; Rec."Main Engine")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Main Engine Type"; Rec."Main Engine Type")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("ME Turbo"; Rec."ME Turbo")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("AUX Engine"; Rec."AUX Engine")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("AUX Engine Type"; Rec."AUX Engine Type")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Seal Maker"; Rec."Seal Maker")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Seal Type"; Rec."Seal Type")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Ex Name"; Rec."Ex Name")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("LLoyds No."; Rec."LLoyds No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'IMO';
                    Importance = Additional;
                }
                field("Hull No."; Rec."Hull No.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(NRT; Rec.NRT)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(GRT; Rec.GRT)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Flag; Rec.Flag)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                group(Roles)
                {
                    ShowCaption = false;
                    field(Superintendent; Rec.Superintendent)
                    {
                        ApplicationArea = Basic;

                        trigger OnValidate()
                        var
                            ContactObjectRelation_L: Record "Contact Object Relation";
                            Contact_L: Record Contact;
                        begin
                            if Rec.Superintendent <> xRec.Superintendent then begin
                                SetContactObjectRelation(Rec.Superintendent, xRec.Superintendent, Rec.Code, ContactObjectRelation_L.Role::"Super Intendent");
                                if Contact_L.Get(Rec.Superintendent) then
                                    Rec."Superintendent Name" := Contact_L.Name;
                            end;
                        end;
                    }
                    field("Superintendent Name"; Rec."Superintendent Name")
                    {
                        ApplicationArea = Basic;
                    }
                    field(Fleetmanager; Rec.Fleetmanager)
                    {
                        ApplicationArea = Basic;

                        trigger OnValidate()
                        var
                            ContactObjectRelation_L: Record "Contact Object Relation";
                            Contact_L: Record Contact;
                        begin
                            if Rec.Fleetmanager <> xRec.Fleetmanager then begin
                                SetContactObjectRelation(Rec.Fleetmanager, xRec.Fleetmanager, Rec.Code, ContactObjectRelation_L.Role::"Fleet Manager");
                                if Contact_L.Get(Rec.Fleetmanager) then
                                    Rec."Fleetmanager Name" := Contact_L.Name;
                            end;
                        end;
                    }
                    field("Fleetmanager Name"; Rec."Fleetmanager Name")
                    {
                        ApplicationArea = Basic;
                    }
                    field(Manager; Rec.Manager)
                    {
                        ApplicationArea = Basic;

                        trigger OnValidate()
                        var
                            ContactObjectRelation_L: Record "Contact Object Relation";
                            Contact_L: Record Contact;
                        begin
                            if Rec.Manager <> xRec.Manager then begin
                                SetContactObjectRelation(Rec.Manager, xRec.Manager, Rec.Code, ContactObjectRelation_L.Role::"Manager");
                                if Contact_L.Get(Rec.Manager) then
                                    Rec."Manager Name" := Contact_L.Name;
                            end;
                        end;
                    }
                    field("Manager Name"; Rec."Manager Name")
                    {
                        ApplicationArea = Basic;
                    }
                    field(Charterer; Rec.Charterer)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Bareboat Charterer';

                        trigger OnValidate()
                        var
                            ContactObjectRelation_L: Record "Contact Object Relation";
                            Contact_L: Record Contact;
                        begin
                            if Rec.Charterer <> xRec.Charterer then begin
                                SetContactObjectRelation(Rec.Charterer, xRec.Charterer, Rec.Code, ContactObjectRelation_L.Role::Charterer);
                                if Contact_L.Get(Rec.Charterer) then
                                    Rec."Bareboat Charterer Name" := Contact_L.Name;
                            end;
                        end;
                    }
                    field("Bareboat Charterer Name"; Rec."Bareboat Charterer Name")
                    {
                        ApplicationArea = Basic;
                    }
                }
            }
            part("Job List Part"; "Job List Part")
            {
                ApplicationArea = All;
                SubPageLink = Object = field(Code);
            }
        }
    }
    actions
    {
        area(Processing)
        {

            action(DELETE)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    ContactObjectRelation: Record "Contact Object Relation";
                begin
                    ContactObjectRelation.DeleteAll();
                end;
            }
        }
    }

    local procedure SetContactObjectRelation(ContactNo_L: Code[20]; xContactNo_L: Code[20]; ObjectCode_L: Code[20]; Role_L: Enum "Contact Object Role")
    var
        ContactObjectRelation_L: Record "Contact Object Relation";
        Contact_L: Record Contact;
    begin
        if Contact_L.Get(ContactNo_L) then begin
            ContactObjectRelation_L.SetRange("Object Code", ObjectCode_L);
            ContactObjectRelation_L.SetRange("Contact No.", xContactNo_L);
            ContactObjectRelation_L.SetRange(Role, Role_L);
            if ContactObjectRelation_L.FindFirst() then
                ContactObjectRelation_L.Delete();

            ContactObjectRelation_L.Init();
            ContactObjectRelation_L."Object Code" := ObjectCode_L;
            ContactObjectRelation_L."Contact Parent No." := Contact_L."Company No.";
            ContactObjectRelation_L."Contact No." := Contact_L."No.";
            ContactObjectRelation_L.Role := Role_L;
            ContactObjectRelation_L.Insert();

        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec.Code = '' then begin
            SchiffRec.SetRange(Kennzeichen, 'SCHIFF');
            SchiffRec.FindLast();
            SchiffRec.Next(-1);
            Rec.Code := SchiffRec.Code;
            repeat
                Rec.Code := IncStr(Rec.Code);
            until not SchiffRec.Get('SCHIFF', Rec.Code);
        end;
    end;

    var
        SchiffRec: Record "Multi Table";
}