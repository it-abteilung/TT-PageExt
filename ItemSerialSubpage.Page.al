#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50091 "Item Serial Subpage"
{
    Caption = 'Seriennummer / Lagerort';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Item Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Bin Code"; BinCode_g)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lagerplatz Code';
                    Editable = false;
                }
                field("Goods Receiving Date"; Rec."Goods Receiving Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Serial No. Description_g"; "Serial No. Description_g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Serien Nr. Beschreibung';
                    Editable = false;
                }
                field("Serial No. Description 2_g"; "Serial No. Description 2_g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Serien Nr. Beschreibung 2';
                    Editable = false;
                }
                field(Manufacturer_g; Manufacturer_g)
                {
                    ApplicationArea = Basic;
                    Caption = 'Hersteller';

                    trigger OnValidate()
                    var
                        ArtikelSeriennr_l: Record "Artikel-Seriennr";
                    begin
                        SetValue(30);
                    end;
                }
                field("Manufacturer Type_g"; "Manufacturer Type_g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Hersteller Typ';

                    trigger OnValidate()
                    begin
                        SetValue(40);
                    end;
                }
                field("Manufacturer Serial No._g"; "Manufacturer Serial No._g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Hersteller Serien Nr.';

                    trigger OnValidate()
                    begin
                        SetValue(50);
                    end;
                }
                field("Manufacturer Description_g"; "Manufacturer Description_g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Hersteller Beschreibung';

                    trigger OnValidate()
                    begin
                        SetValue(55);
                    end;
                }
                field(Electricity_g; Electricity_g)
                {
                    ApplicationArea = Basic;
                    Caption = 'Strom';

                    trigger OnValidate()
                    begin
                        SetValue(60);
                    end;
                }
                field(Voltage_g; Voltage_g)
                {
                    ApplicationArea = Basic;
                    Caption = 'Spannung';

                    trigger OnValidate()
                    begin
                        SetValue(70);
                    end;
                }
                field(Power_g; Power_g)
                {
                    ApplicationArea = Basic;
                    Caption = 'Leistung';

                    trigger OnValidate()
                    begin
                        SetValue(80);
                    end;
                }
                field("Next Exam_g"; "Next Exam_g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Nächste Prüfung';

                    trigger OnValidate()
                    begin
                        SetValue(90);
                    end;
                }
                field("Construction Year_g"; "Construction Year_g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Baujahr';

                    trigger OnValidate()
                    begin
                        SetValue(100);
                    end;
                }
                field(ZG_g; ZG_g)
                {
                    ApplicationArea = Basic;
                    Caption = 'ZG';

                    trigger OnValidate()
                    begin
                        SetValue(110);
                    end;
                }
                field("Load capacity_g"; "Load capacity_g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Traglast';

                    trigger OnValidate()
                    begin
                        SetValue(120);
                    end;
                }
                field("Lifting height_g"; "Lifting height_g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Hubhöhe';

                    trigger OnValidate()
                    begin
                        SetValue(130);
                    end;
                }
                field("Weight (kg)_g"; "Weight (kg)_g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Gewicht (kg)';

                    trigger OnValidate()
                    begin
                        SetValue(140);
                    end;
                }
                field("Object ID_g"; "Object ID_g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Objekt ID';

                    trigger OnValidate()
                    begin
                        SetValue(200);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        ArtikelSeriennr_l: Record "Artikel-Seriennr";
    begin
        BinCode_g := '';
        "Serial No. Description_g" := '';
        "Serial No. Description 2_g" := '';
        Manufacturer_g := '';
        "Manufacturer Type_g" := '';
        "Manufacturer Serial No._g" := '';
        "Manufacturer Description_g" := '';
        Electricity_g := '';
        Voltage_g := '';
        Power_g := '';
        "Next Exam_g" := 0D;
        "Construction Year_g" := '';
        ZG_g := 0D;
        "Load capacity_g" := 0;
        "Lifting height_g" := '';
        "Weight (kg)_g" := 0;
        "Object ID_g" := '';

        Clear(WarehouseEntry_g);
        WarehouseEntry_g.SetCurrentkey("Entry No.");
        WarehouseEntry_g.Ascending();
        WarehouseEntry_g.SetRange("Item No.", Rec."Item No.");
        WarehouseEntry_g.SetRange("Serial No.", Rec."Serial No.");
        WarehouseEntry_g.SetRange("Location Code", Rec."Location Code");
        if WarehouseEntry_g.FindLast() then;
        BinCode_g := WarehouseEntry_g."Bin Code";

        if ArtikelSeriennr_l.Get(Rec."Item No.", Rec."Serial No.") then begin
            "Serial No. Description_g" := ArtikelSeriennr_l."Serial No. Description";
            "Serial No. Description 2_g" := ArtikelSeriennr_l."Serial No. Description 2";
            Manufacturer_g := ArtikelSeriennr_l.Hersteller;
            "Manufacturer Type_g" := ArtikelSeriennr_l."Hersteller Typ";
            "Manufacturer Serial No._g" := ArtikelSeriennr_l."Hersteller Seriennr.";
            "Manufacturer Description_g" := ArtikelSeriennr_l."Hersteller-Bezeichnung";
            Electricity_g := ArtikelSeriennr_l.Strom;
            Voltage_g := ArtikelSeriennr_l.Spannung;
            Power_g := ArtikelSeriennr_l.Leistung;
            "Next Exam_g" := ArtikelSeriennr_l."Nächste Prüfung";
            "Construction Year_g" := ArtikelSeriennr_l.Baujahr;
            ZG_g := ArtikelSeriennr_l.ZG;
            "Load capacity_g" := ArtikelSeriennr_l.Traglast;
            "Lifting height_g" := ArtikelSeriennr_l.Hubhöhe;
            "Weight (kg)_g" := ArtikelSeriennr_l."Gewicht (kg)";
            "Object ID_g" := ArtikelSeriennr_l."Object ID";
        end;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Open, true);
        Rec.SetFilter("Remaining Quantity", '<>0');
        Rec.SetFilter("Serial No.", '<>%1', '');
    end;

    var
        WarehouseEntry_g: Record "Warehouse Entry";
        BinCode_g: Code[20];
        "Serial No. Description_g": Text[50];
        "Serial No. Description 2_g": Text[50];
        Manufacturer_g: Text[50];
        "Manufacturer Type_g": Text[50];
        "Manufacturer Serial No._g": Text[50];
        "Manufacturer Description_g": Text[50];
        Electricity_g: Text[50];
        Voltage_g: Text[50];
        Power_g: Text[50];
        "Next Exam_g": Date;
        "Construction Year_g": Text[50];
        ZG_g: Date;
        "Load capacity_g": Decimal;
        "Lifting height_g": Text[50];
        "Weight (kg)_g": Decimal;
        "Object ID_g": Code[20];
        ERR_ItemSerialNo: label 'Die Artikel- und Serien Nummer dürfen nicht leer sein.';

    local procedure SetValue(p_FieldNo: Integer)
    var
        ArtikelSeriennr_l: Record "Artikel-Seriennr";
    begin
        // Feldnummern für die Übergabe
        // 10Serial No. Description
        // 20Serial No. Description 2
        // 30Hersteller
        // 40Hersteller Typ
        // 50Hersteller Seriennr.
        // 55Hersteller-Bezeichnung
        // 60Strom
        // 70Spannung
        // 80Leistung
        // 90Nächste Prüfung
        // 100Baujahr
        // 110ZG
        // 120Traglast
        // 130Hubhöhe
        // 140Gewicht (kg)
        // 200Object ID

        if (Rec."Item No." = '') or (Rec."Serial No." = '') then
            Error(ERR_ItemSerialNo);

        if not ArtikelSeriennr_l.Get(Rec."Item No.", Rec."Serial No.") then begin
            ArtikelSeriennr_l.Init();
            ArtikelSeriennr_l."Item No." := Rec."Item No.";
            ArtikelSeriennr_l."Serial No." := Rec."Serial No.";
            ArtikelSeriennr_l.Description := Rec.Description;
            ArtikelSeriennr_l."Description 2" := Rec."Description 2";
            ArtikelSeriennr_l.Insert();
        end;

        if ArtikelSeriennr_l.Get(Rec."Item No.", Rec."Serial No.") then begin
            case p_FieldNo of
                10:
                    ArtikelSeriennr_l."Serial No. Description" := "Serial No. Description_g";
                20:
                    ArtikelSeriennr_l."Serial No. Description 2" := "Serial No. Description 2_g";
                30:
                    ArtikelSeriennr_l.Hersteller := Manufacturer_g;
                40:
                    ArtikelSeriennr_l."Hersteller Typ" := "Manufacturer Type_g";
                50:
                    ArtikelSeriennr_l."Hersteller Seriennr." := "Manufacturer Serial No._g";
                55:
                    ArtikelSeriennr_l."Hersteller-Bezeichnung" := "Manufacturer Description_g";
                60:
                    ArtikelSeriennr_l.Strom := Electricity_g;
                70:
                    ArtikelSeriennr_l.Spannung := Voltage_g;
                80:
                    ArtikelSeriennr_l.Leistung := Power_g;
                90:
                    ArtikelSeriennr_l."Nächste Prüfung" := "Next Exam_g";
                100:
                    ArtikelSeriennr_l.Baujahr := "Construction Year_g";
                110:
                    ArtikelSeriennr_l.ZG := ZG_g;
                120:
                    ArtikelSeriennr_l.Traglast := "Load capacity_g";
                130:
                    ArtikelSeriennr_l.Hubhöhe := "Lifting height_g";
                140:
                    ArtikelSeriennr_l."Gewicht (kg)" := "Weight (kg)_g";
                200:
                    ArtikelSeriennr_l."Object ID" := "Object ID_g";
                else
                    Error('Die Feldnummer %1 konnte nicht gefunden werden.', p_FieldNo);
            end;
            ArtikelSeriennr_l.Modify();
        end;

        CurrPage.Update(false);
    end;
}

