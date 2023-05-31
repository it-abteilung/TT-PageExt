#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50005 "Artikel-Mengenerfassung"
{

    layout
    {
        area(content)
        {
            field("Artikelnr."; Artikelnr)
            {
                ApplicationArea = Basic;
                Caption = 'Artikelnr.';
                TableRelation = Item."No.";

                trigger OnValidate()
                begin
                    Item.Get(Artikelnr);
                end;
            }
            field(Beschreibung; Item.Description)
            {
                ApplicationArea = Basic;
                Caption = 'Beschreibung';
                Editable = false;
            }
            field("Beschreibung 2"; Item."Description 2")
            {
                ApplicationArea = Basic;
                Caption = 'Beschreibung 2';
                Editable = false;
            }
            field(Menge; Menge)
            {
                ApplicationArea = Basic;
                Caption = 'Menge';
            }
            field(Einheit; Einheit)
            {
                ApplicationArea = Basic;
                Caption = 'Einheit';
            }
            field(Lagerort; Lagerort)
            {
                ApplicationArea = Basic;
                Caption = 'Lagerort';
            }
        }
    }

    actions
    {
    }

    var
        Artikelnr: Code[20];
        Menge: Decimal;
        Einheit: Code[10];
        Lagerort: Code[10];
        Item: Record Item;
}

