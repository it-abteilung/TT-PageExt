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
            field(Insurance; Insurance)
            {
                ApplicationArea = Basic;
                Caption = '1,5% Versich.';
                DecimalPlaces = 2 : 2;
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
        Insurance: Decimal;

    trigger OnAfterGetRecord()
    var
        Job_L: Record Job;
        JobLedgerEntry: Record "Job Ledger Entry";
        JobPlanningLine_L: Record "Job Planning Line";
        JobType_l: Record "Job Type";
        LiquidityPlanning_l: Record "Liquidity Planning";
        PurchaseHeader_l: Record "Purchase Header";
        PurchInvHeader_l: Record "Purch. Inv. Header";
        PurchCrMemoHdr_l: Record "Purch. Cr. Memo Hdr.";
        JobSum_l: Decimal;
        JobSumDiscount_l: Decimal;

        LagegrmaterialIst: Decimal;
        TotalCost_Soll: Decimal;
        TotalCost_Ist: Decimal;
    begin
        TotalCost_Ist := 0;
        TotalCost_Soll := 0;
        LagegrmaterialIst := 0;

        CLEAR(JobPlanningLine);
        JobPlanningLine.SETRANGE("Job No.", Rec."No.");
        JobPlanningLine.CALCSUMS(Quantity, Lohnkosten, Materialkosten, Fremdarbeitenkosten, Fremdlieferungskosten, Transportkosten, Hotelkosten, Flugkosten, Auslöse);

        Gesamtpr := JobPlanningLine.Lohnkosten + JobPlanningLine.Materialkosten + JobPlanningLine.Fremdarbeitenkosten + JobPlanningLine.Fremdlieferungskosten
                    + JobPlanningLine.Transportkosten + JobPlanningLine.Hotelkosten + JobPlanningLine.Flugkosten + JobPlanningLine.Auslöse;

        Insurance := (Gesamtpr - Rec."Nachlass in Euro") / 101.5 * 1.5;
    end;
}
