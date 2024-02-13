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
            group(Special_Filters)
            {
                Caption = 'Filter';
                Image = FilterLines;

                actionref(RemoveFilter; Remove_Filter) { }
                actionref(ApplyFilterOwn; Apply_Filter_Own) { }
                actionref(ApplyFilterStatus1; Apply_Filter_Status_1) { }
                actionref(ApplyFilterStatus2; Apply_Filter_Status_2) { }
                actionref(ApplyFilterStatus3; Apply_Filter_Status_3) { }
            }
        }
        area(Processing)
        {
            action(Remove_Filter)
            {
                ApplicationArea = all;
                Caption = 'Alle MA';
                Image = FilterLines;

                trigger OnAction()
                begin
                    Rec.Reset();
                end;
            }
            action(Apply_Filter_Own)
            {
                ApplicationArea = all;
                Caption = 'Eigene MA';
                Image = FilterLines;

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetRange(Anforderer, UserId());
                end;
            }
            action(Apply_Filter_Status_1)
            {
                ApplicationArea = all;
                Caption = 'Status: Erstellt';
                Image = FilterLines;

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetRange(Status, Rec.Status::erfasst);
                end;
            }
            action(Apply_Filter_Status_2)
            {
                ApplicationArea = all;
                Caption = 'Status: Angefordert';
                Image = FilterLines;

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetRange(Status, Rec.Status::freigegeben);
                end;
            }
            action(Apply_Filter_Status_3)
            {
                ApplicationArea = all;
                Caption = 'Status: Erledigt';
                Image = FilterLines;

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetRange(Status, Rec.Status::beendet);
                end;
            }
        }
    }

    views
    {
        view(Filter_Status_1)
        {
            Caption = 'Erstellt';
            Filters = WHERE(Status = const(erfasst));
        }
        view(Filter_Status_2)
        {
            Caption = 'Angefordert';
            Filters = WHERE(Status = const(freigegeben));
        }
        view(Filter_Status_3)
        {
            Caption = 'Erledigt';
            Filters = WHERE(Status = const(beendet));
        }
    }

    var
        CurrUserId: Code[50];

    trigger OnOpenPage()
    begin
        CurrUserId := UserId;
    end;
}