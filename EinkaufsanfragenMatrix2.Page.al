#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50054 "Einkaufsanfragen Matrix2"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type" = const(Quote));

    layout
    {
        area(content)
        {
            group(Anfrage)
            {
                field(Serienanfragennr; HeaderNo)
                {
                    ApplicationArea = Basic;
                    TableRelation = "Vendor - Serienanfrage".Serienanfragenr where(Erledigt = const(false));

                    trigger OnValidate()
                    begin
                        Rec.SetRange(Serienanfragennr, HeaderNo);
                        CurrPage.Update;
                    end;
                }
            }
            group("Matrix Options")
            {
                Caption = 'Matrix Options';
                Visible = false;
                field(MATRIX_CaptionRange; MATRIX_CaptionRange)
                {
                    ApplicationArea = Basic;
                    Caption = 'Column Set';
                    Editable = false;
                }
            }
            part(MatrixSubpage; "Einkaufsanfragen Matrix Sub2")
            {
                SubPageLink = "Document Type" = field("Document Type"),
                              Serienanfragennr = field(Serienanfragennr);
                SubPageView = where(Serienanfragennr = filter(<> ''));
                ApplicationArea = all;
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
        HeaderNo := Rec."No.";
    end;

    var
        MatrixRecRef: RecordRef;
        MatrixRecord: Record "Purchase Line";
        MatrixRecords: array[64] of Record "Purchase Line";
        MatrixMgt: Codeunit "Matrix Management";
        Matrix_ColumnCaptions: array[64] of Text[1024];
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
        PurchaseLine: Record "Purchase Line";
        purchHeader: Record "Purchase Header";
        documentNoFilter: Text;
        x: Integer;
    begin
        Clear(Matrix_ColumnCaptions);
        Clear(MatrixRecords);
        CurrentMatrixRecordOrdinal := 1;

        if Rec.Serienanfragennr <> '' then begin

            //G-ERP.AG 2021-07-22 + Anfrage#2312362

            // build a string for filter to find all purchase lines
            Clear(purchHeader);
            purchHeader.SetRange("Document Type", purchHeader."document type"::Quote);
            purchHeader.SetRange(Serienanfragennr, Rec.Serienanfragennr);
            if purchHeader.FindSet() then
                repeat
                    if documentNoFilter = '' then
                        documentNoFilter := purchHeader."No."
                    else
                        documentNoFilter := documentNoFilter + '|' + purchHeader."No.";
                until purchHeader.Next = 0;
            //G-ERP.AG 2021-07-22 -

            // get all purchaselines fltered by the purchase header no. field and type
            MatrixRecord.SetRange("Document Type", Rec."Document Type");
            //G-ERP.AG 2021-07-22 + Anfrage#2312362
            if documentNoFilter <> '' then
                MatrixRecord.SetFilter("Document No.", documentNoFilter)
            else
                //G-ERP.AG 2021-07-22 -
                MatrixRecord.SetRange("Document No.", Rec."No.");
            MatrixRecord.SetFilter(Type, '%1 | %2', MatrixRecord.Type::Item, MatrixRecord.Type::"Charge (Item)");

            //table exists
            MatrixRecRef.GetTable(MatrixRecord);
            //set table
            MatrixRecRef.SetTable(MatrixRecord);
            //get line no id
            CaptionFieldNo := MatrixRecord.FieldNo("Line No.");

            //magic
            MatrixMgt.GenerateMatrixData(MatrixRecRef, SetWanted, ArrayLen(MatrixRecords), CaptionFieldNo, MATRIX_PKFirstRecInCurrSet,
              Matrix_ColumnCaptions, MATRIX_CaptionRange, ColumnSetLength);

            // get all purchaselines fltered by the purchase header no. field and type again
            PurchaseLine.SetRange("Document Type", Rec."Document Type");
            //G-ERP.AG 2021-07-22 + Anfrage#2312362
            if documentNoFilter <> '' then
                PurchaseLine.SetFilter("Document No.", documentNoFilter)
            else
                //G-ERP.AG 2021-07-22 -
                PurchaseLine.SetRange("Document No.", Rec."No.");
            //G-ERP.AG 2021-07-22 + Anfrage#2312362
            PurchaseLine.SetFilter(Type, '%1 | %2', PurchaseLine.Type::Item, PurchaseLine.Type::"Charge (Item)");

            //remove duplicates in Matrix_ColumnCaptions
            for i := 1 to ArrayLen(Matrix_ColumnCaptions) do begin
                // if caption is not blank
                if Matrix_ColumnCaptions[i] <> '' then begin
                    // this for-loop grows every iteration
                    for x := 1 to i do begin
                        // two columns index x and i have same value, but x != i
                        if (x <> i) and (Matrix_ColumnCaptions[x] = Matrix_ColumnCaptions[i]) then
                            // set last column of the iteration to blank
                            Matrix_ColumnCaptions[i] := '';
                    end;
                end;
            end;
            //G-ERP.AG 2021-07-22 -

            for i := 1 to ArrayLen(Matrix_ColumnCaptions) do begin
                //caption is not blank
                if Matrix_ColumnCaptions[i] <> '' then begin
                    // filter by line no, this can lead to an error, if you copy a lines and bc recalcs line no
                    PurchaseLine.SetFilter("Line No.", Matrix_ColumnCaptions[i]);
                    if PurchaseLine.FindFirst then
                        Matrix_ColumnCaptions[i] := PurchaseLine."No." + ' - ' + PurchaseLine.Description + ' ' + PurchaseLine."Description 2";
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

