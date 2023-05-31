PageExtension 50014 pageextension50014 extends "Sales Quote"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
            {
                ApplicationArea = Basic;
            }
            field(Salutation; Rec.Salutation)
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Status)
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Basic;
                Caption = 'Projektnr.';
            }
            field(Unterschriftscode; Rec.Unterschriftscode)
            {
                ApplicationArea = Basic;
            }
            field("Unterschriftscode 2"; Rec."Unterschriftscode 2")
            {
                ApplicationArea = Basic;
            }
            field("Validity (DAYS)"; Rec."Validity (DAYS)")
            {
                ApplicationArea = Basic;
            }
            field(Delivery; Rec.Delivery)
            {
                ApplicationArea = Basic;
            }
            field(Preisstellung; Rec.Preisstellung)
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addafter(Print)
        {
            action("Print TP")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Drucken TP';
                Ellipsis = true;
                Image = Print;

                trigger OnAction()
                var
                    L_SalesHeader: Record "Sales Header";
                begin
                    L_SalesHeader := Rec;
                    L_SalesHeader.SetRecfilter();
                    Report.RunModal(50026, true, false, L_SalesHeader);
                end;
            }
        }
    }
}

