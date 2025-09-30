PageExtension 50027 pageextension50027 extends "Resource List"
{
    Caption = 'Resource List';

    layout
    {
        addafter("Default Deferral Template Code")
        {
            field(Vendor; Rec.Vendor)
            {
                ApplicationArea = Basic;
            }
        }
        addlast(Control1)
        {
            field("ATK Id Card"; Rec."Id Card")
            {
                ApplicationArea = all;
                Caption = 'besitzt TT-Ausweis';
                ToolTip = 'Specifies the value of the besitzt TT-Ausweis field.';
            }
            field("ATK Issued On"; Rec."Id Issued On")
            {
                ApplicationArea = all;
                Caption = 'TT-Ausweis ausgestellt am';
                ToolTip = 'Specifies the value of the TT-Ausweis ausgestellt am.';
            }
            field("ATK Expires On"; Rec."Id Expires On")
            {
                ApplicationArea = all;
                Caption = 'TT-Ausweis gültig bis';
                ToolTip = 'Specifies the value of the TT-Ausweis gültig bis field.';
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            //     action("Switch Job Responsible Person")
            //     {
            //         ApplicationArea = All;
            //         Caption = 'Neue PN -> Verantwortliche Person';

            //         trigger OnAction()
            //         var
            //             Job_L: Record Job;
            //             ResLedgerEntry: Record "Res. Ledger Entry";
            //             asfd: Record "Job Ledger Entry";
            //         begin
            //             Job_L.SetRange("Person Responsible", '30184');
            //             if Job_L.FindSet() then
            //                 Job_L.ModifyAll("Person Responsible", '20015');
            //             Clear(Job_L);
            //             Job_L.SetRange(Verfasser, '30184');
            //             if Job_L.FindSet() then
            //                 Job_L.ModifyAll(Verfasser, '20015');

            //             ResLedgerEntry.SetRange("Resource No.", '30184');
            //             if ResLedgerEntry.FindSet() then
            //                 ResLedgerEntry.ModifyAll("Resource No.", '20015');
            //         end;
            //     }
            action("Update Resource History")
            {
                ApplicationArea = All;
                Caption = 'Update Ressourcenhistorie';

                trigger OnAction()
                var
                    Resource_L: Record Resource;
                    EmployeeCardHistory_L: Record "Employee Card History";
                begin
                    Resource_L.SetRange(Blocked, false);
                    if Resource_L.FindSet() then
                        repeat
                            EmployeeCardHistory_L.Reset();
                            EmployeeCardHistory_L.SetRange("No.", Rec."No.");
                            if NOT EmployeeCardHistory_L.IsEmpty() then begin
                                EmployeeCardHistory_L.SetRange("Returned On", 0D);
                                if EmployeeCardHistory_L.IsEmpty() then begin
                                    Resource_L."Id Card" := false;
                                    Resource_L."Id Issued On" := 0D;
                                    Resource_L."Id Expires On" := 0D;
                                end else begin
                                    EmployeeCardHistory_L.SetRange("Returned On");
                                    if EmployeeCardHistory_L.FindLast() then begin
                                        Resource_L."Id Card" := true;
                                        Resource_L."Id Issued On" := EmployeeCardHistory_L."Issued On";
                                        Resource_L."Id Expires On" := EmployeeCardHistory_L."Expired On";
                                    end;
                                end;
                                Resource_L.Modify();
                            end else begin
                                Resource_L."Id Card" := false;
                                Resource_L."Id Issued On" := 0D;
                                Resource_L."Id Expires On" := 0D;
                                Resource_L.Modify();
                            end;
                        until Resource_L.Next() = 0;
                end;
            }
        }
    }
}

