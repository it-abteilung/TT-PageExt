#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50077 "Werkzeuganforderung Kopf"
{
    AutoSplitKey = true;
    Caption = 'Werkzeuganforderung Kopf';
    PageType = Card;
    SourceTable = Werkzeuganforderungskopf;

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
                        Caption = 'Reparaturbeginn';
                    }
                    field(Reparaturende; Rec.Reparaturende)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Reparaturende';
                    }
                    field(Fertigstellung; Rec.Fertigstellung)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Fertigstellung Werkzeuge Lager';
                    }
                    field(Status; Rec.Status)
                    {
                        ApplicationArea = All;
                        Caption = 'Status';
                    }
                }
                group("Freigabe Schweißzusätze")
                {
                    Editable = IsWeldingSupervisior;
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

        area(Promoted)
        {
            group(Category_New)
            {
                actionref(NewEntry1; NewEntry_1)
                {
                }
                actionref(NewEntry2; NewEntry_2)
                {
                }
            }
            actionref(Print_; Print) { }
        }
        area(processing)
        {
            action(NewEntry_1)
            {
                ApplicationArea = all;
                Caption = 'Kopiere Werkzeuganforderung';
                Image = Copy;

                trigger OnAction()
                var
                    WAK_Copy: Record Werkzeuganforderungskopf;
                begin
                    WAK_Copy := CopyHeader(Rec);
                    CopyLines(Rec, WAK_Copy);
                    Page.Run(50077, WAK_Copy);
                end;
            }
            action(NewEntry_2)
            {
                ApplicationArea = all;
                Caption = 'Kopiere nur Werkzeuganforderungskopf';
                Image = Copy;

                trigger OnAction()
                var
                    WAK_Copy: Record Werkzeuganforderungskopf;
                begin
                    WAK_Copy := CopyHeader(Rec);
                    Page.Run(50077, WAK_Copy);
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Drucken';
                Image = Print;

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

    var
        IsWeldingSupervisior: Boolean;

    trigger OnOpenPage()
    var
        WeldingSupervisior: Record "Welding Supervisior";
    begin
        WeldingSupervisior.SetRange("User Name", UserId());
        IsWeldingSupervisior := NOT WeldingSupervisior.IsEmpty();
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Creation Date" = 0D then
            Rec."Creation Date" := DT2Date(Rec.SystemCreatedAt);
    end;


    local procedure CopyHeaderEmpty(Original: Record Werkzeuganforderungskopf) NewCopy: Record Werkzeuganforderungskopf
    begin
        NewCopy.Init();
        NewCopy."Projekt Nr" := Original."Projekt Nr";
        NewCopy.Insert(true);
        exit(NewCopy);
    end;

    local procedure CopyHeader(Original: Record Werkzeuganforderungskopf) NewCopy: Record Werkzeuganforderungskopf
    begin
        NewCopy.Init();
        NewCopy."Projekt Nr" := Original."Projekt Nr";
        NewCopy.Insert(true);
        NewCopy.Belegdatum := Original.Belegdatum;
        NewCopy."Geplantes Versanddatum" := Original."Geplantes Versanddatum";
        NewCopy.Beschreibung := Original.Beschreibung;
        NewCopy."Beschreibung 2" := Original."Beschreibung 2";
        NewCopy.Schiff := Original.Schiff;
        NewCopy."Stichwort" := Original.Stichwort;
        NewCopy.Typ := Original.Typ;
        NewCopy.Reparaturleiter := Original.Reparaturleiter;
        NewCopy.Reparaturort := Original.Reparaturort;
        NewCopy.Reparaturbeginn := Original.Reparaturbeginn;
        NewCopy.Reparaturende := Original.Reparaturende;
        NewCopy.Fertigstellung := Original.Fertigstellung;
        NewCopy."Abholung am" := Original."Abholung am";
        NewCopy."Abholung durch" := Original."Abholung durch";
        NewCopy."Transport LKW" := Original."Transport LKW";
        NewCopy."Transport Luftfracht" := Original."Transport Luftfracht";
        NewCopy."Transport Seefracht" := Original."Transport Seefracht";
        NewCopy."Transport Sonstig" := Original."Transport Sonstig";
        NewCopy."Transport Sonstig Text" := Original."Transport Sonstig Text";
        NewCopy."Weitertransport von" := Original."Weitertransport von";
        NewCopy."Weitertransport nach" := Original."Weitertransport nach";
        NewCopy."Verpackung Container" := Original."Verpackung Container";
        NewCopy."Verpackung Kiste" := Original."Verpackung Kiste";
        NewCopy."Verpackung Unverpackt" := Original."Verpackung Unverpackt";
        NewCopy."Verpackung Verschlag" := Original."Verpackung Verschlag";
        NewCopy.Modify();
        exit(NewCopy);
    end;

    procedure CopyLines(Original: Record Werkzeuganforderungskopf; NewCopy: Record Werkzeuganforderungskopf)
    var
        WAZ: Record Werkzeuganforderungzeile;
        WAZ_Copy: Record Werkzeuganforderungzeile;
        Counter: Integer;
    begin
        Counter := 10000;
        WAZ.SetRange("Projekt Nr", Original."Projekt Nr");
        WAZ.SetRange("Lfd Nr", Original."Lfd Nr");
        if WAZ.FindSet() then
            repeat
                WAZ_Copy.Init();
                WAZ_Copy."Projekt Nr" := NewCopy."Projekt Nr";
                WAZ_Copy."Lfd Nr" := NewCopy."Lfd Nr";
                WAZ_Copy."Zeilen Nr" := Counter;
                WAZ_Copy."Artikel Nr" := WAZ."Artikel Nr";
                WAZ_Copy.Insert(true);
                WAZ_Copy.Abgehakt := false;
                WAZ_Copy.Anforderungsdatum := Today();
                WAZ_Copy.Beschreibung := WAZ.Beschreibung;
                WAZ_Copy."Beschreibung 2" := WAZ."Beschreibung 2";
                WAZ_Copy."Contains Hazardous Substance" := WAZ."Contains Hazardous Substance";
                WAZ_Copy.Delta := WAZ.Delta;
                WAZ_Copy.Einheit := WAZ.Einheit;
                WAZ_Copy."Gehört zu Zeilen Nr" := WAZ."Gehört zu Zeilen Nr";
                WAZ_Copy."Hazard Accepted By" := WAZ."Hazard Accepted By";
                WAZ_Copy.Menge := WAZ.Menge;
                WAZ_Copy.Modify();
                Counter += 10000;
            until WAZ.Next() = 0;
    end;

}

