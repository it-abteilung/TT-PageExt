#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50089 "Kred offene Posten ausbuchen"
{
    Editable = false;
    PageType = List;
    SourceTable = "Vendor Ledger Entry";
    SourceTableView = sorting("Vendor No.", Open, Positive, "Due Date", "Currency Code")
                      where(Open = const(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor.Name"; Vendor.Name)
                {
                    ApplicationArea = Basic;
                    Caption = 'Kreditorname';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code"; Rec."Currency Code")
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
            group(ActionGroup100000010)
            {
                action(Buchen)
                {
                    ApplicationArea = Basic;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        genJournalLine: Record "Gen. Journal Line";
                        vendorLedgerEntry: Record "Vendor Ledger Entry";
                        lfdnr: Integer;
                    begin
                        if Rec.GetFilters() = '' then
                            Error('Bitte Liste filtern');

                        if Confirm('Möchten Sie die offenen Posten ausbuchen', false) then begin
                            Clear(genJournalLine);
                            genJournalLine.SetRange("Journal Template Name", 'ZAHLUNGSAU');
                            genJournalLine.SetRange("Journal Batch Name", 'SYSTEM');
                            if genJournalLine.FindFirst then
                                genJournalLine.DeleteAll;

                            lfdnr := 0;

                            vendorLedgerEntry.CopyFilters(Rec);
                            if vendorLedgerEntry.FindSet() then
                                repeat
                                    vendorLedgerEntry.CalcFields("Remaining Amount");
                                    lfdnr += 10000;
                                    Clear(genJournalLine);
                                    genJournalLine.Validate("Journal Template Name", 'ZAHLUNGSAU');
                                    genJournalLine.Validate("Journal Batch Name", 'SYSTEM');
                                    genJournalLine.Validate("Line No.", lfdnr);
                                    genJournalLine.Insert(true);
                                    genJournalLine.Validate("Posting Date", Today);
                                    genJournalLine.Validate("Document No.", 'AUSBUCH_' + Format(Date2dmy(Today, 3)) + Format(Date2dmy(Today, 2)) + Format(Date2dmy(Today, 1)));
                                    genJournalLine.Validate("Document Type", genJournalLine."document type"::Payment);
                                    genJournalLine.Validate("Account Type", genJournalLine."account type"::Vendor);
                                    genJournalLine.Validate("Account No.", vendorLedgerEntry."Vendor No.");
                                    if (vendorLedgerEntry."Currency Code" <> '') and (vendorLedgerEntry."Currency Code" <> 'EUR') then
                                        genJournalLine.Validate("Currency Code", vendorLedgerEntry."Currency Code");
                                    genJournalLine.Validate(Amount, -vendorLedgerEntry."Remaining Amount");
                                    genJournalLine.Validate("Bal. Account Type", genJournalLine."bal. account type"::"G/L Account");
                                    genJournalLine.Validate("Bal. Account No.", '1210');
                                    genJournalLine.Validate("Applies-to Doc. Type", vendorLedgerEntry."Document Type");
                                    genJournalLine.Validate("Applies-to Doc. No.", vendorLedgerEntry."Document No.");
                                    genJournalLine.Modify(true);
                                    Codeunit.Run(12, genJournalLine);
                                until vendorLedgerEntry.Next = 0;
                            /*
                            genJournalLine.SETRANGE("Journal Template Name",'ZAHLUNGSAU');
                            genJournalLine.SETRANGE("Journal Batch Name",'SYSTEM');
                            IF genJournalLine.FINDFIRST THEN
                              CODEUNIT.RUN(12,genJournalLine);
                            */
                            CurrPage.Update(false);
                        end;

                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if not Vendor.Get(Rec."Vendor No.") then
            Vendor.Init;
    end;

    var
        Vendor: Record Vendor;
}

