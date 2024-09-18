page 50083 "Lot No. Quantity Temp"
{
    Caption = 'Wähle Charge';
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Lot No. Quantity Temp";
    SourceTableTemporary = true;
    DataCaptionFields = "Item No.", Description;
    DataCaptionExpression = Rec."Item No." + ' - ' + Rec.Description;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Caption = 'Chargennummer';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                    Caption = 'Lagerort';
                }
                field(Bin; Rec.Bin)
                {
                    ApplicationArea = All;
                    Caption = 'Lagerplatz';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Verfügbare Menge';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        WarehouseEntry: Record "Warehouse Entry";
        Item: Record Item;

        MasterDict: Dictionary of [Code[20], Dictionary of [Code[20], Dictionary of [Code[50], Decimal]]];
        BinCodeKey: Code[20];
        BinCodeDict: Dictionary of [Code[50], Decimal];

        LocationCodeKey: Code[20];
        LocationDict: Dictionary of [Code[20], Dictionary of [Code[50], Decimal]];

        LotNoKey: Code[50];
        QuantityValue: Decimal;

        LocationCodeValue: Code[20];
        BinCodeValue: Code[20];
        LotNoValue: Code[50];

        Counter: Integer;
    begin
        WarehouseEntry.SetCurrentKey("Item No.", "Lot No.", Quantity);
        WarehouseEntry.SetRange("Item No.", ItemNo_G);
        WarehouseEntry.SetFilter("Lot No.", '<> %1', '');
        WarehouseEntry.SetAscending("Lot No.", true);

        if WarehouseEntry.FindSet() then begin
            repeat
                if Item.Get(WarehouseEntry."Item No.") then begin
                    if Item."Item Category Code" = 'BLECH' then begin
                        LocationCodeValue := WarehouseEntry."Location Code";
                        LotNoValue := WarehouseEntry."Lot No.";
                        BinCodeValue := WarehouseEntry."Bin Code";

                        if MasterDict.ContainsKey(LocationCodeValue) then begin
                            if MasterDict.Get(LocationCodeValue).ContainsKey(BinCodeValue) then begin
                                if MasterDict.Get(LocationCodeValue).Get(BinCodeValue).ContainsKey(LotNoValue) then begin
                                    QuantityValue := WarehouseEntry.Quantity;
                                    QuantityValue += MasterDict.Get(LocationCodeValue).Get(BinCodeValue).Get(LotNoValue);
                                    MasterDict.Get(LocationCodeValue).Get(BinCodeValue).Set(LotNoValue, QuantityValue);
                                end else begin
                                    MasterDict.Get(LocationCodeValue).Get(BinCodeValue).Add(LotNoValue, WarehouseEntry.Quantity);
                                end;
                            end
                            else begin
                                MasterDict.Get(LocationCodeValue).Add(BinCodeValue, createLotNoDictEmpty());
                                MasterDict.Get(LocationCodeValue).Get(BinCodeValue).Add(LotNoValue, WarehouseEntry.Quantity);
                            end;
                        end
                        else begin
                            MasterDict.Add(LocationCodeValue, createItemDictEmpty());
                            MasterDict.Get(LocationCodeValue).Add(BinCodeValue, createLotNoDictEmpty());
                            MasterDict.Get(LocationCodeValue).Get(BinCodeValue).Add(LotNoValue, WarehouseEntry.Quantity);
                        end;
                    end;
                end;
            until WarehouseEntry.Next() = 0;
        end;

        Counter := 0;
        foreach LocationCodeKey in MasterDict.Keys() do begin
            LocationDict := MasterDict.Get(LocationCodeKey);
            foreach BinCodeKey in LocationDict.Keys() do begin
                BinCodeDict := LocationDict.Get(BinCodeKey);
                foreach LotNoKey in BinCodeDict.Keys() do begin
                    Counter += 1;
                    QuantityValue := BinCodeDict.Get(LotNoKey);
                    if QuantityValue > 0 then begin
                        Rec.Init();
                        Rec."Item No." := ItemNo_G;
                        if Item.Get(ItemNo_G) then
                            Rec.Description := Item.Description;
                        Rec.Location := LocationCodeKey;
                        Rec.Bin := BinCodeKey;
                        Rec."Lot No." := LotNoKey;
                        Rec.Quantity := QuantityValue;
                        Rec.Insert();
                    end;
                end;
            end;
        end;
    end;

    procedure createItemDictEmpty() Result: Dictionary of [Code[20], Dictionary of [Code[50], Decimal]]
    begin
        exit(Result);
    end;

    procedure createLotNoDictEmpty() Result: Dictionary of [Code[50], Decimal]
    begin
        exit(Result);
    end;

    procedure SetItemNo(ItemNo_L: Code[20])
    begin
        ItemNo_G := ItemNo_L;
    end;

    var
        ItemNo_G: Code[20];
}