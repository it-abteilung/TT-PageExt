pageextension 50032 PhysInventoryRecordingList extends "Phys. Inventory Recording List"
{
    layout
    {
        addafter("Person Recorded")
        {
            field(Threshold; Rec.Threshold)
            {
                ApplicationArea = All;
                Caption = 'Maximale Abweichung (%)';
            }
            field(Delta_G; Delta_G)
            {
                ApplicationArea = All;
                Editable = false;
                StyleExpr = StyleExpr_G;
                Caption = 'Delta';
                ToolTip = 'Gibt die Anzahl der Zeilen an, diese sich nicht im Interval der erfassten Mengen befinden.\ Das Interval besteht aus der erfassten Menge +- maximalen Abweichung.';
            }
            field(StillOpen_G; StillOpen_G)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Nicht Erfasst';
                ToolTip = 'Gibt die Anzahl der Zeilen an, diese noch nicht als "Erfasst" markiert wurden.';
            }
        }
    }

    var
        StyleExpr_G: Text;
        Delta_G: Decimal;
        StillOpen_G: Decimal;

    trigger OnAfterGetRecord()
    var
        PhysInvtOrderLine_L: Record "Phys. Invt. Order Line";
        PhysInvtRecordLine_L: Record "Phys. Invt. Record Line";
        ThresholdDelta_L: Decimal;
    begin
        StyleExpr_G := 'Favorable';
        Delta_G := 0;
        StillOpen_G := 0;

        PhysInvtRecordLine_L.SetRange("Order No.", Rec."Order No.");
        PhysInvtRecordLine_L.SetRange("Recording No.", Rec."Recording No.");
        if PhysInvtRecordLine_L.FindSet() then begin
            repeat
                PhysInvtOrderLine_L.SetRange("Document No.", PhysInvtRecordLine_L."Order No.");
                PhysInvtOrderLine_L.SetRange("Item No.", PhysInvtRecordLine_L."Item No.");
                PhysInvtOrderLine_L.SetRange("Location Code", PhysInvtRecordLine_L."Location Code");
                PhysInvtOrderLine_L.SetRange("Bin Code", PhysInvtRecordLine_L."Bin Code");
                if PhysInvtOrderLine_L.FindFirst() then begin
                    ThresholdDelta_L := PhysInvtOrderLine_L."Qty. Expected (Base)" * Rec.Threshold / 100;
                    if PhysInvtRecordLine_L.Quantity > (PhysInvtOrderLine_L."Qty. Expected (Base)" + ThresholdDelta_L) then begin
                        Delta_G += 1;
                    end else if PhysInvtRecordLine_L.Quantity < (PhysInvtOrderLine_L."Qty. Expected (Base)" - ThresholdDelta_L) then begin
                        Delta_G += 1;
                    end;
                end;

                if NOT PhysInvtRecordLine_L.Recorded then
                    StillOpen_G += 1;
            until PhysInvtRecordLine_L.Next() = 0;
        end;

        if Delta_G > 0 then
            StyleExpr_G := 'Unfavorable';

    end;
}