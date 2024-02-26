Page 82001 "Contact Person Card"
{
    Caption = 'Contactperson Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Contact;
    SourceTableView = sorting("Company No.", Type, "Display Level", Surname)
                      where(Type = const(Person));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        TypeOnAfterValidate;
                    end;
                }
                field("Company No."; Rec."Company No.")
                {
                    ApplicationArea = Basic;
                    Enabled = "Company No.Enable";
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = Basic;
                    AssistEdit = true;
                    Enabled = "Company NameEnable";

                    trigger OnAssistEdit()
                    begin
                        Cont.SetRange("No.", Rec."Company No.");
                        Clear(CompanyDetails);
                        CompanyDetails.SetTableview(Cont);
                        CompanyDetails.SetRecord(Cont);
                        CompanyDetails.RunModal;
                    end;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = Basic;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        Rec.Modify;
                        Commit;
                        Cont.SetRange("No.", Rec."No.");
                        Clear(NameDetails);
                        NameDetails.SetTableview(Cont);
                        NameDetails.SetRecord(Cont);
                        NameDetails.RunModal;
                        NameDetails.GetRecord(Rec);
                        CurrPage.Update;
                    end;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = Basic;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                }
                field("Salutation Code"; Rec."Salutation Code")
                {
                    ApplicationArea = Basic;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic;
                }
                field("Person Information"; Rec."Person Information")
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Attempted"; Rec."Last Date Attempted")
                {
                    ApplicationArea = Basic;

                    trigger OnDrillDown()
                    var
                        InteractionLogEntry: Record "Interaction Log Entry";
                    begin
                        InteractionLogEntry.SetCurrentkey("Contact Company No.", Date, "Contact No.", Canceled, "Initiated By", "Attempt Failed");
                        InteractionLogEntry.SetRange("Contact Company No.", Rec."Company No.");
                        InteractionLogEntry.SetFilter("Contact No.", Rec."Lookup Contact No.");
                        InteractionLogEntry.SetRange("Initiated By", InteractionLogEntry."initiated by"::Us);
                        //IF InteractionLogEntry.FIND('+') THEN
                        Page.Run(0, InteractionLogEntry);
                    end;
                }
                field("Date of Last Interaction"; Rec."Date of Last Interaction")
                {
                    ApplicationArea = Basic;

                    trigger OnDrillDown()
                    var
                        InteractionLogEntry: Record "Interaction Log Entry";
                    begin
                        InteractionLogEntry.SetCurrentkey("Contact Company No.", Date, "Contact No.", Canceled, "Initiated By", "Attempt Failed");
                        InteractionLogEntry.SetRange("Contact Company No.", Rec."Company No.");
                        InteractionLogEntry.SetFilter("Contact No.", Rec."Lookup Contact No.");
                        InteractionLogEntry.SetRange("Attempt Failed", false);
                        //IF InteractionLogEntry.FIND('+') THEN
                        Page.Run(0, InteractionLogEntry);
                    end;
                }
                field("Correspondence Type"; Rec."Correspondence Type")
                {
                    ApplicationArea = Basic;
                }
                field("Dialing Code"; Rec."Dialing Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Dialing Code / Phoneno. / Extension No.';
                    Visible = false;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    ExtendedDatatype = None;
                }
                field("Extension No."; Rec."Extension No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    begin
                        TAPIManagement.DialContCustVendBank(Database::Contact, Rec."No.", Rec."Mobile Phone No.", '');
                    end;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = Basic;
                }
                field("Telex No."; Rec."Telex No.")
                {
                    ApplicationArea = Basic;
                }
                field(Pager; Rec.Pager)
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = Basic;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = Basic;
                }
                field("Territory Code"; Rec."Territory Code")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = Basic;
                }
                field("Privat Phone No."; Rec."Privat Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field("Privat Fax No."; Rec."Privat Fax No.")
                {
                    ApplicationArea = Basic;
                }
                field("Privat E-Mail"; Rec."Privat E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                }
                field("Modified from"; Rec."Modified from")
                {
                    ApplicationArea = Basic;
                    Caption = 'Modified from';
                }
            }
            group(Segmentation)
            {
                Caption = 'Segmentation';
                field("No. of Mailing Groups"; Rec."No. of Mailing Groups")
                {
                    ApplicationArea = Basic;

                    trigger OnDrillDown()
                    var
                        ContMailingGrp: Record "Contact Mailing Group";
                    begin
                        CurrPage.SaveRecord;
                        Commit;
                        ContMailingGrp.SetRange("Contact No.", Rec."No.");
                        Page.RunModal(Page::"Contact Mailing Groups", ContMailingGrp);
                        CurrPage.Update(false);
                    end;
                }
                field("Organizational Level Code"; Rec."Organizational Level Code")
                {
                    ApplicationArea = Basic;
                    Enabled = OrganizationalLevelCodeEnable;
                }
                field("No. of Job Responsibilities"; Rec."No. of Job Responsibilities")
                {
                    ApplicationArea = Basic;
                    Enabled = NoofJobResponsibilitiesEnable;

                    trigger OnDrillDown()
                    var
                        ContJobResp: Record "Contact Job Responsibility";
                    begin
                        CurrPage.SaveRecord;
                        Commit;
                        ContJobResp.SetRange("Contact No.", Rec."No.");
                        Page.RunModal(Page::"Contact Job Responsibilities", ContJobResp);
                        CurrPage.Update(false);
                    end;
                }
                field(Control54; Rec."Job Responsibilities")
                {
                    ApplicationArea = Basic;

                    trigger OnDrillDown()
                    var
                        ContJobResp: Record "Contact Job Responsibility";
                    begin
                        CurrPage.SaveRecord;
                        Commit;
                        ContJobResp.SetRange("Contact No.", Rec."No.");
                        Page.RunModal(Page::"Contact Job Responsibilities", ContJobResp);
                        CurrPage.Update(false);
                    end;
                }
                field("Exclude from Segment"; Rec."Exclude from Segment")
                {
                    ApplicationArea = Basic;
                }
                field(Canceled; Rec.Canceled)
                {
                    ApplicationArea = Basic;
                }
            }
            part(Profil; "Contact Card Subform")
            {
                Caption = 'Profil';
                SubPageLink = "Contact No." = field("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("C&ontact")
            {
                Caption = 'C&ontact';
                action(List)
                {
                    ApplicationArea = Basic;
                    Caption = 'List';
                    ShortCutKey = 'F5';

                    trigger OnAction()
                    var
                        rContact: Record Contact;
                        fContactList: Page "Contact List";
                    begin
                        rContact.SetCurrentkey("Company Name", "Company No.", Type, Name);
                        rContact.SetRange(Type);
                        rContact.SetRange("Company No.", Rec."Company No.");

                        fContactList.SetTableview(rContact);
                        fContactList.LookupMode(true);
                        fContactList.RunModal;
                    end;
                }
                action("Relate&d Contacts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Relate&d Contacts';
                    Visible = false;

                    trigger OnAction()
                    var
                        rContact: Record Contact;
                        fContactList: Page "Contact List";
                    begin
                        rContact.SetCurrentkey("Company Name", "Company No.", Type, Name);
                        rContact.SetRange(Type);
                        rContact.SetRange("Company No.", Rec."Company No.");

                        fContactList.SetTableview(rContact);
                        fContactList.LookupMode(true);
                        fContactList.RunModal;
                    end;
                }
                group("Comp&any")
                {
                    Caption = 'Comp&any';
                    Visible = false;
                    action("Business Relations")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Business Relations';
                        RunObject = Page "Contact Business Relations";
                        RunPageLink = "Contact No." = field("Company No.");
                        Visible = false;
                    }
                    action("Industry Groups")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Industry Groups';
                        RunObject = Page "Contact Industry Groups";
                        RunPageLink = "Contact No." = field("Company No.");
                        Visible = false;
                    }
                    action("Web Sources")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Web Sources';
                        RunObject = Page "Contact Web Sources";
                        RunPageLink = "Contact No." = field("Company No.");
                        Visible = false;
                    }
                }
                group("P&erson")
                {
                    Caption = 'P&erson';
                    action("Job Responsibilities")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Job Responsibilities';

                        trigger OnAction()
                        var
                            ContJobResp: Record "Contact Job Responsibility";
                        begin
                            Rec.TestField(Type, Rec.Type::Person);
                            ContJobResp.SetRange("Contact No.", Rec."No.");
                            Page.RunModal(Page::"Contact Job Responsibilities", ContJobResp);
                        end;
                    }
                }
                action("Mailing &Groups")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mailing &Groups';
                    RunObject = Page "Contact Mailing Groups";
                    RunPageLink = "Contact No." = field("No.");
                }
                action("Pro&files")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pro&files';

                    trigger OnAction()
                    var
                        ProfileManagement: Codeunit ProfileManagement;
                    begin
                        ProfileManagement.ShowContactQuestionnaireCard(Rec, '', 0);
                    end;
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Contact Statistics";
                    RunPageLink = "No." = field("No.");
                    ShortCutKey = 'F7';
                }
                action("&Picture")
                {
                    ApplicationArea = Basic;
                    Caption = '&Picture';
                    RunObject = Page "Contact Picture";
                    RunPageLink = "No." = field("No.");
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Rlshp. Mgt. Comment Sheet";
                    RunPageLink = "Table Name" = const(Contact),
                                  "No." = field("No."),
                                  "Sub No." = const(0);
                }
                group("Alternati&ve Address")
                {
                    Caption = 'Alternati&ve Address';
                    action(Card)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Card';
                        Image = EditLines;
                        RunObject = Page "Contact Alt. Address Card";
                        RunPageLink = "Contact No." = field("No.");
                    }
                    action("Date Ranges")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Date Ranges';
                        RunObject = Page "Contact Alt. Addr. Date Ranges";
                        RunPageLink = "Contact No." = field("No.");
                    }
                }
                separator(Action94)
                {
                }
                action("Interaction Log E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interaction Log E&ntries';
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "Contact Company No." = field("Company No."),
                                  "Contact No." = filter(<> ''),
                                  "Contact No." = field(filter("Lookup Contact No."));
                    RunPageView = sorting("Contact Company No.", Date, "Contact No.", Canceled, "Initiated By", "Attempt Failed")
                                  order(descending);
                    ShortCutKey = 'Ctrl+F5';
                }
                action("Documnet Interaction Log Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Documnet Interaction Log Entries';
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "Contact Company No." = field("Company No."),
                                  "Contact No." = filter(<> ''),
                                  "Contact No." = field(filter("Lookup Contact No.")),
                                  "Attachment No." = filter(<> 0);
                    RunPageView = sorting("Contact Company No.", Date, "Contact No.", Canceled, "Initiated By", "Attempt Failed")
                                  order(descending);
                }
                action("T&o-dos")
                {
                    ApplicationArea = Basic;
                    Caption = 'T&o-dos';
                    RunObject = Page "Task List";
                    RunPageLink = "Contact Company No." = field("Company No."),
                                  "Contact No." = filter(<> ''),
                                  "Contact No." = field(filter("Lookup Contact No."));
                    RunPageView = sorting("Contact Company No.", Date, "Contact No.", Closed);
                }
                action("Oppo&rtunities")
                {
                    ApplicationArea = Basic;
                    Caption = 'Oppo&rtunities';
                    RunObject = Page "Opportunity List";
                    RunPageLink = "Contact Company No." = field("Company No."),
                                  "Contact No." = filter(<> ''),
                                  "Contact No." = field(filter("Lookup Contact No."));
                    RunPageView = sorting("Contact Company No.", "Contact No.");
                }
                action("Segmen&ts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Segmen&ts';
                    Image = Segment;
                    RunObject = Page "Contact Segment List";
                    RunPageLink = "Contact Company No." = field("Company No."),
                                  "Contact No." = filter(<> ''),
                                  "Contact No." = field(filter("Lookup Contact No."));
                    RunPageView = sorting("Contact No.", "Segment No.");
                }
                separator(Action98)
                {
                }
                action("Sales &Quotes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales &Quotes';
                    Image = Quote;
                    RunObject = Page "Sales Quote";
                    RunPageLink = "Sell-to Contact No." = field("No.");
                    RunPageView = sorting("Document Type", "Sell-to Contact No.");
                    Visible = false;
                }
                separator(Action119)
                {
                }
                separator(Action139)
                {
                }
                action("Änderungsprotokoll")
                {
                    ApplicationArea = Basic;
                    Caption = 'Änderungsprotokoll';
                    RunObject = Page "Change Log Entries";
                    RunPageLink = "Table No." = const(5050),
                                  "Primary Key Field 1 Value" = field("No.");
                    RunPageView = sorting("Table No.", "Primary Key Field 1 Value");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Launch &Web Source")
                {
                    ApplicationArea = Basic;
                    Caption = 'Launch &Web Source';
                    Visible = false;

                    trigger OnAction()
                    var
                        ContactWebSource: Record "Contact Web Source";
                    begin
                        ContactWebSource.SetRange("Contact No.", Rec."Company No.");
                        if Page.RunModal(Page::"Web Source Launch", ContactWebSource) = Action::LookupOK then
                            ContactWebSource.Launch;
                    end;
                }
                action("Print Cover &Sheet")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Cover &Sheet';

                    trigger OnAction()
                    var
                        Cont: Record Contact;
                    begin
                        Cont := Rec;
                        Cont.SetRecfilter;
                        Report.Run(Report::"Contact - Cover Sheet", true, false, Cont);
                    end;
                }
                group("Create as")
                {
                    Caption = 'Create as';
                    Visible = false;
                    action(Customer)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Customer';
                        Visible = false;

                        trigger OnAction()
                        begin
                            Rec.CreateCustomer();
                        end;
                    }
                    action(Vendor)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Vendor';
                        Visible = false;

                        trigger OnAction()
                        begin
                            Rec.CreateVendor;
                        end;
                    }
                    action(Bank)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Bank';
                        Visible = false;

                        trigger OnAction()
                        begin
                            Rec.CreateBankAccount;
                        end;
                    }
                }
                group("Link with existing")
                {
                    Caption = 'Link with existing';
                    Visible = false;
                    action(Action110)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Customer';
                        Visible = false;

                        trigger OnAction()
                        begin
                            Rec.CreateCustomerLink;
                        end;
                    }
                    action(Action111)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Vendor';
                        Visible = false;

                        trigger OnAction()
                        begin
                            Rec.CreateVendorLink;
                        end;
                    }
                    action(Action112)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Bank';
                        Visible = false;

                        trigger OnAction()
                        begin
                            Rec.CreateBankAccountLink;
                        end;
                    }
                }
                action("Co&ntact Search")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&ntact Search';

                    trigger OnAction()
                    begin
                        /*  // G-ERP
                        ContactSearchForm.LOOKUPMODE(TRUE);
                        IF ContactSearchForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                          ContactSearchForm.GETRECORD(SearchResult);
                          IF GET(SearchResult."Contact No.") THEN;
                        END;
                        */

                    end;
                }
                separator(Action147)
                {
                }
            }
            action("Create &Interact")
            {
                ApplicationArea = Basic;
                Caption = 'Create &Interact';
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.CreateInteraction;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetCurrRecord;
    end;

    trigger OnInit()
    begin
        NoofJobResponsibilitiesEnable := true;
        OrganizationalLevelCodeEnable := true;
        "Company NameEnable" := true;
        "Company No.Enable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        GetCurrRecord;
    end;

    var
        Cont: Record Contact;
        Text000: label 'Your mail client has returned the following error.\';
        Text001: label 'R E C A L L   %1 ';
        Text002: label 'Please call %1. Phone: %2 - %3 extension: %4';
        TAPIManagement: Codeunit TAPIManagement;
        CompanyDetails: Page "Company Details";
        NameDetails: Page "Name Details";
        "Company No.Enable": Boolean;
        "Company NameEnable": Boolean;
        OrganizationalLevelCodeEnable: Boolean;
        NoofJobResponsibilitiesEnable: Boolean;


    procedure EnableFields()
    begin
        "Company No.Enable" := Rec.Type = Rec.Type::Person;
        "Company NameEnable" := Rec.Type = Rec.Type::Person;
        OrganizationalLevelCodeEnable := Rec.Type = Rec.Type::Person;
        NoofJobResponsibilitiesEnable := Rec.Type = Rec.Type::Person;
    end;

    local procedure TypeOnAfterValidate()
    begin
        EnableFields;
    end;

    local procedure GetCurrRecord()
    begin
        xRec := Rec;
        EnableFields;
    end;
}

