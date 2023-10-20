Page 50043 "Package Tree List Dlg"
{
    Caption = 'Vergleiche Packstücke mit Werkzeuganforderungen';
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = '';
                field(StandardBinCode; StandardBinCode)
                {
                    ApplicationArea = All;
                    Caption = 'Lagerplatz';
                    TableRelation = Bin.Code;
                    ToolTip = 'Gibt den Lagerplatz an.';

                    trigger OnValidate()
                    begin
                        CalcSelectedBins();
                    end;
                }
                field(SelectPacketFilter; SelectPacketFilter)
                {
                    ApplicationArea = all;
                    Caption = 'Alle Packstücke';
                    ToolTip = 'Gibt an, ob alle Packstücke berücksichtigt werden sollen.';

                    trigger OnValidate()
                    begin
                        CalcSelectedBins();
                    end;
                }
                field(AllowStandardBinCode; AllowStandardBinCode)
                {
                    ApplicationArea = All;
                    Caption = 'Mit Lagerplatz';
                    ToolTip = 'Gibt an, ob der Lagerplatz auch in den Vergleich aufgenommen werden soll.';
                }
            }

            group(Bounds)
            {
                Caption = 'Packstücke';
                field(FromBinCode; FromBinCode)
                {
                    ApplicationArea = All;
                    Caption = 'Von Packstück';
                    Editable = NOT SelectPacketFilter;
                    ToolTip = 'Gibt das erste Packstück an.';

                    trigger OnValidate()
                    var
                        Bin: Record Bin;
                    begin
                        Bin.SetFilter(Code, '%1 & %2', FromBinCode, StandardBinCode + '-P*');
                        if Bin.IsEmpty() then
                            Error('Paket %1 für %2 nicht gefunden', FromBinCode, StandardBinCode);
                        if FromBinCode > ToBinCode then
                            Error('Das Feld "Von Packstück" muss kleiner-gleich dem Feld "Bis Packstück" sein.');
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Bin: Record Bin;
                    begin
                        Bin.SetFilter(Code, '%1', StandardBinCode + '-P*');
                        if Page.RunModal(Page::"Bin List", Bin) = Action::LookupOK then begin
                            FromBinCode := Bin.Code;
                        end;
                        if FromBinCode > ToBinCode then
                            Error('Das Feld "Von Packstück" muss kleiner-gleich dem Feld "Bis Packstück" sein.');
                    end;
                }
                field(ToBinCode; ToBinCode)
                {
                    ApplicationArea = all;
                    Caption = 'Bis Packstück';
                    Editable = NOT SelectPacketFilter;
                    ToolTip = 'Gibt das letzte Packstück an.';
                    trigger OnValidate()
                    var
                        Bin: Record Bin;
                    begin
                        Bin.SetFilter(Code, '%1 & %2', ToBinCode, StandardBinCode + '-P*');
                        if Bin.IsEmpty() then
                            Error('Paket %1 für %2 nicht gefunden', ToBinCode, StandardBinCode);
                        if FromBinCode > ToBinCode then
                            Error('Das Feld "Von Packstück" muss kleiner-gleich dem Feld "Bis Packstück" sein.');
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Bin: Record Bin;
                    begin
                        Bin.SetFilter(Code, '%1', StandardBinCode + '-P*');
                        if Page.RunModal(Page::"Bin List", Bin) = Action::LookupOK then begin
                            ToBincode := Bin.Code;
                        end;
                        if FromBinCode > ToBinCode then
                            Error('Das Feld "Von Packstück" muss kleiner-gleich dem Feld "Bis Packstück" sein.');
                    end;
                }

            }
            group(Target)
            {
                Caption = 'Werkzeuganforderungen';

                field(WerkzeugKopfText; WerkzeugKopfText)
                {
                    ApplicationArea = All;
                    Caption = 'Filter';
                    ToolTip = 'Filter nach Werkzeuganforderungen';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        WerkzeugKopf: Record Werkzeuganforderungskopf;
                        WerkzeugList: Page "Werkzeuganforderung Übersicht";
                        Dict: Dictionary of [Code[20], Integer];
                    begin
                        if WerkzeugList.RunModal() = Action::OK then begin
                            WerkzeugList.SetSelectionFilter(WerkzeugKopf);
                            WerkzeugKopf.MarkedOnly(true);
                            if WerkzeugKopf.FindSet() then begin
                                repeat
                                    Dict := createDictEmpty();
                                    Dict.Add(WerkzeugKopf."Projekt Nr", WerkzeugKopf."Lfd Nr");
                                    JobMap.Add(Dict);
                                until WerkzeugKopf.Next() = 0;
                            end;
                            WerkzeugKopfText := WerkzeugKopf.GetFilters();
                        end;
                    end;

                }
            }
        }
    }

    var
        StandardBinCode: Code[20];
        FromBinCode: Code[20];
        ToBinCode: Code[20];
        SelectPacketFilter: Boolean;
        AllowStandardBinCode: Boolean;
        WerkzeugKopfText: Text;
        JobMap: List of [Dictionary of [Code[20], Integer]];

    trigger OnOpenPage()
    begin
        SelectPacketFilter := true;
    end;

    procedure CalcSelectedBins()
    var
        Bin: Record Bin;
    begin
        FromBinCode := '';
        ToBinCode := '';
        if StandardBinCode <> '' then begin
            Bin.SetFilter(Code, '%1', StandardBinCode + '-P*');
            Bin.SetCurrentKey("Code");
            if Bin.FindFirst() then
                FromBinCode := Bin."Code";
            if Bin.FindLast() then begin
                ToBinCode := Bin."Code";
            end;
        end;
    end;

    local procedure createDictEmpty() Result: Dictionary of [Code[20], Integer]
    begin
        exit(Result);
    end;

    procedure GetStandardBinCode(): Code[20]
    begin
        exit(StandardBinCode);
    end;

    procedure GetFromBinCode(): Code[20];
    begin
        exit(FromBinCode);
    end;

    procedure GetToBinCode(): Code[20];
    begin
        exit(ToBinCode);
    end;

    procedure GetSelectPacketFilter(): Boolean;
    begin
        exit(SelectPacketFilter);
    end;

    procedure GetAllowStandardBinCode(): Boolean
    begin
        exit(AllowStandardBinCode);
    end;

    procedure SetJobMap(JobMap_L: List of [Dictionary of [Code[20], Integer]])
    begin
        JobMap := JobMap_L;
    end;

    procedure GetJobMap(var JobMap_L: List of [Dictionary of [Code[20], Integer]])
    var
        Dict: Dictionary of [Code[20], Integer];
    begin
        foreach Dict in JobMap do begin
            JobMap_L.Add(Dict);
        end;
    end;
}