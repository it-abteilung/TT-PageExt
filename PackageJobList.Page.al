page 50045 "Package Job List"
{
    Caption = 'Herkunft: Anforderungszeilen';
    Editable = false;
    PageType = List;
    SourceTable = Werkzeuganforderungzeile;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Projekt Nr"; Rec."Projekt Nr")
                {
                    ApplicationArea = All;
                }
                field(Beschreibung; Rec.Beschreibung)
                {
                    ApplicationArea = All;
                }
                field("Beschreibung 2"; Rec."Beschreibung 2")
                {
                    ApplicationArea = All;
                }
                field(Anforderungsdatum; Rec.Anforderungsdatum)
                {
                    ApplicationArea = All;
                }
                field(Menge; Rec.Menge)
                {
                    ApplicationArea = All;
                }
                field(Einheit; Rec.Einheit)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}