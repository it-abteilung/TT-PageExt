page 50044 "Package Tree List"
{
    Caption = 'Detailierter Vergleich';
    Editable = false;
    PageType = List;
    SourceTable = "Package Tree Temp";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                ShowAsTree = true;
                TreeInitialState = CollapseAll;
                IndentationColumn = Rec.Indentation;

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Lfd-Nr.';
                    Enabled = false;
                    Visible = false;
                }
                field(Indentation; Rec.Indentation)
                {
                    ApplicationArea = All;
                    Caption = 'Indentation';
                    Enabled = false;
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Artikel-Nr.';
                    HideValue = HideValues;
                    StyleExpr = StyleExpr;

                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Caption = 'Beschreibung';
                    HideValue = HideValues;
                }
                field(Bin; Rec.Bin)
                {
                    ApplicationArea = All;
                    Caption = 'Paketstück';
                    HideValue = NOT HideValues;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Buchungsdatum';
                    HideValue = NOT HideValues;
                    Visible = false;
                }
                field("Packed Quantity"; Rec."Packed Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Gepackte Menge';
                }
                field("Requested Quantity"; Rec."Requested Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Angeforderte Menge';
                    HideValue = HideValues;

                    trigger OnDrillDown()
                    var
                        WerkzeugZeile: Record Werkzeuganforderungzeile;
                        PackageTreeList: Page "Package Job List";
                    begin
                        WerkzeugZeile_G.SetRange("Artikel Nr", Rec."Item No.");
                        if WerkzeugZeile_G.FindSet() then begin
                            PackageTreeList.SetTableView(WerkzeugZeile_G);
                            PackageTreeList.RunModal();
                        end;
                    end;
                }
                field("Delta Quantity"; DeltaQuantitiy)
                {
                    ApplicationArea = All;
                    Caption = 'Differenz';
                    HideValue = HideValues;
                }
            }
        }
    }

    var
        DeltaQuantitiy: Decimal;
        WerkzeugKopf_G: Record Werkzeuganforderungskopf;
        WerkzeugZeile_G: Record Werkzeuganforderungzeile;
        BinFilter: Text;
        HideValues: Boolean;
        StyleExpr: Text;
        JobMap: List of [Dictionary of [Code[20], Integer]];

    trigger OnAfterGetRecord()
    var
        Resource: Record Resource;
    begin
        case Rec.Indentation of
            0:
                begin
                    HideValues := false;
                    StyleExpr := 'Strong';
                end;
            1:
                begin
                    HideValues := true;
                end;
        end;
        DeltaQuantitiy := Rec."Requested Quantity" - Rec."Packed Quantity";
    end;

    trigger OnOpenPage()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        Job: Record Job;
        Bin: Record Bin;
        EntryNoCounter: Integer;
        SaveEntryNoCounter: Integer;
        IndQty0: Integer;
        IndQty1: Integer;
        IndQty2: Integer;
        WerkzeugKopf_L: Record Werkzeuganforderungskopf;
        WerkzeugZeile_L: Record Werkzeuganforderungzeile;
        WarehouseEntry: Record "Warehouse Entry";

        ReqQty: Decimal;

        Item: Record Item;
        ItemDesc: Text;
        ItemKey: Code[20];
        ItemDict: Dictionary of [Code[20], Decimal];
        BinKey: Code[20];
        BinDict: Dictionary of [Code[20], Decimal];

        JobDict: Dictionary of [Code[20], Integer];
        JobKey: Code[20];
    begin
        EntryNoCounter := 0;

        WerkzeugKopf_L.Reset();
        FOREACH JobDict IN JobMap do
            foreach JobKey in JobDict.Keys() do
                if WerkzeugKopf_L.Get(JobKey, JobDict.Get(JobKey)) then
                    WerkzeugKopf_L.Mark(true);

        WerkzeugKopf_L.MarkedOnly(true);
        if WerkzeugKopf_L.FindSet() then begin
            WerkzeugZeile_L.Reset();
            WerkzeugZeile_L.ClearMarks();
            repeat
                WerkzeugZeile_L.SetRange("Projekt Nr", WerkzeugKopf_L."Projekt Nr");
                WerkzeugZeile_L.SetRange("Lfd Nr", WerkzeugKopf_L."Lfd Nr");
                if WerkzeugZeile_L.FindSet() then begin
                    repeat
                        WerkzeugZeile_L.Mark(true);
                    until WerkzeugZeile_L.Next() = 0;
                end;
            until WerkzeugKopf_L.Next() = 0;
            WerkzeugZeile_L.SetRange("Projekt Nr");
            WerkzeugZeile_L.SetRange("Lfd Nr");
            WerkzeugZeile_L.MarkedOnly(true);
            WerkzeugZeile_L.SetCurrentKey("Artikel Nr");
            WerkzeugZeile_L.SetAscending("Artikel Nr", true);
            if WerkzeugZeile_L.FindSet() then begin
                WerkzeugZeile_G.Copy(WerkzeugZeile_L);
                ItemDict := createDictEmpty();
                repeat
                    if ItemDict.ContainsKey(WerkzeugZeile_L."Artikel Nr") then
                        ItemDict.Set(WerkzeugZeile_L."Artikel Nr", ItemDict.Get(WerkzeugZeile_L."Artikel Nr") + WerkzeugZeile_L.Menge)
                    else
                        ItemDict.Add(WerkzeugZeile_L."Artikel Nr", WerkzeugZeile_L.Menge);
                until WerkzeugZeile_L.Next() = 0;

                foreach ItemKey in ItemDict.Keys() do begin
                    EntryNoCounter += 1;
                    SaveEntryNoCounter := EntryNoCounter;

                    Item.Reset();
                    ItemDesc := '';
                    if Item.Get(ItemKey) then
                        ItemDesc := Item.Description;

                    Rec.Init();
                    Rec."Entry No." := EntryNoCounter;
                    Rec.Indentation := 0;
                    Rec."Item No." := ItemKey;
                    Rec."Item Description" := ItemDesc;
                    Rec."Requested Quantity" := ItemDict.get(Itemkey);
                    Rec.Insert(true);

                    WarehouseEntry.Reset();
                    WarehouseEntry.Setfilter("Bin Code", BinFilter);
                    WarehouseEntry.SetFilter(Quantity, '>%1', 0);
                    WarehouseEntry.SetRange("Item No.", ItemKey);

                    ReqQty := 0;
                    if WarehouseEntry.FindSet() then begin
                        BinDict := createDictEmpty();
                        repeat
                            if BinDict.ContainsKey(WarehouseEntry."Bin Code") then
                                BinDict.Set(WarehouseEntry."Bin Code", BinDict.Get(WarehouseEntry."Bin Code") + WarehouseEntry.Quantity)
                            else
                                BinDict.Add(WarehouseEntry."Bin Code", WarehouseEntry.Quantity)
                        until WarehouseEntry.Next() = 0;

                        foreach BinKey in BinDict.Keys() do begin

                            EntryNoCounter += 1;
                            Rec.Init();
                            Rec."Entry No." := EntryNoCounter;
                            Rec.Indentation := 1;
                            Rec."Packed Quantity" := BinDict.Get(BinKey);
                            Rec.Bin := BinKey;
                            Rec.Insert(true);

                            ReqQty += BinDict.Get(BinKey);
                        end;
                    end;

                    if Rec.Get(SaveEntryNoCounter) then begin
                        Rec."Packed Quantity" := ReqQty;
                        Rec.Modify();
                    end;
                end;
            end;
        end;
    end;

    local procedure createDictEmpty() Result: Dictionary of [Code[20], Decimal]
    begin
        exit(Result);
    end;

    procedure SetBinFilter(BinFilter_L: Text)
    begin
        BinFilter := BinFilter_L;
    end;

    procedure SetJobMap(JobMap_L: List of [Dictionary of [Code[20], Integer]])
    begin
        JobMap := JobMap_L;
    end;

}