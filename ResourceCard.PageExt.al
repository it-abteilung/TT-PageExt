PageExtension 50026 pageextension50026 extends "Resource Card"
{
    layout
    {
        addafter("Time Sheet Approver User ID")
        {
            field(Vendor; Rec.Vendor)
            {
                ApplicationArea = Basic;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = Basic;
            }
        }
        addlast("Personal Data")
        {
            field("User ID"; Rec."User Id")
            {
                ApplicationArea = All;
                Caption = 'Benutzer-ID';
            }
        }
        moveafter("Address 2"; "Post Code")

        addlast(content)
        {
            group("TT-Ausweisinformationen")
            {

                Caption = 'TT-Ausweisinformationen';

                field("Id Card"; Rec."Id Card")
                {
                    ApplicationArea = all;
                    Caption = 'besitzt TT-Ausweis';
                    Editable = false;
                }
                field("Issued On"; Rec."Id Issued On")
                {
                    ApplicationArea = all;
                    Caption = 'Ausgestellt am';
                    Editable = false;
                }
                field("Expires On"; Rec."Id Expires On")
                {
                    ApplicationArea = all;
                    Caption = 'Gültig bis';
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        addlast(Promoted)
        {
            actionref(ATK; "Employee Card History") { }
        }

        addlast(processing)
        {
            action("Employee Card History")
            {
                ApplicationArea = all;
                Caption = 'Nachverfolgung';
                Image = OrderTracking;

                RunObject = Page "Employee Card History";
                RunPageLink = "No." = field("No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        EmployeeCardHistory_L: Record "Employee Card History";
    begin
        EmployeeCardHistory_L.Reset();
        EmployeeCardHistory_L.SetRange("No.", Rec."No.");
        if NOT EmployeeCardHistory_L.IsEmpty() then begin
            EmployeeCardHistory_L.SetRange("Returned On", 0D);
            if EmployeeCardHistory_L.IsEmpty() then begin
                Rec."Id Card" := false;
                Rec."Id Issued On" := 0D;
                Rec."Id Expires On" := 0D;
            end
            else begin
                EmployeeCardHistory_L.SetRange("Returned On");
                if EmployeeCardHistory_L.FindLast() then begin
                    Rec."Id Card" := true;
                    Rec."Id Issued On" := EmployeeCardHistory_L."Issued On";
                    Rec."Id Expires On" := EmployeeCardHistory_L."Expired On";
                end;
            end;
            Rec.Modify();
        end
        else begin
            Rec."Id Card" := false;
            Rec."Id Issued On" := 0D;
            Rec."Id Expires On" := 0D;
            Rec.Modify();
        end;
    end;
}

