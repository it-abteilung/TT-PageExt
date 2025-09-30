page 50110 "Item Vendor Purchase List"
{
    ApplicationArea = All;
    Caption = 'Item Vendor Purchase List';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    PageType = Worksheet;
    SourceTable = "Vendor";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;
                field(ItemNo_G; ItemNo_G)
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the item number of the item.';
                    TableRelation = "Item"."No.";

                    trigger OnValidate()
                    var
                        Item_L: Record Item;
                    begin
                        ItemDescription_G := '';
                        if Item_L.Get(ItemNo_G) then
                            ItemDescription_G := Item_L.Description;
                        ApplyVendorFilter();
                    end;
                }
                field(itemDescription_G; ItemDescription_G)
                {
                    ApplicationArea = All;
                    Caption = 'Item Description';
                    ToolTip = 'Specifies the description of the item.';
                    Editable = false;
                }
            }
            repeater("Vendor Purchase List")
            {

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
        }
    }


    var
        ItemNo_G: Code[20];
        ItemDescription_G: Text;

    trigger OnOpenPage()
    begin
    end;

    local procedure ApplyVendorFilter()
    var
        Item_L: Record Item;
        VendorNoList_L: List of [Code[20]];
        VendorNo_L: Code[20];
        Vendor_L: Record Vendor;
        PurchaseHeader_L: Record "Purchase Header";
        PurchaseLine_L: Record "Purchase Line";
        PurchInvHeader_L: Record "Purch. Inv. Header";
        PurchInvLine_L: Record "Purch. Inv. Line";
    begin

        // get item
        if Item_L.Get(ItemNo_G) then begin
            Clear(PurchaseLine_L);
            PurchaseLine_L.SetRange("No.", Item_L."No.");
            if PurchaseLine_L.FindSet() then begin
                repeat
                    if PurchaseHeader_L.Get(PurchaseLine_L."Document Type", PurchaseLine_L."Document No.") then begin
                        if NOT VendorNoList_L.Contains(PurchaseHeader_L."Buy-from Vendor No.") then
                            VendorNoList_L.Add(PurchaseHeader_L."Buy-from Vendor No.");
                    end;
                until PurchaseLine_L.Next() = 0;
            end;

            Clear(PurchInvLine_L);
            PurchInvLine_L.SetRange("No.", Item_L."No.");
            if PurchInvLine_L.FindSet() then begin
                repeat
                    if PurchInvHeader_L.Get(PurchInvLine_L."Document No.") then begin
                        if NOT VendorNoList_L.Contains(PurchInvHeader_L."Buy-from Vendor No.") then
                            VendorNoList_L.Add(PurchInvHeader_L."Buy-from Vendor No.");
                    end;
                until PurchInvLine_L.Next() = 0;
            end;
        end;

        Rec.DeleteAll();
        foreach VendorNo_L in VendorNoList_L do begin
            Rec.Init();
            Rec."No." := VendorNo_L;
            if Vendor_L.Get(VendorNo_L) then begin
                Rec.Name := Vendor_L.Name;
            end;
            Rec.Insert();
        end;
        CurrPage.Update();
    end;
}