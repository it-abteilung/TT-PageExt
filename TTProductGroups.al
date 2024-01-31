page 50204 "TT Product Groups"
{
    ApplicationArea = All;
    Caption = 'TT Produktgruppen';
    PageType = List;
    SourceTable = "TT Product Group";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    Caption = 'Artikelkategorie';
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    Caption = 'Produktgruppencode';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Beschreibung';
                }
                field("Warehouse Class Code"; Rec."Warehouse Class Code")
                {
                    ApplicationArea = All;
                    Caption = 'Lagerklassencode';
                    Visible = false;
                }
            }
        }
    }
}