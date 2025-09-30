pageextension 50106 "Item Journal" extends "Item Journal"
{
    layout
    {
        addafter("Entry Type")
        {
            field("Short Comment"; Rec."Short Comment")
            {
                ApplicationArea = All;
                Caption = 'Kommentar';
                Visible = false;
            }
        }
        modify("Variant Code")
        {
            Visible = true;
        }
        moveafter("Bin Code"; "Variant Code")
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Item No." = '' then begin
            Rec."Document No." := '';
        end;
    end;
}