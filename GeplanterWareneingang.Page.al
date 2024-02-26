Page 50018 "Geplante Wareneingänge"
{
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'Neu,Vorgang,Berichte,Filter';
    SourceTable = "Purchase Header";
    SourceTableView = sorting("Promised Receipt Date") where("Document Type" = const(Order), Leistungsart = const(Fremdlieferung));
    UsageCategory = Lists;
    ApplicationArea = All;
    AdditionalSearchTerms = 'Geplante Wareneingänge';

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Promised Receipt Date"; Rec."Promised Receipt Date")
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
                field("Status Purchase"; Rec."Status Purchase")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000021; "EK-Lieferung Subpage")
            {
                Caption = 'Zeilen';
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("No.");
                SubPageView = where("Outstanding Quantity" = filter(> 0));
                ApplicationArea = All;
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
                Enabled = false;
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
                Enabled = false;

                trigger OnAction()
                var
                    GerwingERPTool: Codeunit 50001;
                begin
                    //GerwingERPTool.DruckerTabelleFuellen(PBerichtID,PTableID,PRecordKey1,PRecordKey2,PRecordKey3,PRecordKey4,PRecordKey5,pDruckerVorgabe,pAnzahlAusdrucke)
                    GerwingERPTool.DruckerTabelleFuellen(50051, 38, '1', Rec."No.", '', '', '', '', 1);
                end;
            }
            group("Filter")
            {
                Caption = 'Filter';
                action(all)
                {
                    ApplicationArea = Filter;
                    Caption = 'Alle';
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Rec.SetRange("Due Date");
                    end;
                }
                action(today)
                {
                    ApplicationArea = Filter;
                    Caption = 'Heute';
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Rec.SetRange("Promised Receipt Date", Today);
                    end;
                }
                action(future)
                {
                    ApplicationArea = Filter;
                    Caption = 'Zukünftig';
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Rec.SetFilter("Promised Receipt Date", '>%', Today);
                    end;
                }
                action(delayed)
                {
                    ApplicationArea = Filter;
                    Caption = 'Verspätet';
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Rec.SetFilter("Promised Receipt Date", '<%', Today);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BuyfromVendorNameOnFormat;

        if Rec."Promised Receipt Date" < Today then
            Style := true
        else
            Style := false;

        //G-ERP.KBS 2017-08-15 +
        if Job.Get(Rec."Job No.") then;
        //G-ERP.KBS 2017-08-15 -
    end;

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Promised Receipt Date", '%1..%2', CalcDate('-8W', Today()), Today());
        //G-ERP.RS 2019-01-23 +++
        Rec.FilterGroup := 29;
        Rec.SetRange("Status Purchase", Rec."status purchase"::" ", Rec."status purchase"::"partly delivered");
        Rec.FilterGroup := 0;
        //G-ERP.RS 2019-01-23 +++
    end;

    var
        L_PurchaseHeader: Record "Purchase Header";
        Style: Boolean;
        Job: Record Job;
        Header: Page "Geplante Wareneingänge";

    local procedure BuyfromVendorNameOnFormat()
    begin
        if Rec."Promised Receipt Date" < Today then;
    end;
}

