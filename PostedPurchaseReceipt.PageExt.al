PageExtension 50035 pageextension50035 extends "Posted Purchase Receipt"
{
    layout
    {
        addafter("Responsibility Center")
        {
            field("Goods Receiving Date"; rec."Goods Receiving Date")
            {
                ApplicationArea = Basic;
            }
            field("Employee No."; rec."Employee No.")
            {
                ApplicationArea = Basic;
            }
            field(Employee; rec.Employee)
            {
                ApplicationArea = Basic;
            }
        }
        moveafter("Pay-to Address 2"; "Pay-to Post Code")
        moveafter("Ship-to Address 2"; "Ship-to Post Code")
    }
}

