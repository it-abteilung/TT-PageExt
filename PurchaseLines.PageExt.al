PageExtension 50046 pageextension50046 extends "Purchase Lines"
{
    layout
    {
        addafter("Amt. Rcd. Not Invoiced (LCY)")
        {
            field("CO2 Menge in Kilogramm"; Rec."CO2 Menge in Kilogramm")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

