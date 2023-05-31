#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50077 "Werkzeuganforderung Kopf"
{
    AutoSplitKey = true;
    PageType = Card;
    SourceTable = Werkzeuganforderungskopf;
    Caption = 'Werkzeuganforderung Kopf';

    layout
    {
        area(content)
        {
            group(Allgemein)
            {
                field("Projekt Nr"; Rec."Projekt Nr")
                {
                    ApplicationArea = Basic;
                }
                field(Stichwort; Rec.Stichwort)
                {
                    ApplicationArea = Basic;
                }
                field(Schiff; Rec.Schiff)
                {
                    ApplicationArea = Basic;
                }
                group(Reparatur)
                {
                    Caption = 'Reparatur';
                    field(Reparaturleiter; Rec.Reparaturleiter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Leiter';
                    }
                    field(Reparaturort; Rec.Reparaturort)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ort';
                    }
                    field(Reparaturbeginn; Rec.Reparaturbeginn)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Beginn';
                    }
                    field(Reparaturende; Rec.Reparaturende)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ende';
                    }
                    field(Fertigstellung; Rec.Fertigstellung)
                    {
                        ApplicationArea = Basic;
                    }
                }
                group("Freigabe Schweißzusätze")
                {
                    Caption = 'Freigabe Schweißzusätze';
                    field("Freigabe Schweißzusätze am"; Rec."Freigabe Schweißzusätze am")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Am';
                    }
                    field("Freigabe Schweißzusätze durch"; Rec."Freigabe Schweißzusätze durch")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Durch';
                    }
                }
                group(Abholung)
                {
                    Caption = 'Abholung';
                    field("Abholung am"; Rec."Abholung am")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Am';
                    }
                    field("Abholung durch"; Rec."Abholung durch")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Durch';
                    }
                }
                group(Transport)
                {
                    Caption = 'Transport';
                    field("Transport LKW"; Rec."Transport LKW")
                    {
                        ApplicationArea = Basic;
                        Caption = 'LKW';
                    }
                    field("Transport Seefracht"; Rec."Transport Seefracht")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Seefracht';
                    }
                    field("Transport Luftfracht"; Rec."Transport Luftfracht")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Luftfracht';
                    }
                    field("Transport Sonstig"; Rec."Transport Sonstig")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Sonstig';
                    }
                    field("Transport Sonstig Text"; Rec."Transport Sonstig Text")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Sonstig Text';
                    }
                }
                group(Weitertransport)
                {
                    Caption = 'Weitertransport';
                    Visible = false;
                    field("Weitertransport von"; Rec."Weitertransport von")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Von';
                    }
                    field("Weitertransport nach"; Rec."Weitertransport nach")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Nach';
                    }
                }
                group(Verpackung)
                {
                    Caption = 'Verpackung';
                    Visible = false;
                    field("Verpackung Kiste"; Rec."Verpackung Kiste")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Kiste';
                    }
                    field("Verpackung Verschlag"; Rec."Verpackung Verschlag")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Verschlag';
                    }
                    field("Verpackung Container"; Rec."Verpackung Container")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Container';
                    }
                    field("Verpackung Unverpackt"; Rec."Verpackung Unverpackt")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Unverpackt';
                    }
                }
            }
            part(Control1000000031; "Werkzeuganforderung Subform")
            {
                SubPageLink = "Projekt Nr" = field("Projekt Nr"),
                              "Lfd Nr" = field("Lfd Nr");
                ApplicationArea = All;
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
            action(CreateStockTransferOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Umlagerungsauftrag anlegen';

                trigger OnAction()
                var
                    TransferHeader_l: Record "Transfer Header";
                    TransferLine_l: Record "Transfer Line";
                    Werkzeuganforderungzeile_l: Record Werkzeuganforderungzeile;
                    LineNo: Integer;
                begin
                    /*// G-ERP.RS- 2020-11-11 +++
                    TransferHeader_l."No." := '';
                    TransferHeader_l.INSERT(TRUE);
                    
                    TransferHeader_l.VALIDATE("Job No","Projekt Nr");
                    TransferHeader_l.VALIDATE("Shipment Date","Abholung am");
                    TransferHeader_l.VALIDATE("Transfer-from Code",'TEST');
                    TransferHeader_l.VALIDATE("In-Transit Code",'TRANS');
                    TransferHeader_l.VALIDATE("Assigned User ID",USERID);
                    TransferHeader_l.MODIFY(TRUE);
                    
                    Werkzeuganforderungzeile_l.SETRANGE("Projekt Nr","Projekt Nr");
                    Werkzeuganforderungzeile_l.SETRANGE("Lfd Nr","Lfd Nr");
                    IF Werkzeuganforderungzeile_l.FINDSET() THEN BEGIN
                      REPEAT
                        TransferLine_l.VALIDATE("Document No.", TransferHeader_l."No.");
                        TransferLine_l.VALIDATE("Line No.", Werkzeuganforderungzeile_l."Zeilen Nr");
                        TransferLine_l.VALIDATE("Item No.", Werkzeuganforderungzeile_l."Artikel Nr");
                        TransferLine_l.VALIDATE(Quantity, Werkzeuganforderungzeile_l.Menge);
                        TransferLine_l.VALIDATE("Unit of Measure", Werkzeuganforderungzeile_l.Einheit);
                        TransferLine_l.INSERT(TRUE);
                    
                      UNTIL(Werkzeuganforderungzeile_l.NEXT() = 0);
                    END;
                    */// G-ERP.RS- 2020-11-11 ---

                end;
            }
        }
    }
}

