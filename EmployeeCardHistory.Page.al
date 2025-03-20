page 50098 "Employee Card History"
{
    PageType = List;
    SourceTable = "Employee Card History";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Issued On"; Rec."Issued On")
                {
                    ApplicationArea = All;
                    Caption = 'Ausgestellt am';
                    ToolTip = 'Specifies the value of the Issued On field.';

                    trigger OnValidate()
                    begin
                        if Rec."Expired On" = 0D then
                            Rec."Expired On" := Rec."Issued On";
                    end;
                }
                field("Expired On"; Rec."Expired On")
                {
                    ApplicationArea = All;
                    Caption = 'Gültig bis';
                    ToolTip = 'Specifies the value of the Expired On field.';
                }
                field("Returned On"; Rec."Returned On")
                {
                    ApplicationArea = All;
                    Caption = 'Rückgabe am';
                    ToolTip = 'Specifies the value of the Returned On field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Bemerkung';
                    ToolTip = 'Specifies the value of the Comment field.';
                }
            }
        }
    }
}

