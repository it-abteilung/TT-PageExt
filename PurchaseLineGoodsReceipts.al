page 50047 "Purchase Line Goods Receipts"
{
    Caption = 'Liste - Offene Bestellungen mit Posten';
    PageType = List;
    SourceTable = "Purchase Line";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Bestellnr.';
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    Caption = 'Projektnr.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'TT Artikelnr.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Bestellte Menge';
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = All;
                    Caption = 'Gebuchte Menge';
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Restmenge';
                }
            }
        }
    }
}