PageExtension 50048 pageextension50048 extends "Contact Card"
{
    layout
    {
        modify(Name)
        {
            ShowMandatory = true;
        }
        modify(Address)
        {
            ShowMandatory = true;
        }
        modify("Post Code")
        {
            ShowMandatory = true;
        }
        modify(City)
        {
            ShowMandatory = true;
        }
        modify("Country/Region Code")
        {
            ShowMandatory = true;
        }
        modify("Phone No.")
        {
            ShowMandatory = true;
        }
        modify("E-Mail")
        {
            ShowMandatory = true;
        }
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

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        TextBuilder_L: TextBuilder;
    begin
        if (Rec.Name = '') then begin
            TextBuilder_L.Append('Name');
        end;
        if (Rec.Address = '') then begin
            if TextBuilder_L.Length > 0 then
                TextBuilder_L.Append(', ');
            TextBuilder_L.Append('Adresse');
        end;
        if (Rec."Post Code" = '') then begin
            if TextBuilder_L.Length > 0 then
                TextBuilder_L.Append(', ');
            TextBuilder_L.Append('PLZ');
        end;
        if (Rec.City = '') then begin
            if TextBuilder_L.Length > 0 then
                TextBuilder_L.Append(', ');
            TextBuilder_L.Append('Ort');
        end;
        if (Rec."Country/Region Code" = '') then begin
            if TextBuilder_L.Length > 0 then
                TextBuilder_L.Append(', ');
            TextBuilder_L.Append('Länder-/Regionscode');
        end;
        if (Rec."Phone No." = '') then begin
            if TextBuilder_L.Length > 0 then
                TextBuilder_L.Append(', ');
            TextBuilder_L.Append('Telefon Nr.');
        end;
        if (Rec."E-Mail" = '') then begin
            if TextBuilder_L.Length > 0 then
                TextBuilder_L.Append(', ');
            TextBuilder_L.Append('E-Mail');
        end;
        if TextBuilder_L.Length > 0 then begin
            if NOT Confirm('Die Pflichtfelder %1 sind leer und der Kontakt kann möglicherweise nicht für die weitere Verarbeitung verwendet werden, soll die Seite trotzdem geschlossen werden?', false, TextBuilder_L.ToText()) then
                exit(false);
        end;

    end;
}
