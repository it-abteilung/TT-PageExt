Page 50076 "Werkzeuganforderung Übersicht"
{
    CardPageID = "Werkzeuganforderung Kopf";
    DataCaptionFields = "Projekt Nr";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Werkzeuganforderungskopf;
    Caption = 'Werkzeuganforderung (TT)';
    UsageCategory = Documents;
    ApplicationArea = All;

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
                field("Lfd Nr"; Rec."Lfd Nr")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Stichwort; Rec.Stichwort)
                {
                    ApplicationArea = Basic;
                }
                field(Belegdatum; Rec.Belegdatum)
                {
                    ApplicationArea = Basic;
                }
                field("Geplantes Versanddatum"; Rec."Geplantes Versanddatum")
                {
                    ApplicationArea = Basic;
                }
                field(Beschreibung; Rec.Beschreibung)
                {
                    ApplicationArea = Basic;
                }
                field("Beschreibung 2"; Rec."Beschreibung 2")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Drucken';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Werkzeuganforderungskopf_l: Record Werkzeuganforderungskopf;
                    WerkzeuganforderungWerkzeug_l: Report 50066;
                begin
                    Clear(Werkzeuganforderungskopf_l);
                    Werkzeuganforderungskopf_l.SetRange("Projekt Nr", Rec."Projekt Nr");
                    Werkzeuganforderungskopf_l.SetRange("Lfd Nr", Rec."Lfd Nr");
                    WerkzeuganforderungWerkzeug_l.SetTableview(Werkzeuganforderungskopf_l);
                    WerkzeuganforderungWerkzeug_l.RunModal();
                end;
            }
            action(Compare)
            {
                ApplicationArea = all;
                Caption = 'Abgleich mit Paketen';
                Image = ItemAvailability;

                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PackageTreeListDlg: Page "Package Tree List Dlg";
                    PackageTreeList: Page "Package Tree List";
                    JobMap: List of [Dictionary of [Code[20], Integer]];
                    Bin: Record Bin;
                begin
                    if PackageTreeListDlg.RunModal() = Action::OK then begin
                        if PackageTreeListDlg.GetAllowStandardBinCode() then
                            PackageTreeList.SetBinFilter(PackageTreeListDlg.GetStandardBinCode() + ' | ' + PackageTreeListDlg.GetFromBinCode() + '..' + PackageTreeListDlg.GetToBinCode())
                        else
                            PackageTreeList.SetBinFilter(PackageTreeListDlg.GetFromBinCode() + '..' + PackageTreeListDlg.GetToBinCode());
                        if PackageTreeListDlg.IsAutoSetJob() then begin
                            PackageTreeList.SetJobNo(PackageTreeListDlg.GetJobNo());
                        end else begin
                            PackageTreeListDlg.GetJobMap(JobMap);
                            PackageTreeList.SetJobMap(JobMap);
                        end;
                        PackageTreeList.Run();
                    end;
                end;
            }
            action(WeldingSupervisiors)
            {
                ApplicationArea = Basic;
                Caption = 'Schweißaufsichten';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                RunObject = Page "Welding Supervisiors";
            }
        }
    }

    views
    {
        view(ShowStatusCreate)
        {
            Caption = 'Nur Status "Erstellt"';
            Filters = where(Status = filter(Erstellt));
        }
        view(ShowStatusProcessing)
        {
            Caption = 'Nur Status "Bearbeitung"';
            Filters = where(Status = filter(Bearbeitung));
        }
        view(ShowStatusClosed)
        {
            Caption = 'Nur Status "Erledigt"';
            Filters = where(Status = filter(Erledigt));
        }
        view(LastWeek)
        {
            Caption = 'Erstellt in der letzten Woche';
            Filters = where("Creation Date" = filter('<-1W>..T'));
        }
        view(LastMonth)
        {
            Caption = 'Erstellt im letzten Monat';
            Filters = where("Creation Date" = filter('<-1M>..T'));
        }
        view(CollectionWeek)
        {
            Caption = 'Abholung <= 7T';
            Filters = where("Abholung am" = filter('T..<7D>'));
        }
        view(CollectionMonth)
        {
            Caption = 'Abholung <= 30T';
            Filters = where("Abholung am" = filter('T..<30D>'));
        }
    }

    var
        Materialanforderung2: Record Materialanforderungzeile;
        Lfd: Integer;
        Projektnr: Code[20];
        Materialanforderung: Record Materialanforderungskopf;
}

