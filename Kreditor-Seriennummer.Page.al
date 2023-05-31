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
                field("Ignore Vendor"; Rec."Ignore Vendor")
                {
                    ApplicationArea = Basic;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = Basic;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(Erledigt; Rec.Erledigt)
                {
                    ApplicationArea = Basic;
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
                }
                field("Send Mail To"; Rec."Send Mail To")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::OK then begin
            if Rec.GetFilter(Serienanfragenr) <> '' then begin
                if Rec.FindSet() then begin
                    repeat
                        Rec.TestField("Buy-from Contact No.");
                        Rec.TestField("Buy-from Contact");
                        Rec.TestField("Send Mail To");
                    until (Rec.Next() = 0);
                end;
            end;
        end;
    end;
}

