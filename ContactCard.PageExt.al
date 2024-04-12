PageExtension 50048 pageextension50048 extends "Contact Card"
{
    layout
    {
        addafter("Exclude from Segment")
        {
            field("Vendor No. TT"; Rec."Vendor No. TT")
            {
                ApplicationArea = Basic;
            }
            field("Customer No. TT"; Rec."Customer No. TT")
            {
                ApplicationArea = Basic;
            }
            field(DATEV; Rec.DATEV)
            {
                ApplicationArea = Basic;
                ShowMandatory = true;
            }
            part(Mitarbeiter; "Contact Person Subform")
            {
                SubPageLink = "Company No." = FIELD("Company No.");
                SubPageView = SORTING("Company No.", Type, "Display Level", Surname) WHERE(Type = CONST(Person), Canceled = CONST(false));
                ApplicationArea = All;
            }
        }
        moveafter("Company Name"; Address)
    }
    actions
    {
        addfirst("F&unctions")
        {
            action("Create New Person")
            {
                Caption = 'Neue Person erstellen';
                ApplicationArea = All;

                trigger OnAction()
                var
                    rContactNew: Record Contact;
                begin
                    CRMPlusFunctions.insertPerson(Rec, rContactNew);
                    CurrPage.UPDATE(FALSE);
                end;
            }
        }
    }
    var
        CRMPlusFunctions: Codeunit "CRMPlus Functions";
        Cont: Record Contact;
        "*G-ERP*": Integer;

    trigger OnOpenPage()
    begin
        IF UPPERCASE(USERID) <> 'TURBO-TECHNIK\KE-TH' THEN  //G-ERP.RS 2021-03-23 Auf Wunsch von Herrn Habsch
            Rec.SETRANGE(Type, Rec.Type::Company);                // G-ERP
    end;

    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        case Rec."Contact Business Relation" of
            Rec."Contact Business Relation"::" ":
                ;
            Rec."Contact Business Relation"::Customer:
                begin
                    if Rec.DATEV = '' then
                        if Customer.Get(Rec."Customer No. TT") then
                            Rec.DATEV := Customer.DATEV;
                end;
            Rec."Contact Business Relation"::Vendor:
                if Rec.DATEV = '' then
                    if Vendor.Get(Rec."Vendor No. TT") then
                        Rec.DATEV := Vendor.DATEV;
            Rec."Contact Business Relation"::"Bank Account":
                ;
            Rec."Contact Business Relation"::Employee:
                ;
            Rec."Contact Business Relation"::None:
                ;
            Rec."Contact Business Relation"::Other:
                ;
            Rec."Contact Business Relation"::Multiple:
                ;

        end;
    end;
}

