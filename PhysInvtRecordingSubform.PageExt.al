pageextension 50018 PhysInvtRecordingSubform extends "Phys. Invt. Recording Subform"
{
    layout
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        addafter(Quantity)
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
        PhysInvtRecordHeader: Record "Phys. Invt. Record Header";
        ThresholdDelta: Decimal;
    begin
        StyleExpr := 'Favorable';

        DeltaOverQty := 0;
        DeltaOverQtySort := 0;

        if PhysInvtRecordHeader.Get(Rec."Order No.", Rec."Recording No.") then begin
            PhysInvtOrderLine.SetRange("Document No.", Rec."Order No.");
            PhysInvtOrderLine.SetRange("Item No.", Rec."Item No.");
            PhysInvtOrderLine.SetRange("Location Code", Rec."Location Code");
            PhysInvtOrderLine.SetRange("Bin Code", Rec."Bin Code");

            if PhysInvtOrderLine.FindFirst() then begin
                DeltaOverQtySort := Rec.Quantity - PhysInvtOrderLine."Qty. Expected (Base)";
                ThresholdDelta := PhysInvtOrderLine."Qty. Expected (Base)" * PhysInvtRecordHeader.Threshold / 100;
                if Rec.Quantity > (PhysInvtOrderLine."Qty. Expected (Base)" + ThresholdDelta) then begin
                    DeltaOverQty := Rec.Quantity - PhysInvtOrderLine."Qty. Expected (Base)";
                    StyleExpr := 'Unfavorable';
                end else if Rec.Quantity < (PhysInvtOrderLine."Qty. Expected (Base)" - ThresholdDelta) then begin
                    DeltaOverQty := Rec.Quantity - PhysInvtOrderLine."Qty. Expected (Base)";
                    StyleExpr := 'Unfavorable';
                end;
            end;
        end;
    end;
}