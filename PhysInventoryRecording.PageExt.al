pageextension 50017 PhysInventoryRecording extends "Phys. Inventory Recording"
{
    layout
    {
        addlast(General)
        {
            field(Threshold; Rec.Threshold)
            {
                ApplicationArea = All;
                Caption = 'Maximale Abweichung';
                ToolTip = 'Die maximal erlaubte Abweichung zwischen gezählter Menge und dem aktuellen Lagerbestand in Prozent.';

                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
        }
    }
}