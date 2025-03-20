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
        }
        moveafter("Company Name"; Address)
        addlast(General)
        {
            field("Parent Contact No."; Rec."Parent Contact No.")
            {
                ApplicationArea = All;
                Caption = 'Unternehmensgruppe';
                Visible = true;

                trigger OnValidate()
                var
                    Contact_L: Record Contact;
                    SubContact_L: Record Contact;
                begin
                    if Rec."Parent Contact No." <> xRec."Parent Contact No." then begin
                        Contact_L.SetRange("Company No.", Rec."Company No.");
                        if Contact_L.FindSet() then
                            repeat
                                if Contact_L."No." <> Rec."No." then begin
                                    Contact_L."Parent Contact No." := Rec."Parent Contact No.";
                                    Contact_L.Modify();
                                end;
                            until Contact_L.Next() = 0;
                    end;
                end;
            }
            field("Just Sales"; Rec."Just Sales")
            {
                ApplicationArea = All;
                Caption = 'Nur Vertrieb';
            }
            field("Is Corporation"; Rec."Is Corporation")
            {
                ApplicationArea = All;
                Caption = 'Ist Unternehmensgruppe';
                ToolTip = 'Gibt an, ob es sich um einen Kontakt für eine Unternehmensgruppe handelt. Der Kontakt erscheint in der Auswahl für die Unternehmensgruppe. Der Name erhält das Sufix "(Gruppe)"';

                trigger OnValidate()
                begin
                    if Rec."Is Corporation" then
                        Rec.Name := Rec.Name + ' (Gruppe)';
                end;
            }
        }
        addafter(General)
        {
            part(Mitarbeiter; "Contact Person Subform")
            {
                SubPageLink = "Company No." = FIELD("Company No.");

                SubPageView = SORTING("Company No.", Type, "Display Level", Surname) WHERE(Type = CONST(Person), Canceled = CONST(false));
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(Promoted)
        {
            group("Group_Corporation")
            {
                Caption = 'Unternehmensgruppe';
                Image = Company;
                actionref(ShowInheritedContact; Show_Inherited_Contacts) { }
                actionref(ShowInheritedInteractions; Show_Inherited_Interactions) { }
            }
        }
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
            action("Show_Inherited_Contacts")
            {
                ApplicationArea = All;
                Caption = 'Unternehmensgruppe - Kontakte';
                Image = ContactPerson;

                trigger OnAction()
                var
                    MarkedContact_L: Record Contact;
                    Contact_L: Record Contact;
                    ContactPersonSubform_P: Page "Contact Person Subform";
                    ContactList_L: List of [Code[20]];
                    ContactNo_L: Code[20];
                begin
                    RecursiveContactList(Rec, ContactList_L);
                    foreach ContactNo_L in ContactList_L do begin
                        if Contact_L.Get(ContactNo_L) then begin
                            MarkedContact_L.SETRANGE("Company No.", Contact_L."No.");
                            if MarkedContact_L.FindSet() then
                                repeat
                                    MarkedContact_L.Mark(true);
                                until MarkedContact_L.Next() = 0;
                        end;
                    end;

                    MarkedContact_L.SetRange("Company No.");
                    MarkedContact_L.MarkedOnly(true);

                    ContactPersonSubform_P.SetTableView(MarkedContact_L);
                    ContactPersonSubform_P.ShowParentContact(true);
                    ContactPersonSubform_P.RunModal();
                end;
            }
            action("Show_Inherited_Interactions")
            {
                ApplicationArea = All;
                Caption = 'Unternehmensgruppe - Aktivitäten';
                Image = InteractionLog;

                trigger OnAction()
                var
                    Contact_L: Record Contact;
                    InteractionLogEntry_L: Record "Interaction Log Entry";
                    InteractionLogEntries_P: Page "Interaction Log Entries";
                    ContactList_L: List of [Code[20]];
                    ContactNo_L: Code[20];
                begin
                    RecursiveContactList(Rec, ContactList_L);
                    foreach ContactNo_L in ContactList_L do begin
                        if Contact_L.Get(ContactNo_L) then begin
                            InteractionLogEntry_L.SETRANGE("Contact Company No.", Contact_L."No.");
                            if InteractionLogEntry_L.FindSet() then
                                repeat
                                    InteractionLogEntry_L.Mark(true);
                                until InteractionLogEntry_L.Next() = 0;
                        end;
                    end;

                    InteractionLogEntry_L.SetRange("Contact Company No.");
                    InteractionLogEntry_L.MarkedOnly(true);

                    InteractionLogEntries_P.SetTableView(InteractionLogEntry_L);
                    InteractionLogEntries_P.RunModal();
                end;
            }
        }
    }

    local procedure RecursiveContactList(var Contact_L: Record Contact; var ContactList_L: List of [Code[20]])
    var
        RecursiveContact_L: Record Contact;
    begin
        if ContactList_L.Contains(RecursiveContact_L."No.") = false then
            ContactList_L.Add(Contact_L."No.");

        RecursiveContact_L.SetRange(Type, RecursiveContact_L.Type::Company);
        RecursiveContact_L.SetRange("Parent Contact No.", Contact_L."No.");
        if RecursiveContact_L.FindSet() then
            repeat
                if ContactList_L.Contains(RecursiveContact_L."No.") = false then begin
                    RecursiveContactList(RecursiveContact_L, ContactList_L);
                end;
            until RecursiveContact_L.NEXT() = 0;
    end;

    var
        CRMPlusFunctions: Codeunit "CRMPlus Functions";
        Cont: Record Contact;
        "*G-ERP*": Integer;

    trigger OnOpenPage()
    var
        SalespersonPurchaser_L: Record "Salesperson/Purchaser";
    begin
        IF UPPERCASE(USERID) <> 'TURBO-TECHNIK\KE-TH' THEN  //G-ERP.RS 2021-03-23 Auf Wunsch von Herrn Habsch
            Rec.SETRANGE(Type, Rec.Type::Company);                // G-ERP

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
        if (Rec."Is Corporation" = false) then begin
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
        end
    end;
}
