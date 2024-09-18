PageExtension 50150 JobCardExt extends "Job Card"
{
    Caption = 'Job Card';
    layout
    {
        modify("No.")
        {
            AssistEdit = false;
        }
        modify("Bill-to Customer No.")
        {
            trigger OnBeforeValidate()
            begin
                if NOT ((Rec.Status = Rec.Status::Open) OR (Rec.Status = Rec.Status::Quote)) then
                    Error('Der aktive Status erlaubt keinen Debitorenwechsel.');
            end;
        }
        modify("Sell-to Customer No.")
        {
            trigger OnBeforeValidate()
            begin
                if NOT ((Rec.Status = Rec.Status::Open) OR (Rec.Status = Rec.Status::Quote)) then
                    Error('Der aktive Status erlaubt keinen Debitorenwechsel.');
            end;
        }
        modify("Description")
        {
            ShowMandatory = true;
        }
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
        modify("Starting Date")
        {
            ShowMandatory = true;
        }
        modify("Ending Date")
        {
            ShowMandatory = true;
        }
        modify(Status)
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        addafter("Bill-to Contact")
        {
            fixed(Allgemein)
            {
                Caption = 'Allgemein';
            }
        }
        addbefore("No.")
        {
            field("Job Type"; Rec."Job Type")
            {
                ApplicationArea = Basic;
                Importance = Promoted;
                NotBlank = true;
                ShowMandatory = true;

                trigger OnValidate()
                var
                    NewJobFlag: Boolean;
                    TransferItemsFlag: Boolean;
                    NewJobNo: Code[20];
                    NewJobNoExt: Code[20];
                    OldJobNo: Code[20];
                    Pattern: Text;
                    Regex: Codeunit Regex;
                    ItemJournalLine: Record "Item Journal Line";
                    WarehouseEntry: Record "Warehouse Entry";
                    BinContent: Record "Bin Content";
                    ReservationEntry: Record "Reservation Entry";
                    Item: Record Item;
                    OldBin: Record Bin;
                    NewBin: Record Bin;
                    LineNo: Integer;
                    Qty: Decimal;
                    DictSerialNo: Dictionary of [Code[20], Decimal];
                    SerialNo: Code[20];
                    SubJob: Record Job;
                begin
                    NewJobFlag := false;
                    TransferItemsFlag := false;
                    if Rec."Job Type" <> xRec."Job Type" then begin
                        Pattern := '^[0-9]{2}\-[0-9]{3}\.[0-9]{1}$';
                        if Regex.IsMatch(Rec."No.", Pattern, 0) then begin
                            NewJobNo := Format(Rec."No.").Substring(1, 6);
                            NewJobFlag := true;
                        end else begin
                            Pattern := '^[0-9]{2}\-[0-9]{3}$';
                            if Regex.IsMatch(Rec."No.", Pattern, 0) then begin
                                NewJobNo := Rec."No.";
                                NewJobFlag := true;
                            end;
                        end;

                        if NewJobFlag then
                            NewJobNo += GetJobTypeSuffix(Rec."Job Type");
                        Rec."No." := NewJobNo;

                        if xRec."No." <> '' then begin
                            UpdateJobNotices(xRec."No.", NewJobNo);
                        end;

                        // CHANGE BIN + CONTENT
                        LineNo := 0;

                        BinContent.SetRange("Location Code", 'PROJEKT');
                        BinContent.SetFilter("Bin Code", '%1', xRec."No." + '*');

                        if BinContent.FindSet() then begin
                            // if false then
                            ItemLedgerLineNo := 0;
                            ItemJournalLine.DeleteAll();
                            ReservationEntry.DeleteAll();
                            repeat
                                NewJobNoExt := NewJobNo;
                                if StrLen(NewJobNo) < StrLen(BinContent."Bin Code") then begin
                                    NewJobNoExt += Text.CopyStr(BinContent."Bin Code", StrLen(NewJobNo) + 1)
                                end;
                                if NOT NewBin.Get('PROJEKT', NewJobNoExt) then begin
                                    NewBin.Init();
                                    NewBin.Code := NewJobNoExt;
                                    NewBin."Location Code" := 'PROJEKT';
                                    NewBin.Description := Rec.Description;
                                    NewBin.Insert();
                                end;

                                Clear(Item);
                                if Item.Get(BinContent."Item No.") then begin
                                    Qty := BinContent.CalcQtyUOM();
                                    if Qty > 0 then begin
                                        WarehouseEntry.SetRange("Location Code", 'PROJEKT');
                                        WarehouseEntry.SetRange("Bin Code", BinContent."Bin Code");
                                        WarehouseEntry.SetRange("Item No.", BinContent."Item No.");
                                        WarehouseEntry.SetFilter("Serial No.", '<>%1', '');
                                        if WarehouseEntry.FindSet() then begin
                                            DictSerialNo := CreateEmptyDictionary();
                                            repeat
                                                if NOT DictSerialNo.ContainsKey(WarehouseEntry."Serial No.") then
                                                    DictSerialNo.Add(WarehouseEntry."Serial No.", 0);
                                                DictSerialNo.Set(WarehouseEntry."Serial No.", DictSerialNo.Get(WarehouseEntry."Serial No.") + WarehouseEntry.Quantity);
                                            until WarehouseEntry.Next() = 0;

                                            foreach SerialNo in DictSerialNo.Keys do begin
                                                // Die Reihenfolge muss eingehalten werden. 1. Abgang 2. Neg. Reservierung 3. Zugang 4. Pos. Reservierung
                                                // 1. Abgang 2. Zugang 3. Neg. Reservierung 4. Pos. Reservierung => Fehler
                                                NewItemJournalLine(ItemJournalLine, Item, SerialNo, BinContent."Location Code", BinContent."Bin Code", 1, ItemJournalLine."Entry Type"::"Negative Adjmt.", 'UMLAG');
                                                CreateReservationEntryNegative(ReservationEntry, ItemJournalLine, SerialNo);
                                                NewItemJournalLine(ItemJournalLine, Item, SerialNo, NewBin."Location Code", NewBin.Code, 1, ItemJournalLine."Entry Type"::"Positive Adjmt.", 'UMLAG');
                                                CreateReservationEntryPositive(ReservationEntry, ItemJournalLine, SerialNo);
                                                TransferItemsFlag := true;
                                            end;
                                        end else begin
                                            NewItemJournalLine(ItemJournalLine, Item, '', BinContent."Location Code", BinContent."Bin Code", Qty, ItemJournalLine."Entry Type"::"Negative Adjmt.", 'UMLAG');
                                            NewItemJournalLine(ItemJournalLine, Item, '', NewBin."Location Code", NewBin.Code, Qty, ItemJournalLine."Entry Type"::"Positive Adjmt.", 'UMLAG');
                                            TransferItemsFlag := true;
                                        end;
                                    end;
                                end;
                            until BinContent.Next() = 0;
                            if TransferItemsFlag then
                                CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", ItemJournalLine);
                        end;
                    end;
                    CurrPage.Update();
                end;
            }
        }
        addbefore("Last Date Modified")
        {
            field("Object";
            Rec.Object)
            {
                ApplicationArea = Basic;
                Caption = 'Objekt';
                ShowMandatory = true;
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
        addfirst(navigation)
        {
            action("New Job Customer 1")
            {
                ApplicationArea = All;
                Caption = 'Neue Kopie ohne Debitor';
                Image = Add;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Job: Record Job;
                    JobCard: Page "Job Card";
                    // NoSeriesManagement: Codeunit NoSeriesManagement;
                    NoSeries: Codeunit "No. Series";
                    NewJobNo: Code[20];
                begin
                    NewJobNo := NoSeries.GetNextNo('PROJEKT', Today, true);
                    NewJobNo += GetJobTypeSuffix(Rec."Job Type");

                    Job.Init();
                    Job."No." := NewJobNo;
                    Job."No. Series" := 'PROJEKT';
                    Job.Insert(false);
                    Job.TransferFields(Rec, false);
                    Job."Sell-to Customer No." := '';
                    Job."Sell-to Address" := '';
                    Job."Sell-to Address 2" := '';
                    Job."Sell-to City" := '';
                    Job."Sell-to Contact" := '';
                    Job."Sell-to Contact No." := '';
                    Job."Sell-to Country/Region Code" := '';
                    Job."Sell-to County" := '';
                    Job."Sell-to Customer Name" := '';
                    Job."Sell-to Customer Name 2" := '';
                    Job."Sell-to E-Mail" := '';
                    Job."Sell-to Phone No." := '';
                    Job."Sell-to Post Code" := '';

                    Job."Bill-to Customer No." := '';
                    Job."Bill-to Address" := '';
                    Job."Bill-to Address 2" := '';
                    Job."Bill-to City" := '';
                    Job."Bill-to Contact" := '';
                    Job."Bill-to Contact No." := '';
                    Job."Bill-to Country/Region Code" := '';
                    Job."Bill-to County" := '';
                    Job."Bill-to Name" := '';
                    Job."Bill-to Name 2" := '';
                    Job."Bill-to Post Code" := '';

                    Job."Ship-to Code" := '';
                    Job."Ship-to Address" := '';
                    Job."Ship-to Address 2" := '';
                    Job."ship-to City" := '';
                    Job."Ship-to Contact" := '';
                    Job."Ship-to Country/Region Code" := '';
                    Job."Ship-to County" := '';
                    Job."Ship-to Name" := '';
                    Job."Ship-to Name 2" := '';
                    Job."Ship-to Post Code" := '';

                    Job.Modify();
                    JobCard.SetRecord(Job);
                    JobCard.Run();
                end;
            }
            action("New Job Customer 2")
            {
                ApplicationArea = All;
                Caption = 'Neue Kopie mit Debitor';
                Image = Add;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Job: Record Job;
                    JobCard: Page "Job Card";
                    // NoSeriesManagement: Codeunit NoSeriesManagement;
                    NoSeries: Codeunit "No. Series";
                    NewJobNo: Code[20];
                begin
                    NewJobNo := NoSeries.GetNextNo('PROJEKT', Today, true);
                    case Rec."Job Type" of
                        '10000':
                            NewJobNo += '.1';
                        '20000':
                            NewJobNo += '.2';
                        '30000':
                            NewJobNo += '.3';
                        '40000':
                            NewJobNo += '.4';
                        '50000':
                            NewJobNo += '.5';
                        '60000':
                            NewJobNo += '.6';
                        '70000':
                            NewJobNo += '.7';
                        '80000':
                            NewJobNo += '.8';
                        '90000':
                            NewJobNo += '.9';
                    end;

                    Job.Init();
                    Job."No." := NewJobNo;
                    Job."No. Series" := 'PROJEKT';
                    Job.Insert(false);
                    Job.TransferFields(Rec, false);
                    Job."Anfrage am" := 0D;
                    Job."Anfrage per" := '';
                    Job."Anfrage von" := '';
                    job."Angebotsabgabe bis" := 0D;
                    Job."Angebotsabgabe durch" := '';
                    Job.Modify();
                    JobCard.SetRecord(Job);
                    JobCard.Run();
                end;
            }
        }

        addbefore("Ledger E&ntries")
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
                        Rec."Prev. Status" := Rec.Status;
                        Rec."Status Modify Date" := Today;
                        Rec.Status := Rec.Status::Quote;
                        Rec.Modify();
                        exit;
                    end;

                    if Rec.Status = Rec.Status::Quote then begin
                        Rec."Prev. Status" := Rec.Status;
                        Rec."Status Modify Date" := Today;
                        Rec.Status := Rec.Status::Planning;
                        Rec.Modify();
                        exit;
                    end;

                    if Rec.Status = Rec.Status::Planning then begin
                        Rec."Prev. Status" := Rec.Status;
                        Rec."Status Modify Date" := Today;
                        Rec.Status := Rec.Status::Invoiced;
                        Rec.Modify();
                        exit;
                    end;

                    if Rec.Status = Rec.Status::Completed then begin
                        Rec."Prev. Status" := Rec.Status;
                        Rec."Status Modify Date" := Today;
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
                        Rec."Prev. Status" := Rec.Status;
                        Rec."Status Modify Date" := Today;
                        Rec.Status := Rec.Status::Quote;
                        Rec.Modify();
                        exit;
                    end;

                    if Rec.Status = Rec.Status::"Gewährleistung" then begin
                        Rec."Prev. Status" := Rec.Status;
                        Rec."Status Modify Date" := Today;
                        Rec.Status := Rec.Status::Planning;
                        Rec.Modify();
                        exit;
                    end;

                    if Rec.Status = Rec.Status::Invoiced then begin
                        Rec."Prev. Status" := Rec.Status;
                        Rec."Status Modify Date" := Today;
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
                    Rec."Prev. Status" := Rec.Status;
                    Rec."Status Modify Date" := Today;
                    Rec.Status := Rec.Status::Cancelled;
                    Rec.Modify();
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
                    Rec."Prev. Status" := Rec.Status;
                    Rec."Status Modify Date" := Today;
                    Rec.Status := Rec.Status::Completed;
                    Rec.Modify();
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
                    Rec."Prev. Status" := Rec.Status;
                    Rec."Status Modify Date" := Today;
                    Rec.Status := Rec.Status::"Gewährleistung";
                    Rec.Modify();
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
                    JobCard: Page "Job Card";
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
                        l_Job2.Description := Rec.Description;
                        l_Job2."Contact Person Name" := Rec."Contact Person Name";
                        l_Job2."Contact Person No." := Rec."Contact Person No.";
                        l_Job2."Your Reference" := Rec."Your Reference";
                        l_Job2."Person Responsible" := Rec."Person Responsible";
                        l_Job2.Verfasser := Rec.Verfasser;
                        l_Job2.Reparaturort := Rec.Reparaturort;
                        l_Job2."Anfrage per" := Rec."Anfrage per";
                        l_Job2."Anfrage von" := Rec."Anfrage von";
                        l_Job2."Anfrage am" := Rec."Anfrage am";
                        l_Job2."Angebotsabgabe bis" := Rec."Angebotsabgabe bis";
                        l_Job2."Angebotsabgabe durch" := Rec."Angebotsabgabe durch";
                        l_Job2."Starting Date" := Rec."Starting Date";
                        l_Job2."Ending Date" := Rec."Ending Date";
                        l_Job2.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
                        l_Job2."Sell-to Contact No." := Rec."Sell-to Contact No.";
                        l_Job2."Job Type" := Rec."Job Type";
                        l_Job2.Status := Rec.Status;
                        l_Job2.Object := Rec.Object;
                        l_Job2.Objektname := Rec.Objektname;
                        l_Job2."Ship Owner" := Rec."Ship Owner";
                        l_Job2."Ship Owner Bearbeiter" := Rec."Ship Owner Bearbeiter";

                        // l_Job2.Status := l_Job2.Status::Order;
                        l_Job2.Subproject := true;        //G-ERP.RS 2019-01-24
                        l_Job2.MainProjektNo := Rec."No.";    //G-ERP.RS 2019-01-24
                        l_Job2."Folder Created" := false; //G-ERP.RS 2019-01-24
                        l_Job2.Insert;

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
                        l_Job2."Bill-to Customer No." := Rec."Bill-to Customer No.";
                        l_Job2."Bill-to Name" := Rec."Bill-to Name";
                        l_Job2."Bill-to Name 2" := Rec."Bill-to Name 2";
                        l_Job2."Bill-to Address" := Rec."Bill-to Address";
                        l_Job2."Bill-to Address 2" := Rec."Bill-to Address 2";
                        l_Job2."Bill-to City" := Rec."Bill-to City";
                        l_Job2."Bill-to County" := Rec."Bill-to County";
                        l_Job2."Bill-to Post Code" := Rec."Bill-to Post Code";
                        l_Job2."Bill-to Country/Region Code" := l_Job2."Bill-to Country/Region Code";
                        l_Job2."Bill-to Contact No." := Rec."Bill-to Contact No.";
                        l_Job2."Bill-to Contact" := Rec."Bill-to Contact";

                        l_Job2."Ship-to Code" := Rec."Ship-to Code";
                        l_Job2."Ship-to Name" := Rec."Ship-to Name";
                        l_Job2."Ship-to Name 2" := Rec."Ship-to Name 2";
                        l_Job2."Ship-to Address" := Rec."Ship-to Address";
                        l_Job2."Ship-to Address 2" := Rec."Ship-to Address 2";
                        l_Job2."Ship-to City" := Rec."Ship-to City";
                        l_Job2."Ship-to County" := Rec."Ship-to County";
                        l_Job2."Ship-to Post Code" := Rec."Ship-to Post Code";
                        l_Job2."Ship-to Country/Region Code" := l_Job2."Ship-to Country/Region Code";
                        l_Job2."Ship-to Contact" := Rec."Ship-to Contact";

                        l_Job2."Payment Method Code" := Rec."Payment Method Code";
                        l_Job2."Payment Terms Code" := Rec."Payment Terms Code";

                        l_Job2.Validate(Status, l_Job2.Status::Open);
                        l_Job2.Modify(true); //G-ERP.RS 2019-01-24

                        Jobcard.SetRecord(l_Job2);
                        JobCard.Run();
                        // Message('Es wurde Unterauftrag %1 angelegt!', l_Job2."No.");
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
            action(CustomerChange)
            {
                ApplicationArea = Basic;
                Caption = 'Debitorenwechsel';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CustomerChangeDlg: Page "Job Customer Change Dlg";
                    Customer: Record Customer;
                begin
                    if NOT ((Rec.Status = Rec.Status::Open) OR (Rec.Status = Rec.Status::Quote)) then
                        Error('Der aktive Status erlaubt keinen Debitorenwechsel.');

                    CustomerChangeDlg.SetCustomerNo(Rec."Sell-to Customer No.");
                    if CustomerChangeDlg.RunModal() = Action::OK then begin
                        if Customer.Get(CustomerChangeDlg.GetCustomerNo()) then begin
                            Rec.Validate("Sell-to Customer No.", Customer."No.");
                            Rec.Validate("Bill-to Customer No.", Customer."No.");
                        end;
                    end;
                end;
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
        ItemLedgerLineNo: Integer;

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


    local procedure NextEntryNo(): Integer
    var
        LastEntryNo: Integer;
        ReservationEntry: Record "Reservation Entry";
    begin
        LastEntryNo := 0;
        ReservationEntry.Reset();
        if ReservationEntry.FindLast() then
            LastEntryNo := ReservationEntry."Entry No.";
        exit(LastEntryNo + 1);
    end;

    local procedure CreateEmptyDictionary() Result: Dictionary of [Code[20], Decimal]
    begin
        exit(Result);
    end;

    local procedure GetJobTypeSuffix(JobType_L: Code[20]) JobTypeSuffix: Code[4]
    begin
        JobTypeSuffix := '';
        case "JobType_L" of
            '10000':
                JobTypeSuffix += '.1';
            '20000':
                JobTypeSuffix += '.2';
            '30000':
                JobTypeSuffix += '.3';
            '40000':
                JobTypeSuffix += '.4';
            '50000':
                JobTypeSuffix += '.5';
            '60000':
                JobTypeSuffix += '.6';
            '70000':
                JobTypeSuffix += '.7';
            '80000':
                JobTypeSuffix += '.8';
            '90000':
                JobTypeSuffix += '.9';
        end;
        Exit(JobTypeSuffix);
    end;

    local procedure UpdateJobNotices(OldJobNo: Code[20]; NewJobNo: Code[20])
    var
        JobNotice: Record "Projekt-Notizen";
        JobNoticeNew: Record "Projekt-Notizen";
    begin
        Clear(JobNoticeNew);
        if JobNotice.Get(NewJobNo) then begin
            Exit;
        end;
        if JobNotice.Get(OldJobNo) then begin
            JobNoticeNew.Init();
            JobNoticeNew."Job No." := NewJobNo;
            JobNoticeNew.Insert(true);
            JobNoticeNew."Anfrage über1" := JobNotice."Anfrage über1";
            JobNoticeNew."Anfrage über2" := JobNotice."Anfrage über2";
            JobNoticeNew."Anfrage über3" := JobNotice."Anfrage über3";
            JobNoticeNew.Montagegruppe1 := JobNotice.Montagegruppe1;
            JobNoticeNew.Montagegruppe2 := JobNotice.Montagegruppe2;
            JobNoticeNew.Montagegruppe3 := JobNotice.Montagegruppe3;
            JobNoticeNew."Zu beachten1" := JobNotice."Zu beachten1";
            JobNoticeNew."Zu beachten2" := JobNotice."Zu beachten2";
            JobNoticeNew."Zu beachten3" := JobNotice."Zu beachten3";
            JobNoticeNew.Modify();
        end;
    end;

    procedure NewItemJournalLine(var ItemJournalLine: Record "Item Journal Line"; Item: Record Item; SerialNo: Code[50]; Location: Code[20]; Bin: Code[20]; Qty: Decimal; EntryType: Enum "Item Journal Entry Type"; DocumentNo: Code[20])
    var
        ItemJournalLine_Tmp: Record "Item Journal Line";
    begin
        ItemLedgerLineNo += 10000;
        ItemJournalLine.Init();
        ItemJournalLine.Validate("Journal Template Name", 'ARTIKEL');
        ItemJournalLine.Validate("Journal Batch Name", 'PROJEKT');
        ItemJournalLine."Line No." := ItemLedgerLineNo;
        ItemJournalLine.Insert(true);
        ItemJournalLine.Validate("Item No.", Item."No.");
        ItemJournalLine.Validate("Serial No.", SerialNo);
        ItemJournalLine.Validate("Posting Date", Today());
        ItemJournalLine.Validate("Entry Type", EntryType);
        ItemJournalLine.Validate("Document No.", DocumentNo);
        ItemJournalLine.Validate(Description, Item.Description);
        ItemJournalLine.Validate("Source Code", 'LAGPLUMLAG');
        ItemJournalLine.Validate("Gen. Prod. Posting Group", Item."Gen. Prod. Posting Group");
        ItemJournalLine.Validate("Document Date", Today());
        ItemJournalLine.Validate("Location Code", Location);
        ItemJournalLine.Validate("Bin Code", Bin);
        ItemJournalLine.Validate(Quantity, Qty);
        ItemJournalLine.Validate("Flushing Method", ItemJournalLine."Flushing Method"::Manual);
        ItemJournalLine.Validate("Value Entry Type", ItemJournalLine."Value Entry Type"::"Direct Cost");
        ItemJournalLine.Validate("Unit Cost Calculation", ItemJournalLine."Unit Cost Calculation"::Time);
        ItemJournalLine.Modify();
    end;

    procedure CreateReservationEntryNegative(var ReservationEntry: Record "Reservation Entry"; var NewItemJnlLine: Record "Item Journal Line"; SerialNo: Code[50])
    begin
        ReservationEntry.Init();
        ReservationEntry."Entry No." := NextEntryNo;
        ReservationEntry."Item No." := NewItemJnlLine."Item No.";
        ReservationEntry.Description := NewItemJnlLine.Description;
        ReservationEntry."Location Code" := NewItemJnlLine."Location Code";
        ReservationEntry."Variant Code" := NewItemJnlLine."Variant Code";
        ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Prospect;
        ReservationEntry."Source Type" := Database::"Item Journal Line";
        // SUBTYPE = 3 für ABGANG!!!  SUBTYPPE = 2 für ZUGANG
        ReservationEntry."Source Subtype" := ReservationEntry."Source Subtype"::"3";
        ReservationEntry."Source Batch Name" := NewItemJnlLine."Journal Batch Name";
        ReservationEntry."Source ID" := NewItemJnlLine."Journal Template Name";
        ReservationEntry."Source Ref. No." := NewItemJnlLine."Line No.";
        ReservationEntry."Serial No." := SerialNo;
        ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Serial No.";
        ReservationEntry."Created By" := UserId;
        ReservationEntry.Positive := false;
        ReservationEntry.Quantity := -1;
        ReservationEntry."Qty. per Unit of Measure" := 1;
        ReservationEntry."Quantity (Base)" := -1;
        ReservationEntry."Qty. to Handle (Base)" := -1;
        ReservationEntry."Qty. to Invoice (Base)" := -1;
        ReservationEntry."Quantity Invoiced (Base)" := 0;

        ReservationEntry."Creation Date" := Today();
        ReservationEntry."Expiration Date" := Today();
        ReservationEntry.Insert();
    end;

    procedure CreateReservationEntryPositive(var ReservationEntry: Record "Reservation Entry"; var NewItemJnlLine: Record "Item Journal Line"; SerialNo: Code[50])
    begin
        ReservationEntry.Init();
        ReservationEntry."Entry No." := NextEntryNo;
        ReservationEntry."Item No." := NewItemJnlLine."Item No.";
        ReservationEntry.Description := NewItemJnlLine.Description;
        ReservationEntry."Location Code" := NewItemJnlLine."Location Code";
        ReservationEntry."Variant Code" := NewItemJnlLine."Variant Code";
        ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Prospect;
        ReservationEntry."Source Type" := Database::"Item Journal Line";
        // SUBTYPE = 3 für ABGANG!!!  SUBTYPPE = 2 für ZUGANG
        ReservationEntry."Source Subtype" := ReservationEntry."Source Subtype"::"2";
        ReservationEntry."Source Batch Name" := NewItemJnlLine."Journal Batch Name";
        ReservationEntry."Source ID" := NewItemJnlLine."Journal Template Name";
        ReservationEntry."Source Ref. No." := NewItemJnlLine."Line No.";
        ReservationEntry."Serial No." := SerialNo;
        ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Serial No.";
        ReservationEntry."Created By" := UserId;
        ReservationEntry.Positive := true;
        ReservationEntry.Quantity := 1;
        ReservationEntry."Qty. per Unit of Measure" := 1;
        ReservationEntry."Quantity (Base)" := 1;
        ReservationEntry."Qty. to Handle (Base)" := 1;
        ReservationEntry."Qty. to Invoice (Base)" := 1;
        ReservationEntry."Quantity Invoiced (Base)" := 0;

        ReservationEntry."Creation Date" := Today();
        ReservationEntry."Expiration Date" := Today();
        ReservationEntry.Insert();
    end;
}