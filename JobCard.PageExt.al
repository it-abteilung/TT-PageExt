PageExtension 50150 JobCardExt extends "Job Card"
{
    Caption = 'Job Card';
    layout
    {
        modify("Search Description")
        {
            Visible = false;
        }
        modify("WIP and Recognition")
        {
            Visible = false;
        }
        modify("To Post")
        {
            Visible = false;
        }
        modify("WIP Posting Date")
        {
            Visible = false;
        }
        modify("Total WIP Sales Amount")
        {
            Visible = false;
        }
        modify("Applied Sales G/L Amount")
        {
            Visible = false;
        }
        modify("Total WIP Cost Amount")
        {
            Visible = false;
        }
        modify("Applied Costs G/L Amount")
        {
            Visible = false;
        }
        modify("Recog. Sales Amount")
        {
            Visible = false;
        }
        modify("Recog. Costs Amount")
        {
            Visible = false;
        }
        modify("Recog. Profit Amount")
        {
            Visible = false;
        }
        modify("Recog. Profit %")
        {
            Visible = false;
        }
        modify("Acc. WIP Costs Amount")
        {
            Visible = false;
        }
        modify("Acc. WIP Sales Amount")
        {
            Visible = false;
        }
        modify("Calc. Recog. Sales Amount")
        {
            Visible = false;
        }
        modify("Calc. Recog. Costs Amount")
        {
            Visible = false;
        }
        modify(Posted)
        {
            Visible = false;
        }
        modify("WIP G/L Posting Date")
        {
            Visible = false;
        }
        modify("Total WIP Sales G/L Amount")
        {
            Visible = false;
        }
        modify("Total WIP Cost G/L Amount")
        {
            Visible = false;
        }
        modify("Recog. Sales G/L Amount")
        {
            Visible = false;
        }
        modify("Recog. Costs G/L Amount")
        {
            Visible = false;
        }
        modify("Recog. Profit G/L Amount")
        {
            Visible = false;
        }
        modify("Recog. Profit G/L %")
        {
            Visible = false;
        }
        modify("Calc. Recog. Sales G/L Amount")
        {
            Visible = false;
        }
        modify("Calc. Recog. Costs G/L Amount")
        {
            Visible = false;
        }
        modify(Control1902018507)
        {
            Visible = false;
        }
        modify(Control1902136407)
        {
            Visible = false;
        }
        modify(Control1905650007)
        {
            Visible = false;
        }
        modify("Person Responsible")
        {
            ShowMandatory = true;
        }
        addafter(Description)
        {
            fixed("Rechnungsempfänger")
            {
                Caption = 'Rechnungsempfänger';
            }
        }
        addafter("Bill-to Contact")
        {
            fixed(Allgemein)
            {
                Caption = 'Allgemein';
            }
        }
        addafter("Last Date Modified")
        {
            field("Job Type"; Rec."Job Type")
            {
                ApplicationArea = Basic;
                Importance = Promoted;
                NotBlank = true;
                ShowMandatory = true;
            }
            field("Object"; Rec.Object)
            {
                ApplicationArea = Basic;
                Caption = 'Objekt';
            }
            field(Objektname; Rec.Objektname)
            {
                ApplicationArea = Basic;
                Caption = 'Objekt Name';
            }
            field("Person Responsible Name"; Rec."Person Responsible Name")
            {
                ApplicationArea = Basic;
                ShowMandatory = true;
                Caption = 'Verantwortlicher';
            }
            field(Verfasser; Rec.Verfasser)
            {
                ApplicationArea = Basic;
                ShowMandatory = true;
                Caption = 'Verfasser';
            }
            field("Leistungsfortschritt %"; Rec."Leistungsfortschritt %")
            {
                ApplicationArea = Basic;
                Caption = 'Performance progress %';
            }
            fixed(Service)
            {
                Caption = 'Service';
            }
            field(Reparaturort; Rec.Reparaturort)
            {
                ApplicationArea = Basic;
                ShowMandatory = true;
                Caption = 'Reparaturort';
            }
            field(Reparaturleiter; Rec.Reparaturleiter)
            {
                ApplicationArea = Basic;
                Caption = 'Reparaturleiter';
            }
            fixed(Agentur)
            {
                Caption = 'Agentur';
            }
            field("Anfrage von"; Rec."Anfrage von")
            {
                ApplicationArea = Basic;
                Caption = 'Anfrage von';
                Importance = Additional;
                ShowMandatory = true;
            }
            field("Anfrage am"; Rec."Anfrage am")
            {
                ApplicationArea = Basic;
                Importance = Additional;
                ShowMandatory = true;
                Caption = 'Anfrage am';
            }
            field("Anfrage per"; Rec."Anfrage per")
            {
                ApplicationArea = Basic;
                Caption = 'Anfrage per';
            }
            field("Angebotsabgabe bis"; Rec."Angebotsabgabe bis")
            {
                ApplicationArea = Basic;
                Importance = Additional;
                ShowMandatory = true;
                Caption = 'Angebotsabgabe bis';
            }
            field("Angebotsabgabe durch"; Rec."Angebotsabgabe durch")
            {
                ApplicationArea = Basic;
                Importance = Additional;
                ShowMandatory = true;
                Caption = 'Angebotsabgabe durch';
            }
            field("Auftragseingang erfolgte am"; Rec."Auftragseingang erfolgte am")
            {
                ApplicationArea = Basic;
                Importance = Additional;
                Caption = 'Auftragseingang erfolgte am';
            }
            field("Parts for"; Rec."Parts for")
            {
                ApplicationArea = Basic;
                Importance = Additional;
                Caption = 'Parts for';
            }
            field(Maker; Rec.Maker)
            {
                ApplicationArea = Basic;
                Importance = Additional;
                Caption = 'Maker';
            }
            field(Type; Rec.Type)
            {
                ApplicationArea = Basic;
                Importance = Additional;
                Caption = 'Type';
            }
            field("We Quote for"; Rec."We Quote for")
            {
                ApplicationArea = Basic;
                Importance = Additional;
                Caption = 'We Quote for';
            }
            field("Serial Number"; Rec."Serial Number")
            {
                ApplicationArea = Basic;
                Importance = Additional;
                Caption = 'Serial Number';
            }
            field("Letzte Notiz"; Rec."Letzte Notiz")
            {
                ApplicationArea = Basic;
                Importance = Promoted;
                Caption = 'Last Note';
            }
            group(Notizen)
            {
                Caption = 'Notizen';
                field(AnfrageUeber; AnfrageUeber)
                {
                    ApplicationArea = Basic;
                    Caption = 'Anfrage über';
                    MultiLine = true;
                    RowSpan = 2;

                    trigger OnValidate()
                    begin
                        if not ProjektNotizen.Get(Rec."No.") then begin
                            ProjektNotizen."Job No." := Rec."No.";
                            ProjektNotizen.Insert;
                        end;

                        ProjektNotizen."Anfrage über1" := CopyStr(AnfrageUeber, 1, 250);
                        ProjektNotizen."Anfrage über2" := CopyStr(AnfrageUeber, 251, 250);
                        ProjektNotizen."Anfrage über3" := CopyStr(AnfrageUeber, 501, 250);
                        ProjektNotizen.Modify;
                    end;
                }
                field(ZuBeachten; ZuBeachten)
                {
                    ApplicationArea = Basic;
                    Caption = 'zu Beachten';
                    MultiLine = true;
                    RowSpan = 2;

                    trigger OnValidate()
                    begin
                        if not ProjektNotizen.Get(Rec."No.") then begin
                            ProjektNotizen."Job No." := Rec."No.";
                            ProjektNotizen.Insert;
                        end;

                        ProjektNotizen."Zu beachten1" := CopyStr(ZuBeachten, 1, 250);
                        ProjektNotizen."Zu beachten2" := CopyStr(ZuBeachten, 251, 250);
                        ProjektNotizen."Zu beachten3" := CopyStr(ZuBeachten, 501, 250);
                        ProjektNotizen.Modify;
                    end;
                }
                field(MontageGrp; MontageGrp)
                {
                    ApplicationArea = Basic;
                    Caption = 'Montagegruppe';
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        if not ProjektNotizen.Get(Rec."No.") then begin
                            ProjektNotizen."Job No." := Rec."No.";
                            ProjektNotizen.Insert;
                        end;

                        ProjektNotizen.Montagegruppe1 := CopyStr(MontageGrp, 1, 250);
                        ProjektNotizen.Montagegruppe2 := CopyStr(MontageGrp, 251, 250);
                        ProjektNotizen.Montagegruppe3 := CopyStr(MontageGrp, 501, 250);
                        ProjektNotizen.Modify;
                    end;
                }
            }
            group("Stundensätze/Zuschläge")
            {
                Caption = 'Hourly rates / Supplements';
                Visible = false;
                field("Reparatur in Euro"; Rec."Reparatur  in Euro")
                {
                    ApplicationArea = Basic;
                }
                field("Gütesicherung in Euro"; Rec."Gütesicherung  in Euro")
                {
                    ApplicationArea = Basic;
                }
                field("Brandwache in Euro"; Rec."Brandwache  in Euro")
                {
                    ApplicationArea = Basic;
                }
                field("Lagermaterialzuschlag %"; Rec."Lagermaterialzuschlag %")
                {
                    ApplicationArea = Basic;
                }
                field("Fremdzuschlag %"; Rec."Fremdzuschlag %")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        addafter(Control1902018507)
        {
            part("Soll / Ist Vergleich"; "Projekt Soll/Ist Vergleich")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No." = field("No.");
            }
            part("Projektdetails - WIP/Umsatzrealisierung"; "Job WIP/Recognition FactBox")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No." = field("No."), "Resource Filter" = field("Resource Filter"), "Posting Date Filter" = field("Posting Date Filter"), "Resource Gr. Filter" = field("Resource Gr. Filter"), "Planning Date Filter" = field("Planning Date Filter");
            }
        }
    }
    actions
    {
        modify("&Job")
        {
            Caption = '&Job';
        }
        modify("Co&mments")
        {
            Caption = 'Co&mments';
            ToolTip = 'View the comment sheet for this job.';
        }
        modify("&Online Map")
        {
            Caption = '&Online Map';
            ToolTip = 'View online map for addresses assigned to this job.';
        }
        modify(History)
        {
            Caption = 'History';
        }
        modify("Ledger E&ntries")
        {
            Caption = 'Ledger E&ntries';
            ToolTip = 'View the history of transactions that have been posted for the selected record.';
        }
        modify(JobPlanningLines)
        {
            Visible = false;
        }
        modify("&Dimensions")
        {
            Visible = false;
        }
        modify("&Statistics")
        {
            Visible = false;
        }
        modify("W&IP")
        {
            Visible = false;
        }
        modify("&WIP Entries")
        {
            Visible = false;
        }
        modify("WIP &G/L Entries")
        {
            Visible = false;
        }
        modify("Plan&ning")
        {
            Visible = false;
        }
        modify("Resource &Allocated per Job")
        {
            Visible = false;
        }
        modify("Res. Gr. All&ocated per Job")
        {
            Visible = false;
        }
        modify("&Copy")
        {
            Visible = false;
        }
        modify("Copy Job Tasks &from...")
        {
            Visible = false;
        }
        modify("Copy Job Tasks &to...")
        {
            Visible = false;
        }
        modify("<Action82>")
        {
            Visible = false;
        }
        modify("<Action83>")
        {
            Visible = false;
        }
        modify("Job Actual to Budget")
        {
            Visible = false;
        }
        modify("Job Analysis")
        {
            Visible = false;
        }
        modify("Job - Planning Lines")
        {
            Visible = false;
        }
        modify("Job - Suggested Billing")
        {
            Visible = false;
        }
        modify("Report Job Quote")
        {
            Visible = false;
        }
        modify("Send Job Quote")
        {
            Visible = false;
        }
        addafter("Ledger E&ntries")
        {
            action(Bilder)
            {
                ApplicationArea = Basic;
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Bildspeicherung: Record 50015;
                begin
                    Bildspeicherung.SetRange("Job No.", Rec."No.");
                    Page.RunModal(50015, Bildspeicherung);
                end;
            }
            group(Requests)
            {
                Caption = 'Anforderungen';
                action("Tool Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Werkzeuganforderung';
                    Image = List;

                    trigger OnAction()
                    var
                        Werkzeuganforderungskopf_l: Record 50008;
                    begin
                        Werkzeuganforderungskopf_l.SetRange("Projekt Nr", Rec."No.");
                        Page.RunModal(50076, Werkzeuganforderungskopf_l);
                    end;
                }
                action("Material Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Materialanforderung';
                    Image = List;

                    trigger OnAction()
                    var
                        Materialanforderungskopf_l: Record 50007;
                    begin
                        Materialanforderungskopf_l.SetRange("Projekt Nr", Rec."No.");
                        Page.RunModal(50064, Materialanforderungskopf_l);
                    end;
                }
            }
        }
        addlast(navigation)
        {
            action(Liquidity)
            {
                ApplicationArea = All;
                Caption = 'Liquidität';
                RunObject = Page "Liquidity Planning";
                RunPageLink = "Job No." = FIELD("No.");
            }
        }

        addfirst(Reporting)
        {
            action("<Action1000000022>")
            {
                ApplicationArea = Basic;
                Caption = 'Projekteingangsmeldung';
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    LJob: Record Job;
                begin
                    LJob.Get(Rec."No.");
                    LJob.SetRecfilter;
                    Report.RunModal(50012, true, false, LJob);
                end;
            }
            action("Status hoch stufen")
            {
                ApplicationArea = Basic;
                Caption = 'Status hoch stufen';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Bin_l: Record Bin;
                    InventorySetup_l: Record "Inventory Setup";
                begin

                    // G-ERP.RS+ 2021-02-01 + 01
                    InventorySetup_l.Get();
                    InventorySetup_l.TestField("Project Location");
                    // G-ERP.RS+ 2021-02-01 - 01

                    if Rec.Status = Rec.Status::Open then begin
                        Rec.Status := Rec.Status::Quote;
                        Rec.Modify();
                        exit;
                    end;

                    if Rec.Status = Rec.Status::Quote then begin
                        Rec.Status := Rec.Status::Planning;
                        Rec.Modify();
                        exit;
                    end;

                    if Rec.Status = Rec.Status::Planning then begin
                        Rec.Status := Rec.Status::Invoiced;
                        Rec.Modify();
                        exit;
                    end;

                    if Rec.Status = Rec.Status::Completed then begin
                        Rec.Status := Rec.Status::Invoiced;
                        Rec.Modify();
                        exit;
                    end;

                    // G-ERP.RS 2021-02-01 + 01
                    if Rec.Status = Rec.Status::Planning then begin
                        if not Bin_l.Get(InventorySetup_l."Project Location", Rec."No.") then begin
                            Clear(Bin_l);
                            Bin_l.Init();
                            Bin_l.Validate("Location Code", InventorySetup_l."Project Location");
                            Bin_l.Validate(Code, Rec."No.");
                            Bin_l.Validate(Description, Rec.Description);
                            Bin_l.Insert(true);
                        end;
                    end;
                    // G-ERP.RS 2021-02-01 - 01

                end;
            }
            action("<Action1000000028>")
            {
                ApplicationArea = Basic;
                Caption = 'Status runter stufen';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    IF (Rec.Status = Rec.Status::Open) THEN
                        EXIT;

                    if (Rec.Status = Rec.Status::Cancelled) then begin
                        Rec.Status := Rec.Status::Quote;
                        Rec.Modify();
                        exit;
                    end;

                    if Rec.Status = Rec.Status::"Gewährleistung" then begin
                        Rec.Status := Rec.Status::Planning;
                        Rec.Modify();
                        exit;
                    end;

                    if Rec.Status = Rec.Status::Invoiced then begin
                        Rec.Status := Rec.Status::Planning;
                        Rec.Modify();
                        exit;
                    end;
                end;
            }
            action("Status abgesagt")
            {
                ApplicationArea = Basic;
                Caption = 'Status abgesagt';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Cancelled;
                end;
            }
            action("<Action1000000029>")
            {
                ApplicationArea = Basic;
                Caption = 'Status Abgeschlossen';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Completed;
                end;
            }
            action("<Action1000000050>")
            {
                ApplicationArea = Basic;
                Caption = 'Status Gewährleistung';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::"Gewährleistung";
                end;
            }
            action("<Action1000000031>")
            {
                ApplicationArea = Basic;
                Caption = 'Unterauftrag anlegen';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    l_Job2: Record Job;
                    InJob: Record Job;
                    JobNo: Code[20];
                    Bin_l: Record Bin;
                    InventorySetup_l: Record "Inventory Setup";
                begin
                    // Auf anfrage von Florian Prill
                    // AC01 B
                    //IF (Status = Status::Order) OR (Status = Status::Abgerechnet) THEN BEGIN
                    // AC01 E
                    if Confirm('Möchten Sie einen Unterauftrag anlegen?', false) then begin
                        if StrPos(Rec."No.", '-') = 6 then begin
                            JobNo := CopyStr(Rec."No.", 1, (StrPos(Rec."No.", '-') - 1)) + '-001';
                            while InJob.Get(JobNo) do
                                JobNo := IncStr(JobNo);
                        end
                        else begin
                            if StrPos(Rec."No.", '-') = 8 then begin
                                JobNo := Rec."No.";
                                while InJob.Get(JobNo) do
                                    JobNo := IncStr(JobNo);
                            end
                            else begin
                                JobNo := Rec."No." + '-001';
                                while InJob.Get(JobNo) do
                                    JobNo := IncStr(JobNo);
                            end;
                        end;

                        //l_Job2 := Rec;
                        l_Job2."No." := JobNo;
                        l_Job2.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
                        l_Job2."Sell-to Contact No." := Rec."Sell-to Contact No.";
                        l_Job2."Job Type" := Rec."Job Type";
                        l_Job2.Status := Rec.Status;
                        l_Job2.Object := Rec.Object;
                        l_Job2.Objektname := Rec.Objektname;

                        // l_Job2.Status := l_Job2.Status::Order;
                        l_Job2.Subproject := true;        //G-ERP.RS 2019-01-24
                        l_Job2.MainProjektNo := Rec."No.";    //G-ERP.RS 2019-01-24
                        l_Job2."Folder Created" := false; //G-ERP.RS 2019-01-24
                        l_Job2.Insert;
                        l_Job2.Modify(true); //G-ERP.RS 2019-01-24

                        //G-ERP.RS 2021-07-09 +++ Anfrage#2310609
                        //G-ERP.RS 2021-07-14 IF Status = Status::Order THEN BEGIN
                        InventorySetup_l.Get();
                        InventorySetup_l.TestField("Project Location");
                        if not Bin_l.Get(InventorySetup_l."Project Location", l_Job2."No.") then begin
                            Clear(Bin_l);
                            Bin_l.Init();
                            Bin_l.Validate("Location Code", InventorySetup_l."Project Location");
                            Bin_l.Validate(Code, l_Job2."No.");
                            Bin_l.Validate(Description, l_Job2.Description);
                            Bin_l.Insert(true);
                        end;
                        //G-ERP.RS 2021-07-14 END;
                        //G-ERP.RS 2021-07-09 --- Anfrage#2310609


                        Message('Es wurde Unterauftrag %1 angelegt!', l_Job2."No.");
                    end;
                    // AC01 B
                    //END;
                    // AC01 E
                end;
            }
            action("Verkaufsangebot anlegen")
            {
                ApplicationArea = Basic;
                Caption = 'Verkaufsangebot anlegen';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    l_SalesHeader: Record "Sales Header";
                    l_SalesNo: Code[20];
                begin
                    l_SalesNo := Rec.SalesQuoteCreate();
                    Commit;
                    if l_SalesHeader.Get(l_SalesHeader."document type"::Quote, l_SalesNo) then
                        Page.RunModal(41, l_SalesHeader);
                end;
            }
            action("<Action1000000043>")
            {
                ApplicationArea = Basic;
                Caption = 'Auftragsbestätigung anlegen';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    l_SalesHeader: Record "Sales Header";
                    l_SalesNo: Code[20];
                begin
                    l_SalesNo := Rec.SalesOrderCreate();
                    Commit;
                    if l_SalesHeader.Get(l_SalesHeader."document type"::Order, l_SalesNo) then
                        Page.RunModal(42, l_SalesHeader);
                end;
            }
            action("<Action1000000044>")
            {
                ApplicationArea = Basic;
                Caption = 'Auftragsbestätigung anzeigen';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    l_SalesHeader: Record "Sales Header";
                begin
                    l_SalesHeader.SetRange("Document Type", l_SalesHeader."document type"::Order);
                    l_SalesHeader.SetRange("Job No.", Rec."No.");
                    if l_SalesHeader.FindSet then
                        Page.RunModal(0, l_SalesHeader);
                end;
            }
            action("<Action1000000053>")
            {
                ApplicationArea = Basic;
                Caption = 'Rechnung anzeigen';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    l_SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    l_SalesInvoiceHeader.SetRange("Job No.", Rec."No.");
                    if l_SalesInvoiceHeader.FindSet then
                        Page.RunModal(0, l_SalesInvoiceHeader);
                end;
            }
            action("Import Kalkulation")
            {
                ApplicationArea = Basic;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    l_Job: Record Job;
                begin
                    l_Job.SetRange("No.", Rec."No.");
                    //l_Job.GET("No.");
                    //l_Job.SETRECFILTER();
                    Report.RunModal(50029, true, false, l_Job);
                end;
            }
            action(Auftragseingangsmeldung)
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    LJob: Record Job;
                begin
                    LJob.Get(Rec."No.");
                    LJob.SetRecfilter;
                    Report.RunModal(50013, true, false, LJob);
                end;
            }
            action(ProjectPlanningLines)
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "TT Projekt Planung";
                RunPageLink = "Job No." = field("No.");
                Caption = 'Projektplanungszeilen';
            }
        }
    }

    var
        "*G-ERP*": Integer;
        MapPointVisible: Boolean;
        UserSetup: Record "User Setup";
        Job2: Record Job;
        ReturnJob: Record Job;
        Text001: label 'Möchten Sie das Projekt in den Auftragsstatus setzen (es erfolgt eine Projektkopie in den Auftragsnummernbereich) ?';
        ZuBeachten: Text;
        AnfrageUeber: Text;
        MontageGrp: Text;
        ProjektNotizen: Record 50001;



    trigger OnAfterGetRecord()
    begin
        AnfrageUeber := '';
        ZuBeachten := '';
        MontageGrp := '';
        IF ProjektNotizen.GET(Rec."No.") THEN BEGIN
            AnfrageUeber := ProjektNotizen."Anfrage über1" + ProjektNotizen."Anfrage über2" + ProjektNotizen."Anfrage über3";
            ZuBeachten := ProjektNotizen."Zu beachten1" + ProjektNotizen."Zu beachten2" + ProjektNotizen."Zu beachten3";
            MontageGrp := ProjektNotizen.Montagegruppe1 + ProjektNotizen.Montagegruppe2 + ProjektNotizen.Montagegruppe3;
        END;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //G-ERP.KBS 2017-07-25 +
        IF Rec.GETFILTER(Status) <> '' THEN
            EVALUATE(Rec.Status, Rec.GETFILTER(Status));
        //G-ERP.KBS 2017-07-25 -
    end;
}

