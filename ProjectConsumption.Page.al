Page 50039 "Project Consumption"
{
    // ***************************************************************
    // *                 Gerwing-ERP Software GmbH                   *
    // ***************************************************************
    // 
    // Nummer  Datum       Benutzer      Gruppe      Ticket  Bemerkung
    // 01      2021-02-02  Stalljann     Erstellung  239310  Erstellung der Page.
    //                                                       Diese Page ist da um Bestände die auf den Projekten gebucht wurden, wieder auszubuchen.
    // 02      2021-02-04  Stalljann     Anpassung   239310  Hinzufügen eines weiteren Feldes für die korrekte Filterung auf Lagerplatz.
    // 03      2021-03-09  Stalljann     Anpassung   239310  Direkte Kosten (Neuste) und Verkaufspreis Anpassung in Artikelkarte speichern.
    // 04      2021-03-09  Stalljann     Anpassung   239310  Anpassung zum Buchen mit Mitarbeiter
    // 05      2021-03-11  Stalljann     Anpassung   239310  Anpassung das "Verkaufspreis Änderung" und "Direkte Kosten (Neuste)" am Ende vom Buchen, in die Artikelkarte übertragen werden.
    // 06      2021-03-30  Stalljann     Anpassung           Telefonisch mit Herrn Habsch eine die Anpassung besprochen, das der VK-Preis = dem VK-Preis Projekt sein soll beim laden des Projektes.
    //                                                       Außerdem soll auch, wenn der VK-Preis geändert wird, der VK-Preis Projekt angepasst werden.
    // 07      2021-09-29  Stalljann     Bugfix      2312176 Anpassung dass das buchen vor dem ändern des Preises ausgeführt wird.
    // 08      2021-09-29  Stalljann     Anpassung   2312176 Anpassung das Direkte Kosten (Neuste) das Feld Verkaufspreis Projekt füllt.
    // 09      2021-09-29  Stalljann     Anpassung           Anpassung wenn der Lagerortcode nicht gefüllt ist, wird die Projekt Nummer als Lagerortcode beim buchen benutzt.
    // 
    // AC01    20210405    DAP                               Wenn Direkte Kosten (neuste) = 0, dann VK-Preis buchen.

    Caption = 'Projekt Verbrauch';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Project Consumption";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Allgemein';
                field(JobNo; BinCode_g)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lagerplatz';
                    TableRelation = Bin.Code;

                    trigger OnValidate()
                    var
                        Job_l: Record Job;
                        Bin_l: Record Bin;
                        InventorySetup_l: Record "Inventory Setup";
                    begin
                        //G-ERP.RS 2021-02-04 + 02
                        InventorySetup_l.Get();
                        if Bin_l.Get(InventorySetup_l."Project Location", BinCode_g) then begin
                            //  BinCode_g := ProjectNo_g;
                            ProjectNo_g := Bin_l.Code;
                            Rec.SetRange("Job No.", ProjectNo_g);
                            //  SETRANGE("Bin Code");
                            Rec.SetRange("Bin Code", BinCode_g);
                            CurrPage.Update();
                        end;
                        //G-ERP.RS 2021-02-04 - 02

                        //G-ERP.RS 2021-02-04 + 02
                        /*
                        // IF Job_l.GET(ProjectNo_g) THEN
                          SETRANGE("Job No.",ProjectNo_g);
                        
                        CurrPage.UPDATE();
                        */
                        //G-ERP.RS 2021-02-04 - 02

                    end;
                }
                field(BinCode; ProjectNo_g)
                {
                    ApplicationArea = Basic;
                    Caption = 'Projekt Nr.';
                    TableRelation = Job;

                    trigger OnAssistEdit()
                    var
                        InventorySetup_l: Record "Inventory Setup";
                        Bin_l: Record Bin;
                    begin
                        InventorySetup_l.Get();
                        InventorySetup_l.TestField("Project Location");

                        Clear(Bin_l);
                        Bin_l.SetRange("Location Code", InventorySetup_l."Project Location");
                        if Page.RunModal(0, Bin_l) = Action::LookupOK then
                            BinCode_g := Bin_l.Code;
                    end;

                    trigger OnValidate()
                    begin
                        //G-ERP.RS 2021-02-04 + 02
                        //SETRANGE("Bin Code",BinCode_g);
                        //CurrPage.UPDATE();
                        //MESSAGE('%1',GETFILTERS);
                        //G-ERP.RS 2021-02-04 - 02
                        Rec.SetRange("Job No.", ProjectNo_g);
                        Rec.SetRange("Bin Code", BinCode_g);
                        //SETRANGE("Bin Code");
                        //  SETRANGE("Bin Code",BinCode_g);
                        CurrPage.Update();
                    end;
                }
            }
            repeater(Group)
            {
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Item TT Type"; Rec."Item TT Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Item Description 2"; Rec."Item Description 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field("Last Direct Cost"; Rec."Last Direct Cost")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        Rec."Selling Price Project" := Rec."Last Direct Cost"; //G-ERP.RS 2021-09-29 08
                    end;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Price';

                    trigger OnValidate()
                    begin
                        //G-ERP.RS 2021-09-29 08 "Selling Price Project" := "Unit Price";  //G-ERP.RS 2021-03-30 06
                    end;
                }
                field("Selling Price Project"; Rec."Selling Price Project")
                {
                    ApplicationArea = Basic;
                }
                field(Employee; Rec.Employee)
                {
                    ApplicationArea = Basic;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field("Post Out"; Rec."Post Out")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(LoadProject)
            {
                ApplicationArea = Basic;
                Caption = 'Projekt laden';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    InventorySetup_l: Record "Inventory Setup";
                    WarehouseEntry_l: Record "Warehouse Entry";
                    Item_l: Record Item;
                    ProjectConsumption_l: Record "Project Consumption";
                    ItemLedgerEntry_l: Record "Item Ledger Entry";
                    ValueEntry_l: Record "Value Entry";
                    EntryNo_l: Integer;
                begin
                    InventorySetup_l.Get();
                    InventorySetup_l.TestField("Project Location");

                    if ProjectNo_g = '' then
                        Error(ERR_NoProjectNo);

                    EntryNo_l := 1;

                    Clear(ProjectConsumption_l);
                    ProjectConsumption_l.SetRange("Job No.", ProjectNo_g);
                    //ProjectConsumption_l.SETRANGE("Bin Code",BinCode_g);
                    ProjectConsumption_l.DeleteAll();
                    //CLEAR(ProjectConsumption_l);

                    WarehouseEntry_l.SetCurrentkey("Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.", "Entry Type", Dedicated);
                    WarehouseEntry_l.Ascending();
                    WarehouseEntry_l.SetRange("Location Code", InventorySetup_l."Project Location");
                    WarehouseEntry_l.SetRange("Bin Code", BinCode_g);
                    //WarehouseEntry_l.SETRANGE("Job No.",ProjectNo_g);
                    if WarehouseEntry_l.FindSet() then begin
                        repeat

                            WarehouseEntry_l.SetRange("Item No.", WarehouseEntry_l."Item No.");
                            WarehouseEntry_l.SetRange("Serial No.", WarehouseEntry_l."Serial No.");
                            WarehouseEntry_l.SetRange("Lot No.", WarehouseEntry_l."Lot No.");
                            WarehouseEntry_l.FindLast();
                            WarehouseEntry_l.CalcSums(Quantity);
                            if WarehouseEntry_l.Quantity <> 0 then begin
                                Item_l.Get(WarehouseEntry_l."Item No.");
                                Item_l.SetRange("Location Filter", 'WHV');
                                Item_l.CalcFields(Inventory, "Inventory complete");
                                ProjectConsumption_l.Init();
                                ProjectConsumption_l."Job No." := ProjectNo_g;
                                ProjectConsumption_l."Entry No." := EntryNo_l;
                                ProjectConsumption_l."Bin Code" := BinCode_g;   //G-ERP.RS 2021-02-04 02
                                ProjectConsumption_l."Item No." := Item_l."No.";

                                ProjectConsumption_l."Item Description" := WarehouseEntry_l.Description;
                                if ProjectConsumption_l."Item Description" = '' then
                                    ProjectConsumption_l."Item Description" := Item_l.Description;

                                ProjectConsumption_l."Item Description 2" := WarehouseEntry_l."Description 2";
                                if ProjectConsumption_l."Item Description 2" = '' then
                                    ProjectConsumption_l."Item Description 2" := Item_l."Description 2";

                                ProjectConsumption_l.Stock := Item_l.Inventory;
                                ProjectConsumption_l."Serial No." := WarehouseEntry_l."Serial No.";
                                ProjectConsumption_l."Lot No." := WarehouseEntry_l."Lot No.";
                                ProjectConsumption_l.Quantity := WarehouseEntry_l.Quantity;
                                ProjectConsumption_l."Unit of Measure" := WarehouseEntry_l."Unit of Measure Code"; //G-EPR.RS 2021-05-21

                                //G-ERP.RS 2021-09-29 +
                                Clear(ItemLedgerEntry_l);
                                ItemLedgerEntry_l.SetRange("Item No.", Item_l."No.");
                                ItemLedgerEntry_l.SetFilter("Entry Type", '%1|%2', ItemLedgerEntry_l."entry type"::Purchase
                                                                                , ItemLedgerEntry_l."entry type"::"Positive Adjmt.");
                                ItemLedgerEntry_l.SetRange("Lot No.", ProjectConsumption_l."Lot No.");
                                ItemLedgerEntry_l.SetRange("Serial No.", ProjectConsumption_l."Serial No.");
                                ItemLedgerEntry_l.SetRange(Open, true);
                                if ItemLedgerEntry_l.FindSet() then begin
                                    ValueEntry_l.SetRange("Item Ledger Entry No.", ItemLedgerEntry_l."Entry No.");
                                    if ValueEntry_l.FindSet() then begin
                                        ProjectConsumption_l."Last Direct Cost" := ValueEntry_l."Cost per Unit";
                                    end;
                                end;
                                //G-ERP.RS 2021-09-29 -

                                ProjectConsumption_l."Post Out" := false;

                                //G-ERP.RS 2021-02-04 + 02
                                case Item_l."TT Type" of
                                    Item_l."tt type"::Material:
                                        ProjectConsumption_l."Item TT Type" := Item_l."tt type"::Material;
                                    Item_l."tt type"::Werkzeug:
                                        ProjectConsumption_l."Item TT Type" := Item_l."tt type"::Werkzeug;
                                    else
                                        Error(ERR_ItemTtTypeNotFound, Item_l."TT Type", ProjectConsumption_l.TableCaption);
                                end;
                                //G-ERP.RS 2021-02-04 - 02
                                ProjectConsumption_l."Last Direct Cost" := Item_l."Last Direct Cost";
                                ProjectConsumption_l."Unit Price" := Item_l."Unit Price";
                                //G-ERP.RS 2021-09-29 +
                                //ProjectConsumption_l."Selling Price Project" := Item_l."Unit Price"; //G-ERP.RS 2021-03-30 06
                                ProjectConsumption_l."Selling Price Project" := Item_l."Last Direct Cost";
                                //G-ERP.RS 2021-09-10 -

                                //G-ERP.RS 2021-03-09 + 04
                                ProjectConsumption_l.Employee := WarehouseEntry_l.Employee;
                                ProjectConsumption_l."Employee No." := WarehouseEntry_l."Employee No.";
                                //G-ERP.RS 2021-03-09 - 04

                                ProjectConsumption_l.Insert();
                                EntryNo_l += 1;
                            end;

                            WarehouseEntry_l.SetRange("Item No.");
                            WarehouseEntry_l.SetRange("Serial No.");
                            WarehouseEntry_l.SetRange("Lot No.");

                        until (WarehouseEntry_l.Next() = 0);
                    end;
                end;
            }
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Buchen';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    JobJournalLine_l: Record "Job Journal Line";
                    ProjectConsumption_l: Record "Project Consumption";
                    InventorySetup_l: Record "Inventory Setup";
                    ReservationEntry_l: Record "Reservation Entry";
                    Item_l: Record Item;
                    LineNo_l: Integer;
                    EntryNo_l: Integer;
                begin
                    InventorySetup_l.Get();
                    InventorySetup_l.TestField("Project Location");

                    Clear(ProjectConsumption_l);
                    ProjectConsumption_l.CopyFilters(Rec);
                    ProjectConsumption_l.SetRange("Post Out", true);
                    if ProjectConsumption_l.FindSet() then begin
                        Clear(JobJournalLine_l);
                        JobJournalLine_l.SetRange("Journal Template Name", 'PROJEKT');
                        JobJournalLine_l.SetRange("Journal Batch Name", 'STANDARD');
                        if JobJournalLine_l.FindLast() then
                            JobJournalLine_l.DeleteAll;
                        Clear(ReservationEntry_l);
                        ReservationEntry_l.SetRange("Source ID", 'PROJEKT');
                        ReservationEntry_l.SetRange("Source Batch Name", 'STANDARD');
                        if ReservationEntry_l.FindLast() then
                            ReservationEntry_l.DeleteAll;

                        LineNo_l := 10000;
                        Clear(JobJournalLine_l);
                        JobJournalLine_l.SetRange("Journal Template Name", 'PROJEKT');
                        JobJournalLine_l.SetRange("Journal Batch Name", 'STANDARD');
                        if JobJournalLine_l.FindLast() then
                            LineNo_l := JobJournalLine_l."Line No.";
                        repeat
                            Clear(JobJournalLine_l);
                            JobJournalLine_l.Init();
                            JobJournalLine_l.Validate("Journal Template Name", 'PROJEKT');
                            JobJournalLine_l.Validate("Journal Batch Name", 'STANDARD');
                            JobJournalLine_l.Validate("Line No.", LineNo_l);
                            JobJournalLine_l.Validate("Posting Date", WorkDate);
                            JobJournalLine_l.Validate("Document Date", Today);
                            JobJournalLine_l.Validate("Document No.", 'Projekt Verbrauch');
                            JobJournalLine_l.Validate("Job No.", ProjectConsumption_l."Job No.");
                            JobJournalLine_l.Validate(Type, JobJournalLine_l.Type::Item);
                            JobJournalLine_l.Validate("No.", ProjectConsumption_l."Item No.");
                            JobJournalLine_l.Validate("Location Code", InventorySetup_l."Project Location");
                            //G-ERP.RS 2021-03-09 +
                            //G-ERP.RS 2021-09-29 + 09
                            if JobJournalLine_l."Bin Code" <> '' then
                                JobJournalLine_l.Validate("Bin Code", ProjectConsumption_l."Bin Code")
                            else
                                JobJournalLine_l.Validate("Bin Code", ProjectConsumption_l."Job No.");
                            //JobJournalLine_l.VALIDATE("Bin Code"             , ProjectConsumption_l."Bin Code");
                            //G-ERP.RS 2021-09-29 - 09
                            //JobJournalLine_l.VALIDATE("Bin Code"             , ProjectConsumption_l."Job No.");
                            //G-ERP.RS 2021-03-09 -
                            JobJournalLine_l.Validate("Unit of Measure Code", ProjectConsumption_l."Unit of Measure");  //G-ERP.RS 2021-09-29
                            JobJournalLine_l.Validate(Quantity, ProjectConsumption_l.Quantity);
                            // AC01 B
                            //G-ERP.RS 2021-03-09 + 03
                            if ProjectConsumption_l."Last Direct Cost" <> 0 then
                                JobJournalLine_l.Validate("Unit Cost", ProjectConsumption_l."Last Direct Cost")
                            else
                                JobJournalLine_l.Validate("Unit Cost", ProjectConsumption_l."Selling Price Project");
                            // AC01 E
                            JobJournalLine_l.Validate("Unit Price", ProjectConsumption_l."Selling Price Project");
                            //G-ERP.RS 2021-03-09 - 03
                            //G-ERP.RS 2021-03-09 + 04
                            JobJournalLine_l.Validate("Mitarbeiter Nr", ProjectConsumption_l."Employee No.");
                            //G-ERP.RS 2021-03-09 - 04

                            JobJournalLine_l.Insert(true);
                            LineNo_l += 10000;

                            Clear(ReservationEntry_l);
                            if ReservationEntry_l.FindLast() then
                                EntryNo_l := ReservationEntry_l."Entry No.";

                            EntryNo_l += 1;
                            Clear(ReservationEntry_l);
                            ReservationEntry_l.Init();
                            ReservationEntry_l.Validate("Entry No.", EntryNo_l);
                            ReservationEntry_l.Validate("Creation Date", Today);
                            ReservationEntry_l.Validate("Created By", UserId);
                            ReservationEntry_l.Validate("Reservation Status", ReservationEntry_l."reservation status"::Prospect);
                            ReservationEntry_l.Validate("Source Type", 210);
                            ReservationEntry_l.Validate("Source ID", JobJournalLine_l."Journal Template Name");
                            ReservationEntry_l.Validate("Source Batch Name", JobJournalLine_l."Journal Batch Name");
                            ReservationEntry_l.Validate("Source Ref. No.", JobJournalLine_l."Line No.");
                            ReservationEntry_l.Validate("Location Code", JobJournalLine_l."Location Code");
                            ReservationEntry_l.Validate("Shipment Date", Today);
                            ReservationEntry_l.Validate("Item No.", JobJournalLine_l."No.");

                            //G-ERP.RS 2021-03-01 +
                            /*
                        //    IF ProjectConsumption_l."Lot No." <> '' THEN BEGIN
                              //ReservationEntry_l.VALIDATE("Lot No.", ProjectConsumption_l."Lot No.");
                              ReservationEntry_l.VALIDATE("Item Tracking",ReservationEntry_l."Item Tracking"::"Lot No.");
                              ReservationEntry_l.VALIDATE("Lot No.", 'DE4711');
                        //    END;
                            */
                            if ProjectConsumption_l."Lot No." <> '' then begin
                                ReservationEntry_l.Validate("Lot No.", ProjectConsumption_l."Lot No.");
                                ReservationEntry_l.Validate("Item Tracking", ReservationEntry_l."item tracking"::"Lot No.");
                            end;
                            //G-ERP.RS 2021-03-01 -



                            if ProjectConsumption_l."Serial No." <> '' then begin
                                ReservationEntry_l.Validate("Item Tracking", ReservationEntry_l."item tracking"::"Serial No.");
                                ReservationEntry_l.Validate("Serial No.", ProjectConsumption_l."Serial No.");
                            end;

                            ReservationEntry_l.Validate("Quantity (Base)", (JobJournalLine_l."Quantity (Base)" * -1));
                            ReservationEntry_l.Insert(true);

                        //G-ERP.RS 2021-03-11 + 05
                        /*
                        //G-ERP.RS 2021-03-09 + 03
                        IF Item_l.GET(ProjectConsumption_l."Item No.") THEN BEGIN
                          Item_l."Unit Price"       := ProjectConsumption_l."Unit Price";
                          Item_l."Last Direct Cost" := ProjectConsumption_l."Last Direct Cost";
                          Item_l.MODIFY(TRUE);
                        END;
                        //G-ERP.RS 2021-03-09 - 03
                        */
                        //G-ERP.RS 2021-03-11 + 05

                        until (ProjectConsumption_l.Next() = 0);
                    end;

                    // CODEUNIT.RUN(CODEUNIT::"Job Jnl.-Post",JobJournalLine_l);
                    Codeunit.Run(Codeunit::"Job Jnl.-Post+Print", JobJournalLine_l); //G-ERP.RS 2021-09-29 07

                    //G-ERP.RS 2021-03-11 + 05
                    Clear(ProjectConsumption_l);
                    ProjectConsumption_l.CopyFilters(Rec);
                    ProjectConsumption_l.SetRange("Post Out", true);
                    if ProjectConsumption_l.FindSet() then begin
                        repeat
                            if Item_l.Get(ProjectConsumption_l."Item No.") then begin
                                Item_l."Price/Profit Calculation" := Item_l."price/profit calculation"::"Profit=Price-Cost";
                                Item_l."Unit Price" := ProjectConsumption_l."Unit Price";
                                // AC01 B
                                if ProjectConsumption_l."Last Direct Cost" <> 0 then
                                    Item_l."Last Direct Cost" := ProjectConsumption_l."Last Direct Cost"
                                else
                                    Item_l."Last Direct Cost" := ProjectConsumption_l."Selling Price Project";
                                // AC01 E
                                Item_l.Validate("Unit Price");
                                Item_l.Validate("Last Direct Cost");
                                Item_l.Modify(true);
                            end;
                        until (ProjectConsumption_l.Next() = 0);
                    end;
                    //G-ERP.RS 2021-03-11 - 05

                    //G-ERP.RS 2021-09-29 07 CODEUNIT.RUN(CODEUNIT::"Job Jnl.-Post+Print",JobJournalLine_l);

                    ProjectConsumption_l.DeleteAll();
                    CurrPage.Update();

                end;
            }
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
                    ProjectConsumption_Rec_l: Record "Project Consumption";
                // ProjectConsumption_Rep_l: Report 50027;
                begin
                    ProjectConsumption_Rec_l.SetRange("Job No.", Rec."Job No.");
                    //     ProjectConsumption_Rep_l.SetTableview(ProjectConsumption_Rec_l);
                    //     ProjectConsumption_Rep_l.RunModal();
                end;
            }
            action("Filter Material")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    Rec.SetRange("Item TT Type", Rec."item tt type"::Material);
                    CurrPage.Update(false);
                end;
            }
            action("Filter Werkzeug")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    Rec.SetRange("Item TT Type", Rec."item tt type"::Werkzeug);
                    CurrPage.Update(false);
                end;
            }
            action("Filter aufheben")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    Rec.SetRange("Item TT Type");
                    CurrPage.Update(false);
                end;
            }
            action("Kennzeichen Ausbuchen setzen")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    if Rec.FindSet then
                        repeat
                            Rec."Post Out" := true;
                            Rec.Modify;
                        until Rec.Next = 0;
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("Job No.", '');
        Rec.SetRange("Bin Code", ''); //G-ERP.RS 2021-02-04 02
    end;

    var
        ProjectNo_g: Code[20];
        ERR_NoProjectNo: label 'No project number was entered.';
        BinCode_g: Code[20];
        ERR_ItemTtTypeNotFound: label 'Die TT-Art %1 wird von der Maske %2 nicht untersützt.';
}

