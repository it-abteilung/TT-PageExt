#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50032 "LOT-Nr. / Chargennr. Eingabe"
{
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(Eingabe; Chargennr)
            {
                ApplicationArea = Basic;
                Caption = 'Geben oder scannen Sie die LOT-Nr. / Chargennr.';
            }
        }
    }

    actions
    {
    }

    var
        Chargennr: Code[20];


    procedure WertHolen(var PChargennr: Code[20])
    begin
        PChargennr := Chargennr;
    end;
}

