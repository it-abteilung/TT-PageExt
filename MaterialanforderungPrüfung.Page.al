Page 50063 "Materialanforderung Prüfung"
{
    // 001 HF  17.10.19  new field in header "Lfd Nr",Liefertermin,"zusätzliche Anforderungen"

    PageType = List;
    SourceTable = Materialanforderungzeile;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTableView = where(Abgehakt = filter(false));

    layout
    {
        area(content)
        {
            group(Control1000000003)
            {
                field(JobNo_G; JobNo_G)
                {
                    ApplicationArea = Basic;
                    Caption = 'Projekt-Nr.';
                    TableRelation = Materialanforderungzeile."Projekt Nr";

                    trigger OnValidate()
                    begin
                        Rec.SetRange("Projekt Nr", JobNo_G);
                        CurrPage.Update(false);
                    end;
                }
                field("EntryNo_G"; EntryNo_G)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lfd. Nr.';

                    trigger OnValidate()
                    begin
                        Rec.SetRange("Lfd Nr", EntryNo_G);
                        CurrPage.Update(false);
                    end;
                }
            }
            repeater(Control1000000001)
            {
                field("Projekt Nr"; Rec."Projekt Nr")
                {
                    ApplicationArea = Basic;
                    Caption = 'Projekt-Nr.';
                    Editable = false;
                    TableRelation = Materialanforderungzeile."Projekt Nr";
                }
                field("Lfd Nr"; Rec."Lfd Nr")
                {
                    ApplicationArea = Basic;
                    Caption = 'Lfd. Nr.';
                    Editable = false;
                }
                field("Artikel Nr"; Rec."Artikel Nr")
                {
                    ApplicationArea = Basic;
                    Caption = 'TT-Artikel-Nr.';
                    Editable = false;
                }
                field(Beschreibung; Rec.Beschreibung)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Beschreibung 2"; Rec."Beschreibung 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Menge; Rec.Menge)
                {
                    ApplicationArea = Basic;
                    Caption = 'Angeforderte Menge';
                    Editable = false;
                }
                field("Quoted Quantity"; Rec."Quoted Quantity")
                {
                    ApplicationArea = Basic;
                    Caption = 'Angefragte Menge';
                    Editable = false;
                }
                field(Abgehakt; Rec.Abgehakt)
                {
                    ApplicationArea = Basic;
                }
                field(Anforderungsdatum; Rec.Anforderungsdatum)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(PlanedDeliveryDate_G; PlanedDeliveryDate_G)
                {
                    ApplicationArea = Basic;
                    Caption = 'Geplantes Versanddatum';
                    Editable = false;
                }
                field("zusätzliche Anforderungen"; Rec."zusätzliche Anforderungen")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
        area(Promoted)
        {
            actionref(PrevRecord; "Prev Record") { }
            actionref(NextRecord; "Next Record") { }
        }
        area(processing)
        {
            // action(Abhaken)
            // {
            //     ApplicationArea = Basic;
            //     Gesture = RightSwipe;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Scope = Repeater;

            //     trigger OnAction()
            //     begin
            //         Rec.SetRecfilter;
            //         Rec.Abgehakt := true;
            //         Rec.Modify;
            //         Rec.SetRange("Lfd Nr");
            //     end;
            // }

            action("Prev Record")
            {
                ApplicationArea = All;
                Caption = 'Vorherige Materialanforderung';
                Image = PreviousRecord;

                trigger OnAction()
                var
                    MaterialKopf: Record Materialanforderungskopf;
                    PrevEntryNo: Integer;
                begin
                    MaterialKopf.SetRange("Projekt Nr", JobNo_G);
                    MaterialKopf.SetRange("Lfd Nr", EntryNo_G - 10);
                    if MaterialKopf.FindFirst() then begin
                        EntryNo_G := MaterialKopf."Lfd Nr";
                        Rec.SetRange("Lfd Nr", EntryNo_G);
                        CurrPage.Update(false);
                    end else
                        Message('Keine vorherige Materialanforderung gefunden.');
                end;
            }
            action("Next Record")
            {
                ApplicationArea = All;
                Caption = 'Nächste Materialanforderung';
                Image = NextRecord;

                trigger OnAction()
                var
                    MaterialKopf: Record Materialanforderungskopf;
                begin
                    MaterialKopf.SetRange("Projekt Nr", JobNo_G);
                    MaterialKopf.SetRange("Lfd Nr", EntryNo_G + 10);
                    if MaterialKopf.FindFirst() then begin
                        EntryNo_G := MaterialKopf."Lfd Nr";
                        Rec.SetRange("Lfd Nr", EntryNo_G);
                        CurrPage.Update(false);
                    end else
                        Message('Keine nächste Materialanforderung gefunden.');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        MaterialKopf: Record Materialanforderungskopf;
    begin
        Rec.SetRange("Projekt Nr", JobNo_G);
        Rec.SetRange("Lfd Nr", EntryNo_G);
        CurrPage.Update(false);
        if MaterialKopf.Get(JobNo_G, EntryNo_G) then
            PlanedDeliveryDate_G := MaterialKopf."Geplantes Versanddatum";
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("Projekt Nr", JobNo_G);
        Rec.SetRange("Lfd Nr", EntryNo_G);
        CurrPage.Update(false);
    end;

    var
        JobNo_G: Code[20];
        EntryNo_G: Integer;
        PlanedDeliveryDate_G: Date;

    procedure SetParameters(JobNo_L: Code[20]; EntryNo_L: Integer)
    begin
        JobNo_G := JobNo_L;
        EntryNo_G := EntryNo_L;
    end;
}

