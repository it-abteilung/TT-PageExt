#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50019 "TT Job Journal"
{
    AutoSplitKey = true;
    Caption = 'Materialerfassung';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    ShowFilter = true;
    UsageCategory = Tasks;
    ApplicationArea = All;
    SourceTable = "Job Journal Line";
    SourceTableView = where(Type = const(Item));

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
                field("Mitarbeiter Nr"; Rec."Mitarbeiter Nr")
                {
                    ApplicationArea = Basic;
                    TableRelation = Resource."No.";
                }
                field(Baugruppe; Rec.Baugruppe)
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
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
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Line Amount (LCY)"; Rec."Line Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = Basic;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemLedgerEntry: Record "Item Ledger Entry";
                    begin
                        //G-ERP.RS 2019-03-19
                        ItemLedgerEntry.FilterGroup(29);
                        //ItemLedgerEntry.SETRANGE("Entry Type",ItemLedgerEntry."Entry Type"::Purchase);
                        ItemLedgerEntry.SetRange("Item No.", Rec."No.");
                        ItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
                        ItemLedgerEntry.SetFilter("Remaining Quantity", '>0');
                        ItemLedgerEntry.FilterGroup(0);

                        if Page.RunModal(0, ItemLedgerEntry) = Action::LookupOK then begin
                            if ItemLedgerEntry."Remaining Quantity" >= Rec.Quantity then begin
                                Rec."Lot No." := ItemLedgerEntry."Lot No.";
                                Rec."Applies-to Entry" := ItemLedgerEntry."Entry No.";
                                CurrPage.Update();
                            end else begin
                                Error(ERR_Quantity, Rec.Quantity);
                            end;
                        end;
                    end;
                }
                field("Applies-to Entry"; Rec."Applies-to Entry")
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
                        field(AccName; AccName)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Account Name';
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
                        Rec.SetRange(Type, Rec.Type::Item);
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
                        Rec.SetRange(Type, Rec.Type::Item);
                        CurrPage.Update(false);
                    end;
                }
            }
            group("<Action29>")
            {
                Caption = 'P&osting';
                action("<Action1000000007>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Daten einlesen';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        L_AusstattungPosten: Record Ausstattung_Posten;
                    begin
                        L_AusstattungPosten.Zeilenuebertragen();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        OnAfterGetCurrRecord;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveJobJnlLine: Codeunit "Job Jnl. Line-Reserve";
    begin
        Commit;
        /* // G-ERP 21.09.2017
        IF NOT ReserveJobJnlLine.DeleteLineConfirm(Rec) THEN
          EXIT(FALSE);
        ReserveJobJnlLine.DeleteLine(Rec);
        */ // G-ERP 21.09.2017

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::Item;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec);
        Clear(ShortcutDimCode);

        //G-ERP 06.07.2012+
        Rec.Validate("Posting Date", Today);
        Rec.Validate("Document No.", Format(Today));
        Rec.Validate(Type, Rec.Type::Item);
        //G-ERP 06.07.2012-

        OnAfterGetCurrRecord;
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
        JobDescription: Text[50];
        AccName: Text[50];
        CurrentJnlBatchName: Code[10];
        ShortcutDimCode: array[8] of Code[20];
        OpenedFromBatch: Boolean;
        LotNoVisible: Boolean;
        AppliestoEntryVisible: Boolean;
        ERR_Quantity: label 'Die Menge der Auswahl muss gleich oder größer sein als %1.';

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        JobJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
    end;
}

