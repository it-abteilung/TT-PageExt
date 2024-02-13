#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50042 "Kreditor - Seriennummer"
{
    PageType = List;
    SourceTable = "Vendor - Serienanfrage";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Use Vendor"; Rec."Use Vendor")
                {
                    ApplicationArea = Basic;
                    Caption = 'Verwende Kreditor';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Erledigt; Rec.Erledigt)
                {
                    ApplicationArea = Basic;
                    Caption = 'Anfrage erz.';
                    Editable = false;
                }
                field("Buy-from Contact No."; Rec."Buy-from Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field("Buy-from Contact"; Rec."Buy-from Contact")
                {
                    ApplicationArea = Basic;
                }
                field("Buy-from Contact Ansprech"; Rec."Buy-from Contact Ansprech")
                {
                    ApplicationArea = Basic;
                }
                field("Serienanfrage erstellt"; Rec."Serienanfrage erstellt")
                {
                    ApplicationArea = Basic;
                }
                field("Send Mail"; Rec."Send Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Mail is Send"; Rec."Mail is Send")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Send Mail To"; Rec."Send Mail To")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        ContCompany: Record Contact;
        ContPerson: Record Contact;
    begin
        ContCompany.Reset();
        ContPerson.Reset();
        if Rec."Buy-from Contact No." = '' then begin
            ContCompany.SetRange("Vendor No.", Rec."No.");
            ContCompany.SetRange(Type, ContCompany.Type::Company);
            if ContCompany.FindFirst() then begin
                ContPerson.SetRange("Company No.", ContCompany."No.");
                ContPerson.SetRange(Type, ContPerson.Type::Person);
                if ContPerson.Count() = 1 then
                    if ContPerson.FindFirst() then begin
                        Rec.Validate("Buy-from Contact No.", ContPerson."No.");
                        Rec.Validate("Buy-from Contact", ContPerson.Name);
                        Rec.Modify();
                    end;
            end;
        end;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::OK then begin
            if Rec.GetFilter(Serienanfragenr) <> '' then begin
                if Rec.FindSet() then begin
                    repeat
                        if Rec."Use Vendor" then begin
                            Rec.TestField("Buy-from Contact No.");
                            Rec.TestField("Buy-from Contact");
                            Rec.TestField("Send Mail To");
                        end;
                    until (Rec.Next() = 0);
                end;
            end;
        end;
    end;
}

