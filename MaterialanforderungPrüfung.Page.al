Page 50063 "Materialanforderung Prüfung"
{
    // 001 HF  17.10.19  new field in header "Lfd Nr",Liefertermin,"zusätzliche Anforderungen"

    PageType = List;
    SourceTable = Materialanforderungzeile;
    SourceTableView = where(Abgehakt = filter(false));

    layout
    {
        area(content)
        {
            group(Control1000000003)
            {
                field(Projektnr; Projektnr)
                {
                    ApplicationArea = Basic;
                    TableRelation = Materialanforderungzeile."Projekt Nr";

                    trigger OnValidate()
                    begin
                        Rec.SetRange("Projekt Nr", Projektnr);
                        CurrPage.Update(false);
                    end;
                }
                field("Lfd Nr"; Rec."Lfd Nr")
                {
                    ApplicationArea = Basic;
                }
            }
            repeater(Control1000000001)
            {
                field("Projekt Nr"; Rec."Projekt Nr")
                {
                    ApplicationArea = Basic;
                    TableRelation = Materialanforderungzeile."Projekt Nr";
                }
                field("Artikel Nr"; Rec."Artikel Nr")
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
                field(Menge; Rec.Menge)
                {
                    ApplicationArea = Basic;
                }
                field(Abgehakt; Rec.Abgehakt)
                {
                    ApplicationArea = Basic;
                }
                field(Anforderungsdatum; Rec.Anforderungsdatum)
                {
                    ApplicationArea = Basic;
                }
                field(Liefertermin; Rec.Liefertermin)
                {
                    ApplicationArea = Basic;
                }
                field("zusätzliche Anforderungen"; Rec."zusätzliche Anforderungen")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(ItemPicture; "Item Picture")
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = "No." = field("Artikel Nr");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Abhaken)
            {
                ApplicationArea = Basic;
                Gesture = RightSwipe;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;

                trigger OnAction()
                begin
                    Rec.SetRecfilter;
                    Rec.Abgehakt := true;
                    Rec.Modify;
                    Rec.SetRange("Lfd Nr");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SetRange("Projekt Nr", Projektnr);
        CurrPage.Update(false);
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("Projekt Nr", Projektnr);
        CurrPage.Update(false);
    end;

    var
        Projektnr: Code[20];
}

