PageExtension 50068 pageextension50068 extends "Purchase Order List"
{
    Caption = 'Purchase Orders';

    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Basic;
                Caption = 'Job No.';
            }
            field(Leistung; Rec.Leistung)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Amount Including VAT")
        {
            field("Status Purchase"; Rec."Status Purchase")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("CO2 Menge in Kilogramm"; Rec."CO2 Menge in Kilogramm")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter("Job No.")
        {
            field(DelieveryStatus; DelieveryStatus)
            {
                ApplicationArea = All;
                Caption = 'Belegstatus';
            }
            field("Vollständig geliefert am:"; FullDeliveredDate)
            {
                ApplicationArea = All;
                Caption = 'Vollständig geliefert am:';
            }
            field("Promised Receipt Date"; Rec."Promised Receipt Date")
            {
                ApplicationArea = All;
            }
        }
    }

    var
        DelieveryStatus: Text[100];
        FullDeliveredDate: Date;

    trigger OnAfterGetRecord()
    var
        PurchaseLine: Record "Purchase Line";
        LineCounter: Integer;
        FullCounter: Integer;
        PartialCounter: Integer;
        WarehouseEntry: Record "Warehouse Entry";
    begin
        FullDeliveredDate := 0D;
        DelieveryStatus := 'Nicht Geliefert';

        PurchaseLine.SetRange("Document Type", Rec."Document Type");
        PurchaseLine.SetRange("Document No.", Rec."No.");
        PurchaseLine.SetFilter(Type, '%1 | %2', PurchaseLine.Type::Item, PurchaseLine.Type::"G/L Account");

        if PurchaseLine.FindSet() then begin
            repeat
                LineCounter += 1;
                if PurchaseLine.Quantity = PurchaseLine."Quantity Received" then
                    FullCounter += 1;
                if PurchaseLine."Quantity Received" > 0 then
                    PartialCounter += 1;
            until PurchaseLine.Next() = 0;

            if LineCounter = FullCounter then begin
                DelieveryStatus := 'Geliefert';
                WarehouseEntry.SetRange("Source No.", Rec."No.");
                if WarehouseEntry.FindLast() then begin
                    FullDeliveredDate := WarehouseEntry."Registering Date";
                end;

            end else begin
                if PartialCounter > 0 then
                    DelieveryStatus := ' Teil geliefert';
            end;
        end;
    end;
}

