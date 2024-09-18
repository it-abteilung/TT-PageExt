page 50046 "Memo. Goods Receipts"
{
    ApplicationArea = All;
    Caption = 'TT Fehler im Wareneingang';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Memo. Goods Receipt";
    DelayedInsert = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Editable = isStorageWorker;
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    Caption = 'Bestellnr.';
                    ToolTip = ' Eine noch nicht fakturierte Bestellung, diese als Grundlage für die Posten dient.';
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    Caption = 'Projektnr.';
                    Editable = false;
                    ToolTip = 'Wird vom System autom. gesetzt, sobald eine Artikelnr. ausgewählt wurde.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'TT Artikelnr.';
                    ToolTip = 'Wird von der Bestellung vorgegeben.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PurchaseHeader_L: Record "Purchase Header";
                        PurchaseLine_L: Record "Purchase Line";
                        PurchaseLineGoodsReceipt: Page "Purchase Line Goods Receipts";
                        Item: Record Item;
                        ItemList: Page "Item List";
                    begin
                        if PurchaseHeader_L.Get(PurchaseHeader_L."Document Type"::Order, Rec."Order No.") then begin
                            PurchaseLine_L.SetRange("Document Type", PurchaseHeader_L."Document Type");
                            PurchaseLine_L.SetRange("Document No.", PurchaseHeader_L."No.");
                            PurchaseLine_L.SetRange(PurchaseLine_L.Type, PurchaseLine_L.Type::Item);
                            if PurchaseLine_L.FindSet() then begin
                                PurchaseLineGoodsReceipt.Editable(false);
                                PurchaseLineGoodsReceipt.SetTableView(PurchaseLine_L);
                                if PurchaseLineGoodsReceipt.RunModal() = Action::OK then begin
                                    PurchaseLineGoodsReceipt.GetRecord(PurchaseLine_L);
                                    Rec."Job No." := PurchaseLine_L."Job No.";
                                    Rec."Item No." := PurchaseLine_L."No.";
                                    Rec.Description := PurchaseLine_L.Description;
                                    Rec."Quantity Received" := PurchaseLine_L."Quantity Received";
                                    Rec."Quantity Ordered" := PurchaseLine_L."Quantity";
                                    Rec.Modify();
                                    // CurrPage.Update();
                                end
                            end;
                        end;
                    end;

                    // Ware kann geliefert werden, diese nicht auf dem WE steht, also soll keine Validierung durchgeführt werden. 12.06.24 CN 
                    // trigger OnValidate()
                    // var
                    //     PurchaseHeader_L: Record "Purchase Header";
                    //     PurchaseLine_L: Record "Purchase Line";
                    //     Item: Record Item;
                    // begin
                    //     Rec.Testfield("Order No.");
                    //     if PurchaseHeader_L.Get(PurchaseHeader_L."Document Type"::Order, Rec."Order No.") then begin
                    //         PurchaseLine_L.SetRange("Document Type", PurchaseHeader_L."Document Type");
                    //         PurchaseLine_L.SetRange("Document No.", PurchaseHeader_L."No.");
                    //         PurchaseLine_L.SetRange(PurchaseLine_L.Type, PurchaseLine_L.Type::Item);
                    //         PurchaseLine_L.SetRange("No.", Rec."Item No.");

                    //         if PurchaseLine_L.FindSet() then begin
                    //             Rec.Description := PurchaseLine_L.Description;
                    //             Rec."Quantity Received" := PurchaseLine_L."Quantity Received";
                    //             CurrPage.Update();
                    //         end else
                    //             Error('Keine offene Einkaufszeile für die Artikelnr. gefunden.');
                    //     end;
                    // end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Beschreibung';
                    Editable = false;
                }
                field("Quantity Ordered"; Rec."Quantity Ordered")
                {
                    ApplicationArea = All;
                    Caption = 'Bestellte Menge';
                    Editable = false;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = All;
                    Caption = 'Gebuchte Menge';
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Tatsächliche Menge';
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;
                    Caption = 'Begründung';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    Caption = 'Erledigt';
                }
            }
        }
    }

    var
        isStorageWorker: Boolean;

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.SetRange("User ID", UserId());
        if UserSetup.FindFirst() then begin
            isStorageWorker := UserSetup."Edit Memo Goods Receipt";
        end;
    end;

    trigger OnAfterGetCurrRecord()
    var
        PurchaseHeader_L: Record "Purchase Header";
        PurchaseLine_L: Record "Purchase Line";
    begin
        if (Rec."Order No." <> '') AND (Rec."Item No." <> '') then begin
            if PurchaseHeader_L.Get(PurchaseHeader_L."Document Type"::Order, Rec."Order No.") then begin
                PurchaseLine_L.SetRange("Document Type", PurchaseHeader_L."Document Type");
                PurchaseLine_L.SetRange("Document No.", PurchaseHeader_L."No.");
                PurchaseLine_L.SetRange(PurchaseLine_L.Type, PurchaseLine_L.Type::Item);
                PurchaseLine_L.SetRange("No.", Rec."Item No.");
                if PurchaseLine_L.FindLast() then begin
                    if Rec."Quantity Received" <> PurchaseLine_L."Quantity Received" then begin
                        Rec."Quantity Received" := PurchaseLine_L."Quantity Received";
                        Rec.Modify();
                    end;
                end;
            end;
        end;
    end;
}