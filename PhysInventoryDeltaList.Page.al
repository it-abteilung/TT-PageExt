page 50085 "Phys. Inventory Delta List"
{
    Caption = 'Differenzen - Inventur';
    PageType = List;
    SourceTable = "Phys. Invt. Record Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the item that was counted when taking the physical inventory.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the item.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the additional description of the item.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the location where the item was counted during taking the physical inventory.';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the bin where the item was counted while performing the physical inventory.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity of the item of the physical inventory recording line.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
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
    }



    var
        StyleExpr: Text;
        DeltaOverQty: Decimal;
        DeltaOverQtySort: Decimal;
        Threshold_G: Decimal;

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

    procedure SetThreshold(Threshold_L: Decimal)
    begin
        Threshold_G := Threshold_L;
    end;
}