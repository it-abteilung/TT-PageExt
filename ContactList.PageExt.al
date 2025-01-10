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
        }
    }

    var
        ContactRecordRef: RecordRef;

    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";

    trigger OnOpenPage()
    begin
        // G-ERP+
        CASE rec.Type OF
            rec.Type::Company:
                rec.SETRANGE(Type, rec.Type::Company);
            rec.Type::Person:
                rec.SETRANGE(Type, rec.Type::Person);
        END;
        // G-ERP-
    end;

}

