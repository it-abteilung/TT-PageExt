Page 82000 "Contact Person Subform"
{
    CardPageID = "Contact Person Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = Contact;
    SourceTableView = sorting("Company No.", Type, "Display Level", Surname)
                      where(Type = const(Person));
    Caption = 'Ansprechpartner';

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Company No."; Rec."Company No.")
                {
                    ApplicationArea = All;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                }
                field(Name; rec.Name)
                {
                    ApplicationArea = Basic;
                }
                field(City; rec.City)
                {
                    ApplicationArea = Basic;
                }
                field("Phone No."; rec."Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(Image; rec.Image)
                {
                    ApplicationArea = Basic;
                }
                field("Salutation Code"; rec."Salutation Code")
                {
                    ApplicationArea = Basic;
                }
                field("First Name"; rec."First Name")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                }
                field(Surname; rec.Surname)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = NameEmphasize;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CurrPage.SaveRecord;
                        Commit;
                        Page.RunModal(Page::"Contact Person Card", Rec);
                        CurrPage.Update(true);
                    end;
                }
                field("Extension No."; rec."Extension No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnAssistEdit()
                    var
                        TAPIManagement: Codeunit TAPIManagement;
                        DialString: Text[100];
                    begin
                        if rec."Extension No." = '' then
                            DialString := rec."Phone No."
                        else
                            if StrPos(rec."Phone No.", '-') <> 0 then
                                DialString := CopyStr(rec."Phone No.", 1, StrPos(rec."Phone No.", '-') - 1)
                            else
                                DialString := rec."Phone No.";
                        if rec."Dialing Code" <> '' then
                            DialString := rec."Dialing Code" + '-' + DialString;
                        if rec."Extension No." <> '' then
                            DialString := DialString + '-' + rec."Extension No.";

                        TAPIManagement.DialContCustVendBank(Database::Contact, rec."No.", DialString, '');
                    end;
                }
                field("Mobile Phone No."; rec."Mobile Phone No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("No. of Job Responsibilities"; rec."No. of Job Responsibilities")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        ContJobResp: Record "Contact Job Responsibility";
                    begin
                        CurrPage.SaveRecord;
                        Commit;
                        ContJobResp.SetRange("Contact No.", rec."No.");
                        Page.RunModal(Page::"Contact Job Responsibilities", ContJobResp);
                        CurrPage.Update(false);
                    end;
                }
                field("Job Responsibilities"; rec."Job Responsibilities")
                {
                    ApplicationArea = Basic;

                    trigger OnDrillDown()
                    var
                        ContJobResp: Record "Contact Job Responsibility";
                    begin
                        CurrPage.SaveRecord;
                        Commit;
                        ContJobResp.SetRange("Contact No.", rec."No.");
                        Page.RunModal(Page::"Contact Job Responsibilities", ContJobResp);
                        CurrPage.Update(false);
                    end;
                }
                field("Organizational Level Code"; rec."Organizational Level Code")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail"; rec."E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Person Information"; rec."Person Information")
                {
                    ApplicationArea = Basic;
                    Caption = 'Information / internal mail';
                }
                field("Display Level"; rec."Display Level")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        DisplayLevelOnAfterValidate;
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Funktion)
            {
                action(CreateNewContact)
                {
                    Caption = 'Neue Person anlegen';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        CRMPlusFunctions: Codeunit "CRMPlus Functions";
                        rContactnew: Record Contact;
                    begin
                        CRMPlusFunctions.insertPerson(Rec, rContactnew);
                        CurrPage.SAVERECORD;
                        IF rec.GET(rContactnew."No.") THEN;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                action(DeleteContact)
                {
                    Caption = 'Person zum Löschen markieren';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        CRMPlusFunctions: Codeunit "CRMPlus Functions";
                    begin
                        IF CONFIRM('Person wirklich zum Löschen markieren?') THEN BEGIN
                            CRMPlusFunctions.DeletePerson(Rec);
                            CurrPage.UPDATE(FALSE);
                        END;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
    end;

    trigger OnAfterGetRecord()
    var
        Contact_L: Record Contact;
    begin
        NameOnFormat;
    end;

    trigger OnModifyRecord(): Boolean
    var
        ChangeLogManagement: Codeunit "Change Log Management";
        recref: RecordRef;
        xrecref: RecordRef;
    begin
        recref.GetTable(Rec);
        xrecref.GetTable(xRec);
        ChangeLogManagement.LogModification(recref);

        rec.Modify();
        Commit();
        CurrPage.Update(false);
    end;

    var
        Text000: label 'Your mail client has returned the following error.\';
        Text001: label 'R E C A L L   %1 ';
        Text002: label 'Please call %1. Phone: %2 - %3 extension: %4';
        NameEmphasize: Boolean;
        ShowParentContact_G: Boolean;
        ContactNo_G: Code[20];

    local procedure DisplayLevelOnAfterValidate()
    begin
        CurrPage.Update(true);
    end;

    local procedure NameOnFormat()
    begin
        if rec."Display Level" = 10 then begin
            NameEmphasize := true;
        end else begin
            NameEmphasize := false;
        end;
    end;

    procedure ShowParentContact(ShowParentContact_L: Boolean)
    begin
        ShowParentContact_G := ShowParentContact_L;
    end;
}

