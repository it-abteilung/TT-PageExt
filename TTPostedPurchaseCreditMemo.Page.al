#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50034 "TT Posted Purchase Credit Memo"
{
    Caption = 'TT Geb. Verkaufsgutschrift';
    CardPageID = "Posted Purchase Credit Memo";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    PromotedActionCategories = 'New,Process,Report,Cancel';
    SourceTable = "Purch. Cr. Memo Hdr.";
    SourceTableView = sorting("Posting Date")
                      order(descending);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posted credit memo number.';
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the vendor associated with the credit memo.';
                }
                field("Order Address Code"; Rec."Order Address Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the order address code used in the credit memo.';
                    Visible = false;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code used to calculate the amounts on the credit memo.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies when the credit memo is due. The program calculates the date using the Payment Terms Code and Posting Date fields on the purchase header.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total, in the currency of the credit memo, of the amounts on all the credit memo lines.';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        Rec.SetRange("No.");
                        Page.RunModal(Page::"Posted Purchase Credit Memo", Rec)
                    end;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total, in the currency of the credit memo, of the amounts on all the credit memo lines - including VAT.';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        Rec.SetRange("No.");
                        Page.RunModal(Page::"Posted Purchase Credit Memo", Rec)
                    end;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount that remains to be paid for the posted purchase invoice that relates to this purchase credit memo.';
                    Visible = false;
                }
                field("Betrag (EUR)"; AmountLCY)
                {
                    ApplicationArea = Basic;
                }
                field(Paid; Rec.Paid)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the posted purchase invoice that relates to this purchase credit memo is paid. The check box will also be selected if a credit memo for the remaining amount has been applied.';
                }
                field(Cancelled; Rec.Cancelled)
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Sales Invoices";
                    Editable = false;
                    HideValue = not Rec.Cancelled;
                    LookupPageID = "Posted Sales Invoices";
                    Style = Unfavorable;
                    StyleExpr = Rec.Cancelled;
                    ToolTip = 'Specifies if the posted purchase invoice that relates to this purchase credit memo has been either corrected or canceled.';

                    trigger OnDrillDown()
                    begin
                        Rec.ShowCorrectiveInvoice;
                    end;
                }
                field(Corrective; Rec.Corrective)
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Posted Sales Invoices";
                    Editable = false;
                    HideValue = not Rec.Corrective;
                    LookupPageID = "Posted Sales Invoices";
                    Style = Unfavorable;
                    StyleExpr = Rec.Corrective;
                    ToolTip = 'Specifies if the posted purchase invoice has been either corrected or canceled by this purchase credit memo .';

                    trigger OnDrillDown()
                    begin
                        Rec.ShowCancelledInvoice;
                    end;
                }
                field("Buy-from Post Code"; Rec."Buy-from Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the postal code of the address.';
                    Visible = false;
                }
                field("Buy-from Country/Region Code"; Rec."Buy-from Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the address.';
                    Visible = false;
                }
                field("Buy-from Contact"; Rec."Buy-from Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person to contact at the vendor who shipped the items.';
                    Visible = false;
                }
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the vendor who you received the credit memo from.';
                    Visible = false;
                }
                field("Pay-to Name"; Rec."Pay-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the vendor who you received the credit memo from.';
                    Visible = false;
                }
                field("Pay-to Post Code"; Rec."Pay-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the postal code of the address.';
                    Visible = false;
                }
                field("Pay-to Country/Region Code"; Rec."Pay-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the address.';
                    Visible = false;
                }
                field("Pay-to Contact"; Rec."Pay-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person you should contact at the vendor who you received the credit memo from.';
                    Visible = false;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipment of the sales order that is linked to the purchase order for drop shipment from the vendor to a customer.';
                    Visible = false;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the company at the address to which the items were shipped.';
                    Visible = false;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the postal code of the address.';
                    Visible = false;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the address.';
                    Visible = false;
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of a contact person at the address that the items were shipped to.';
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date the credit memo was posted.';
                    Visible = false;
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which purchaser is associated with the credit memo.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the dimension value associated with the credit memo.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the dimension value associated with the credit memo.';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location used when you posted the credit memo.';
                }
                field("No. Printed"; Rec."No. Printed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many times the credit memo has been printed.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the purchase document was created.';
                    Visible = false;
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the credit memo has been applied to an already-posted document.';
                    Visible = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Basic;
                }
                field(Leistung; Rec.Leistung)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Basic, Suite;
                ShowFilter = false;
                Visible = not IsOfficeAddin;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Cr. Memo")
            {
                Caption = '&Cr. Memo';
                Image = CreditMemo;
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purch. Credit Memo Statistics";
                    RunPageLink = "No." = field("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type" = const("Posted Credit Memo"),
                                  "No." = field("No.");
                    ToolTip = 'View or add notes about the posted purchase credit memo.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
            }
        }
        area(processing)
        {
            action(Vendor)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Vendor';
                Image = Vendor;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Vendor Card";
                RunPageLink = "No." = field("Buy-from Vendor No.");
                Scope = Repeater;
                ShortCutKey = 'Shift+F7';
                ToolTip = 'View or edit detailed information about the vendor on the selected posted purchase document.';
            }
            action("&Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                Visible = not IsOfficeAddin;

                trigger OnAction()
                var
                    PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
                begin
                    CurrPage.SetSelectionFilter(PurchCrMemoHdr);
                    PurchCrMemoHdr.PrintRecords(true);
                end;
            }
            action("&Navigate")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                Visible = not IsOfficeAddin;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
            group(Cancel)
            {
                Caption = 'Cancel';
                action(CancelCrMemo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ToolTip = 'Create and post a purchase invoice that reverses this posted purchase credit memo. This posted purchase credit memo will be canceled.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Cancel PstdPurchCrM (Yes/No)", Rec);
                    end;
                }
                action(ShowInvoice)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Canceled/Corrective Invoice';
                    Enabled = Rec.Cancelled or Rec.Corrective;
                    Image = Invoice;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ToolTip = 'Open the posted sales invoice that was created when you canceled the posted sales credit memo. If the posted sales credit memo is the result of a canceled sales invoice, then canceled invoice will open.';

                    trigger OnAction()
                    begin
                        Rec.ShowCanceledOrCorrInvoice;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        AmountLCY := 0;
        /*
        VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETRANGE("Document No.","No.");
        VendLedgEntry.SETRANGE("Document Type",VendLedgEntry."Document Type"::Invoice);
        VendLedgEntry.SETRANGE("Vendor No.","Pay-to Vendor No.");
        IF VendLedgEntry.FINDFIRST THEN
          AmountLCY := -VendLedgEntry."Purchase (LCY)";
        */
        Clear(PurchCrMemoLine);
        PurchCrMemoLine.SetRange("Document No.", Rec."No.");
        PurchCrMemoLine.SetFilter("Job No.", Rec.GetFilter("Job No."));
        if PurchCrMemoLine.FindSet then
            repeat
                waehrungsfaktor := 1;
                waehrungsfaktor := Rec."Currency Factor";
                if waehrungsfaktor = 0 then
                    waehrungsfaktor := 1;

                AmountLCY += (PurchCrMemoLine.Amount / waehrungsfaktor);
            until PurchCrMemoLine.Next = 0;

    end;

    trigger OnOpenPage()
    var
        OfficeMgt: Codeunit "Office Management";
    begin
        Rec.SetSecurityFilterOnRespCenter;
        if Rec.FindFirst then;
        IsOfficeAddin := OfficeMgt.IsAvailable;
    end;

    var
        IsOfficeAddin: Boolean;
        "*G-ERP*": Integer;
        AmountLCY: Decimal;
        VendLedgEntry: Record "Vendor Ledger Entry";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        waehrungsfaktor: Decimal;
}

