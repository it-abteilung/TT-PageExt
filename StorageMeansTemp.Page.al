page 50108 "Storage Means Temp."
{
    Caption = 'Lagermittel - Lagerinhalt';
    Editable = false;
    PageType = List;
    SourceTable = "Temp. Bin Content";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Caption = 'Lagerortcode';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    Caption = 'Lagerplatzcode';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Artikel-Nr.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Caption = 'Artikelbeschreibung';
                }
                field("Item Description 2"; Rec."Item Description 2")
                {
                    ApplicationArea = All;
                    Caption = 'Artikelbeschreibung 2';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    Caption = 'Seriennummer';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Menge';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    Caption = 'Basiseinheit';
                }
            }
        }
        area(FactBoxes)
        {
        }
    }

    actions
    {
    }

    var
        LocationCode_G: Code[10];
        BinCode_G: Code[20];

    trigger OnOpenPage()
    var
        Counter: Integer;
        ItemNoValue: Code[20];
        SerialNoValue: Code[50];
        QuantityValue: Decimal;
        ItemNoDict: Dictionary of [Code[20], Dictionary of [Code[50], Decimal]];
        ItemNoKey: Code[20];
        SerialNoDict: Dictionary of [Code[50], Decimal];
        SerialNoKey: Code[50];
        BinContent: Record "Bin Content";
        WarehouseEntry: Record "Warehouse Entry";
        Item: Record "Item";
    begin
        Clear(BinContent);
        Clear(WarehouseEntry);
        BinContent.SetRange("Location Code", LocationCode_G);
        BinContent.SetRange("Bin Code", BinCode_G);

        if BinContent.FindFirst() then begin
            WarehouseEntry.SetRange("Location Code", LocationCode_G);
            WarehouseEntry.SetRange("Bin Code", BinCode_G);
            WarehouseEntry.SetCurrentKey("Bin Code", "Location Code", "Item No.");
            WarehouseEntry.SetAscending("Bin Code", true);
            if WarehouseEntry.FindSet() then begin
                repeat
                    ItemNoValue := WarehouseEntry."Item No.";
                    SerialNoValue := WarehouseEntry."Serial No.";
                    if ItemNoDict.ContainsKey(ItemNoValue) then begin
                        if ItemNoDict.Get(ItemNoValue).ContainsKey(SerialNoValue) then begin
                            QuantityValue := WarehouseEntry.Quantity;
                            QuantityValue += ItemNoDict.Get(ItemNoValue).Get(SerialNoValue);
                            ItemNoDict.Get(ItemNoValue).Set(SerialNoValue, QuantityValue);
                        end else begin
                            ItemNoDict.Get(ItemNoValue).Add(SerialNoValue, WarehouseEntry.Quantity);
                        end;
                    end else begin
                        ItemNoDict.Add(ItemNoValue, createSerialDictEmpty());
                        ItemNoDict.Get(ItemNoValue).Add(SerialNoValue, WarehouseEntry.Quantity);
                    end
                until WarehouseEntry.Next() = 0;
            end;

            Counter := 0;
            foreach ItemNoKey in ItemNoDict.Keys() do begin
                SerialNoDict := ItemNoDict.Get(ItemNoKey);
                foreach SerialNoKey in SerialNoDict.Keys() do begin
                    Counter += 1;
                    QuantityValue := SerialNoDict.Get(SerialNoKey);
                    if QuantityValue > 0 then begin
                        Item.Reset();
                        WarehouseEntry.Reset();

                        Item.SetRange("No.", ItemNoKey);

                        WarehouseEntry.SetRange("Location Code", LocationCode_G);
                        WarehouseEntry.SetRange("Bin Code", BinCode_G);
                        WarehouseEntry.SetRange("Item No.", ItemNoKey);
                        WarehouseEntry.SetRange("Serial No.", SerialNoKey);
                        WarehouseEntry.SetFilter(Description, '<> %1', '');

                        if WarehouseEntry.IsEmpty() then
                            WarehouseEntry.SetRange(Description);

                        if WarehouseEntry.FindFirst() then begin
                            Rec."Location Code" := WarehouseEntry."Location Code";
                            Rec."Bin Code" := WarehouseEntry."Bin Code";
                            Rec."Item No." := WarehouseEntry."Item No.";
                            Rec."Serial No." := WarehouseEntry."Serial No.";
                            Rec.Quantity := QuantityValue;
                        end;

                        if Item.FindFirst() then begin
                            Rec."Item Description" := Item.Description;
                            Rec."Item Description 2" := Item."Description 2";
                            Rec."Base Unit of Measure" := Item."Base Unit of Measure";
                        end;

                        Rec."Entry No." := Format(Counter);
                        Rec.Insert();
                    end;
                end;
            end;
        end;
    end;

    procedure AddParameters(LocationCode_L: Code[10]; BinCode_L: Code[20])
    begin
        LocationCode_G := LocationCode_L;
        BinCode_G := BinCode_L;
    end;

    local procedure createSerialDictEmpty() Result: Dictionary of [Code[50], Decimal]
    begin
        exit(Result);
    end;

    local procedure createSerialDict(KeyTmp: Code[50]; ValueTmp: Decimal) Result: Dictionary of [Code[50], Decimal]
    begin
        Result.Add(KeyTmp, ValueTmp);
        exit(Result);
    end;
}