pageextension 50013 pageextention50013 extends "Payment Journal"
{
    actions
    {
        addafter(PositivePayExport)
        {
            action("Payment Import")
            {
                Caption = 'Zahlungsimport';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Xmlport.Run(Xmlport::"Payment Import", false, true);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}

