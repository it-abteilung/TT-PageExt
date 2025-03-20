pageextension 50034 PostedPurchaseInvoiceLines extends "Posted Purchase Invoice Lines"
{
    layout
    {
        addafter("Buy-from Vendor No.")
        {
            field(VendorName; VendorName)
            {
                ApplicationArea = All;
                Caption = 'Kreditor';
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(Filter_IT)
            {
                ApplicationArea = All;
                Caption = 'Filter IT';

                trigger OnAction()
                begin
                    Rec.SetFilter("Job No.", '%1 | %2 | %3 | %4', '6063', '6087', '6088', '6188');
                    Rec.SetFilter(SystemCreatedAt, '>%1 & <%2', CreateDateTime(20240101D, 0T), CreateDateTime(20250101D, 0T));
                end;
            }
        }
    }

    var
        VendorNo: Code[20];
        VendorName: Text[200];

    trigger OnAfterGetRecord()
    var
        Vendor_L: Record Vendor;
    begin
        VendorNo := '';
        VendorName := '';

        if Vendor_L.Get(Rec."Pay-to Vendor No.") then begin
            VendorNo := Vendor_L."No.";
            VendorName := Vendor_L.Name;
        end;
    end;
}