page 50202 JobMarineOpenPart
{
    Caption = 'Projekte - Offen';
    PageType = ListPart;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = Job;
    SourceTableView = SORTING("No.") ORDER(descending) WHERE(Status = filter(Open));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Projekt-Nr.';
                    TableRelation = Job;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Beschreibung';
                }
                field(Customer; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Debitor';
                }
                field("Gesamtpreis inkl. Nachlass"; Gesamtpr - Rec."Nachlass in Euro")
                {
                    ApplicationArea = Basic;
                    Caption = 'Gesamtpreis inkl. Nachlass';
                    Visible = true;
                }
                field(Objektname; Rec.Objektname)
                {
                    ApplicationArea = All;
                    Caption = 'Objekt';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("To Job List")
            {
                ApplicationArea = All;
                Caption = 'Gefilterte Projektliste';
                Image = Job;

                trigger OnAction()
                begin
                    Page.Run(Page::"Job List", Rec);
                end;
            }
        }
    }

    var
        Gesamtpr: Decimal;

    trigger OnOpenPage()
    var
        EmployeeToJobType: Record "Employee To Job Type";
        TextBuilderTmp: TextBuilder;
    begin
        EmployeeToJobType.SetRange("User ID", UserId);
        if EmployeeToJobType.FindSet() then begin
            repeat
                if TextBuilderTmp.Length <> 0 then
                    TextBuilderTmp.Append(' | ');
                TextBuilderTmp.Append(EmployeeToJobType."Job Type")
            until EmployeeToJobType.Next() = 0;
        end;
        Rec.SetFilter("Job Type", TextBuilderTmp.ToText());

        // Rec.SetFilter(SystemCreatedAt, '> %1', CreateDateTime(CalcDate('<CD-2D>', Today), 0T));
    end;

    trigger OnAfterGetRecord()
    begin
        CalcFullAmount();
    end;

    local procedure CalcFullAmount()
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        CLEAR(JobPlanningLine);
        JobPlanningLine.SETRANGE("Job No.", Rec."No.");
        JobPlanningLine.CALCSUMS(Quantity, Lohnkosten, Materialkosten, Fremdarbeitenkosten, Fremdlieferungskosten, Transportkosten, Hotelkosten, Flugkosten, Auslöse);
        Gesamtpr := JobPlanningLine.Lohnkosten + JobPlanningLine.Materialkosten + JobPlanningLine.Fremdarbeitenkosten + JobPlanningLine.Fremdlieferungskosten + JobPlanningLine.Transportkosten + JobPlanningLine.Hotelkosten + JobPlanningLine.Flugkosten + JobPlanningLine.Auslöse;
    end;

}