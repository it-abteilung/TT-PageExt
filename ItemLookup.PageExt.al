pageextension 50053 ItemLookup extends "Item Lookup"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                Caption = 'Beschreibung 2';
            }
            field("Description 3"; Rec."Description 3")
            {
                ApplicationArea = All;
                Caption = 'Beschreibung 3';
            }
            field(DIN; Rec.DIN)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the DIN field.', Comment = '%';
            }
            field(ASME; Rec.ASME)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ASME field.', Comment = '%';
            }
            field(ISO; Rec.ISO)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ISO field.', Comment = '%';
            }
        }
    }
}