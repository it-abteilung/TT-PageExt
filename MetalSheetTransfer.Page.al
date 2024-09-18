page 50080 "Metal Sheet Transfer"
{
    Caption = 'Buchen des Zuschnitts';
    PageType = StandardDialog;
    SourceTable = "Metal Sheet";
    DataCaptionExpression = Rec."Item No." + ' - ' + Rec."Lot No.";

    layout
    {
        area(Content)
        {
            group(General)
            {

                group(FromLocation)
                {
                    field(Available_Quantity_G; Available_Quantity_G)
                    {
                        ApplicationArea = All;
                        Caption = 'Verfügbare Menge (KG)';
                        Editable = false;
                        ShowMandatory = true;
                        ToolTip = 'Gibt die verfügbare Menge an.';
                    }
                    field("To Location"; Rec."To Location")
                    {
                        ApplicationArea = All;
                        Caption = 'Von Lagerort';
                        Editable = false;
                        ToolTip = 'Gibt den derzeitigen Lagerort an.';
                    }
                    field("To Bin"; Rec."To Bin")
                    {
                        ApplicationArea = All;
                        Caption = 'Nach Lagerplatz';
                        Editable = false;
                        ShowMandatory = true;
                        ToolTip = 'Gibt den derzeitigen Lagerplatz an.';
                    }
                }

                group(ToLocation)
                {
                    field(Required_Quantity_G; Required_Quantity_G)
                    {
                        ApplicationArea = All;
                        Caption = 'Zuschnittmenge (KG)';
                        Editable = false;
                        ShowMandatory = true;
                        ToolTip = 'Gibt die zugeschnittene Menge an.';

                        trigger OnValidate()
                        begin
                            Available_Quantity_G := CalcQuantity(Rec."Item No.", Rec."Lot No.", Rec."To Location", Rec."To Bin");

                            if Available_Quantity_G < Required_Quantity_G then
                                Error('Die verfügbare Menge reicht nicht aus.');
                        end;
                    }
                    field(ToLocation_G; ToLocation_G)
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
                    field(ToBin_G; ToBin_G)
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
            }
        }
    }

    var
        Available_Quantity_G: Decimal;
        Required_Quantity_G: Decimal;
        ToLocation_G: Code[10];
        ToBin_G: Code[20];

    trigger OnAfterGetCurrRecord()
    begin
        Available_Quantity_G := CalcQuantity(Rec."Item No.", Rec."Lot No.", Rec."To Location", Rec."To Bin");
        Required_Quantity_G := Available_Quantity_G;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
    begin
        if CloseAction = CloseAction::OK then begin
            if ToLocation_G = '' then begin
                Error('Die Umlagerung benötigt einen Lagerort.');
            end;
            if ToBin_G = '' then begin
                Error('Die Umlagerung benötigt einen Lagerplatz.');
            end;
        end;
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


    procedure GetRequiredQuantity(): Decimal
    begin
        exit(Required_Quantity_G);
    end;

    procedure GetNewLocation(): Code[10]
    begin
        exit(ToLocation_G);
    end;

    procedure GetNewBin(): Code[20]
    begin
        exit(ToBin_G);
    end;
}
