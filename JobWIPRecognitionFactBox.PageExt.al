PageExtension 50064 pageextension50064 extends "Job WIP/Recognition FactBox"
{
    layout
    {
        addafter("Calc. Recog. Costs Amount")
        {
            field("Arbeitsstd. Gesamt"; JobPlanningLine.Quantity)
            {
                ApplicationArea = Basic;
                Caption = 'Arbeitsstd. Gesamt';
                DecimalPlaces = 2 : 2;
            }
            field(Lohnkosten; JobPlanningLine.Lohnkosten)
            {
                ApplicationArea = Basic;
                DecimalPlaces = 2 : 2;
            }
            field("Verkaufspreis für Material"; JobPlanningLine.Materialkosten)
            {
                ApplicationArea = Basic;
                DecimalPlaces = 2 : 2;
            }
            field("Verkaufspreis Fremdleistung"; JobPlanningLine.Fremdarbeitenkosten)
            {
                ApplicationArea = Basic;
                DecimalPlaces = 2 : 2;
            }
            field("Verkaufspreis Fremdlieferung"; JobPlanningLine.Fremdlieferungskosten)
            {
                ApplicationArea = Basic;
            }
            field("Verkaufspreis Transport"; JobPlanningLine.Transportkosten)
            {
                ApplicationArea = Basic;
            }
            field("Verkaufspreis Hotel"; JobPlanningLine.Hotelkosten)
            {
                ApplicationArea = Basic;
            }
            field("Verkaufspreis Flugkosten"; JobPlanningLine.Flugkosten)
            {
                ApplicationArea = Basic;
            }
            field("Verkaufspreis Auslöse"; JobPlanningLine.Auslöse)
            {
                ApplicationArea = Basic;
            }
            field(Gesamtpreis; Gesamtpr)
            {
                ApplicationArea = Basic;
                DecimalPlaces = 2 : 2;
                Style = Standard;
                StyleExpr = true;
            }
            field("Nachlass (netto)"; Rec."Nachlass in Euro")
            {
                ApplicationArea = Basic;
            }
            field("Gesamtpreis incl. Nachlass"; Gesamtpr - Rec."Nachlass in Euro")
            {
                ApplicationArea = Basic;
            }
        }
    }

    var
        JobPlanningLine: Record "Job Planning Line";
        Gesamtpr: Decimal;

    trigger OnAfterGetRecord()
    begin

        CLEAR(JobPlanningLine);
        JobPlanningLine.SETRANGE("Job No.", Rec."No.");
        JobPlanningLine.CALCSUMS(Quantity, Lohnkosten, Materialkosten, Fremdarbeitenkosten, Fremdlieferungskosten,
                                 Transportkosten, Hotelkosten, Flugkosten, Auslöse);
        Gesamtpr := JobPlanningLine.Lohnkosten + JobPlanningLine.Materialkosten + JobPlanningLine.Fremdarbeitenkosten +
                    JobPlanningLine.Fremdlieferungskosten + JobPlanningLine.Transportkosten + JobPlanningLine.Hotelkosten +
                    JobPlanningLine.Flugkosten + JobPlanningLine.Auslöse;
    end;
}

