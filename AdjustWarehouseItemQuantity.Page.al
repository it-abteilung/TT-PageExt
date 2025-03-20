page 50097 "Adjust Warehouse Item Quantity"
{
    ApplicationArea = All;
    Caption = 'Anpassen Lagerartikelmenge';
    PageType = StandardDialog;
    Permissions = tabledata "Warehouse Entry" = RIM;

    layout
    {
        area(content)
        {
            Group(General)
            {

                field("Journal Batch Name"; "JournalBatchName_G")
                {
                    ApplicationArea = Basic;
                    Caption = 'Buch.-Blatt';

                    TableRelation = "Warehouse Journal Batch".Name;
                }
                field("Location Code"; LocationCode_G)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lagerort';
                    TableRelation = Location."Code";
                }
                field("Bin Code"; BinCode_G)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lagerplatz';
                    TableRelation = Bin.Code;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Bin_L: Record Bin;
                        BinList_P: Page "Bin List";
                    begin
                        Bin_L.SetRange("Location Code", LocationCode_G);
                        if Bin_L.FindSet() then begin
                            BinList_P.SetTableView(Bin_L);
                            if BinList_P.RunModal() = Action::LookupOK then begin
                                BinCode_G := Bin_L.Code;
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    var
                        Bin_L: Record Bin;
                    begin
                        If NOT Bin_L.Get(LocationCode_G, BinCode_G) then
                            Error('Lagerplatz %1 in %2 nicht gefunden', BinCode_G, LocationCode_G);
                    end;
                }
                field("Item No."; ItemNo_G)
                {
                    ApplicationArea = Basic;
                    Caption = 'Artikel-Nr.';
                    TableRelation = Item."No.";

                    trigger OnValidate()
                    var
                        BinContent: Record "Bin Content";
                    begin
                        BinContent.SetRange("Location Code", LocationCode_G);
                        BinContent.SetRange("Bin Code", BinCode_G);
                        BinContent.SetRange("Item No.", ItemNo_G);
                        if BinContent.IsEmpty() then begin
                            Error('Artikel %1 nicht im Lagerplatz %2 in %3 gefunden', ItemNo_G, BinCode_G, LocationCode_G);
                        end
                    end;
                }
                field(Quantity; Quantity_G)
                {
                    ApplicationArea = Basic;
                    Caption = 'Delta Menge';
                }
            }
        }
    }

    var
        JournalBatchName_G: Text[10];
        LocationCode_G: Code[10];
        BinCode_G: Code[20];
        ItemNo_G: Code[20];
        Quantity_G: Decimal;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        WarehouseEntry_L: Record "Warehouse Entry";
        Item_L: Record Item;
    begin
        if Confirm('Buchung fortsetzen?') then begin
            if JournalBatchName_G = '' then begin
                Error('Buchungsblatt muss angegeben werden!');
            end;
            if LocationCode_G = '' then begin
                Error('Lagerort muss angegeben werden!');
            end;
            if BinCode_G = '' then begin
                Error('Lagerplatz muss angegeben werden!');
            end;
            if ItemNo_G = '' then begin
                Error('Artikel-Nr. muss angegeben werden!');
            end;
            if Quantity_G = 0 then begin
                Error('Menge muss angegeben werden!');
            end;
            Item_L.Get(ItemNo_G);

            WarehouseEntry_L.Init();
            WarehouseEntry_L."Entry No." := WarehouseEntry_L.GetLastEntryNo() + 1;
            WarehouseEntry_L."Journal Batch Name" := JournalBatchName_G;
            WarehouseEntry_L."Location Code" := LocationCode_G;
            WarehouseEntry_L."Bin Code" := BinCode_G;
            WarehouseEntry_L."Item No." := ItemNo_G;
            WarehouseEntry_L.Quantity := Quantity_G;
            WarehouseEntry_L."Qty. (Base)" := Quantity_G;
            WarehouseEntry_L."Unit of Measure Code" := Item_L."Base Unit of Measure";
            WarehouseEntry_L.insert(true);
        end;
    end;

}