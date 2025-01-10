pageextension 50017 PhysInventoryRecording extends "Phys. Inventory Recording"
{
    layout
    {
        addlast(General)
        {
            field(Threshold; Rec.Threshold)
            {
                ApplicationArea = All;
                Caption = 'Maximale Abweichung (%)';
                ToolTip = 'Die maximal erlaubte Abweichung zwischen gezählter Menge und dem aktuellen Lagerbestand in Prozent.';

                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
        }
    }

    actions
    {
        addlast(Promoted)
        {
            actionref(PrintNew; Print_New) { }
            actionref(ShowDelta; Show_Delta) { }
        }
        addafter(Print)
        {
            action(Print_New)
            {
                ApplicationArea = All;
                Caption = 'Drucken (TT)';
                Image = Print;

                trigger OnAction()
                var
                    PhysInvtRecording_R: Report "Phys. Invt. Recording";
                begin
                    PhysInvtRecording_R.SetTableView(Rec);
                    PhysInvtRecording_R.RunModal();
                end;
            }
            action(Show_Delta)
            {
                ApplicationArea = All;
                Caption = 'Differenzen';
                Image = Questionnaire;

                trigger OnAction()
                var
                    PhysInvtRecordLine_L: Record "Phys. Invt. Record Line";
                    PhysInventoryDeltaList_P: Page "Phys. Inventory Delta List";
                    PhysInvtOrderLine: Record "Phys. Invt. Order Line";
                    ThresholdDelta: Decimal;
                begin
                    PhysInvtRecordLine_L.SetRange("Order No.", Rec."Order No.");
                    PhysInvtRecordLine_L.SetRange("Recording No.", Rec."Recording No.");

                    if PhysInvtRecordLine_L.FindSet() then begin
                        repeat
                            Clear(PhysInvtOrderLine);
                            PhysInvtOrderLine.SetRange("Document No.", Rec."Order No.");
                            PhysInvtOrderLine.SetRange("Item No.", PhysInvtRecordLine_L."Item No.");
                            PhysInvtOrderLine.SetRange("Location Code", PhysInvtRecordLine_L."Location Code");
                            PhysInvtOrderLine.SetRange("Bin Code", PhysInvtRecordLine_L."Bin Code");

                            if PhysInvtOrderLine.FindFirst() then begin
                                ThresholdDelta := PhysInvtOrderLine."Qty. Expected (Base)" * Rec.Threshold / 100;
                                if PhysInvtRecordLine_L.Quantity > (PhysInvtOrderLine."Qty. Expected (Base)" + ThresholdDelta) then begin
                                    PhysInvtRecordLine_L.Mark(true);
                                end else if PhysInvtRecordLine_L.Quantity < (PhysInvtOrderLine."Qty. Expected (Base)" - ThresholdDelta) then begin
                                    PhysInvtRecordLine_L.Mark(true);
                                end;
                            end;
                        until PhysInvtRecordLine_L.Next() = 0;

                        if PhysInvtRecordLine_L.MarkedOnly(true) then begin
                            PhysInventoryDeltaList_P.SetThreshold(Rec.Threshold);
                            PhysInventoryDeltaList_P.SetTableView(PhysInvtRecordLine_L);
                            // PhysInventoryDeltaList_P.SetRecord(PhysInvtRecordLine_L);
                            PhysInventoryDeltaList_P.Editable(false);
                            PhysInventoryDeltaList_P.RunModal();
                        end;
                    end;
                end;
            }
        }
    }
}