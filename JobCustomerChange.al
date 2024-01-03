page 50096 "Job Customer Change Dlg"
{
    Caption = 'Debitorenwechsel';
    PageType = StandardDialog;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field(OldCustomer; OldCustomerNo)
                {
                    ApplicationArea = all;
                    Caption = 'Alter Debitor';
                    Editable = false;
                }
                field(NewCustomer; NewCustomerNo)
                {
                    ApplicationArea = all;
                    Caption = 'Neuer Debitor';
                    TableRelation = Customer;
                }
            }
        }
    }

    var
        OldCustomerNo: Code[20];
        NewCustomerNo: Code[20];

    procedure SetCustomerNo(CustomerNo: Code[20])
    begin
        OldCustomerNo := CustomerNo;
    end;

    procedure GetCustomerNo(): Code[20]
    begin
        exit(NewCustomerNo);
    end;

}