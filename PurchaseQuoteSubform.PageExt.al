PageExtension 50031 pageextension50031 extends "Purchase Quote Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Description 3 FlowField"; Rec."Description 3 FlowField")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Description 4"; Rec."Description 4")
            {
                ApplicationArea = Basic;
                Caption = 'Zusätzliche Anforderungen 1';
            }
            field("Description 5"; Rec."Description 5")
            {
                ApplicationArea = Basic;
                Caption = 'Zusätzliche Anforderungen 2';
            }
            field("Vendor Item No."; Rec."Vendor Item No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Allow Invoice Disc.")
        {
            field("CO2 Menge in Kilogramm"; Rec."CO2 Menge in Kilogramm")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(ShortcutDimCode8)
        {
            field("Requested Receipt Date"; Rec."Requested Receipt Date")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

