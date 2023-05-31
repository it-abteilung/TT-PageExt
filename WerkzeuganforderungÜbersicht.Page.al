Page 50076 "Werkzeuganforderung Übersicht"
{
    CardPageID = "Werkzeuganforderung Kopf";
    DataCaptionFields = "Projekt Nr";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Werkzeuganforderungskopf;
    Caption = 'Werkzeuganforderung';
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
        area(processing)
        {
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Drucken';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Werkzeuganforderungskopf_l: Record Werkzeuganforderungskopf;
                    WerkzeuganforderungWerkzeug_l: Report 50066;
                begin
                    Clear(Werkzeuganforderungskopf_l);
                    Werkzeuganforderungskopf_l.SetRange("Projekt Nr", Rec."Projekt Nr");
                    Werkzeuganforderungskopf_l.SetRange("Lfd Nr", Rec."Lfd Nr");
                    WerkzeuganforderungWerkzeug_l.SetTableview(Werkzeuganforderungskopf_l);
                    WerkzeuganforderungWerkzeug_l.RunModal();
                end;
            }
        }
    }

    var
        Materialanforderung2: Record Materialanforderungzeile;
        Lfd: Integer;
        Projektnr: Code[20];
        Materialanforderung: Record Materialanforderungskopf;
}

