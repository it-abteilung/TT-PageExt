PageExtension 50065 pageextension50065 extends "Contact Statistics FactBox"
{
    Caption = 'Contact Statistics FactBox';
    layout
    {
        addafter("Duration (Min.)")
        {
            field("EK-Anfragen"; Rec."EK-Anfragen")
            {
                ApplicationArea = Basic;

                trigger OnLookup(var Text: Text): Boolean
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."document type"::Quote);
                    // G-ERP.RS 2020-02-13 +++
                    // PurchaseHeader.SETRANGE("Job No.","No.");
                    Rec.CalcFields("Vendor No. TT");
                    if Rec."Vendor No. TT" = '' then
                        exit;
                    PurchaseHeader.SetRange("Buy-from Vendor No.", Rec."Vendor No. TT");
                    // G-ERP.RS 2020-02-13 ---
                    Page.RunModal(Page::"Purchase List", PurchaseHeader);
                end;
            }
            field("EK-Bestellungen"; Rec."EK-Bestellungen")
            {
                ApplicationArea = Basic;

                trigger OnLookup(var Text: Text): Boolean
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."document type"::Order);
                    // G-ERP.RS 2020-02-13 +++
                    // PurchaseHeader.SETRANGE("Job No.","No.");
                    Rec.CalcFields("Vendor No. TT");
                    if Rec."Vendor No. TT" = '' then
                        exit;
                    PurchaseHeader.SetRange("Buy-from Vendor No.", Rec."Vendor No. TT");
                    // G-ERP.RS 2020-02-13 ---
                    Page.RunModal(Page::"Purchase List", PurchaseHeader);
                end;
            }
            field("EK-Rechnungen"; Rec."EK-Rechnungen")
            {
                ApplicationArea = Basic;

                trigger OnLookup(var Text: Text): Boolean
                var
                    PurchInvHeader: Record "Purch. Inv. Header";
                begin
                    // G-ERP.RS 2020-05-05 +++
                    // PurchInvHeader.SETRANGE("Job No.","No.");
                    Rec.CalcFields("Vendor No. TT");
                    if Rec."Vendor No. TT" = '' then
                        exit;
                    PurchInvHeader.SetRange("Buy-from Vendor No.", Rec."Vendor No. TT");
                    // G-ERP.RS 2020-05-05 ---
                    Page.RunModal(Page::"Purchase Invoices", PurchInvHeader);
                end;
            }
            field("EK-Gutschrift"; Rec."EK-Gutschrift")
            {
                ApplicationArea = Basic;

                trigger OnLookup(var Text: Text): Boolean
                var
                    PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
                begin
                    // G-ERP.RS 2020-05-05 +++
                    // PurchCrMemoHdr.SETRANGE("Job No.","No.");
                    Rec.CalcFields("Vendor No. TT");
                    if Rec."Vendor No. TT" = '' then
                        exit;
                    PurchCrMemoHdr.SetRange("Buy-from Vendor No.", Rec."Vendor No. TT");
                    // G-ERP.RS 2020-05-05 ---
                    Page.RunModal(Page::"Purchase Credit Memos", PurchCrMemoHdr);
                end;
            }
        }
    }
}

