PageExtension 50011 pageextension50011 extends "Item List"
{
    layout
    {
        addafter(Description)
        {
            // Feld wurde mit v22.3.5.... in die Base-App aufgenommen 04.08.2023 CN 
            // field("Description 2"; Rec."Description 2")
            // {
            //     ApplicationArea = Basic;
            // }
            field("Description 3"; Rec."Description 3")
            {
                ApplicationArea = Basic;
            }
            field("Description 2 Test"; D2Test)
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter("Default Deferral Template Code")
        {
            field("Inventory complete"; Rec."Inventory complete")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter(ItemAttributesFactBox)
        {
            part(ItemPicture; "Item Picture")
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = "No." = field("No."),
                              "Date Filter" = field("Date Filter"),
                              "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                              "Location Filter" = field("Location Filter"),
                              "Drop Shipment Filter" = field("Drop Shipment Filter"),
                              "Variant Filter" = field("Variant Filter");
            }
            part(Control1000000003; "Item Seriennr Factbox")
            {
                Caption = 'Seriennr.';
                SubPageLink = "Item No." = field("No.");
                SubPageView = sorting("Item No.", "Serial No.");
                ApplicationArea = All;
            }
        }
    }
    actions
    {

        addlast(processing)
        {
            action(FindSerialNumber)
            {
                ApplicationArea = all;
                Caption = 'Artikel & Seriennummer';

                trigger OnAction()
                var
                    ItemSerialPage: Page "Artikel-Seriennr";
                begin
                    ItemSerialPage.Editable(false);
                    ItemSerialPage.RunModal();
                end;
            }
        }
        addafter(Translations)
        {
            action("Artikel Barcode")
            {
                ApplicationArea = Basic;
                Image = BarCode;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = Repeater;

                trigger OnAction()
                begin
                    Rec.SetRecfilter;
                    Report.RunModal(50036, false, false, Rec);
                    Rec.SetRange("No.");
                end;
            }
            action("Dummy Artikel anlegen")
            {
                ApplicationArea = Basic;
                Caption = 'Dummy Artikel anlegen';
                // RunObject = Report 50054;
            }
            action("New from template")
            {
                ApplicationArea = Basic;
                Caption = 'New from template';
                Image = New;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ACFunctions: Codeunit 50006;
                begin
                    //ACFunctions.CreateItemFromTemplate;
                end;
            }

        }

        addafter(CopyItem)
        {
            action("Update article number series")
            {
                ApplicationArea = Basic;
                Caption = 'Update article number series';
                Image = NumberSetup;
                // RunObject = Report 50042;
            }
            action(ImportItemsviaCSVBuffer)
            {
                ApplicationArea = All;
                Caption = 'Import Items via CSV Buffer';
                Visible = isSuper;
                Enabled = isSuper;

                trigger OnAction()
                var
                    InS: InStream;
                    FileName: Text[100];
                    UploadMsg: Label 'Please choose the CSV file';
                    Item: Record Item;
                    LineNo: Integer;
                begin
                    CSVBuffer.Reset();
                    CSVBuffer.DeleteAll();
                    if UploadIntoStream(UploadMsg, '', '', FileName, InS) then begin
                        CSVBuffer.LoadDataFromStream(InS, ',');
                        for LineNo := 2 to CSVBuffer.GetNumberOfLines() do begin
                            Clear(Item);
                            if Item.Get(GetValueAtCell(LineNo, 1)) then begin
                                if GetValueAtCell(LineNo, 2) = '""' then begin
                                    Item."Product Group Code TT" := '';
                                end else
                                    Item."Product Group Code TT" := GetValueAtCell(LineNo, 2);
                                Item.Modify();
                            end;
                        end;
                    end;
                end;
            }
            action(ServiceToProductSwitch)
            {
                ApplicationArea = All;
                Caption = 'Service to product switch';
                Visible = isSuper;
                Enabled = isSuper;

                trigger OnAction()
                var
                    ProductGroup: Record "TT Product Group";
                    ServiceItemGroup: Record "Service Item Group";
                    Item: Record Item;
                begin
                    Clear(Item);
                    Item.SetFilter("Service Item Group", '<>%1', '');
                    if Item.FindSet() then
                        repeat
                            Clear(ProductGroup);
                            if NOT ProductGroup.Get(Item."Item Category Code", Item."Service Item Group") then begin
                                ProductGroup.Init();
                                ProductGroup."Item Category Code" := Item."Item Category Code";
                                ProductGroup.Code := Item."Service Item Group";
                                ProductGroup.Insert(true);
                            end;
                            if Item."Product Group Code TT" = '' then begin
                                Item."Product Group Code TT" := ProductGroup.Code;
                                Item.Modify();
                            end;
                        until Item.Next() = 0;
                end;
            }
        }
        addafter(Orders)
        {
            group(ActionGroup100000001)
            {
                action("Artikel in Einkauf anzeigen")
                {
                    ApplicationArea = Basic;
                    Caption = 'Artikel in Einkauf anzeigen';
                    Visible = false;

                    trigger OnAction()
                    var
                        PurchaseLine_l: Record "Purchase Line";
                    // PurchaseLineItemInfo_l: Report 50048;
                    begin
                        // ((UPPERCASE(USERID) = 'TURBO-TECHNIK\KE-TH') or (UPPERCASE(USERID) = 'TURBO-TECHNIK\GERWING-ERP'))
                        PurchaseLine_l.SetRange(Type, PurchaseLine_l.Type::Item);
                        PurchaseLine_l.SetRange("No.", Rec."No.");
                        // PurchaseLineItemInfo_l.SetTableview(PurchaseLine_l);
                        // PurchaseLineItemInfo_l.RunModal();
                    end;
                }
            }
        }
    }

    var
        TempFilteredItem: Record Item temporary;
        D2Test: Text;
        CSVBuffer: Record "CSV Buffer" temporary;
        isSuper: Boolean;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        if CSVBuffer.Get(RowNo, ColNo) then
            exit(CSVBuffer.Value)
        else
            exit('');
    end;

    trigger OnAfterGetRecord()
    begin
        D2Test := '';
        if Rec."Description 2" <> '' then
            D2Test := Rec."Description 2";
    end;

    trigger OnOpenPage()
    var
        Purchaser_L: Record "Salesperson/Purchaser";
        UserSetup_L: Record "User Setup";
        UserPerm: Codeunit "User Permissions";
    begin
        CurrPage.Editable(false);
        Purchaser_L.SetRange("User ID", UserId());
        if Purchaser_L.FindFirst() then
            if Purchaser_L."Allow Edit Item" then
                CurrPage.Editable(true);
        isSuper := UserPerm.IsSuper(UserSecurityId())
    end;

}

