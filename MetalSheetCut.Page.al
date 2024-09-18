page 50079 "Metal Sheet Cut"
{
    Caption = 'Blechzuschnitt';
    PageType = StandardDialog;
    SourceTable = "Metal Sheet";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(Quantities)
            {
                Caption = 'Mengen';
                field(Available_Quantity_G; Available_Quantity_G)
                {
                    ApplicationArea = All;
                    Caption = 'Verfügbare Menge (KG)';
                    Editable = false;
                    ToolTip = 'Gibt die verfügbare Menge an, diese über die ausgewählte Herkunfts-Chargennummer bereitgestellt wird.';
                }
                field(Required_Quantity_G; Required_Quantity_G)
                {
                    ApplicationArea = All;
                    Caption = 'Zuschnittmenge (KG)';
                    ToolTip = 'Gibt die zugeschnittene Menge an.';

                    trigger OnValidate()
                    begin
                        if Available_Quantity_G < Required_Quantity_G then
                            Error('Die verfügbare Menge reicht nicht aus.');
                    end;
                }
            }
            group(ToLocation)
            {
                Caption = 'Ziel';
                field("To Location"; ToLocation_G)
                {
                    ApplicationArea = All;
                    Caption = 'Nach Lagerort';
                    ShowMandatory = true;
                    TableRelation = Location.Code;
                    ToolTip = 'Gibt den zukünftigen Lagerort an.';

                    trigger OnValidate()
                    var
                        Bin: Record Bin;
                    begin
                        if ToLocation_G <> '' then
                            if ToBin_G <> '' then
                                if NOT Bin.Get(ToLocation_G, ToBin_G) then
                                    Error('Lagerplatz %1 nicht im Lagerort %2 gefunden.', ToBin_G, ToLocation_G);
                    end;
                }
                field("To Bin"; ToBin_G)
                {
                    ApplicationArea = All;
                    Caption = 'Nach Lagerplatz';
                    ShowMandatory = true;
                    TableRelation = Bin.Code;
                    ToolTip = 'Gibt den zukünftigen Lagerplatz an.';

                    trigger OnValidate()
                    var
                        Bin: Record Bin;
                    begin
                        if ToBin_G <> '' then
                            if NOT Bin.Get(ToLocation_G, ToBin_G) then
                                Error('Lagerplatz %1 nicht im Lagerort %2 gefunden.', ToBin_G, ToLocation_G);
                    end;
                }
            }
            group(Informationen)
            {
                field(Format_G; Format_G)
                {
                    ApplicationArea = All;
                    Caption = 'Form';
                    ToolTip = 'Information über die grobe Form des Blechs';
                }
                field(Description_G; Description_G)
                {
                    ApplicationArea = All;
                    Caption = 'Beschreibung';
                    ToolTip = 'Detailierte Information über das Blech';
                }
                field(LengthA_G; LengthA_G)
                {
                    ApplicationArea = All;
                    Caption = 'Länge A';
                    ToolTip = 'Gibt die erste Blechlänge an.';
                }
                field(LengthB_G; LengthB_G)
                {
                    ApplicationArea = All;
                    Caption = 'Länge B';
                    ToolTip = 'Gibt die zweite Blechlänge an.';
                }
                field(WidthA_G; WidthA_G)
                {
                    ApplicationArea = All;
                    Caption = 'Breite A';
                    ToolTip = 'Gibt die erste Blechbreite an.';
                }
                field(WidthB_G; WidthB_G)
                {
                    ApplicationArea = All;
                    Caption = 'Breite B';
                    ToolTip = 'Gibt die zweite Blechbreite an.';
                }
                field(CircleDiameter_G; CircleDiameter_G)
                {
                    ApplicationArea = All;
                    Caption = 'Kreisdurchmesser';
                    ToolTip = 'Gibt den Kreisdurchmesser an.';
                }
                field(Area_G; Area_G)
                {
                    ApplicationArea = All;
                    Caption = 'Fläche';
                    ToolTip = 'Gibt die gesamte Restfläche des Blechs an.';
                }
            }
        }
    }
    var
        Available_Quantity_G: Decimal;
        Required_Quantity_G: Decimal;
        LotNo_G: Code[50];
        Format_G: Text;
        Description_G: Text;
        LengthA_G: Decimal;
        LengthB_G: Decimal;
        WidthA_G: Decimal;
        WidthB_G: Decimal;
        CircleDiameter_G: Decimal;
        Area_G: Decimal;
        LineNo: Integer;
        ToLocation_G: Code[20];
        ToBin_G: Code[20];

    trigger OnAfterGetRecord()
    var
        WarehouseEntry: Record "Warehouse Entry";
    begin
        Format_G := Rec.Format;
        Description_G := Rec.Description;
        LengthA_G := Rec."Length A";
        LengthB_G := Rec."Length B";
        WidthA_G := Rec."Width A";
        WidthB_G := Rec."Width B";
        CircleDiameter_G := Rec."Circle Diameter";
        Area_G := Rec."Area";

        Available_Quantity_G := CalcQuantity(Rec."Item No.", Rec."Lot No.", rec."To Location", rec."To Bin");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        MetalSheet: Record "Metal Sheet";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemJournalLine: Record "Item Journal Line";
        ReservationEntry: Record "Reservation Entry";
        Item: Record Item;
    begin
        if CloseAction = CloseAction::OK then begin

            if Rec."Original Lot No." = '' then
                Error('Herkunfts-Chargennummer darf nicht leer sein.');
            if Required_Quantity_G <= 0 then
                Error('Menge muss größer als 0 sein.');
            if Available_Quantity_G <= Required_Quantity_G then
                Error('Die verfügbare Menge reicht nicht aus.');
            if ToLocation_G = '' then
                Error('Nach Lagerort darf nicht leer sein.');
            if ToBin_G = '' then
                Error('Nach Lagerplatz darf nicht leer sein.');

            if Item.Get(Rec."Item No.") then begin

                MetalSheet.Init();
                MetalSheet."Item No." := Rec."Item No.";
                MetalSheet.Insert(true);
                MetalSheet."Original Lot No." := Rec."Lot No.";
                MetalSheet."Lot No." := Rec."Lot No." + '-' + Format(MetalSheet."Entry No.");
                MetalSheet.Quantity := Required_Quantity_G;

                MetalSheet.Format := Format_G;
                MetalSheet.Description := Description_G;
                MetalSheet."Length A" := LengthA_G;
                MetalSheet."Length B" := LengthB_G;
                MetalSheet."Width A" := WidthA_G;
                MetalSheet."Width B" := WidthB_G;
                MetalSheet."Circle Diameter" := CircleDiameter_G;
                MetalSheet."Area" := Area_G;
                MetalSheet."Is Nipped" := Rec."Is Nipped";
                MetalSheet."Is Punched" := Rec."Is Punched";

                MetalSheet."From Location" := Rec."To Location";
                MetalSheet."From Bin" := Rec."To Bin";

                MetalSheet."To Location" := ToLocation_G;
                MetalSheet."To Bin" := ToBin_G;

                ItemJournalLine.Reset();
                NewItemJournalLine(ItemJournalLine, Item, Rec."Lot No.", Rec."To Location", Rec."To Bin", Required_Quantity_G, ItemJournalLine."Entry Type"::"Negative Adjmt.");
                CreateReservationEntryNegative(ReservationEntry, ItemJournalLine, Rec."Lot No.");
                NewItemJournalLine(ItemJournalLine, Item, MetalSheet."Lot No.", ToLocation_G, ToBin_G, Required_Quantity_G, ItemJournalLine."Entry Type"::"Positive Adjmt.");
                CreateReservationEntryPositive(ReservationEntry, ItemJournalLine, MetalSheet."Lot No.");

                CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", ItemJournalLine);

                MetalSheet.Locked := true;
                MetalSheet.Modify();
                Update(true);

                Message('Ein neues Restblech mit der Chargennummer %1 wurde erstellt.', MetalSheet."Lot No.");
            end;
        end;
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