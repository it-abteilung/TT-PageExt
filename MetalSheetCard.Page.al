page 50075 "Metal Sheet"
{
    Caption = 'Restbleche';
    PageType = Card;
    SourceTable = "Metal Sheet";
    DataCaptionExpression = Format(Rec."Entry No.") + ' - ' + Rec."Item No." + ' - ' + Rec."Lot No.";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Blech';
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Lfd. Nr.';
                    Editable = false;
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Artikelnr.';
                    Editable = NOT Rec.Locked;
                    ShowMandatory = true;
                    ToolTip = 'Gibt die Artikelnr. an.';

                    trigger OnValidate()
                    var
                        Item: Record Item;
                    begin
                        if Item.Get(Rec."Item No.") then
                            ItemDescription_G := Item.Description;
                    end;
                }
                field(ItemDescription_G; ItemDescription_G)
                {
                    ApplicationArea = All;
                    Caption = 'Artikelbeschreibung';
                    Editable = false;
                    ToolTip = 'Gibt die Artikelbeschreibung an.';
                }
                field(Locking_G; Locking_G)
                {
                    ApplicationArea = All;
                    Caption = 'Gebucht';
                    Editable = false;
                    ToolTip = 'Gibt an, ob der Artikel bereits gebucht wurde. Nur ein gebuchter Artikel erzeugt ';

                }
            }
            group(Post)
            {
                Caption = 'Buchungsdaten';
                group(FromLocation)
                {
                    Caption = 'Herkunft';
                    field("Original Lot No."; Rec."Original Lot No.")
                    {
                        ApplicationArea = All;
                        Caption = 'Herkunfts-Chargennummer';
                        Editable = NOT Rec.Locked;
                        ShowMandatory = true;
                        ToolTip = 'Gibt die Herkunfts-Chargennummer an, diese für die Umlagerung verwendet werden soll.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            LotNoQuantityTemp_T: Record "Lot No. Quantity Temp";
                            LotNoQuantityTemp_P: Page "Lot No. Quantity Temp";
                            MetalSheet_L: Record "Metal Sheet";
                        begin
                            Rec.TestField("Item No.");

                            LotNoQuantityTemp_P.SetItemNo(Rec."Item No.");
                            if LotNoQuantityTemp_P.RunModal() = Action::OK then begin
                                LotNoQuantityTemp_P.GetRecord(LotNoQuantityTemp_T);

                                Rec."Original Lot No." := LotNoQuantityTemp_T."Lot No.";
                                Rec."Lot No." := LotNoQuantityTemp_T."Lot No." + '-' + Format(Rec."Entry No.");
                                Rec."From Location" := LotNoQuantityTemp_T.Location;
                                Rec."From Bin" := LotNoQuantityTemp_T.Bin;
                                Available_Quantity_G := LotNoQuantityTemp_T.Quantity;
                            end;
                            Update();
                        end;

                        trigger OnValidate()
                        var
                            WarehouseEntry: Record "Warehouse Entry";
                        begin
                            WarehouseEntry.SetRange("Location Code", Rec."From Location");
                            WarehouseEntry.SetRange("Bin Code", Rec."From Bin");
                            WarehouseEntry.SetRange("Item No.", Rec."Item No.");
                            WarehouseEntry.SetRange("Lot No.", Rec."Original Lot No.");

                            if WarehouseEntry.IsEmpty() then
                                Error('Keine Posten für %1 gefunden.', Rec."Original Lot No.");
                        end;
                    }
                    field(Available_Quantity_G; Available_Quantity_G)
                    {
                        ApplicationArea = All;
                        Caption = 'Verfügbare Menge (KG)';
                        Editable = false; // wird über Buchung erfüllt
                        ToolTip = 'Gibt die verfügbare Menge an, diese über die ausgewählte Herkunfts-Chargennummer bereitgestellt wird.';
                    }
                    field("From Location"; Rec."From Location")
                    {
                        ApplicationArea = All;
                        Caption = 'Von Lagerort';
                        Editable = false;
                        ToolTip = 'Gibt den Lagerort an, dieser als Quelle für die Umlagerung dient.';
                    }
                    field("From Bin"; Rec."From Bin")
                    {
                        ApplicationArea = All;
                        Caption = 'Von Lagerplatz';
                        Editable = false;
                        ToolTip = 'Gibt den Lagerplatz an, dieser als Quelle für die Umlagerung dient.';

                    }
                }
                group(ToLocation)
                {
                    Caption = 'Ziel';
                    field("Lot No."; Rec."Lot No.")
                    {
                        ApplicationArea = All;
                        Caption = 'Neue Chargennummer';
                        Editable = false;
                        ToolTip = 'Gibt die neue Chargennummer an. Die neue Chargennummer beinhaltet die Herkunfts-Chargennummer und die aktuelle Lfd. Nr. des Blechs.';
                    }
                    field(Required_Quantity_G; Required_Quantity_G)
                    {
                        ApplicationArea = All;
                        Caption = 'Zuschnittmenge (KG)';
                        Editable = NOT Locking_G;
                        ShowMandatory = true;
                        ToolTip = 'Gibt die zugeschnittene Menge an.';

                        trigger OnValidate()
                        begin
                            if Rec."Original Lot No." = '' then
                                Error('Zuerst muss eine Herkunfts-Chargennummer bestimmt werden.');

                            Available_Quantity_G := CalcQuantity(Rec."Item No.", Rec."Original Lot No.", Rec."From Location", Rec."From Bin");

                            if Available_Quantity_G < Required_Quantity_G then
                                Error('Die verfügbare Menge reicht nicht aus.');
                        end;
                    }
                    field("To Location"; Rec."To Location")
                    {
                        ApplicationArea = All;
                        Caption = 'Nach Lagerort';
                        Editable = NOT Rec.Locked;
                        ShowMandatory = true;
                        ToolTip = 'Gibt den zukünftigen Lagerort an.';

                        trigger OnValidate()
                        var
                            Bin: Record Bin;
                        begin
                            if Rec."To Location" <> xRec."To Location" then
                                if Rec."To Bin" <> '' then
                                    if NOT Bin.Get(Rec."To Location", Rec."To Bin") then
                                        Error('Lagerplatz %1 nicht im Lagerort %2 gefunden.', Rec."To Bin", Rec."To Location");
                        end;
                    }
                    field("To Bin"; Rec."To Bin")
                    {
                        ApplicationArea = All;
                        Caption = 'Nach Lagerplatz';
                        Editable = NOT Rec.Locked;
                        ShowMandatory = true;
                        ToolTip = 'Gibt den zukünftigen Lagerplatz an.';

                        trigger OnValidate()
                        var
                            Bin: Record Bin;
                        begin
                            if Rec."To Bin" <> xRec."To Bin" then
                                if NOT Bin.Get(Rec."To Location", Rec."To Bin") then
                                    Error('Lagerplatz %1 nicht im Lagerort %2 gefunden.', Rec."To Bin", Rec."To Location");
                        end;
                    }
                }
            }
            group(Special)
            {
                Caption = 'Oberfläche';
                field("Is Punched"; Rec."Is Punched")
                {
                    ApplicationArea = All;
                    Caption = 'Ist Gestanzt';
                    Editable = NOT Rec.Locked;
                    ToolTip = 'Gibt an, ob es sich um ein gestanztes Blech handelt.';
                }
                field("Is Nipped"; Rec."Is Nipped")
                {
                    ApplicationArea = All;
                    Caption = 'Ist Genoppt';
                    Editable = NOT Rec.Locked;
                    ToolTip = 'Gibt an, ob es sich um ein genopptes Blech handelt.';
                }
            }
            group(Information)
            {
                Caption = 'Abmessung';
                field(Format; Rec.Format)
                {
                    ApplicationArea = All;
                    Caption = 'Form';
                    Editable = NOT Rec.Locked;
                    InstructionalText = 'Rechteck';
                    ToolTip = 'Information über die grobe Form des Blechs';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Beschreibung';
                    Editable = NOT Rec.Locked;
                    ToolTip = 'Detailierte Information über das Blech';
                }
                field("Length A"; Rec."Length A")
                {
                    ApplicationArea = All;
                    Caption = 'Länge A';
                    Editable = NOT Rec.Locked;
                    ToolTip = 'Gibt die erste Blechlänge an.';
                }
                field("Length B"; Rec."Length B")
                {
                    ApplicationArea = All;
                    Caption = 'Länge B';
                    Editable = NOT Rec.Locked;
                    ToolTip = 'Gibt die zweite Blechlänge an.';
                }
                field("Width A"; Rec."Width A")
                {
                    ApplicationArea = All;
                    Caption = 'Breite A';
                    Editable = NOT Rec.Locked;
                    ToolTip = 'Gibt die erste Blechbreite an.';
                }
                field("Width B"; Rec."Width B")
                {
                    ApplicationArea = All;
                    Caption = 'Breite B';
                    Editable = NOT Rec.Locked;
                    ToolTip = 'Gibt die zweite Blechbreite an.';
                }
                field("Circle Diameter"; Rec."Circle Diameter")
                {
                    ApplicationArea = All;
                    Caption = 'Kreisdurchmesser';
                    Editable = NOT Rec.Locked;
                    ToolTip = 'Gibt den Kreisdurchmesser an.';
                }
                field("Area"; Rec."Area")
                {
                    ApplicationArea = All;
                    Caption = 'Fläche';
                    Editable = NOT Rec.Locked;
                    ToolTip = 'Gibt die gesamte Restfläche des Blechs an.';
                }
            }
        }
    }
    actions
    {
        area(Promoted)
        {
            actionref(PostRecord; Post_Record) { }
            actionref(TransferRecord; Transfer_Reocrd) { }
            actionref(CutSheet; Cut_Sheet) { }
        }
        area(Processing)
        {
            action(Post_Record)
            {
                ApplicationArea = All;
                Caption = 'Buchen';
                Enabled = NOT Rec.Locked;
                Image = PostDocument;
                ToolTip = 'Erlaubt die Buchung von dem Restblech, dies beinhaltet eine Umlagerung auf den neuen Lagerort und Lagerplatz mit einer neuen Chargennummer.';

                trigger OnAction()
                var
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    ItemJournalLine: Record "Item Journal Line";
                    ReservationEntry: Record "Reservation Entry";
                    Item: Record Item;
                begin
                    if Rec."Original Lot No." = '' then
                        Error('Herkunfts-Chargennummer darf nicht leer sein.');
                    if Required_Quantity_G <= 0 then
                        Error('Menge muss größer als 0 sein.');
                    if Rec."To Location" = '' then
                        Error('Nach Lagerort darf nicht leer sein.');
                    if Rec."To Bin" = '' then
                        Error('Nach Lagerplatz darf nicht leer sein.');

                    Available_Quantity_G := CalcQuantity(Rec."Item No.", Rec."Original Lot No.", Rec."From Location", Rec."From Bin");

                    if Available_Quantity_G < Required_Quantity_G then
                        Error('Die verfügbare Menge reicht nicht aus.');

                    if Item.Get(Rec."Item No.") then begin

                        ItemJournalLine.Reset();
                        NewItemJournalLine(ItemJournalLine, Item, Rec."Original Lot No.", Rec."From Location", Rec."From Bin", Required_Quantity_G, ItemJournalLine."Entry Type"::"Negative Adjmt.");
                        CreateReservationEntryNegative(ReservationEntry, ItemJournalLine, Rec."Original Lot No.");
                        NewItemJournalLine(ItemJournalLine, Item, Rec."Lot No.", Rec."To Location", Rec."To Bin", Required_Quantity_G, ItemJournalLine."Entry Type"::"Positive Adjmt.");
                        CreateReservationEntryPositive(ReservationEntry, ItemJournalLine, Rec."Lot No.");

                        CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", ItemJournalLine);

                        Rec.Locked := true;
                        Update(true);
                    end;
                end;
            }
            action(Cut_Sheet)
            {
                ApplicationArea = All;
                Caption = 'Zuschnitt';
                Image = CoupledUnitOfMeasure;
                ToolTip = 'Erlaubt die Erstellung von einem neuen Restblech basierend auf dem ausgewählten Blech.';

                trigger OnAction()
                var
                    MetalSheetCut_P: Page "Metal Sheet Cut";
                    MetalSheet_T: Record "Metal Sheet";
                begin
                    MetalSheetCut_P.SetRecord(Rec);
                    MetalSheetCut_P.RunModal();
                end;
            }

            action(Transfer_Reocrd)
            {
                ApplicationArea = All;
                Caption = 'Umlagerung';
                Image = TransferOrder;
                ToolTip = 'Erlaubt die Umlagerung des Blechs auf einen neuen Lagerort und Lagerplatz. Die abgeleiteten Bleche werden nicht aktualisiert.';

                trigger OnAction()
                var
                    MetalSheetTransfer: Page "Metal Sheet Transfer";
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    ItemJournalLine: Record "Item Journal Line";
                    ReservationEntry: Record "Reservation Entry";
                    Item: Record Item;
                begin
                    MetalSheetTransfer.SetRecord(Rec);
                    if MetalSheetTransfer.RunModal() = Action::OK then begin

                        Available_Quantity_G := CalcQuantity(Rec."Item No.", Rec."Lot No.", Rec."To Location", Rec."To Bin");

                        if Available_Quantity_G < MetalSheetTransfer.GetRequiredQuantity() then
                            Error('Die verfügbare Menge reicht nicht aus.');

                        if Item.Get(Rec."Item No.") then begin

                            ItemJournalLine.Reset();
                            NewItemJournalLine(ItemJournalLine, Item, Rec."Lot No.", Rec."To Location", Rec."To Bin", MetalSheetTransfer.GetRequiredQuantity(), ItemJournalLine."Entry Type"::"Negative Adjmt.");
                            CreateReservationEntryNegative(ReservationEntry, ItemJournalLine, Rec."Lot No.");
                            NewItemJournalLine(ItemJournalLine, Item, Rec."Lot No.", MetalSheetTransfer.GetNewLocation(), MetalSheetTransfer.GetNewBin(), MetalSheetTransfer.GetRequiredQuantity(), ItemJournalLine."Entry Type"::"Positive Adjmt.");
                            CreateReservationEntryPositive(ReservationEntry, ItemJournalLine, Rec."Lot No.");

                            CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", ItemJournalLine);

                            Rec."To Location" := MetalSheetTransfer.GetNewLocation();
                            Rec."To Bin" := MetalSheetTransfer.GetNewBin();
                        end;
                    end;
                end;
            }
        }
    }

    var
        ItemDescription_G: Text;
        Available_Quantity_G: Decimal;
        Required_Quantity_G: Decimal;
        Locking_G: Boolean;
        LineNo: Integer;

    trigger OnAfterGetCurrRecord()
    var
        Item: Record Item;
        WarehouseEntry: Record "Warehouse Entry";
    begin
        ItemDescription_G := '';
        if Item.Get(Rec."Item No.") then
            ItemDescription_G := Item.Description;

        Available_Quantity_G := CalcQuantity(Rec."Item No.", Rec."Original Lot No.", Rec."From Location", Rec."From Bin");
        Required_Quantity_G := CalcQuantity(Rec."Item No.", Rec."Lot No.", Rec."To Location", Rec."To Bin");

        Locking_G := Rec.Locked;
    end;

    procedure createItemDictEmpty() Result: Dictionary of [Code[20], Dictionary of [Code[50], Decimal]]
    begin
        exit(Result);
    end;

    procedure createLotNoDictEmpty() Result: Dictionary of [Code[50], Decimal]
    begin
        exit(Result);
    end;

    procedure NewItemJournalLine(var ItemJournalLine: Record "Item Journal Line"; Item: Record Item; LotNo: Code[50]; Location: Code[20]; Bin: Code[20]; Qty: Decimal; EntryType: Enum "Item Journal Entry Type")
    var
        ItemJournalLine_Tmp: Record "Item Journal Line";
    begin
        LineNo += 100000;

        ItemJournalLine.Init();
        ItemJournalLine.Validate("Journal Template Name", 'ARTIKEL');
        ItemJournalLine.Validate("Journal Batch Name", 'STANDARD');
        ItemJournalLine."Line No." := LineNo;
        ItemJournalLine.Insert(true);
        ItemJournalLine.Validate("Item No.", Item."No.");
        ItemJournalLine.Validate("Lot No.", LotNo);
        ItemJournalLine.Validate("Posting Date", Today());
        ItemJournalLine.Validate("Entry Type", EntryType);
        ItemJournalLine.Validate("Document No.", Rec."Original Lot No.");
        ItemJournalLine.Validate(Description, Item.Description);
        ItemJournalLine.Validate("Source Code", 'ARTBUCHBL');
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

    procedure CreateReservationEntryNegative(var ReservationEntry: Record "Reservation Entry"; var NewItemJnlLine: Record "Item Journal Line"; LotNo: Code[50])
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
        ReservationEntry."Lot No." := LotNo;
        ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Serial No.";
        ReservationEntry."Created By" := UserId;
        ReservationEntry.Positive := false;
        ReservationEntry.Quantity := NewItemJnlLine.Quantity * -1;
        ReservationEntry."Qty. per Unit of Measure" := NewItemJnlLine.Quantity;
        ReservationEntry."Quantity (Base)" := NewItemJnlLine.Quantity * -1;
        ReservationEntry."Qty. to Handle (Base)" := NewItemJnlLine.Quantity * -1;
        ReservationEntry."Qty. to Invoice (Base)" := NewItemJnlLine.Quantity * -1;
        ReservationEntry."Quantity Invoiced (Base)" := 0;

        ReservationEntry."Creation Date" := Today();
        ReservationEntry."Expiration Date" := Today();
        ReservationEntry.Insert();
    end;

    procedure CreateReservationEntryPositive(var ReservationEntry: Record "Reservation Entry"; var NewItemJnlLine: Record "Item Journal Line"; LotNo: Code[50])
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
        ReservationEntry."Lot No." := LotNo;
        ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Serial No.";
        ReservationEntry."Created By" := UserId;
        ReservationEntry.Positive := true;
        ReservationEntry.Quantity := NewItemJnlLine.Quantity;
        ReservationEntry."Qty. per Unit of Measure" := NewItemJnlLine.Quantity;
        ReservationEntry."Quantity (Base)" := NewItemJnlLine.Quantity;
        ReservationEntry."Qty. to Handle (Base)" := NewItemJnlLine.Quantity;
        ReservationEntry."Qty. to Invoice (Base)" := NewItemJnlLine.Quantity;
        ReservationEntry."Quantity Invoiced (Base)" := 0;

        ReservationEntry."Creation Date" := Today();
        ReservationEntry."Expiration Date" := Today();
        ReservationEntry.Insert();
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


    local procedure CalcQuantity(ItemNo_L: Code[20]; LotNo_L: Code[50]; LocationCode_L: Code[20]; BinCode_L: Code[20]) Qty: decimal
    var
        WarehouseEntry: Record "Warehouse Entry";
    begin
        WarehouseEntry.SetRange("Location Code", LocationCode_L);
        WarehouseEntry.SetRange("Bin Code", BinCode_L);
        WarehouseEntry.SetRange("Item No.", ItemNo_L);
        WarehouseEntry.SetRange("Lot No.", LotNo_L);
        if WarehouseEntry.FindSet() then
            repeat
                Qty += WarehouseEntry.Quantity;
            until WarehouseEntry.Next() = 0;
    end;
}