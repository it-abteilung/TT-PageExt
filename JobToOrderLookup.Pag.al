page 50013 "Job To Order Lookup"
{
    ApplicationArea = All;
    Caption = 'Job To Order Lookup';
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Header";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                }

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the purchase document.';

                    trigger OnDrillDown()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseOrder: Page "Purchase Order";
                        PurchInvHeader: Record "Purch. Inv. Header";
                        PostedPurchaseInvoice: Page "Posted Purchase Invoice";
                    begin
                        if Rec."Document Type" = Rec."Document Type"::Order then begin
                            PurchaseHeader.SetRange("No.", Rec."No.");
                            if PurchaseHeader.FindFirst() then begin
                                PurchaseOrder.Editable(false);
                                PurchaseOrder.SetRecord(PurchaseHeader);
                                PurchaseOrder.RunModal();
                            end;
                        end else begin
                            PurchInvHeader.SetRange("No.", rec."No.");
                            if PurchInvHeader.FindFirst() then begin
                                PostedPurchaseInvoice.Editable(false);
                                PostedPurchaseInvoice.SetRecord(PurchInvHeader);
                                PostedPurchaseInvoice.RunModal();
                            end;
                        end;
                    end;
                }
                field("Pay-to Name"; Rec."Pay-to Name")
                {
                    ToolTip = 'Specifies the name of the vendor sending the invoice.';
                }
                field(Bestellername; Rec.Bestellername)
                {
                    ToolTip = 'Specifies the value of the Bestellername field.';
                }
                field(Amount; Rec."Invoice Discount Value")
                {
                    Caption = 'Betrag';
                    ToolTip = 'Specifies the sum of amounts on all the lines in the document. This will include invoice discounts.';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ToolTip = 'Specifies the date when the order was created.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the date when the posting of the purchase document will be recorded.';
                }
            }
        }
    }

    var
        JobNo: Code[20];
        Amount: Decimal;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalcFields(Amount, Bestellername);
    end;

    trigger OnOpenPage()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        PurchaseHeader.SetRange("Document Type", "Purchase Document Type"::Order);
        PurchaseHeader.SetRange("Job No.", JobNo);
        if PurchaseHeader.FindSet() then
            repeat
                Rec.Init();
                PurchaseHeader.CalcFields(Amount);
                Rec."Document Type" := PurchaseHeader."Document Type";
                Rec."No." := PurchaseHeader."No.";
                Rec."Order Date" := PurchaseHeader."Order Date";
                Rec."Posting Date" := PurchaseHeader."Posting Date";
                Rec.Besteller := PurchaseHeader.Besteller;
                Rec."Pay-to Name" := PurchaseHeader."Pay-to Name";
                Rec."Invoice Discount Value" := PurchaseHeader.Amount;
                Rec.Amount := PurchaseHeader.Amount;
                Rec.Insert(true);
            until PurchaseHeader.Next() = 0;

        PurchInvHeader.SetRange("Job No.", JobNo);
        if PurchInvHeader.FindSet() then
            repeat
                Rec.Init();
                PurchInvHeader.CalcFields(Amount);
                Rec."Document Type" := "Purchase Document Type"::Invoice;
                Rec."No." := PurchInvHeader."No.";
                Rec."Order Date" := PurchInvHeader."Order Date";
                Rec."Posting Date" := PurchInvHeader."Posting Date";
                Rec."Besteller" := PurchInvHeader.Besteller;
                Rec."Pay-to Name" := PurchInvHeader."Pay-to Name";
                Rec."Invoice Discount Value" := PurchInvHeader.Amount;
                Rec.Insert(true);
            until PurchInvHeader.Next() = 0;
    end;

    procedure SetJobNo(JobNo_L: Code[20])
    begin
        JobNo := JobNo_L;
    end;
}
