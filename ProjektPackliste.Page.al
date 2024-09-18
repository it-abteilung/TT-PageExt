#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50057 "Projekt Packliste"
{
    AutoSplitKey = true;
    Caption = 'Materialerfassung';
    DelayedInsert = true;
    Editable = true;
    PageType = Worksheet;
    SourceTable = "Projekt Packliste";
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(ProjectNo; ProjectNo)
            {
                ApplicationArea = Basic;
                Caption = 'Batch Name';
                Lookup = true;
                LookupPageID = "Job List";
                TableRelation = Job;

                trigger OnValidate()
                begin
                    JobRec.Get(ProjectNo);
                    Rec.SetRange("Projektnr.", ProjectNo);
                    CurrPage.Update();
                end;
            }
            field(RepLeiter; RepLeiter)
            {
                ApplicationArea = Basic;
                Caption = 'Repair Manager No.';
                TableRelation = Resource;

                trigger OnValidate()
                var
                    L_ResourceRec: Record Resource;
                begin
                    Rec.Reparaturleiter := RepLeiter;
                    RepLeitername := '';
                    if L_ResourceRec.Get(RepLeiter) then
                        RepLeitername := L_ResourceRec.Name;
                    CurrPage.Update();
                end;
            }
            field(RepLeitername; RepLeitername)
            {
                ApplicationArea = Basic;
                Caption = 'Repair Manager Name';
                Editable = false;
            }
            repeater(Control1)
            {
                field("Artikelnr."; Rec."Artikelnr.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field(Beschreibung; Rec.Beschreibung)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Beschreibung 2"; Rec."Beschreibung 2")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Menge; Rec.Menge)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control73)
            {
                fixed(Control1902114901)
                {
                    group("Job Description")
                    {
                        Caption = 'Job Description';
                        field("JobRec.Description"; JobRec.Description)
                        {
                            ApplicationArea = Basic;
                            Editable = false;
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
        area(processing)
        {
            action(Bearbeiten)
            {
                ApplicationArea = Basic;
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';

                trigger OnAction()
                begin
                    Page.RunModal(50057, Rec);
                end;
            }
            group("<Action29>")
            {
                Caption = 'P&osting';
                action("<Action57>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    var
                        l_ProjektPackliste: Record "Projekt Packliste";
                    begin
                        l_ProjektPackliste.SetRange("Projektnr.", ProjectNo);
                        if l_ProjektPackliste.FindSet then
                            Report.RunModal(50044, true, false, l_ProjektPackliste);
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    var
        ReserveJobJnlLine: Codeunit "Job Jnl. Line-Reserve";
    begin
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if ProjectNo = '' then
            Error('Bitte Projekt auswählen');
        Rec."Projektnr." := ProjectNo;
        Rec.Reparaturleiter := RepLeiter;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        Rec.SetRange("Projektnr.", ProjectNo);
    end;

    var
        JobJnlManagement: Codeunit JobJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        JobDescription: Text[50];
        AccName: Text[50];
        CurrentJnlBatchName: Code[10];
        ShortcutDimCode: array[8] of Code[20];
        OpenedFromBatch: Boolean;
        ProjectNo: Code[10];
        JobRec: Record Job;
        RepLeiter: Code[20];
        RepLeitername: Text[50];

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
    end;
}

