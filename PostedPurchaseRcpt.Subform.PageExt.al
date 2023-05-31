PageExtension 50036 pageextension50036 extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter(Correction)
        {
            field("LOT-Nr. / Chargennr."; Rec."LOT-Nr. / Chargennr.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

