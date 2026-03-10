page 50114 "Contact Lookup"
{
    Caption = 'Contact Lookup';
    Editable = false;
    PageType = StandardDialog;
    SourceTable = "Contact";
    SourceTableView = sorting("No.") order(ascending);


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                    Caption = 'First Name';
                }
                field(Surname; Rec.Surname)
                {
                    ApplicationArea = All;
                    Caption = 'Surname';
                }
                field("Name"; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                    Caption = 'Name 2';
                }
                field("Name 3"; Rec."Name 3")
                {
                    ApplicationArea = All;
                    Caption = 'Name 3';
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = All;
                    Caption = 'Job Title';
                }

            }
        }
    }
}