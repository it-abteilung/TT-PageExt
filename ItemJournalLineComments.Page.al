page 50093 "Item Journal Line Comments"
{
    ApplicationArea = All;
    Caption = 'Lagerplatzposten - Kommentare';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Item Journal Comment";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Lfd.-Nr.';
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    Caption = 'Postenart';
                    ToolTip = 'Specifies the value of the Entry Type field.', Comment = '%';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Artikelnr.';
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    Caption = 'Seriennr.';
                    ToolTip = 'Specifies the value of the Serial No. field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Menge';
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Short Comment"; Rec."Short Comment")
                {
                    ApplicationArea = All;
                    Caption = 'Kommentar';
                    ToolTip = 'Specifies the value of the Short Comment field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Caption = 'Erstellt am';
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
            }
        }
    }
}