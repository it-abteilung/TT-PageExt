page 50116 "Job List Part"
{
    Caption = 'Job List Part';
    PageType = ListPart;
    SourceTable = "Job";
    SourceTableView = sorting("No.") order(descending);
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Job No.';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        Job_L: Record Job;
                    begin
                        if Rec."No." <> '' then
                            if Job_L.Get(Rec."No.") then
                                RunModal(Page::"Job Card", Job_L)
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        Job_L: Record Job;
                    begin
                        if Rec."No." <> '' then
                            if Job_L.Get(Rec."No.") then
                                RunModal(Page::"Job Card", Job_L)
                    end;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Starting Date';
                    Editable = false;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    Caption = 'Ending Date';
                    Editable = false;
                }
            }
        }
    }
}