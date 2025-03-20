PageExtension 50049 pageextension50049 extends "Contact List"
{
    AdditionalSearchTerms = 'Kontakt,Kontakte,Kontaktübersicht';
    Caption = 'Contact List';
    layout
    {
        modify("Territory Code")
        {
            ApplicationArea = Basic, Suite;
        }
        modify("Privacy Blocked")
        {
            Visible = false;
        }
        modify(Minor)
        {
            Visible = false;
        }
        modify("Parental Consent Received")
        {
            Visible = false;
        }

        addafter("Search Name")
        {
            field(City; Rec.City)
            {
                ApplicationArea = Basic;
            }
            field(Address; Rec.Address)
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("First Name"; Rec."First Name")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Middle Name"; Rec."Middle Name")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(Surname; Rec.Surname)
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Organizational Level Code"; Rec."Organizational Level Code")
            {
                ApplicationArea = All;
            }
            field("Is Corporation"; Rec."Is Corporation")
            {
                ApplicationArea = All;
                Caption = 'Ist Unternehmensgruppe';
                ToolTip = 'Gibt an, ob es sich um einen Kontakt für eine Unternehmensgruppe handelt.';
            }

        }
    }

    actions
    {
        modify(ShowLog)
        {
            Visible = false;
        }
        modify("Open Oppo&rtunities")
        {
            Visible = false;
        }
        modify(Statistics)
        {
            Visible = false;
        }
        modify("Export Contact")
        {
            Visible = false;
        }
        modify("Create Opportunity")
        {
            Visible = false;
        }
        addlast(processing)
        {
            action(Special_Contact_List)
            {
                ApplicationArea = All;
                Caption = 'Spezielle Kontaktliste';
                Image = ContactPerson;

                trigger OnAction()
                var
                    Contact: Record Contact;
                begin
                    Page.Run(Page::"Special Contact List");
                end;

            }
            // action(Update_Primary_Key)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Update PK';
            //     Image = UpdateXML;

            //     trigger OnAction()
            //     var
            //         Contact_L: Record Contact;
            //         StrLength_L: Integer;
            //         Counter: Integer;
            //     begin
            //         if Contact_L.FindSet() then begin
            //             repeat
            //                 StrLength_L := StrLen(Contact_L."No.");
            //                 if StrLength_L < 5 then begin
            //                     Counter += 1;
            //                 end;
            //             until Contact_L.Next() = 0;
            //         end;
            //         Message('Counter: %1', Counter);
            //     end;
            // }
            action(Update_ParentContactNo)
            {
                ApplicationArea = All;
                Caption = 'Update Parent Contact No.';
                Image = UpdateXML;

                trigger OnAction()
                var
                    Contact_L: Record Contact;
                begin
                    if Contact_L.FindSet() then begin
                        repeat
                            Contact_L."Parent Contact No." := Contact_L."Company No.";
                            Contact_L.Modify();
                        until Contact_L.Next() = 0;
                    end;
                end;
            }
            action(Show_All_Interactions)
            {
                ApplicationArea = All;
                Caption = 'Alle Aktivitäten';
                Image = UpdateXML;

                RunPageMode = View;
                RunObject = Page "TT Inter. Log Entries";
            }
        }
    }

    views
    {
        addfirst
        {
            view(View_Customer)
            {
                Caption = 'Alle Debitoren';
                Filters = WHERE("Contact Business Relation" = Const("Contact Business Relation"::Customer), Type = Const(Company));
            }
            view(View_Vendor)
            {
                Caption = 'Alle Kreditoren';
                Filters = WHERE("Contact Business Relation" = Const("Contact Business Relation"::Vendor), Type = Const(Company));
            }
            view(View_Multiple)
            {
                Caption = 'Mehrere Geschäftsbeziehungen';
                Filters = WHERE("Contact Business Relation" = Const("Contact Business Relation"::Multiple), Type = Const(Company));
            }
            view(View_None)
            {
                Caption = 'Keine Geschäftsbeziehung';
                Filters = WHERE("Contact Business Relation" = Const("Contact Business Relation"::None), Type = Const(Company));
            }
        }
    }

    var
        ContactRecordRef: RecordRef;

    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";

    trigger OnOpenPage()
    var
        SalespersonPurchaser_L: Record "Salesperson/Purchaser";
    begin
        // G-ERP+
        CASE rec.Type OF
            rec.Type::Company:
                rec.SETRANGE(Type, rec.Type::Company);
            rec.Type::Person:
                rec.SETRANGE(Type, rec.Type::Person);
        END;
        // G-ERP-

        SalespersonPurchaser_L.SetRange("User ID", USERID);
        if SalespersonPurchaser_L.FindFirst() then begin
            if NOT SalespersonPurchaser_L."Just Sales" then begin
                Rec.FilterGroup(4);
                Rec.SetRange("Just Sales", false);
                Rec.FilterGroup(0)
            end;
        end else begin
            Rec.FilterGroup(4);
            Rec.SetRange("Just Sales", false);
            Rec.FilterGroup(0)
        end;
    end;

}

