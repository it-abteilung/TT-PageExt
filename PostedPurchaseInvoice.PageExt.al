
PageExtension 50037 pageextension50037 extends "Posted Purchase Invoice"
{
    layout
    {
        addafter(Corrective)
        {
            field("CO2 Menge in Kilogramm"; Rec."CO2 Menge in Kilogramm")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

