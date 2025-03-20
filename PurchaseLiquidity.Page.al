page 50068 "Purchase Liquidity"
{
    ApplicationArea = All;
    Caption = 'Purchase Liquidity';
    PageType = List;
    SourceTable = "Purchase Liquidity";
    SourceTableTemporary = true;
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Goods Receipt Date"; Rec."Goods Receipt Date")
                {
                    ApplicationArea = All;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                }
                field(JobDescription; JobDescription)
                {
                    ApplicationArea = All;
                }
                field(ObjectName; ObjectName)
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Is Discount"; Rec."Is Discount")
                {
                    ApplicationArea = All;
                }
                field("Discount Percent"; Rec."Discount Percent")
                {
                    ApplicationArea = All;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    var
        JobDescription: Text;
        ObjectName: Text;
        LowerBoundsDate: Date;
        UpperBoundsDate: Date;

    trigger OnOpenPage()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        PaymentTerms: Record "Payment Terms";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        Counter: Integer;
    begin
        Counter := 0;
        LowerBoundsDate := Today();
        UpperBoundsDate := CalcDate('30T', LowerBoundsDate);

        // Use Expected Receipt Date or Promised Receipt Date

        // Order
        Clear(PurchaseHeader);
        Clear(PurchaseLine);
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
        // PurchaseHeader.SetRange("No.", '058454');
        PurchaseHeader.SetFilter("Promised Receipt Date", '>= %1 & <= %2', LowerBoundsDate, UpperBoundsDate);

        if PurchaseHeader.FindSet() then
            repeat
                if PurchaseHeader."Promised Receipt Date" <> 0D then begin

                    Clear(PaymentTerms);
                    if PaymentTerms.Get(PurchaseHeader."Payment Terms Code") then;

                    PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                    PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                    PurchaseLine.SetFilter(Type, '<> %1', PurchaseLine.Type::" ");

                    if PurchaseLine.FindSet() then
                        repeat
                            // No Delievery
                            if PurchaseLine."Quantity Received" = 0 then begin
                                if Format(PaymentTerms."Due Date Calculation") <> '' then begin
                                    Rec.Init();
                                    Counter += 1;
                                    Rec.Validate("Entry No.", Counter);
                                    Rec."Document Type" := PurchaseLine."Document Type"::Order;
                                    Rec."Document No." := PurchaseLine."Document No.";
                                    Rec."Job No." := PurchaseLine."Job No.";
                                    Rec."Goods Receipt Date" := PurchaseHeader."Promised Receipt Date";
                                    Rec.Quantity := PurchaseLine.Quantity;
                                    Rec."Is Discount" := false;
                                    Rec."Due Date" := CalcDate(PaymentTerms."Due Date Calculation", PurchaseHeader."Promised Receipt Date");
                                    Rec."Discount Percent" := 0;
                                    Rec."Direct Unit Cost" := PurchaseLine."Direct Unit Cost";
                                    Rec."Discount Amount" := 0;
                                    Rec."Amount" := PurchaseLine.Quantity * PurchaseLine."Direct Unit Cost" - Rec."Discount Amount";
                                    Rec.Insert();
                                end;
                                if Format(PaymentTerms."Discount Date Calculation") <> '' then begin
                                    Rec.Init();
                                    Counter += 1;
                                    Rec.Validate("Entry No.", Counter);
                                    Rec."Document Type" := PurchaseLine."Document Type"::Order;
                                    Rec."Document No." := PurchaseLine."Document No.";
                                    Rec."Job No." := PurchaseLine."Job No.";
                                    Rec."Goods Receipt Date" := PurchaseHeader."Promised Receipt Date";
                                    Rec.Quantity := PurchaseLine.Quantity;
                                    Rec."Is Discount" := true;
                                    Rec."Due Date" := CalcDate(PaymentTerms."Discount Date Calculation", PurchaseHeader."Promised Receipt Date");
                                    Rec."Discount Percent" := PaymentTerms."Discount %";
                                    Rec."Direct Unit Cost" := PurchaseLine.Amount;
                                    Rec."Discount Amount" := PurchaseLine.Quantity * PurchaseLine."Direct Unit Cost" * PaymentTerms."Discount %" / 100;
                                    Rec."Amount" := PurchaseLine.Quantity * PurchaseLine."Direct Unit Cost" - Rec."Discount Amount";
                                    Rec.Insert();
                                end;
                            end else begin
                                // partially delievered part 1 (purchase order)
                                if PurchaseLine.Quantity - PurchaseLine."Quantity Received" > 0 then begin

                                    if Format(PaymentTerms."Due Date Calculation") <> '' then begin
                                        Rec.Init();
                                        Counter += 1;
                                        Rec.Validate("Entry No.", Counter);
                                        Rec."Document Type" := PurchaseLine."Document Type"::Quote;
                                        Rec."Document No." := PurchaseLine."Document No.";
                                        Rec."Job No." := PurchaseLine."Job No.";
                                        Rec."Goods Receipt Date" := PurchaseHeader."Promised Receipt Date";
                                        Rec.Quantity := PurchaseLine.Quantity - PurchaseLine."Quantity Received";
                                        Rec."Is Discount" := false;
                                        Rec."Due Date" := CalcDate(PaymentTerms."Due Date Calculation", PurchaseHeader."Promised Receipt Date");
                                        Rec."Discount Percent" := 0;
                                        Rec."Direct Unit Cost" := PurchaseLine."Direct Unit Cost";
                                        Rec."Discount Amount" := 0;
                                        Rec."Amount" := (PurchaseLine.Quantity - PurchaseLine."Quantity Received") * PurchaseLine."Direct Unit Cost";
                                        Rec.Insert();
                                    end;
                                    if Format(PaymentTerms."Discount Date Calculation") <> '' then begin
                                        Rec.Init();
                                        Counter += 1;
                                        Rec.Validate("Entry No.", Counter);
                                        Rec."Document Type" := PurchaseLine."Document Type"::Quote;
                                        Rec."Document No." := PurchaseLine."Document No.";
                                        Rec."Job No." := PurchaseLine."Job No.";
                                        Rec."Goods Receipt Date" := PurchaseHeader."Promised Receipt Date";
                                        Rec.Quantity := PurchaseLine.Quantity - PurchaseLine."Quantity Received";
                                        Rec."Is Discount" := true;
                                        Rec."Due Date" := CalcDate(PaymentTerms."Discount Date Calculation", PurchaseHeader."Promised Receipt Date");
                                        Rec."Discount Percent" := PaymentTerms."Discount %";
                                        Rec."Direct Unit Cost" := PurchaseLine.Amount;
                                        Rec."Discount Amount" := (PurchaseLine.Quantity - PurchaseLine."Quantity Received") * PurchaseLine."Direct Unit Cost" * PaymentTerms."Discount %" / 100;
                                        Rec."Amount" := (PurchaseLine.Quantity - PurchaseLine."Quantity Received") * PurchaseLine."Direct Unit Cost" - Rec."Discount Amount";
                                        Rec.Insert();
                                    end;

                                    // patially delievered part 2 (purchase invoice)
                                    Clear(PurchInvLine);
                                    PurchRcptLine.SetRange("Order No.", PurchaseHeader."No.");
                                    PurchRcptLine.SetRange("No.", PurchaseLine."No.");
                                    PurchRcptLine.SetRange("Line No.", PurchaseLine."Line No.");

                                    if PurchRcptLine.FindSet() then begin

                                        if Format(PaymentTerms."Due Date Calculation") <> '' then begin
                                            Rec.Init();
                                            Counter += 1;
                                            Rec.Validate("Entry No.", Counter);
                                            Rec."Document Type" := PurchaseLine."Document Type"::Order;
                                            Rec."Document No." := PurchaseLine."Document No.";
                                            Rec."Job No." := PurchaseLine."Job No.";
                                            Rec."Goods Receipt Date" := PurchaseHeader."Promised Receipt Date";
                                            Rec.Quantity := PurchRcptLine.Quantity;
                                            Rec."Is Discount" := false;
                                            Rec."Due Date" := CalcDate(PaymentTerms."Due Date Calculation", PurchaseHeader."Promised Receipt Date");
                                            Rec."Discount Percent" := 0;
                                            Rec."Direct Unit Cost" := PurchaseLine."Direct Unit Cost";
                                            Rec."Discount Amount" := 0;
                                            Rec."Amount" := PurchaseLine.Quantity * PurchaseLine."Direct Unit Cost";
                                            Rec.Insert();
                                        end;
                                        if Format(PaymentTerms."Discount Date Calculation") <> '' then begin
                                            Rec.Init();
                                            Counter += 1;
                                            Rec.Validate("Entry No.", Counter);
                                            Rec."Document Type" := PurchaseLine."Document Type"::Order;
                                            Rec."Document No." := PurchaseLine."Document No.";
                                            Rec."Job No." := PurchaseLine."Job No.";
                                            Rec."Goods Receipt Date" := PurchaseHeader."Promised Receipt Date";
                                            Rec.Quantity := PurchRcptLine.Quantity;
                                            Rec."Is Discount" := true;
                                            Rec."Due Date" := CalcDate(PaymentTerms."Discount Date Calculation", PurchaseHeader."Promised Receipt Date");
                                            Rec."Discount Percent" := PaymentTerms."Discount %";
                                            Rec."Direct Unit Cost" := PurchaseLine.Amount;
                                            Rec."Discount Amount" := (PurchaseLine.Quantity - PurchaseLine."Quantity Received") * PurchaseLine."Direct Unit Cost" * PaymentTerms."Discount %" / 100;
                                            Rec."Amount" := PurchaseLine.Quantity * PurchaseLine."Direct Unit Cost" - Rec."Discount Amount";
                                            Rec.Insert();
                                        end;

                                    end;
                                end;
                            end;
                        until PurchaseLine.Next() = 0;

                    if PaymentTerms.Get(PurchaseHeader."Payment Terms Code") then begin

                    end;

                    Clear(PurchRcptHeader);
                    if PurchRcptHeader.Get(PurchaseLine."Document No.") then begin
                        if PaymentTerms.Get(PurchaseHeader."Payment Terms Code") then begin

                        end;
                    end;

                end;
            until PurchaseHeader.Next() = 0;

        // Invoice
        Clear(PurchaseHeader);
        Clear(PurchaseLine);
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type"::Invoice);
        // Posted Invoice
        Clear(PurchInvHeader);

    end;
}