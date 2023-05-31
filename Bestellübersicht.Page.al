Page 50016 "Bestellübersicht"
{
    CardPageID = "Erfassung EK-Lieferung Phone Z";
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Header";
    SourceTableView = sorting("Expected Receipt Date")
                      where("Document Type" = const(Order),
                            Leistungsart = const(Fremdlieferung));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Basic;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = Style;
                }
                field("Buy-from Vendor Name 2"; Rec."Buy-from Vendor Name 2")
                {
                    ApplicationArea = Basic;
                }
                field("Buy-from Vendor Name 3"; Rec."Buy-from Vendor Name 3")
                {
                    ApplicationArea = Basic;
                }
                field("Buy-from Address"; Rec."Buy-from Address")
                {
                    ApplicationArea = Basic;
                }
                field("Buy-from Address 2"; Rec."Buy-from Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Buy-from Post Code"; Rec."Buy-from Post Code")
                {
                    ApplicationArea = Basic;
                }
                field("Buy-from City"; Rec."Buy-from City")
                {
                    ApplicationArea = Basic;
                }
                field(Leistung; Rec.Leistung)
                {
                    ApplicationArea = Basic;
                }
                field(Bestellername; Rec.Bestellername)
                {
                    ApplicationArea = Basic;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Basic;
                }
                field(Objektname; Job.Objektname)
                {
                    ApplicationArea = Basic;
                    Caption = 'Objektname';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Drucken)
            {
                ApplicationArea = Basic;
                Caption = 'Drucken';
                Gesture = RightSwipe;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    L_PurchaseHeader.Get(Rec."Document Type", Rec."No.");
                    L_PurchaseHeader.SetRecfilter();
                    Report.RunModal(50051, true, false, L_PurchaseHeader);
                end;
            }
            action("Drucken Server")
            {
                ApplicationArea = Basic;
                Caption = 'Drucken Server';

                trigger OnAction()
                var
                    GerwingERPTool: Codeunit 50001;
                begin
                    //GerwingERPTool.DruckerTabelleFuellen(PBerichtID,PTableID,PRecordKey1,PRecordKey2,PRecordKey3,PRecordKey4,PRecordKey5,pDruckerVorgabe,pAnzahlAusdrucke)
                    GerwingERPTool.DruckerTabelleFuellen(50051, 38, '1', Rec."No.", '', '', '', '', 1);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BuyfromVendorNameOnFormat;

        if Rec."Expected Receipt Date" < Today then
            Style := true
        else
            Style := false;

        //G-ERP.KBS 2017-08-15 +
        if Job.Get(Rec."Job No.") then;
        //G-ERP.KBS 2017-08-15 -
    end;

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Expected Receipt Date", '%1..', CalcDate('-8W', Today));
    end;

    var
        L_PurchaseHeader: Record "Purchase Header";
        Style: Boolean;
        Job: Record Job;

    local procedure BuyfromVendorNameOnFormat()
    begin
        if Rec."Expected Receipt Date" < Today then;
    end;
}

