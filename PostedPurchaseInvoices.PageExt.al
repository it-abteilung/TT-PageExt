PageExtension 50040 pageextension50040 extends "Posted Purchase Invoices"
{
    layout
    {
        addafter("Amount Including VAT")
        {
            field("Betrag (MW)"; AmountLCY)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Remaining Amount")
        {
            field("Remaining Amount (LCY)"; Rec."Remaining Amount (LCY)")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter(Cancelled)
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Basic;
            }
            field(Leistung; Rec.Leistung)
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Corrective)
        {
            field(Leistungsart; Rec.Leistungsart)
            {
                ApplicationArea = Basic;
            }
            field(Leistungszeitraum; Rec.Leistungszeitraum)
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
    var
        "*G-ERP*": Integer;
        AmountLCY: Decimal;
        VendLedgEntry: Record "Vendor Ledger Entry";

    trigger OnAfterGetRecord()
    begin

        AmountLCY := 0;
        VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETRANGE("Document No.", Rec."No.");
        VendLedgEntry.SETRANGE("Document Type", VendLedgEntry."Document Type"::Invoice);
        VendLedgEntry.SETRANGE("Vendor No.", Rec."Pay-to Vendor No.");
        IF VendLedgEntry.FINDFIRST THEN
            AmountLCY := -VendLedgEntry."Purchase (LCY)";
    end;
}

