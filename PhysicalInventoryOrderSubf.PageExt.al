pageextension 50029 PhysicalInventoryOrderSubf extends "Physical Inventory Order Subf."
{
    layout
    {
        addafter("Qty. Recorded (Base)")
        {
            field(DeltaOverQty; DeltaOverQty)
            {
                ApplicationArea = All;
                Editable = false;
                StyleExpr = StyleExpr;
                Caption = 'Delta-Menge 1';
                ToolTip = 'Differenz zwischen der gezählten Menge und dem aktuellen Lagerbestand. Gezählte Mengen unter der maximalen Abweichung werden auf 0 gerundet.';
            }
            field(DeltaOverQtySort; DeltaOverQtySort)
            {
                ApplicationArea = All;
                Editable = false;
                StyleExpr = StyleExpr;
                Caption = 'Delta-Menge 2';
                ToolTip = 'Differenz zwischen der gezählten Menge und dem aktuellen Lagerbestand.';
            }
        }
    }

    actions
    {
        addlast(processing)
        {
        }
    }

    var
        StyleExpr: Text;
        DeltaOverQty: Decimal;
        DeltaOverQtySort: Decimal;

    trigger OnAfterGetRecord()
    var
        PhysInvtOrderLine: Record "Phys. Invt. Order Line";
        PhysInvtOrderHeader: Record "Phys. Invt. Order Header";
        ThresholdDelta: Decimal;
    begin
        StyleExpr := 'Favorable';

        DeltaOverQty := 0;
        DeltaOverQtySort := 0;

        if PhysInvtOrderHeader.Get(Rec."Document No.") then begin

            DeltaOverQtySort := Rec."Qty. Recorded (Base)" - PhysInvtOrderLine."Qty. Expected (Base)";
            ThresholdDelta := Rec."Qty. Expected (Base)" * PhysInvtOrderHeader.Threshold / 100;
            if Rec."Qty. Recorded (Base)" > (Rec."Qty. Expected (Base)" + ThresholdDelta) then begin
                DeltaOverQty := Rec."Qty. Recorded (Base)" - Rec."Qty. Expected (Base)";
                StyleExpr := 'Unfavorable';
            end else if Rec."Qty. Recorded (Base)" < (Rec."Qty. Expected (Base)" - ThresholdDelta) then begin
                DeltaOverQty := Rec."Qty. Recorded (Base)" - Rec."Qty. Expected (Base)";
                StyleExpr := 'Unfavorable';
            end;
        end;
    end;
}