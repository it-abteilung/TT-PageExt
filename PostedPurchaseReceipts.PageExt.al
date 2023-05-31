PageExtension 50039 pageextension50039 extends "Posted Purchase Receipts"
{
    layout
    {
        addafter("Shipment Method Code")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = Basic;

                trigger OnAssistEdit()
                var
                    PurchaseHeader_l: Record "Purchase Header";
                begin
                    //G-ERP.RS 2019-06-19 +++
                    if PurchaseHeader_l.Get(PurchaseHeader_l."document type"::Order, Rec."Order No.") then
                        Page.RunModal(50, PurchaseHeader_l)
                    else
                        Message(MSG_NoOrder);
                    //G-ERP.RS 2019-06-19 ---
                end;
            }
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Basic;
            }
            field("Goods Receiving Date"; Rec."Goods Receiving Date")
            {
                ApplicationArea = Basic;
            }
            field(Leistung; Rec.Leistung)
            {
                ApplicationArea = Basic;
            }
        }
    }
    var
        MSG_NoOrder: label 'The order %1 could not be opened.';
}

