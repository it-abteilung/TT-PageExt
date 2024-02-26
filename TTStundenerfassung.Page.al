Page 50055 "TT Stundenerfassung"
{
    AutoSplitKey = true;
    Caption = 'Stundenerfassung (TT)';
    DataCaptionFields = "Journal Batch Name";
    UsageCategory = Tasks;
    ApplicationArea = All;

    AdditionalSearchTerms = 'Stundenerfassung';
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Job Journal Line";
    SourceTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.")
                      where("Journal Batch Name" = const('STANDARD'),
                            Type = const(Resource));

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic;
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    JobJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    JobJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(Baugruppe; Rec.Baugruppe)
                {
                    ApplicationArea = Basic;
                }
                field(Pos; Rec.Pos)
                {
                    ApplicationArea = Basic;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    var
                        L_JobJournalLine: Record "Job Journal Line";
                        L_JobLedgerEntry: Record "Job Ledger Entry";
                        L_MengeStd: Decimal;
                        L_Text50000: label 'Stunden für die Ressource Nr. %1 wurden für den %2 schon erfasst bzw. gebucht! Ist die Erfassung korrekt?';
                        BereitsErfasst: Boolean;
                        BereitsGebucht: Boolean;
                    begin
                        //G-ERP.KBS 2018-06-06 +
                        BereitsErfasst := false;
                        BereitsGebucht := false;

                        L_JobJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                        L_JobJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        L_JobJournalLine.SetRange("Posting Date", Rec."Posting Date");
                        L_JobJournalLine.SetRange(Type, Rec.Type);
                        L_JobJournalLine.SetRange("No.", Rec."No.");
                        if L_JobJournalLine.FindSet then begin
                            BereitsErfasst := true;
                            //  REPEAT
                            //   L_MengeStd := L_MengeStd + L_JobJournalLine.Quantity;
                            //  UNTIL L_JobJournalLine.NEXT = 0;
                        end;

                        L_JobLedgerEntry.SetRange("Posting Date", Rec."Posting Date");
                        L_JobLedgerEntry.SetRange(Type, Rec.Type);
                        L_JobLedgerEntry.SetRange("No.", Rec."No.");
                        // L_JobLedgerEntry.CALCSUMS(Quantity);
                        // L_MengeStd := L_MengeStd + L_JobLedgerEntry.Quantity;
                        if L_JobLedgerEntry.FindSet then begin
                            BereitsGebucht := true;
                        end;

                        if BereitsErfasst or BereitsGebucht then begin
                            if not Confirm(L_Text50000, false, Rec."No.", Rec."Posting Date") then begin
                                Rec.Quantity := 0;
                            end;
                        end;
                        //G-ERP.KBS 2018-06-06 -
                    end;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Direct Unit Cost (LCY)"; Rec."Direct Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field("Line Amount"; Rec."Line Amount")
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
                        field(JobDescription; JobDescription)
                        {
                            ApplicationArea = Basic;
                            Editable = false;
                        }
                    }
                    group("Account Name")
                    {
                        Caption = 'Account Name';
                        Visible = false;
                        field(AccName; AccName)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Account Name';
                            Editable = false;
                            Visible = false;
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
            group("&Job")
            {
                Caption = '&Job';
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Job Card";
                    RunPageLink = "No." = field("Job No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Job No." = field("Job No.");
                    RunPageView = sorting("Job No.", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                action("Test Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintJobJnlLine(Rec);
                    end;
                }
                action("P&ost")
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Job Jnl.-Post", Rec);
                        CurrentJnlBatchName := Rec.GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Job Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := Rec.GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        GetNames();
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveJobJnlLine: Codeunit "Job Jnl. Line-Reserve";
    begin
        Commit;
        if not ReserveJobJnlLine.DeleteLineConfirm(Rec) then
            exit(false);
        ReserveJobJnlLine.DeleteLine(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec);
        Clear(ShortcutDimCode);
        GetNames();

        //G-ERP 06.07.2012+
        Rec.Validate("Posting Date", Today);
        Rec.Validate("Document No.", Format(Today));
        Rec.Validate(Type, Rec.Type::Resource);
        //G-ERP 06.07.2012-
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        OpenedFromBatch := (Rec."Journal Batch Name" <> '') and (Rec."Journal Template Name" = '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := Rec."Journal Batch Name";
            JobJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        JobJnlManagement.TemplateSelection(Page::"Job Journal", false, Rec, JnlSelected);
        JobJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        JobJnlManagement: Codeunit JobJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        JobDescription: Text[100];
        AccName: Text[50];
        CurrentJnlBatchName: Code[10];
        ShortcutDimCode: array[8] of Code[20];
        OpenedFromBatch: Boolean;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        JobJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    local procedure GetNames()
    begin
        xRec := Rec;
        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
    end;
}

