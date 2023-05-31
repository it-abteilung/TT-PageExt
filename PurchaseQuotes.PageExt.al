PageExtension 50067 pageextension50067 extends "Purchase Quotes"
{
    layout
    {
        addafter("No.")
        {
            field(Serienanfragennr; Rec.Serienanfragennr)
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Status)
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Basic;
            }
            field(Leistung; Rec.Leistung)
            {
                ApplicationArea = Basic;
            }
            field(Bestellnummer; Rec.Bestellnummer)
            {
                ApplicationArea = Basic;
            }
            field("Keine Angebotsabgabe"; Rec."Keine Angebotsabgabe")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Quote No."; Rec."Quote No.")
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
        ApprovalEntries: Page "Approval Entries";

}

