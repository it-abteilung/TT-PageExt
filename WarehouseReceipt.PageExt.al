PageExtension 50054 pageextension50054 extends "Warehouse Receipt"
{
    layout
    {
        addafter("Sorting Method")
        {
            field("Job No"; Rec."Job No")
            {
                ApplicationArea = Basic;
            }
            field(Ressource; Rec.Ressource)
            {
                ApplicationArea = Basic;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        JobTask: Record "Job Task";
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        PurchaseHeader: Record "Purchase Header";
        Purchasel: Record "Purchase Line";
    begin

        WarehouseReceiptLine.SetRange("No.", Rec."No.");
        if WarehouseReceiptLine.FindSet() then begin
            repeat
                if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, WarehouseReceiptLine."Source No.") then begin
                    if NOT JobTask.Get(PurchaseHeader."Job No.", '1') then begin
                        JobTask.Init();
                        JobTask."Job No." := PurchaseHeader."Job No.";
                        JobTask."Job Task No." := '1';
                        JobTask."Job Task Type" := "Job Task Type"::Posting;
                        JobTask.Insert(false);
                    end;
                end;
            until WarehouseReceiptLine.Next() = 0;
        end;

    end;
}

