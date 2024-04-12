page 50107 "Storage Means"
{
    ApplicationArea = all;
    Caption = 'Lagermittel';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Bin";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            group(TopGeneral)
            {
                Caption = 'Allgemein';
                ShowCaption = false;
                field(LocationCode; LocationCode_G)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lagerortcode';

                    TableRelation = Location.Code;

                    trigger OnValidate()
                    var
                        Bin: Record Bin;
                    begin
                        if (NOT Bin.Get(LocationCode_G, BinCode_G)) OR (LocationCode_G = '') then
                            BinCode_G := '';
                        ApplySelection(LocationCode_G, BinCode_G);
                    end;
                }
                field(BinCode; BinCode_G)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lagerplatzcode';
                    TableRelation = Bin.Code;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Bin: Record "Bin";
                        BinPage: Page "Bin List";
                    begin
                        if LocationCode_G <> '' then begin
                            Bin.SetRange("Location Code", LocationCode_G);
                            BinPage.SetTableView(Bin);
                            BinPage.Editable(false);
                            if BinPage.RunModal() = Action::OK then begin
                                BinPage.GetRecord(Bin);
                                BinCode_G := Bin.Code;
                                ApplySelection(LocationCode_G, BinCode_G);
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if LocationCode_G = '' then
                            Error('Lagerplatzcode darf nicht leer sein.');
                        ApplySelection(LocationCode_G, BinCode_G);
                    end;
                }
                field(SelectPacketFilter; SelectPacketFilter_G)
                {
                    ApplicationArea = All;
                    Caption = 'Unterprojekte & Packete anzeigen';
                    ToolTip = 'Gibt an, ob alle Unterprojekte & Packete berücksichtigt werden sollen.';

                    trigger OnValidate()
                    begin
                        ApplySelection(LocationCode_G, BinCode_G);
                    end;
                }
            }
            repeater(General)
            {
                Editable = true;
                field("Code"; Rec."Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Lagerplatzcode';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        StorageMeansTemp: Page "Storage Means Temp.";
                    begin
                        StorageMeansTemp.AddParameters(LocationCode_G, BinCode_G);
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
                    Visible = false;
                }
                field(RemainingQuantity; RemainingQuantity_G)
                {
                    ApplicationArea = Basic;
                    Caption = 'Menge';
                    Editable = false;
                    Visible = false;
                }
                field(RemainingQuantityBase; RemainingQuantityBase_G)
                {
                    ApplicationArea = Basic;
                    Caption = 'Menge(Basis)';
                    Editable = false;
                    Visible = false;
                }
                field("Inspection Status"; Rec."Inspection Status")
                {
                    ApplicationArea = Basic;
                    Caption = 'Abgehakt';

                    trigger OnValidate()
                    var
                        Bin: Record Bin;
                        Job: Record Job;
                    begin
                        if Rec."Inspection Status" then begin
                            Rec."Inspector Code" := UserId();
                            Rec."Inspection Date" := Today();

                            if Job.Get(Rec.Code) then begin
                                Bin.SetRange("Location Code", Rec."Location Code");
                                Bin.SetFilter(Code, '%1', Rec.Code + '*');
                                if Bin.FindSet() then
                                    repeat
                                        if NOT Job.Get(Bin.Code) then begin
                                            Bin.Validate("Inspection Status", true);
                                            Bin.Validate("Inspector Code", UserId());
                                            Bin.Validate("Inspection Date", Today());
                                            Bin.Modify();
                                        end;
                                    until Bin.Next() = 0;
                            end;
                        end;
                    end;
                }
                field("Inspector Code"; Rec."Inspector Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Abgehackt von';
                    Editable = false;
                    Visible = false;
                }
                field("Inspection Date"; Rec."Inspection Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Abgehackt am';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref(ShowInspectedRecords; "Show Inspected Records") { }
        }
        area(processing)
        {
            action("Show Inspected Records")
            {
                ApplicationArea = All;
                Caption = 'Abgehakte Lagerplätze';
                Image = CalendarWorkcenter;

                RunPageMode = Edit;
                RunObject = Page "Storage Means Closed";
            }
        }
    }

    var
        LocationCode_G: Code[10];
        BinCode_G: Code[20];
        SelectPacketFilter_G: Boolean;
        RemainingQuantity_G: Decimal;
        RemainingQuantityBase_G: Decimal;

    trigger OnAfterGetRecord()
    var
        BinContent: Record "Bin Content";
    begin
        RemainingQuantity_G := 0;
        RemainingQuantityBase_G := 0;
        Clear(BinContent);
        BinContent.SetRange("Location Code", LocationCode_G);
        if SelectPacketFilter_G then
            BinContent.SetFilter("Bin Code", '%1', BinCode_G + '*')
        else
            BinContent.SetRange("Bin Code", BinCode_G);
        if BinContent.FindSet() then begin
            repeat
                RemainingQuantity_G += BinContent.CalcQtyUOM();
                RemainingQuantityBase_G += BinContent."Quantity (Base)";
            until BinContent.Next() = 0;
        end;
    end;

    trigger OnOpenPage()
    begin
        LocationCode_G := 'PROJEKT';
        BinCode_G := '';
        ApplySelection(LocationCode_G, BinCode_G);
    end;

    procedure ApplySelection(LocationCode_L: Code[10]; BinCode_L: Code[20])
    begin
        Rec.SetRange(Empty, false);
        Rec.SetRange("Inspection Status", false);
        Rec.SetRange("Location Code", LocationCode_L);
        if BinCode_L = '' then begin
            if LocationCode_L = 'PROJEKT' then
                Rec.SetFilter(Code, '%1', '*-*.*')
            else
                Rec.SetRange(Code);
        end else begin
            if SelectPacketFilter_G then
                Rec.SetFilter(Code, '%1', BinCode_L + '*')
            else
                Rec.SetRange(Code, BinCode_L);
        end;

        CurrPage.Update(false);
    end;
}

