pageextension 50106 "Item Journal" extends "Item Journal"
{
    trigger OnAfterGetRecord()
    begin
        if Rec."Item No." = '' then begin
            Rec."Document No." := '';
        end;
    end;
}