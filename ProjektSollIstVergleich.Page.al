Page 50025 "Projekt Soll/Ist Vergleich"
{
    Caption = 'Job Soll/Ist Vergleich';
    PageType = CardPart;
    SourceTable = Job;
    layout
    {
        area(content)
        {
            field("Arbeitsstd. kalkuliert"; JobPlanningLine.Quantity)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Arbeitsstd. geleistet"; ArbeitsstdGeleistet)
            {
                ApplicationArea = Basic;
                Style = StandardAccent;
                StyleExpr = Ampelstd;

                trigger OnAssistEdit()
                var
                    JobLedgerEntry_l: Record "Job Ledger Entry";
                begin
                    Clear(JobLedgerEntry_l);
                    case Rec.SumProject of
                        true:
                            JobLedgerEntry_l.SetFilter("Job No.", '%1', Rec."No." + '*');
                        false:
                            JobLedgerEntry_l.SetRange("Job No.", Rec."No.");
                    end;
                    JobLedgerEntry_l.SetRange(Type, JobLedgerEntry.Type::Resource);
                    Page.RunModal(0, JobLedgerEntry_l);
                end;
            }
            field("Arbeitsstd. Eigen"; Arbeitsstunden_EIGEN)
            {
                ApplicationArea = Basic;
            }
            field("Arbeitsstd. Fremd"; Arbeitsstunden_FREMD)
            {
                ApplicationArea = Basic;
            }
            field(Lohnkosten; JobPlanningLine.Lohnkosten)
            {
                ApplicationArea = Basic;
                DecimalPlaces = 2 : 2;
            }
            field("Lohnkosten geleistet"; Lohnkosten_IST)
            {
                ApplicationArea = Basic;
            }
            field("Lohnkosten Fremd geleistet"; PersonalIst)
            {
                ApplicationArea = Basic;
            }
            field("Lagermaterial Soll"; rec."EK-Materialkosten Soll")
            {
                ApplicationArea = Basic;
            }
            field("Lagermaterial Ist"; LagermaterialIst)
            {
                ApplicationArea = Basic;
                Style = StandardAccent;
                StyleExpr = AmpelMaterial;

                trigger OnAssistEdit()
                var
                    JobLedgerEntry_l: Record "Job Ledger Entry";
                begin
                    Clear(JobLedgerEntry_l);
                    case Rec.SumProject of
                        true:
                            JobLedgerEntry_l.SetFilter("Job No.", '%1', Rec."No." + '*');
                        false:
                            JobLedgerEntry_l.SetRange("Job No.", Rec."No.");
                    end;
                    //JobLedgerEntry_l.SETRANGE("Source Code",'');
                    JobLedgerEntry_l.SetFilter("Source Code", '%1|%2', '', 'PROJBUCHBL');
                    Page.RunModal(0, JobLedgerEntry_l);
                end;
            }
            group(Fremdlieferung)
            {
                field(Soll; rec."EK-Fremdlieferung Soll")
                {
                    ApplicationArea = Basic;
                }
                field(Ist; Fremdlief)
                {
                    ApplicationArea = Basic;

                    trigger OnDrilldown()
                    var
                        PurchInvHeader_temp: Record "Purch. Inv. Header" temporary;
                        PurchaseHeader_l: Record "Purchase Header";
                        PurchaseLine_l: Record "Purchase Line";
                        PurchInvLine_l: Record "Purch. Inv. Line";
                        PurchCrMemoHdr_l: Record "Purch. Cr. Memo Hdr.";
                        PurchCrMemoLine_l: Record "Purch. Cr. Memo Line";
                    begin
                        case Rec.SumProject of
                            true:
                                PurchInvLine.SetFilter("Job No.", '%1', Rec."No." + '*');
                            false:
                                PurchInvLine.SetRange("Job No.", Rec."No.");
                        end;
                        PurchInvLine.SetRange(Leistungsart, PurchInvLine.Leistungsart::Fremdlieferung);
                        if PurchInvLine.FindSet then
                            repeat
                                PurchInvHeader.Get(PurchInvLine."Document No.");
                                PurchInvHeader_temp := PurchInvHeader;
                                if PurchInvHeader_temp.Insert then;
                            until PurchInvLine.Next = 0;
                        case Rec.SumProject of
                            true:
                                PurchInvHeader_temp.SetFilter("Job No.", '%1', Rec."No." + '*');
                            false:
                                PurchInvHeader_temp.SetRange("Job No.", Rec."No.");
                        end;
                        PurchInvHeader_temp.SetRange(Leistungsart, PurchInvHeader_temp.Leistungsart::Fremdlieferung);

                        //G-ERP.RS 2020-03-12 +++ Anfrage#235334
                        PurchaseLine_l.SetFilter("Job No.", PurchInvLine.GetFilter("Job No."));
                        PurchaseLine_l.SetRange(Leistungsart, PurchaseLine_l.Leistungsart::Fremdlieferung);
                        if PurchaseLine_l.FindSet then
                            repeat
                                PurchaseHeader_l.Get(PurchaseLine_l."Document Type", PurchaseLine_l."Document No.");
                                PurchaseHeader_l.CalcFields(Amount);
                                if PurchaseHeader_l.Amount <> 0 then begin
                                    PurchInvHeader_temp.Init();
                                    PurchInvHeader_temp.TransferFields(PurchaseHeader_l);
                                    if PurchInvHeader_temp.Insert() then;
                                end;
                            until PurchaseLine_l.Next = 0;
                        PurchInvHeader_temp.SetFilter("Job No.", PurchInvLine.GetFilter("Job No."));
                        PurchInvHeader_temp.SetRange(Leistungsart, PurchInvHeader_temp.Leistungsart::Fremdlieferung);


                        PurchCrMemoLine_l.SetFilter("Job No.", PurchInvLine.GetFilter("Job No."));
                        PurchCrMemoLine_l.SetRange(Leistungsart, PurchCrMemoLine_l.Leistungsart::Fremdlieferung);
                        if PurchCrMemoLine_l.FindSet() then
                            repeat
                                PurchCrMemoHdr_l.Get(PurchCrMemoLine_l."Document No.");
                                PurchInvHeader_temp.Init();
                                PurchInvHeader_temp.TransferFields(PurchCrMemoHdr_l);
                                PurchInvHeader_temp.Amount := PurchInvHeader_temp.Amount * -1;
                                PurchInvHeader_temp."Amount Including VAT" := PurchInvHeader_temp."Amount Including VAT" * -1;
                                if PurchInvHeader_temp.Insert() then;
                            until PurchaseLine_l.Next = 0;
                        PurchInvHeader_temp.SetFilter("Job No.", PurchInvLine.GetFilter("Job No."));
                        PurchInvHeader_temp.SetRange(Leistungsart, PurchInvHeader_temp.Leistungsart::Fremdlieferung);
                        //G-ERP.RS 2020-03-12 --- Anfrage#235334
                        PurchInvHeader_temp.CalcFields(Amount);
                        Page.RunModal(50033, PurchInvHeader_temp);
                    end;
                }
            }
            group(Fremdleistung)
            {
                field(".Soll"; rec."EK-Fremdarbeitenkosten Soll")
                {
                    ApplicationArea = Basic;
                    Caption = 'Soll';
                }
                field(".Ist"; Fremdleist)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ist';
                    Style = StandardAccent;
                    StyleExpr = AmpelFremd;

                    trigger OnDrilldown()
                    var
                        PurchInvHeader_temp: Record "Purch. Inv. Header" temporary;
                    begin
                        Clear(PurchInvLine);
                        case Rec.SumProject of
                            true:
                                PurchInvLine.SetFilter("Job No.", '%1', Rec."No." + '*');
                            false:
                                PurchInvLine.SetRange("Job No.", Rec."No.");
                        end;

                        //PurchInvLine.SETFILTER(Leistungsart,'%1|%2|%3|%4|%5|%6|%7',PurchInvLine.Leistungsart::Fremdleistung,
                        //                                         PurchInvLine.Leistungsart::Personal,    //G-ERP.RS 2019-08-13 +++ Anfrage#233374
                        //                                         PurchInvLine.Leistungsart::Transport,
                        //                                         PurchInvLine.Leistungsart::Hotelkosten,
                        //                                         PurchInvLine.Leistungsart::Reisekosten,
                        //                                         PurchInvLine.Leistungsart::Auslöse,     //G-ERP.RS 2019-08-13 ---
                        PurchInvLine.SetFilter(Leistungsart, '%1|%2', PurchInvLine.Leistungsart::Fremdleistung,
                                                                    PurchInvLine.Leistungsart::" ");
                        if PurchInvLine.FindSet then
                            repeat
                                PurchInvHeader.Get(PurchInvLine."Document No.");
                                PurchInvHeader_temp := PurchInvHeader;
                                if PurchInvHeader_temp.Insert then;
                            until PurchInvLine.Next = 0;

                        case Rec.SumProject of
                            true:
                                PurchInvHeader_temp.SetFilter("Job No.", '%1', Rec."No." + '*');
                            false:
                                PurchInvHeader_temp.SetRange("Job No.", Rec."No.");
                        end;
                        //PurchInvHeader_temp.SETRANGE(Leistungsart,PurchInvHeader_temp.Leistungsart::Fremdleistung);
                        //PurchInvHeader_temp.SETFILTER(Leistungsart,'%1|%2|%3|%4|%5|%6|%7',PurchInvLine.Leistungsart::Fremdleistung,
                        //                                         PurchInvLine.Leistungsart::Personal,    //G-ERP.RS 2019-08-13 +++ Anfrage#233374
                        //                                         PurchInvLine.Leistungsart::Transport,
                        //                                         PurchInvLine.Leistungsart::Hotelkosten,
                        //                                         PurchInvLine.Leistungsart::Reisekosten,
                        //                                         PurchInvLine.Leistungsart::Auslöse,     //G-ERP.RS 2019-08-13 ---
                        PurchInvHeader_temp.SetFilter(Leistungsart, '%1|%2', PurchInvLine.Leistungsart::Fremdleistung,
                                                                           PurchInvLine.Leistungsart::" ");

                        Page.RunModal(50033, PurchInvHeader_temp);
                    end;
                }
            }
            field("Transporte Soll"; rec."EK-Transportkosten Soll")
            {
                ApplicationArea = Basic;
            }
            field("Transporte Ist"; TranspLeist)
            {
                ApplicationArea = Basic;

                trigger OnDrilldown()
                var
                    PurchInvHeader_temp: Record "Purch. Inv. Header" temporary;
                begin
                    case Rec.SumProject of
                        true:
                            PurchInvLine.SetFilter("Job No.", '%1', Rec."No." + '*');
                        false:
                            PurchInvLine.SetRange("Job No.", Rec."No.");
                    end;
                    PurchInvLine.SetRange(Leistungsart, PurchInvLine.Leistungsart::Transport);
                    if PurchInvLine.FindSet then
                        repeat
                            PurchInvHeader.Get(PurchInvLine."Document No.");
                            PurchInvHeader_temp := PurchInvHeader;
                            if PurchInvHeader_temp.Insert then;
                        until PurchInvLine.Next = 0;

                    Page.RunModal(50033, PurchInvHeader_temp);
                end;
            }
            field("Hotelkosten Soll"; rec."EK-Hotelkosten Soll")
            {
                ApplicationArea = Basic;
            }
            field("Hotelkosten Ist"; HotelLeist)
            {
                ApplicationArea = Basic;

                trigger OnDrillDown()
                var
                    PurchInvHeader_temp: Record "Purch. Inv. Header" temporary;
                begin
                    case Rec.SumProject of
                        true:
                            PurchInvLine.SetFilter("Job No.", '%1', Rec."No." + '*');
                        false:
                            PurchInvLine.SetRange("Job No.", Rec."No.");
                    end;
                    PurchInvLine.SetRange(Leistungsart, PurchInvLine.Leistungsart::Hotelkosten);
                    if PurchInvLine.FindSet then
                        repeat
                            PurchInvHeader.Get(PurchInvLine."Document No.");
                            PurchInvHeader_temp := PurchInvHeader;
                            if PurchInvHeader_temp.Insert then;
                        until PurchInvLine.Next = 0;
                    Page.RunModal(50033, PurchInvHeader_temp);
                end;
            }
            field("Flugkosten Soll"; rec."EK-Flugkosten Soll")
            {
                ApplicationArea = Basic;
            }
            field("Flugkosten Ist"; ReiseLeist)
            {
                ApplicationArea = Basic;

                trigger OnDrilldown()
                var
                    PurchInvHeader_temp: Record "Purch. Inv. Header" temporary;
                begin
                    case Rec.SumProject of
                        true:
                            PurchInvLine.SetFilter("Job No.", '%1', Rec."No." + '*');
                        false:
                            PurchInvLine.SetRange("Job No.", Rec."No.");
                    end;
                    PurchInvLine.SetRange(Leistungsart, PurchInvLine.Leistungsart::Flugkosten);
                    if PurchInvLine.FindSet then
                        repeat
                            PurchInvHeader.Get(PurchInvLine."Document No.");
                            PurchInvHeader_temp := PurchInvHeader;
                            if PurchInvHeader_temp.Insert then;
                        until PurchInvLine.Next = 0;
                    Page.RunModal(50033, PurchInvHeader_temp);
                end;
            }
            field("Auslöse Soll"; rec."EK-Auslöse Soll")
            {
                ApplicationArea = Basic;
            }
            field("Auslöse Ist"; AuslöseLeist)
            {
                ApplicationArea = Basic;

                trigger OnDrilldown()
                var
                    PurchInvHeader_temp: Record "Purch. Inv. Header" temporary;
                begin
                    case Rec.SumProject of
                        true:
                            PurchInvLine.SetFilter("Job No.", '%1', Rec."No." + '*');
                        false:
                            PurchInvLine.SetRange("Job No.", Rec."No.");
                    end;
                    PurchInvLine.SetRange(Leistungsart, PurchInvLine.Leistungsart::Auslöse);
                    if PurchInvLine.FindSet then
                        repeat
                            PurchInvHeader.Get(PurchInvLine."Document No.");
                            PurchInvHeader_temp := PurchInvHeader;
                            if PurchInvHeader_temp.Insert then;
                        until PurchInvLine.Next = 0;
                    Page.RunModal(50033, PurchInvHeader_temp);
                end;
            }
            field(Anfragen; Rec."EK-Anfragen")
            {
                ApplicationArea = Basic;

                trigger OnDrilldown()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."document type"::Quote);
                    case Rec.SumProject of
                        true:
                            PurchaseHeader.SetFilter("Job No.", '%1', Rec."No." + '*');
                        false:
                            PurchaseHeader.SetRange("Job No.", Rec."No.");
                    end;
                    Page.RunModal(50011, PurchaseHeader);
                end;
            }
            field("Bestellungen (offen)"; Rec."EK-Bestellungen")
            {
                ApplicationArea = Basic;
                Caption = 'Bestellungen (nicht vorhandene Lieferantenrechnung)';

                trigger OnDrilldown()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."document type"::Order);
                    case Rec.SumProject of
                        true:
                            PurchaseHeader.SetFilter("Job No.", '%1', Rec."No." + '*');
                        false:
                            PurchaseHeader.SetRange("Job No.", Rec."No.");
                    end;

                    //G-ERP.RS 2019-08-13 +++
                    if PurchaseHeader.FindSet() then
                        repeat
                            PurchaseHeader.CalcFields("Amt. Rcd. Not Invoiced", "Outstanding Amount");
                            if (PurchaseHeader."Amt. Rcd. Not Invoiced" <> 0) or
                               (PurchaseHeader."Outstanding Amount" <> 0) then
                                PurchaseHeader.Mark(true);
                        until (PurchaseHeader.Next() = 0);
                    PurchaseHeader.MarkedOnly(true);

                    // PurchaseHeader.SETFILTER(Leistungsart,'%1|%2|%3|%4|%5|%6|%7',PurchaseHeader.Leistungsart::Fremdleistung,
                    //                                         PurchaseHeader.Leistungsart::Personal,
                    //                                         PurchaseHeader.Leistungsart::Transport,
                    //                                         PurchaseHeader.Leistungsart::Hotelkosten,
                    //                                         PurchaseHeader.Leistungsart::Reisekosten,
                    //                                         PurchaseHeader.Leistungsart::Auslöse,
                    //                                         PurchaseHeader.Leistungsart::" ");
                    //G-ERP.RS 2019-08-13 ---
                    Page.RunModal(50012, PurchaseHeader);
                end;
            }
            field(Rechnungen; Rec."EK-Rechnungen")
            {
                ApplicationArea = Basic;

                trigger OnDrilldown()
                var
                    PurchInvHeader_temp: Record "Purch. Inv. Header" temporary;
                begin
                    case Rec.SumProject of
                        true:
                            PurchInvLine.SetFilter("Job No.", '%1', Rec."No." + '*');
                        false:
                            PurchInvLine.SetRange("Job No.", Rec."No.");
                    end;
                    if PurchInvLine.FindSet then
                        repeat
                            PurchInvHeader.Get(PurchInvLine."Document No.");
                            PurchInvHeader_temp := PurchInvHeader;
                            if PurchInvHeader_temp.Insert then;
                        until PurchInvLine.Next = 0;
                    case Rec.SumProject of
                        true:
                            PurchInvHeader_temp.SetFilter("Job No.", '%1', Rec."No." + '*');
                        false:
                            PurchInvHeader_temp.SetRange("Job No.", Rec."No.");
                    end;
                    Page.RunModal(50033, PurchInvHeader_temp);
                end;
            }
            field(Gutschrift; Rec."EK-Gutschrift")
            {
                ApplicationArea = Basic;

                trigger OnDrilldown()
                var
                    PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
                begin
                    case Rec.SumProject of
                        true:
                            PurchCrMemoLine.SetFilter("Job No.", '%1', Rec."No." + '*');
                        false:
                            PurchCrMemoLine.SetRange("Job No.", Rec."No.");
                    end;
                    if PurchCrMemoLine.FindSet then
                        repeat
                            PurchCrMemoHdr.Get(PurchCrMemoLine."Document No.");
                            PurchCrMemoHdr_temp := PurchCrMemoHdr;
                            if PurchCrMemoHdr_temp.Insert then;
                        until PurchCrMemoLine.Next = 0;
                    Page.RunModal(50034, PurchCrMemoHdr_temp);
                end;
            }
            field(LiquidityInvoiced; LiquidityPlanning_Invoice)
            {
                ApplicationArea = Basic;
                Caption = 'Zu erwartende Zahlungen';

                trigger OnAssistEdit()
                var
                    LiquidityPlanning_l: Record "Liquidity Planning";
                begin
                    LiquidityPlanning_l.Reset();
                    LiquidityPlanning_l.SetRange("Job No.", Rec."No.");
                    LiquidityPlanning_l.SetFilter("Posted Invoice No.", '%1', '');
                    if LiquidityPlanning_l.FindSet() then
                        Page.RunModal(0, LiquidityPlanning_l);
                end;
            }
            field(LiquidityPostedInvoiced; LiquidityPlanning_PostedInvoice)
            {
                ApplicationArea = Basic;
                Caption = 'Erhaltene Zahlungen';

                trigger OnAssistEdit()
                var
                    LiquidityPlanning_l: Record "Liquidity Planning";
                begin
                    LiquidityPlanning_l.Reset();
                    LiquidityPlanning_l.SetRange("Job No.", Rec."No.");
                    LiquidityPlanning_l.SetFilter("Posted Invoice No.", '<>%1', '');
                    if LiquidityPlanning_l.FindSet() then
                        Page.RunModal(0, LiquidityPlanning_l);
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        JobLedgerEntry: Record "Job Ledger Entry";
        Job_l: Record Job;
        LiquidityPlanning_l: Record "Liquidity Planning";
    begin
        Rec.CalcFields("EK Material Ist", "EK Fremdlieferung Ist", "EK Fremdleistung Ist", "Lagermaterial Ist", "EK Transporte Ist",
                   "EK Hotelkosten Ist", "EK Flugkosten Ist", "EK Auslöse Ist", "EK Fremdlieferung Ist Gut", "EK Fremdleistung Ist Gut",
                   "EK Transporte Ist Gut", "EK Hotelkosten Ist Gut", "EK Flugkosten Ist Gut", "EK Auslöse Ist Gut", "EK-Auslöse Soll", "EK-Fremdarbeitenkosten Soll",
                   "EK-Fremdlieferung Soll", "EK-Hotelkosten Soll", "EK-Materialkosten Soll", "EK-Flugkosten Soll", "EK-Transportkosten Soll");

        AmpelStd := false;
        AmpelEKStd := false;
        AmpelMaterial := false;
        AmpelFremd := false;

        //Arbeitsstd. kalkuliert / Lohnkosten +++
        Clear(JobPlanningLine);
        JobPlanningLine.SetCurrentkey("Job No.", Type);
        case Rec.SumProject of
            true:
                JobPlanningLine.SetFilter("Job No.", '%1', Rec."No." + '*');
            false:
                JobPlanningLine.SetRange("Job No.", Rec."No.");
        end;
        JobPlanningLine.SetRange(Type, JobPlanningLine.Type::Resource);
        JobPlanningLine.CalcSums(Quantity);
        JobPlanningLine.SetRange(Type);
        JobPlanningLine.CalcSums(Lohnkosten, Materialkosten, Fremdarbeitenkosten, "EK-Lohnkosten",
                                 "EK-Materialkosten", "EK-Fremdarbeitenkosten", "EK-Transport", "EK-Hotelkosten",
                                 "EK-Reisekosten", "EK-Auslöse", "EK-Fremdlieferungkosten");
        //CALCFIELDS("Arbeitsstd. Gesamt Ist","EK Arbeitsstd. Gesamt Ist","EK Material Ist","EK Fremd Ist");
        if JobPlanningLine.Quantity < Rec."Arbeitsstd. Gesamt Ist" then
            AmpelStd := true;
        if JobPlanningLine."EK-Lohnkosten" < Rec."EK Arbeitsstd. Gesamt Ist" then
            AmpelEKStd := true;
        if JobPlanningLine."EK-Materialkosten" < Rec."EK Material Ist" then
            AmpelMaterial := true;
        if JobPlanningLine."EK-Fremdarbeitenkosten" < Rec."EK Fremdlieferung Ist" then
            AmpelFremd := true;
        //G-ERP.KBS 2018-05-28 +
        Clear(JobPlanningLine2);
        JobPlanningLine2.SetCurrentkey("Job No.", Type);
        case Rec.SumProject of
            true:
                JobPlanningLine2.SetFilter("Job No.", '%1', Rec."No." + '*');
            false:
                JobPlanningLine2.SetRange("Job No.", Rec."No.");
        end;
        JobPlanningLine2.SetRange(Type, JobPlanningLine2.Type::Resource);
        JobPlanningLine2.SetRange("No.", '1');
        JobPlanningLine2.CalcSums(Lohnkosten, Quantity);
        //Arbeitsstd. kalkuliert / Lohnkosten ---


        //Arbeitsstd. geleistet +++
        LagermaterialIst := 0;
        Clear(JobLedgerEntry);
        case Rec.SumProject of
            true:
                JobLedgerEntry.SetFilter("Job No.", '%1', Rec."No." + '*');
            false:
                JobLedgerEntry.SetRange("Job No.", Rec."No.");
        end;
        JobLedgerEntry.SetRange(Type, JobLedgerEntry.Type::Resource);
        JobLedgerEntry.CalcSums(Quantity);
        ArbeitsstdGeleistet := JobLedgerEntry.Quantity;
        JobLedgerEntry.SetRange(Type);
        JobLedgerEntry.SetRange("Source Code", '');                     //G-ERP.RS 2019-08-12 Anfrage#233374
        JobLedgerEntry.SetFilter("Source Code", '%1|%2', '', 'PROJBUCHBL'); //G-ERP.RS 2019-08-12
        //JobLedgerEntry.CALCSUMS("Total Cost (LCY)");                                            //G-ERP.RS 2019-08-20
        //LagermaterialIst := JobLedgerEntry."Total Cost (LCY)";                                  //G-ERP.RS 2019-08-20
        //JobLedgerEntry.CALCSUMS("Direct Unit Cost (LCY)",Quantity);                             //G-ERP.RS 2019-08-20
        //LagermaterialIst := JobLedgerEntry."Direct Unit Cost (LCY)" * JobLedgerEntry.Quantity;  //G-ERP.RS 2019-08-20
        if JobLedgerEntry.FindSet() then
            repeat
                if (JobLedgerEntry."Direct Unit Cost (LCY)" <> 0) and
                   (JobLedgerEntry.Quantity <> 0) then
                    LagermaterialIst += JobLedgerEntry."Direct Unit Cost (LCY)" * JobLedgerEntry.Quantity;
            until (JobLedgerEntry.Next() = 0);
        //Arbeitsstd. geleistet ---


        //Arbeitsstunden_EIGEN +++
        Lohnkosten_IST := 0;
        Clear(JobLedgerEntry);
        JobLedgerEntry.SetCurrentkey("Job No.", "Entry Type", Type, "No.");
        case Rec.SumProject of
            true:
                JobLedgerEntry.SetFilter("Job No.", '%1', Rec."No." + '*');
            false:
                JobLedgerEntry.SetRange("Job No.", Rec."No.");
        end;
        JobLedgerEntry.SetRange(Type, JobLedgerEntry.Type::Resource);
        JobLedgerEntry.SetFilter("No.", '2*|3*');
        JobLedgerEntry.CalcSums(Quantity);
        Arbeitsstunden_EIGEN := JobLedgerEntry.Quantity;
        if JobPlanningLine2.Quantity <> 0 then
            Lohnkosten_IST := JobLedgerEntry.Quantity * JobPlanningLine2.Lohnkosten / JobPlanningLine2.Quantity;
        //Arbeitsstunden_EIGEN ---

        //Arbeitsstunden_FREMD +++
        Clear(JobLedgerEntry);
        JobLedgerEntry.SetCurrentkey("Job No.", "Entry Type", Type, "No.");
        case Rec.SumProject of
            true:
                JobLedgerEntry.SetFilter("Job No.", '%1', Rec."No." + '*');
            false:
                JobLedgerEntry.SetRange("Job No.", Rec."No.");
        end;
        JobLedgerEntry.SetRange(Type, JobLedgerEntry.Type::Resource);
        JobLedgerEntry.SetFilter("No.", '9*');
        JobLedgerEntry.CalcSums(Quantity);
        Arbeitsstunden_FREMD := JobLedgerEntry.Quantity;
        //Arbeitsstunden_FREMD ---
        //G-ERP.KBS 2018-05-28 +


        //G-ERP.RS 2019-06-26 +++ "EK-Anfragen"
        Zähler := 0;
        PurchaseLine.SetRange("Document Type", PurchaseLine."document type"::Quote);
        case Rec.SumProject of
            true:
                PurchaseLine.SetFilter("Job No.", '%1', Rec."No." + '*');
            false:
                PurchaseLine.SetRange("Job No.", Rec."No.");
        end;
        if PurchaseLine.FindSet then
            repeat
                PurchaseLine.SetRange("Document No.", PurchaseLine."Document No.");
                PurchaseLine.FindLast();
                PurchaseLine.SetRange("Document No.");
                Zähler += 1;
            until PurchaseLine.Next = 0;
        Rec."EK-Anfragen" := Zähler;
        //G-ERP.RS 2019-06-26 --- "EK-Anfragen"


        //G-ERP.RS 2019-06-26 +++ "EK-Bestellungen"
        Zähler := 0;

        PurchaseHeader.SetRange("Document Type", PurchaseHeader."document type"::Order);
        case Rec.SumProject of
            true:
                PurchaseHeader.SetFilter("Job No.", '%1', Rec."No." + '*');
            false:
                PurchaseHeader.SetRange("Job No.", Rec."No.");
        end;
        if PurchaseHeader.FindSet then
            repeat
                PurchaseHeader.CalcFields("Amt. Rcd. Not Invoiced", "Outstanding Amount");
                if (PurchaseHeader."Amt. Rcd. Not Invoiced" <> 0) or
                   (PurchaseHeader."Outstanding Amount" <> 0) then
                    Zähler += 1;
            until PurchaseHeader.Next = 0;
        Rec."EK-Bestellungen" := Zähler;

        // PurchaseLine.SETRANGE("Document Type",PurchaseLine."Document Type"::Order);
        // CASE SumProject OF
        //  TRUE  : PurchaseLine.SETFILTER("Job No.",'%1',"No."+'*');
        //  FALSE : PurchaseLine.SETRANGE("Job No.","No.");
        // END;
        // IF PurchaseLine.FINDSET THEN
        //  REPEAT
        //    PurchaseLine.SETRANGE("Document No.",PurchaseLine."Document No.");
        //    PurchaseLine.FINDLAST();
        //    PurchaseLine.SETRANGE("Document No.");
        //    Zähler += 1;
        //  UNTIL PurchaseLine.NEXT = 0;
        // "EK-Bestellungen" := Zähler;
        //G-ERP.RS 2019-06-26 --- "EK-Bestellungen"


        //G-ERP.RS 2019-06-26 +++ "EK-Rechnungen"
        Zähler := 0;
        case Rec.SumProject of
            true:
                PurchInvLine.SetFilter("Job No.", '%1', Rec."No." + '*');
            false:
                PurchInvLine.SetRange("Job No.", Rec."No.");
        end;
        if PurchInvLine.FindSet then
            repeat
                PurchInvLine.SetRange("Document No.", PurchInvLine."Document No.");
                PurchInvLine.FindLast();
                PurchInvLine.SetRange("Document No.");
                Zähler += 1;
            until PurchInvLine.Next = 0;
        Rec."EK-Rechnungen" := Zähler;
        //G-ERP.RS 2019-06-26 --- "EK-Rechnungen"


        //G-ERP.RS 2019-06-26 +++ "EK-Gutschrift"
        Zähler := 0;
        case Rec.SumProject of
            true:
                PurchCrMemoLine.SetFilter("Job No.", '%1', Rec."No." + '*');
            false:
                PurchCrMemoLine.SetRange("Job No.", Rec."No.");
        end;
        if PurchCrMemoLine.FindSet then
            repeat
                PurchCrMemoLine.SetRange("Document No.", PurchCrMemoLine."Document No.");
                PurchCrMemoLine.FindLast();
                PurchCrMemoLine.SetRange("Document No.");
                Zähler += 1;
            until PurchCrMemoLine.Next = 0;
        Rec."EK-Gutschrift" := Zähler;
        //G-ERP.RS 2019-06-26 --- "EK-Gutschrift"


        Fremdlief := 0;
        Fremdleist := 0;
        HotelLeist := 0;
        TranspLeist := 0;
        ReiseLeist := 0;
        AuslöseLeist := 0;
        PersonalIst := 0;

        Clear(PurchInvLine);
        case Rec.SumProject of
            true:
                PurchInvLine.SetFilter("Job No.", '%1', Rec."No." + '*');
            false:
                PurchInvLine.SetRange("Job No.", Rec."No.");
        end;
        if PurchInvLine.FindSet then
            repeat
                waehrungsfaktor := 1;
                if l_PurchInvHeader.Get(PurchInvLine."Document No.") then
                    waehrungsfaktor := l_PurchInvHeader."Currency Factor";
                if waehrungsfaktor = 0 then
                    waehrungsfaktor := 1;

                if PurchInvLine.Amount <> 0 then begin
                    if PurchInvLine.Leistungsart = PurchInvLine.Leistungsart::Fremdlieferung then
                        Fremdlief += (PurchInvLine.Amount / waehrungsfaktor);

                    if (PurchInvLine.Leistungsart = PurchInvLine.Leistungsart::Fremdleistung) or
                       //         (PurchInvLine.Leistungsart = PurchInvLine.Leistungsart::Transport) OR
                       //         (PurchInvLine.Leistungsart = PurchInvLine.Leistungsart::Reisekosten) OR
                       //         (PurchInvLine.Leistungsart = PurchInvLine.Leistungsart::Auslöse) OR
                       //         (PurchInvLine.Leistungsart = PurchInvLine.Leistungsart::Hotelkosten) OR
                       //         (PurchInvLine.Leistungsart = PurchInvLine.Leistungsart::Personal) OR
                       (PurchInvLine.Leistungsart = PurchInvLine.Leistungsart::" ") then
                        Fremdleist += (PurchInvLine.Amount / waehrungsfaktor);
                    if PurchInvLine.Leistungsart = PurchInvLine.Leistungsart::Transport then
                        TranspLeist += (PurchInvLine.Amount / waehrungsfaktor);
                    if PurchInvLine.Leistungsart = PurchInvLine.Leistungsart::Flugkosten then
                        ReiseLeist += (PurchInvLine.Amount / waehrungsfaktor);
                    if PurchInvLine.Leistungsart = PurchInvLine.Leistungsart::Auslöse then
                        AuslöseLeist += (PurchInvLine.Amount / waehrungsfaktor);
                    if PurchInvLine.Leistungsart = PurchInvLine.Leistungsart::Hotelkosten then
                        HotelLeist += (PurchInvLine.Amount / waehrungsfaktor);
                    if PurchInvLine.Leistungsart = PurchInvLine.Leistungsart::Personal then
                        PersonalIst += (PurchInvLine.Amount / waehrungsfaktor);
                end;
            until PurchInvLine.Next = 0;

        Clear(PurchCrMemoLine);
        case Rec.SumProject of
            true:
                PurchCrMemoLine.SetFilter("Job No.", '%1', Rec."No." + '*');
            false:
                PurchCrMemoLine.SetRange("Job No.", Rec."No.");
        end;
        if PurchCrMemoLine.FindSet then
            repeat
                waehrungsfaktor := 1;
                if l_PurchCrMemoHdr.Get(PurchCrMemoLine."Document No.") then
                    waehrungsfaktor := l_PurchCrMemoHdr."Currency Factor";
                if waehrungsfaktor = 0 then
                    waehrungsfaktor := 1;

                if PurchCrMemoLine.Amount <> 0 then begin
                    if PurchCrMemoLine.Leistungsart = PurchCrMemoLine.Leistungsart::Fremdlieferung then
                        Fremdlief -= (PurchCrMemoLine.Amount / waehrungsfaktor);
                    if (PurchCrMemoLine.Leistungsart = PurchCrMemoLine.Leistungsart::Fremdleistung) or
                       //         (PurchCrMemoLine.Leistungsart = PurchCrMemoLine.Leistungsart::Transport) OR
                       //         (PurchCrMemoLine.Leistungsart = PurchCrMemoLine.Leistungsart::Reisekosten) OR
                       //         (PurchCrMemoLine.Leistungsart = PurchCrMemoLine.Leistungsart::Auslöse) OR
                       //         (PurchCrMemoLine.Leistungsart = PurchCrMemoLine.Leistungsart::Hotelkosten) OR
                       //         (PurchCrMemoLine.Leistungsart = PurchCrMemoLine.Leistungsart::Personal) OR
                       (PurchCrMemoLine.Leistungsart = PurchCrMemoLine.Leistungsart::" ") then
                        Fremdleist -= (PurchCrMemoLine.Amount / waehrungsfaktor);
                    //      IF (PurchCrMemoLine.Leistungsart = PurchCrMemoLine.Leistungsart::Fremdleistung) then
                    //        Fremdleist -= (PurchCrMemoLine.Amount / waehrungsfaktor);
                    if PurchCrMemoLine.Leistungsart = PurchCrMemoLine.Leistungsart::Transport then
                        TranspLeist -= (PurchCrMemoLine.Amount / waehrungsfaktor);
                    if PurchCrMemoLine.Leistungsart = PurchCrMemoLine.Leistungsart::Flugkosten then
                        ReiseLeist -= (PurchCrMemoLine.Amount / waehrungsfaktor);
                    if PurchCrMemoLine.Leistungsart = PurchCrMemoLine.Leistungsart::Auslöse then
                        AuslöseLeist -= (PurchCrMemoLine.Amount / waehrungsfaktor);
                    if PurchCrMemoLine.Leistungsart = PurchCrMemoLine.Leistungsart::Hotelkosten then
                        HotelLeist -= (PurchCrMemoLine.Amount / waehrungsfaktor);
                    if PurchCrMemoLine.Leistungsart = PurchCrMemoLine.Leistungsart::Personal then
                        PersonalIst -= (PurchCrMemoLine.Amount / waehrungsfaktor);
                end;
            until PurchCrMemoLine.Next = 0;

        //G-ERP.KBS 2018-05-28 +
        Clear(PurchaseLine);
        PurchaseLine.SetRange("Document Type", PurchaseLine."document type"::Order);
        case Rec.SumProject of
            true:
                PurchaseLine.SetFilter("Job No.", '%1', Rec."No." + '*');
            false:
                PurchaseLine.SetRange("Job No.", Rec."No.");
        end;
        if PurchaseLine.FindSet then
            repeat
                waehrungsfaktor := 1;
                if PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.") then
                    waehrungsfaktor := PurchaseHeader."Currency Factor";
                if waehrungsfaktor = 0 then
                    waehrungsfaktor := 1;

                if PurchaseLine."Qty. to Invoice" <> PurchaseLine.Quantity then
                    PurchaseLine."Qty. to Invoice" := PurchaseLine.Quantity - PurchaseLine."Quantity Invoiced";
                PurchaseLine."Outstanding Amount" := ((PurchaseLine."Qty. to Invoice") *
                                PurchaseLine."Direct Unit Cost");

                if PurchaseLine."Outstanding Amount" <> 0 then begin
                    if PurchaseLine.Leistungsart = PurchaseLine.Leistungsart::Fremdlieferung then
                        Fremdlief += (PurchaseLine."Outstanding Amount" / waehrungsfaktor);
                    if (PurchaseLine.Leistungsart = PurchaseLine.Leistungsart::Fremdleistung) or
                       //         (PurchaseLine.Leistungsart = PurchaseLine.Leistungsart::Transport) OR
                       //         (PurchaseLine.Leistungsart = PurchaseLine.Leistungsart::Reisekosten) OR
                       //         (PurchaseLine.Leistungsart = PurchaseLine.Leistungsart::Auslöse) OR
                       //         (PurchaseLine.Leistungsart = PurchaseLine.Leistungsart::Hotelkosten) OR
                       //         (PurchaseLine.Leistungsart = PurchaseLine.Leistungsart::Personal) OR
                       (PurchaseLine.Leistungsart = PurchaseLine.Leistungsart::" ") then
                        Fremdleist += (PurchaseLine."Outstanding Amount" / waehrungsfaktor);
                    if PurchaseLine.Leistungsart = PurchaseLine.Leistungsart::Transport then
                        TranspLeist += (PurchaseLine."Outstanding Amount" / waehrungsfaktor);
                    if PurchaseLine.Leistungsart = PurchaseLine.Leistungsart::Flugkosten then
                        ReiseLeist += (PurchaseLine."Outstanding Amount" / waehrungsfaktor);
                    if PurchaseLine.Leistungsart = PurchaseLine.Leistungsart::Auslöse then
                        AuslöseLeist += (PurchaseLine."Outstanding Amount" / waehrungsfaktor);
                    if PurchaseLine.Leistungsart = PurchaseLine.Leistungsart::Hotelkosten then
                        HotelLeist += (PurchaseLine."Outstanding Amount" / waehrungsfaktor);
                    if PurchaseLine.Leistungsart = PurchaseLine.Leistungsart::Personal then
                        PersonalIst += (PurchaseLine."Outstanding Amount" / waehrungsfaktor);
                end;

            until PurchaseLine.Next = 0;
        //G-ERP.KBS 2018-05-28 -

        // G-ERP.RS 2020-02-24 +++
        LiquidityPlanning_l.Reset();
        case Rec.SumProject of
            true:
                LiquidityPlanning_l.SetFilter("Job No.", '%1', Rec."No." + '*');
            false:
                LiquidityPlanning_l.SetRange("Job No.", Rec."No.");
        end;

        LiquidityPlanning_Invoice := 0;
        LiquidityPlanning_l.SetFilter("Posted Invoice No.", '%1', '');
        if LiquidityPlanning_l.FindSet() then begin
            LiquidityPlanning_l.CalcSums(Amount);
            LiquidityPlanning_Invoice := LiquidityPlanning_l.Amount;
        end;

        LiquidityPlanning_PostedInvoice := 0;
        LiquidityPlanning_l.SetFilter("Posted Invoice No.", '<>%1', '');
        if LiquidityPlanning_l.FindSet() then begin
            LiquidityPlanning_l.CalcSums(Amount);
            LiquidityPlanning_PostedInvoice := LiquidityPlanning_l.Amount;
        end;
        // G-ERP.RS 2020-02-24 ---
    end;

    var
        JobPlanningLine: Record "Job Planning Line";
        JobPlanningLine2: Record "Job Planning Line";
        JobLedgerEntry: Record "Job Ledger Entry";
        PurchaseLine: Record "Purchase Line";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoHdr_temp: Record "Purch. Cr. Memo Hdr." temporary;
        l_PurchInvHeader: Record "Purch. Inv. Header";
        l_PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchaseHeader: Record "Purchase Header";
        AmpelStd: Boolean;
        AmpelEKStd: Boolean;
        AmpelMaterial: Boolean;
        AmpelFremd: Boolean;
        "Zähler": Integer;
        Fremdlief: Decimal;
        Fremdleist: Decimal;
        waehrungsfaktor: Decimal;
        Lohnkosten_IST: Decimal;
        Arbeitsstunden_EIGEN: Decimal;
        Arbeitsstunden_FREMD: Decimal;
        TranspLeist: Decimal;
        HotelLeist: Decimal;
        ReiseLeist: Decimal;
        "AuslöseLeist": Decimal;
        PersonalIst: Decimal;
        ArbeitsstdGeleistet: Decimal;
        LagermaterialIst: Decimal;
        LiquidityPlanning_Invoice: Decimal;
        LiquidityPlanning_PostedInvoice: Decimal;

    local procedure ShowDetails()
    begin
        Page.Run(Page::"Job Card", Rec);
    end;
}

