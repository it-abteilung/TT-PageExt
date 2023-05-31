#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50052 "Einkaufsanfragen Matrix"
{
    PageType = Card;
    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type" = const(Quote));

    layout
    {
        area(content)
        {
            group(Anfrage)
            {
                field("Einkaufsanfragenr."; HeaderNo)
                {
                    ApplicationArea = Basic;
                    TableRelation = "Purchase Header"."No." where("Document Type" = filter(Quote));

                    trigger OnValidate()
                    begin
                        Rec.SetRange("No.", HeaderNo);
                        CurrPage.Update;
                    end;
                }
                field(Serienanfragennr; Rec.Serienanfragennr)
                {
                    ApplicationArea = Basic;
                }
            }
            group("Matrix Options")
            {
                Caption = 'Matrix Options';
                field(MATRIX_CaptionRange; MATRIX_CaptionRange)
                {
                    ApplicationArea = Basic;
                    Caption = 'Column Set';
                    Editable = false;
                }
            }
            part(MatrixSubpage; "Einkaufsanfragen Matrix SubPag")
            {
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Previous Set")
            {
                ApplicationArea = Basic;
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the previous set of data.';

                trigger OnAction()
                begin
                    SetColumns(Setwanted::Previous);
                end;
            }
            action("Previous Column")
            {
                ApplicationArea = Basic;
                Caption = 'Previous Column';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SetColumns(Setwanted::PreviousColumn);
                end;
            }
            action("Next Column")
            {
                ApplicationArea = Basic;
                Caption = 'Next Column';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SetColumns(Setwanted::NextColumn);
                end;
            }
            action("Next Set")
            {
                ApplicationArea = Basic;
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the next set of data.';

                trigger OnAction()
                begin
                    SetColumns(Setwanted::Next);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetColumns(Setwanted::Initial);
    end;

    trigger OnOpenPage()
    begin
        SetColumns(Setwanted::Initial);
    end;

    var
        MatrixRecRef: RecordRef;
        MatrixRecord: Record "Purchase Header";
        MatrixRecords: array[32] of Record "Purchase Header";
        MatrixMgt: Codeunit "Matrix Management";
        Matrix_ColumnCaptions: array[32] of Text[1024];
        SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn;
        CaptionFieldNo: Integer;
        PKFirstRecInSet: Text;
        ColumnSet: Text[1024];
        ColumnSetLength: Integer;
        MATRIX_PKFirstRecInCurrSet: Text[100];
        MATRIX_CaptionRange: Text[100];
        HeaderNo: Code[20];

    local procedure SetColumns(SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn)
    var
        MatrixMgt: Codeunit "Matrix Management";
        CurrentMatrixRecordOrdinal: Integer;
        i: Integer;
        KredRec: Record Vendor;
    begin
        Clear(Matrix_ColumnCaptions);
        Clear(MatrixRecords);
        CurrentMatrixRecordOrdinal := 1;
        if Rec.Serienanfragennr <> '' then begin
            MatrixRecord.SetRange(Serienanfragennr, Rec.Serienanfragennr);

            MatrixRecRef.GetTable(MatrixRecord);
            MatrixRecRef.SetTable(MatrixRecord);

            CaptionFieldNo := MatrixRecord.FieldNo("Buy-from Vendor No.");


            MatrixMgt.GenerateMatrixData(MatrixRecRef, SetWanted, ArrayLen(MatrixRecords), CaptionFieldNo, MATRIX_PKFirstRecInCurrSet,
              Matrix_ColumnCaptions, MATRIX_CaptionRange, ColumnSetLength);

            for i := 1 to ArrayLen(Matrix_ColumnCaptions) do begin
                if Matrix_ColumnCaptions[i] <> '' then begin
                    if KredRec.Get(Matrix_ColumnCaptions[i]) then
                        Matrix_ColumnCaptions[i] := Matrix_ColumnCaptions[i] + ' ' + KredRec.Name;
                end;
            end;

            if ColumnSetLength > 0 then begin
                MatrixRecord.SetPosition(MATRIX_PKFirstRecInCurrSet);
                MatrixRecord.Find;
                repeat
                    MatrixRecords[CurrentMatrixRecordOrdinal].Copy(MatrixRecord);
                    CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
                until (CurrentMatrixRecordOrdinal > ColumnSetLength) or (MatrixRecord.Next <> 1);
            end;
        end;
        CurrPage.MatrixSubpage.Page.Load(Matrix_ColumnCaptions, MatrixRecords, MatrixRecord);
        CurrPage.Update(false);
    end;
}

