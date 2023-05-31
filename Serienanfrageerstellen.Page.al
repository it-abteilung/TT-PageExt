Page 50058 "Serienanfrage erstellen"
{
    AutoSplitKey = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Serienanfragen erstellen";
    SourceTableView = where("Serienanfragen erstellt" = filter(false));

    layout
    {
        area(content)
        {
            field(ProjektNr; ProjektNr)
            {
                ApplicationArea = Basic;
                Caption = 'Projekt Nr.';
                TableRelation = Job."No.";

                trigger OnValidate()
                begin
                    Rec.SetRange("Projekt Nr", ProjektNr);
                    CurrPage.Update(false);
                end;
            }
            repeater(Control1000000001)
            {
                field("Artikelnr."; Rec."Artikelnr.")
                {
                    ApplicationArea = Basic;
                    TableRelation = Item."No.";
                }
                field(Beschreibung; Rec.Beschreibung)
                {
                    ApplicationArea = Basic;
                }
                field("Beschreibung 2"; Rec."Beschreibung 2")
                {
                    ApplicationArea = Basic;
                }
                field(Menge; Rec.Menge)
                {
                    ApplicationArea = Basic;
                }
                field(Einheit; Rec.Einheit)
                {
                    ApplicationArea = Basic;
                    TableRelation = "Unit of Measure".Code;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Kreditoren auswählen")
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    L_PurchaseHeader: Record "Purchase Header" temporary;
                    L_PurchaseLine: Record "Purchase Line" temporary;
                    anfragenr: Code[20];
                begin
                    Page.RunModal(50061, Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("Projekt Nr", ProjektNr);
    end;

    var
        ProjektNr: Code[10];
}

