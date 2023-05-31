#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
PageExtension 50030 pageextension50030 extends "Sales Quote Subform"
{
    layout
    {
        addafter("No.")
        {
            field("Part No."; Rec."Part No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(ShortcutDimCode8)
        {
            field(Delivery; Rec.Delivery)
            {
                ApplicationArea = Basic;
            }
        }
        moveafter("Unit Price"; "Line Amount")
    }
}

