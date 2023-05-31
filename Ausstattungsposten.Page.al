#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50010 Ausstattungsposten
{
    PageType = List;
    SourceTable = Ausstattung_Posten;
    SourceTableView = where(Offen = filter(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Projekt Nr"; Rec."Projekt Nr")
                {
                    ApplicationArea = Basic;
                }
                field("Mitarbeiter Nr"; Rec."Mitarbeiter Nr")
                {
                    ApplicationArea = Basic;
                }
                field("Mitarbeiter Name"; Rec."Mitarbeiter Name")
                {
                    ApplicationArea = Basic;
                }
                field("Artikel Nr"; Rec."Artikel Nr")
                {
                    ApplicationArea = Basic;
                }
                field("Item.Description"; Item.Description)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Item.FIELDCAPTION(Description);
                }
                field("Item.""Description 2"""; Item."Description 2")
                {
                    ApplicationArea = Basic;
                    CaptionClass = Item.FIELDCAPTION("Description 2");
                }
                field(Seriennummer; Rec.Seriennummer)
                {
                    ApplicationArea = Basic;
                }
                field(Buchungsdatum; Rec.Buchungsdatum)
                {
                    ApplicationArea = Basic;
                }
                field(Restmenge; Rec.Restmenge)
                {
                    ApplicationArea = Basic;
                    Caption = 'Menge';
                }
                field(Einheit; Rec.Einheit)
                {
                    ApplicationArea = Basic;
                }
                field(Art; Rec.Art)
                {
                    ApplicationArea = Basic;
                }
                field("Kistennr."; Rec."Kistennr.")
                {
                    ApplicationArea = Basic;
                }
                field("Item.""Tariff No."""; Item."Tariff No.")
                {
                    ApplicationArea = Basic;
                    CaptionClass = Item.FIELDCAPTION("Tariff No.");
                }
                field("Item.""Country/Region Purchased Code"""; Item."Country/Region Purchased Code")
                {
                    ApplicationArea = Basic;
                    CaptionClass = Item.FIELDCAPTION("Country/Region Purchased Code");
                }
                field("Item.""Net Weight"""; Item."Net Weight")
                {
                    ApplicationArea = Basic;
                    CaptionClass = Item.FIELDCAPTION("Net Weight");
                }
                field("Item.""Unit Cost"""; Item."Unit Cost")
                {
                    ApplicationArea = Basic;
                    CaptionClass = Item.FIELDCAPTION("Unit Cost");
                }
                field("Item.""Standard Cost"""; Item."Standard Cost")
                {
                    ApplicationArea = Basic;
                    CaptionClass = Item.FIELDCAPTION("Standard Cost");
                }
                field("Item.""Unit Price"""; Item."Unit Price")
                {
                    ApplicationArea = Basic;
                    CaptionClass = Item.FIELDCAPTION("Unit Price");
                }
                field("Item.""Price Includes VAT"""; Item."Price Includes VAT")
                {
                    ApplicationArea = Basic;
                    CaptionClass = Item.FIELDCAPTION("Price Includes VAT");
                }
                field("ItemTranslation.Description"; ItemTranslation.Description)
                {
                    ApplicationArea = Basic;
                    CaptionClass = ItemTranslation.FIELDCAPTION(Description);
                }
                field("ItemTranslation.""Description 2"""; ItemTranslation."Description 2")
                {
                    ApplicationArea = Basic;
                    CaptionClass = ItemTranslation.FIELDCAPTION("Description 2");
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Clear(Item);
        Clear(ItemTranslation);
        if Item.Get(Rec."Artikel Nr") then;
        if ItemTranslation.Get(Rec."Artikel Nr", '', 'ENU') then;
    end;

    var
        Item: Record Item;
        ItemTranslation: Record "Item Translation";
}

