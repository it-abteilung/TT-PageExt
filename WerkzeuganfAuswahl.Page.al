page 61011 "Werkzeuganf. Auswahl"
{
    Caption = 'Werkzeuganforderung - Auswahl';
    PageType = List;
    SourceTable = "Temp. Werkzeuganforderung";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Zuerst muss die Liste mit "Liste bearbeiten" aktiviert werden, ansonsten wird die Eingabe blockiert.';

                field(ItemCategory; ItemCategory)
                {
                    ApplicationArea = All;
                    Caption = 'Artikelkategorie';
                    TableRelation = "Item Category";

                    trigger OnValidate()
                    begin
                        Rec.Reset();
                        if ItemCategory <> '' then Rec.SetRange("Item Category Code", ItemCategory);
                        CurrPage.Update();
                    end;
                }
            }
            repeater(GeneralList)
            {

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Artikelnr.';
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Beschreibung';
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Caption = 'Beschreibung 2';
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    Caption = 'Basiseinheit';
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("On-Stock Quantity"; Rec."On-Stock Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Lagerbestand';
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Required Quantity"; Rec."Required Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Benötigte Menge';
                    ToolTip = 'Specifies the value of the No. field.';
                }
                // field("Hazardous Substance"; Rec."Hazardous Substance")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Ist Gefahrstoff';
                //     ToolTip = 'Specifies the value of the Hazardous Substance field.';
                // }
            }
        }
    }
    var
        ItemCategory: Code[20];

    trigger OnOpenPage()
    begin
        CurrPage.Editable := true;
    end;
}
