pageextension 50205 "Warehouse Entries" extends "Warehouse Entries"
{

    layout
    {
        addafter("Source No.")
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Caption = 'Erstellt am';
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        Item: Record Item;
    begin
        if Rec.Description = '' then begin
            if Item.Get(Rec."Item No.") then begin
                Rec.Description := Item.Description;
                Rec."Description 2" := Item."Description 2";
            end;
        end;
    end;
}