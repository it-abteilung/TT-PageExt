page 50109 "Storage Means Closed"
{
    Caption = 'Abgehakte Lagerplätze';
    InsertAllowed = false;
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Bin";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Lagerplatzcode';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        StorageMeansTemp: Page "Storage Means Temp.";
                    begin
                        StorageMeansTemp.AddParameters(Rec."Location Code", Rec.Code);
                        StorageMeansTemp.RunModal();
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Beschreibung';
                    Editable = false;
                }
                field(Empty; Rec.Empty)
                {
                    ApplicationArea = Basic;
                }
                field(RemainingQuantity; RemainingQuantity_G)
                {
                    ApplicationArea = Basic;
                    Caption = 'Menge';
                    Editable = false;
                }
                field(RemainingQuantityBase; RemainingQuantityBase_G)
                {
                    ApplicationArea = Basic;
                    Caption = 'Menge(Basis)';
                    Editable = false;
                }
                field("Inspection Status"; Rec."Inspection Status")
                {
                    ApplicationArea = Basic;
                    Caption = 'Abgehakt';
                    // Editable = false;

                    trigger OnValidate()
                    begin
                        if Rec."Inspection Status" then begin
                            Rec."Inspector Code" := UserId();
                            Rec."Inspection Date" := Today();
                        end;
                    end;
                }
                field("Inspector Code"; Rec."Inspector Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Abgehakt von';
                    Editable = false;
                }
                field("Inspection Date"; Rec."Inspection Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Abgehakt am';
                    Editable = false;
                }
                field("Closed Status"; Rec."Closed Status")
                {
                    ApplicationArea = Basic;
                    Caption = 'Geschlossen';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        if Rec."Closed Status" then begin
                            Rec."Closer Code" := UserId();
                            Rec."Closing Date" := Today();
                        end;
                    end;
                }
                field("Closer Code"; Rec."Closer Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Geschlossen von';
                    Editable = false;
                }
                field("Closing Date"; Rec."Closing Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Geschlossen am';
                    Editable = false;
                }
            }
        }
    }
    views
    {
        view(LastWeek)
        {
            Caption = 'Letzte Woche';
            Filters = where("Inspection Date" = filter('<-1W>..T'));
        }
        view(LastMonth)
        {
            Caption = 'Letzten Monat';
            Filters = where("Inspection Date" = filter('<-1M>..T'));
        }
        view(LastYear)
        {
            Caption = 'Letztes Jahr';
            Filters = where("Inspection Date" = filter('<-1Y>..T'));
        }
    }
    var
        RemainingQuantity_G: Decimal;
        RemainingQuantityBase_G: Decimal;

    trigger OnAfterGetRecord()
    var
        BinContent: Record "Bin Content";
    begin
        RemainingQuantity_G := 0;
        RemainingQuantityBase_G := 0;
        Clear(BinContent);
        BinContent.SetRange("Location Code", Rec."Location Code");
        BinContent.SetFilter("Bin Code", '%1', Rec.Code);
        if BinContent.FindSet() then begin
            repeat
                RemainingQuantity_G += BinContent.CalcQtyUOM();
                RemainingQuantityBase_G += BinContent."Quantity (Base)";
            until BinContent.Next() = 0;
        end;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Empty, false);
        Rec.SetRange("Inspection Status", true);
        CurrPage.Update(false);
    end;
}