PageExtension 50068 pageextension50068 extends "Purchase Order List"
{
    Caption = 'Purchase Orders';

    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Vendor Invoice No."; Rec."Vendor Invoice No.")
            {
                ApplicationArea = All;
                Caption = 'Vendor Invoice No.';
            }
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

    actions
    {
        addafter("Co&mments")
        {
            action("JobTask=1")
            {
                ApplicationArea = Basic;
                Caption = 'JobTask=1';

                trigger OnAction()
                var
                    PurchaseHeader_L: Record "Purchase Header";
                    PurchaseLine_L: Record "Purchase Line";
                    Job_L: Record Job;
                    JobTask_L: Record "Job Task";
                begin
                    PurchaseHeader_L.SetFilter("No.", '>%1', '060000');
                    PurchaseHeader_L.SetRange("Document Type", PurchaseHeader_L."Document Type"::Order);
                    if PurchaseHeader_L.FindSet() then begin
                        Message('%1', PurchaseHeader_L.Count);
                        repeat
                            if NOT JobTask_L.Get(PurchaseHeader_L."Job No.", '1') then begin
                                JobTask_L.Init();
                                JobTask_L."Job No." := PurchaseHeader_L."Job No.";
                                JobTask_L."Job Task No." := '1';
                                JobTask_L."Job Task Type" := "Job Task Type"::Posting;
                                JobTask_L.Insert(false);
                            end;

                            PurchaseLine_L.SetRange("Document No.", PurchaseHeader_L."No.");
                            PurchaseLine_L.SetRange("Document Type", PurchaseHeader_L."Document Type");

                            if PurchaseLine_L.FindSet() then begin
                                repeat
                                    if PurchaseLine_L.Type = PurchaseLine_L.Type::Item then
                                        PurchaseLine_L."Job Task No." := '1'
                                    else
                                        PurchaseLine_L."Job Task No." := '';
                                    PurchaseLine_L.Modify();
                                until PurchaseLine_L.Next() = 0;
                            end;

                        until PurchaseHeader_L.Next() = 0;
                    end;
                    Message('Ende');
                end;
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

