Page 50041 "Ausgegebenes Werkzeug"
{
    // ACO1  DAP  13.09.2021  Reset Filter OnValidate.

    PageType = List;
    SourceTable = Ausstattung_Posten;
    SourceTableView = where(Offen = filter(true));
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Filter")
            {
                Caption = 'Filter';
                field(Filter_Item; Filter_Item)
                {
                    ApplicationArea = Basic;
                    Caption = 'Artikel';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Item: Record Item;
                    begin
                        Item.SetRange("TT Type", Item."tt type"::Werkzeug);
                        Item.SetRange(Blocked, false);
                        if Page.RunModal(0, Item) = Action::LookupOK then begin
                            Filter_Item := Item."No.";
                            Rec.SetRange("Artikel Nr", Filter_Item);
                            Table_Visible := true;
                            CurrPage.Update();
                        end;
                    end;

                    trigger OnValidate()
                    var
                        Item: Record Item;
                    begin
                        if Item.Get(Filter_Item) then begin
                            Rec.SetRange("Artikel Nr", Filter_Item);
                            Table_Visible := true;
                            CurrPage.Update();
                        end else
                            // ACO1 B
                            //  IF Filter_Item = '' THEN
                            //    Table_Visible := FALSE
                            if Filter_Item = '' then begin
                                Table_Visible := false;
                                Rec.Reset;
                            end
                            // ACO1 E
                            else
                                Message(ErrorItem01, Filter_Item);
                    end;
                }
                field(Filter_Project; Filter_Project)
                {
                    ApplicationArea = Basic;
                    Caption = 'Projekt';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Job: Record Job;
                    begin
                        if Page.RunModal(0, Job) = Action::LookupOK then begin
                            Filter_Project := Job."No.";
                            Rec.SetRange("Projekt Nr", Filter_Project);
                            Table_Visible := true;
                            CurrPage.Update();
                        end;
                    end;

                    trigger OnValidate()
                    var
                        Job: Record Job;
                    begin
                        if Job.Get(Filter_Project) then begin
                            Rec.SetRange("Projekt Nr", Filter_Project);
                            Table_Visible := true;
                            CurrPage.Update();
                        end else
                            // ACO1 B
                            //  IF Filter_Item = '' THEN
                            //    Table_Visible := FALSE
                            if Filter_Project = '' then begin
                                Table_Visible := false;
                                Rec.Reset;
                            end
                            // ACO1 E
                            else
                                Message(ErrorItem01, Filter_Item);
                    end;
                }
            }
            repeater(Group)
            {
                Visible = Table_Visible;
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

    trigger OnOpenPage()
    begin
        Table_Visible := false;
    end;

    var
        Item: Record Item;
        ItemTranslation: Record "Item Translation";
        Filter_Item: Code[20];
        Filter_Project: Code[20];
        ErrorItem01: label 'Der Artikel %1 konnte nicht gefunden werden.';
        Table_Visible: Boolean;
}

