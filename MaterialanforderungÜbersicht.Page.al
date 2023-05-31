Page 50064 "Materialanforderung Übersicht"
{
    CardPageID = "Materialanforderung Kopf";
    DataCaptionFields = "Projekt Nr";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Materialanforderungskopf;
    Caption = 'Materialanforderung Übersicht';
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
                }
                field("Lfd Nr"; Rec."Lfd Nr")
                {
                    ApplicationArea = Basic;
                }
                field(Stichwort; Rec.Stichwort)
                {
                    ApplicationArea = Basic;
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
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Karte)
            {
                ApplicationArea = Basic, Suite;
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "Materialanforderung Kopf";
                RunPageLink = "Projekt Nr" = field("Projekt Nr"),
                              "Lfd Nr" = field("Lfd Nr");
                Visible = false;
            }
        }
    }

    var
        Materialanforderung2: Record Materialanforderungzeile;
        Lfd: Integer;
        Projektnr: Code[20];
        Materialanforderung: Record Materialanforderungskopf;
}

