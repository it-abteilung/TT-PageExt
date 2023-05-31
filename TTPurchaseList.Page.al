#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50012 "TT Purchase List"
{
    Caption = 'TT Verkaufsübersicht';
    CardPageID = "Purchase Order";
    DataCaptionFields = "Document Type";
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Header";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the purchase document.';
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the vendor that you buy from.';
                }
                field("Order Address Code"; Rec."Order Address Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the order address code linked to the relevant vendor''s order address.';
                    Visible = false;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the vendor who delivers the items.';
                }
                field("Vendor Authorization No."; Rec."Vendor Authorization No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the identification number of a compensation agreement.';
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
                    ToolTip = 'Specifies the name of the person to contact about shipment of the item from this vendor.';
                    Visible = false;
                }
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor who is sending the invoice.';
                    Visible = false;
                }
                field("Pay-to Name"; Rec."Pay-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the vendor sending the invoice.';
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
                    ToolTip = 'Specifies the name of the person to contact about an invoice from this vendor.';
                    Visible = false;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a ship-to code if you want a different shipment address from the one that has been automatically entered.';
                    Visible = false;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the company at the address to which you want the items to be shipped.';
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
                    ToolTip = 'Specifies the name of a contact person for the address where the items should be shipped.';
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the posting of the purchase document will be recorded.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the purchase header.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the purchase header.';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the location where you want the items to be placed when they are received.';
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the currency of the amounts on the purchase lines.';
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
                field(Besteller; Rec.Besteller)
                {
                    ApplicationArea = Basic;
                }
                field(Bestellername; Rec.Bestellername)
                {
                    ApplicationArea = Basic;
                }
                field("Betrag (EUR)"; AmountLCY)
                {
                    ApplicationArea = Basic;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the vendor.';

                    trigger OnAction()
                    var
                        PageManagement: Codeunit "Page Management";
                    begin
                        PageManagement.PageRun(Rec);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Purchase Reservation Avail.")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Reservation Avail.';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Purchase Reservation Avail.";
                ToolTip = 'Print, view, or save a list of the availability of items for shipment on purchase documents, for example credit memos.';
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
        Clear(PurchaseLine);
        PurchaseLine.SetRange("Document No.", Rec."No.");
        PurchaseLine.SetRange("Job No.", Rec."Job No.");
        if LeistungsartFilter <> '' then
            PurchaseLine.SetFilter(Leistungsart, LeistungsartFilter);
        if PurchaseLine.FindSet then
            repeat
                waehrungsfaktor := 1;
                waehrungsfaktor := Rec."Currency Factor";
                if waehrungsfaktor = 0 then
                    waehrungsfaktor := 1;

                AmountLCY += (PurchaseLine.Amount / waehrungsfaktor);
            until PurchaseLine.Next = 0;
    end;

    trigger OnOpenPage()
    begin
        Rec.CopyBuyFromVendorFilter;

        LeistungsartFilter := Rec.GetFilter(Leistungsart);
    end;

    var
        PurchaseLine: Record "Purchase Line";
        AmountLCY: Decimal;
        waehrungsfaktor: Decimal;
        LeistungsartFilter: Text;
}

