PageExtension 50068 pageextension50068 extends "Purchase Order List"
{
    Caption = 'Purchase Orders';

    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Basic;
                Caption = 'Job No.';
            }
            field(Leistung; Rec.Leistung)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Amount Including VAT")
        {
            field("Status Purchase"; Rec."Status Purchase")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("CO2 Menge in Kilogramm"; Rec."CO2 Menge in Kilogramm")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
}

