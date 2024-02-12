Page 50064 "Materialanforderung Übersicht"
{
    CardPageID = "Materialanforderung Kopf";
    DataCaptionFields = "Projekt Nr";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Materialanforderungskopf;
    Caption = 'TT Materialanforderung';
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Projekt Nr"; Rec."Projekt Nr")
                {
                    ApplicationArea = Basic;
                    Caption = 'Projekt-Nr.';
                }
                field("Lfd Nr"; Rec."Lfd Nr")
                {
                    ApplicationArea = Basic;
                    Caption = 'Lfd. Nr.';
                }
                field(Stichwort; Rec.Stichwort)
                {
                    ApplicationArea = Basic;
                    Caption = 'Anforderungsgrund';
                }
                field(Belegdatum; Rec.Belegdatum)
                {
                    ApplicationArea = Basic;
                }
                field("Geplantes Versanddatum"; Rec."Geplantes Versanddatum")
                {
                    ApplicationArea = Basic;
                }
                field(Beschreibung; Rec.Beschreibung)
                {
                    ApplicationArea = Basic;
                }
                field("Beschreibung 2"; Rec."Beschreibung 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    {
        area(Promoted)
        {

        }
        area(Processing)
        {

        }
    }
}