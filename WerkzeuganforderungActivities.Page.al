page 61014 "Werkzeuganforderung Activities"
{
    Caption = 'Werkzeuganforderung (TT)';
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            cuegroup(Approvals)
            {
                Caption = 'Informationen zu Werkzeuganforderungen';

                field(GeneralCounter; GeneralCounter)
                {
                    ApplicationArea = Suite;
                    Caption = 'Eigene Werkzeuganf.';

                    trigger OnDrillDown()
                    var
                        WerkKopf: Record Werkzeuganforderungskopf;
                    begin
                        WerkKopf.SetRange(SystemCreatedBy, UserSecurityId());
                        Page.Run(Page::"Werkzeuganforderung Übersicht", WerkKopf);
                    end;
                }
                field(InProcessingCounter; InProcessingCounter)
                {
                    ApplicationArea = Suite;
                    Caption = 'Status: Bearbeitung';

                    trigger OnDrillDown()
                    var
                        WerkKopf: Record Werkzeuganforderungskopf;
                    begin
                        WerkKopf.SetRange(SystemCreatedBy, UserSecurityId());
                        WerkKopf.SetRange(Status, WerkKopf.Status::Bearbeitung);
                        Page.Run(Page::"Werkzeuganforderung Übersicht", WerkKopf);
                    end;
                }
                field(InClosedCounter; InClosedCounter)
                {
                    ApplicationArea = Suite;
                    Caption = 'Status: Erledigt';

                    trigger OnDrillDown()
                    var
                        WerkKopf: Record Werkzeuganforderungskopf;
                    begin
                        WerkKopf.SetRange(SystemCreatedBy, UserSecurityId());
                        WerkKopf.SetRange(Status, WerkKopf.Status::Erledigt);
                        Page.Run(Page::"Werkzeuganforderung Übersicht", WerkKopf);
                    end;
                }
                field(CollectWithinMonth; CollectWithinMonth)
                {
                    ApplicationArea = Suite;
                    Caption = 'Abholung <= 30T';

                    trigger OnDrillDown()
                    var
                        WerkKopf: Record Werkzeuganforderungskopf;
                        CollectionDate: Date;
                    begin
                        WerkKopf.SetRange(SystemCreatedBy, UserSecurityId());
                        CollectionDate := CalcDate('<30D>', Today);
                        WerkKopf.SetFilter("Abholung am", '%1..%2', Today, CollectionDate);
                        Page.Run(Page::"Werkzeuganforderung Übersicht", WerkKopf);
                    end;
                }
            }
        }
    }

    var
        GeneralCounter: Integer;
        InProcessingCounter: Integer;
        InClosedCounter: Integer;
        CollectWithinMonth: Integer;

    trigger OnOpenPage()
    var
        WerkKopf: Record Werkzeuganforderungskopf;
        CollectionDate: Date;
    begin
        WerkKopf.SetFilter(SystemCreatedBy, UserSecurityId());
        GeneralCounter := WerkKopf.Count();
        WerkKopf.SetRange(Status, WerkKopf.Status::Bearbeitung);
        InProcessingCounter := WerkKopf.Count();
        WerkKopf.SetRange(Status, WerkKopf.Status::Erledigt);
        InClosedCounter := WerkKopf.Count();
        WerkKopf.SetRange(Status);
        CollectionDate := CalcDate('<30D>', Today);
        WerkKopf.SetFilter("Abholung am", '%1..%2', Today, CollectionDate);
    end;

}