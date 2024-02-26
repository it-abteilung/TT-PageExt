PageExtension 50065 pageextension50065 extends "Contact Statistics FactBox"
{
    Caption = 'Contact Statistics FactBox';
    layout
    {
        addafter("Duration (Min.)")
        {
            field("EK-Anfragen"; QuoteCount)
            {
                ApplicationArea = Basic;

                trigger OnDrillDown()
                var
                    PurchaseHeader: Record "Purchase Header";
                    PurchaseList: Page "Purchase List";
                begin
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document type"::Quote);
                    Rec.CalcFields("Vendor No. TT");
                    if Rec."Vendor No. TT" = '' then
                        exit;
                    PurchaseHeader.SetRange("Buy-from Vendor No.", Rec."Vendor No. TT");
                    PurchaseList.SetTableView(PurchaseHeader);
                    PurchaseList.Editable(false);
                    PurchaseList.RunModal();
                end;

                // trigger OnLookup(var Text: Text): Boolean
                // var
                //     PurchaseHeader: Record "Purchase Header";
                // begin
                //     PurchaseHeader.SetRange("Document Type", PurchaseHeader."document type"::Quote);
                //     // G-ERP.RS 2020-02-13 +++
                //     // PurchaseHeader.SETRANGE("Job No.","No.");
                //     Rec.CalcFields("Vendor No. TT");
                //     if Rec."Vendor No. TT" = '' then
                //         exit;
                //     PurchaseHeader.SetRange("Buy-from Vendor No.", Rec."Vendor No. TT");
                //     // G-ERP.RS 2020-02-13 ---
                //     Page.RunModal(Page::"Purchase List", PurchaseHeader);
                // end;
            }
            field("EK-Bestellungen"; OrderCount)
            {
                ApplicationArea = Basic;

                trigger OnDrillDown()
                var
                    PurchaseHeader: Record "Purchase Header";
                    PurchaseList: Page "Purchase List";
                begin
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
                    if Rec."Vendor No. TT" = '' then
                        exit;
                    PurchaseHeader.SetRange("Buy-from Vendor No.", Rec."Vendor No. TT");
                    PurchaseList.SetTableView(PurchaseHeader);
                    PurchaseList.Editable(false);
                    PurchaseList.RunModal();
                end;

                // trigger OnLookup(var Text: Text): Boolean
                // var
                //     PurchaseHeader: Record "Purchase Header";
                // begin
                //     PurchaseHeader.SetRange("Document Type", PurchaseHeader."document type"::Order);
                //     // G-ERP.RS 2020-02-13 +++
                //     // PurchaseHeader.SETRANGE("Job No.","No.");
                //     Rec.CalcFields("Vendor No. TT");
                //     if Rec."Vendor No. TT" = '' then
                //         exit;
                //     PurchaseHeader.SetRange("Buy-from Vendor No.", Rec."Vendor No. TT");
                //     // G-ERP.RS 2020-02-13 ---
                //     Page.RunModal(Page::"Purchase List", PurchaseHeader);
                // end;
            }
            field("EK-Rechnungen"; Rec."EK-Rechnungen")
            {
                ApplicationArea = Basic;

                // trigger OnLookup(var Text: Text): Boolean
                // var
                //     PurchInvHeader: Record "Purch. Inv. Header";
                // begin
                //     // G-ERP.RS 2020-05-05 +++
                //     // PurchInvHeader.SETRANGE("Job No.","No.");
                //     Rec.CalcFields("Vendor No. TT");
                //     if Rec."Vendor No. TT" = '' then
                //         exit;
                //     PurchInvHeader.SetRange("Buy-from Vendor No.", Rec."Vendor No. TT");
                //     // G-ERP.RS 2020-05-05 ---
                //     Page.RunModal(Page::"Purchase Invoices", PurchInvHeader);
                // end;
            }
            field("EK-Gutschrift"; Rec."EK-Gutschrift")
            {
                ApplicationArea = Basic;

                // trigger OnLookup(var Text: Text): Boolean
                // var
                //     PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
                // begin
                //     // G-ERP.RS 2020-05-05 +++
                //     // PurchCrMemoHdr.SETRANGE("Job No.","No.");
                //     Rec.CalcFields("Vendor No. TT");
                //     if Rec."Vendor No. TT" = '' then
                //         exit;
                //     PurchCrMemoHdr.SetRange("Buy-from Vendor No.", Rec."Vendor No. TT");
                //     // G-ERP.RS 2020-05-05 ---
                //     Page.RunModal(Page::"Purchase Credit Memos", PurchCrMemoHdr);
                // end;
            }
        }
    }

    var
        QuoteCount: Integer;
        OrderCount: Integer;

    trigger OnAfterGetRecord()
    var
        PurchaseHeader_L: Record "Purchase Header";
    begin
        Rec.CalcFields("Vendor No. TT", "EK-Anfragen", "EK-Bestellungen", "EK-Rechnungen", "EK-Gutschrift");
        if (Rec."Contact Business Relation" = Rec."Contact Business Relation"::Customer) OR (Rec."Contact Business Relation" = Rec."Contact Business Relation"::None) then begin
            QuoteCount := 0;
            OrderCount := 0;
        end else begin
            Clear(PurchaseHeader_L);
            PurchaseHeader_L.SetRange("Document Type", PurchaseHeader_L."Document Type"::Quote);
            PurchaseHeader_L.SetRange("Buy-from Vendor No.", Rec."Vendor No. TT");
            QuoteCount := PurchaseHeader_L.Count;
            Clear(PurchaseHeader_L);
            PurchaseHeader_L.SetRange("Document Type", PurchaseHeader_L."Document Type"::Order);
            PurchaseHeader_L.SetRange("Buy-from Vendor No.", Rec."Vendor No. TT");
            OrderCount := PurchaseHeader_L.Count;
        end;
    end;
}