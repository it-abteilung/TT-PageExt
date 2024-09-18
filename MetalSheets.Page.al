/*
    Zeigt alle Einträge aus der Tabelle "Metal Sheet" an
*/

page 50081 "Metal Sheets"
{
    ApplicationArea = All;
    Caption = 'Restbleche';
    Editable = false;
    PageType = List;
    CardPageId = "Metal Sheet";
    UsageCategory = Lists;
    SourceTable = "Metal Sheet";
    AdditionalSearchTerms = 'Zuschnitt, Blech, Bleche';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Caption = 'Lfd. Nr.';
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    Caption = 'Artikelnr.';
                }
                field(ItemDescription; ItemDescription_G)
                {
                    Caption = 'Artikelbeschreibung';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Caption = 'Chargennr.';
                }
                field("Original Lot No."; Rec."Original Lot No.")
                {
                    Caption = 'Herkunfts-Chargennr.';
                    Editable = false;
                }
                field(Available_Quantity_G; Available_Quantity_G)
                {
                    Caption = 'Verfügbare Menge';
                }
                field("To Location"; Rec."To Location")
                {
                    Caption = 'Lagerort';
                }
                field("To Bin"; Rec."To Bin")
                {
                    Caption = 'Lagerplatz';
                }

                field("Is Nipped"; Rec."Is Nipped")
                {
                    Caption = 'Ist Genoppt';
                }
                field("Is Punched"; Rec."Is Punched")
                {
                    Caption = 'Ist Gestanzt';
                }
                field(Format; Rec.Format)
                {
                    Caption = 'Format';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Beschreibung';
                }
                field("Length A"; Rec."Length A")
                {
                    Caption = 'Länge A';
                }
                field("Length B"; Rec."Length B")
                {
                    Caption = 'Länge B';
                }
                field("Width A"; Rec."Width A")
                {
                    Caption = 'Breite A';
                }
                field("Width B"; Rec."Width B")
                {
                    Caption = 'Breite B';
                }
                field("Circle Diameter"; Rec."Circle Diameter")
                {
                    Caption = 'Kreisdurchmesser';
                }
                field("Area"; Rec."Area")
                {
                    Caption = 'Fläche';
                }
            }
        }
    }

    var
        ItemDescription_G: Text;
        Available_Quantity_G: Decimal;

    trigger OnAfterGetRecord()
    var
        Item: Record Item;
        WarehouseEntry: Record "Warehouse Entry";
    begin
        Available_Quantity_G := 0;
        ItemDescription_G := '';
        if Item.Get(Rec."Item No.") then
            ItemDescription_G := Item.Description;
        WarehouseEntry.SetRange("Location Code", Rec."To Location");
        WarehouseEntry.SetRange("Bin Code", Rec."To Bin");
        WarehouseEntry.SetRange("Item No.", Rec."Item No.");
        WarehouseEntry.SetRange("Lot No.", Rec."Lot No.");
        if WarehouseEntry.FindSet() then
            repeat
                Available_Quantity_G += WarehouseEntry.Quantity;
            until WarehouseEntry.Next() = 0;
    end;
}