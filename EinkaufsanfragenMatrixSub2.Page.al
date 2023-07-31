Page 50053 "Einkaufsanfragen Matrix Sub2"
{
    // ***************************************************************
    // *                 Gerwing-ERP Software GmbH                   *
    // ***************************************************************
    // 
    // Nummer  Datum       Benutzer      Gruppe      Ticket  Bemerkung
    // 01      06.07.2021  Stalljann     Erweiterung 2312226 Hinzufügen des Feldes "Keine Angebotsabgabe" zur Page.

    CardPageID = "Purchase Quote";
    Editable = false;
    PageType = ListPart;
    SourceTable = "Purchase Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = Basic;
                }
                field("Keine Angebotsabgabe"; Rec."Keine Angebotsabgabe")
                {
                    ApplicationArea = Basic;
                }
                field(SumZeile; SumZeile)
                {
                    ApplicationArea = Basic;
                    Caption = 'Summe Kreditor';
                }
                field(Field1; MATRIX_CellData[1])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];
                    DecimalPlaces = 0 : 5;
                    Visible = Field1Visible;
                }
                field(Field2; MATRIX_CellData[2])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[2];
                    DecimalPlaces = 0 : 5;
                    Visible = Field2Visible;
                }
                field(Field3; MATRIX_CellData[3])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[3];
                    DecimalPlaces = 0 : 5;
                    Visible = Field3Visible;
                }
                field(Field4; MATRIX_CellData[4])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[4];
                    DecimalPlaces = 0 : 5;
                    Visible = Field4Visible;
                }
                field(Field5; MATRIX_CellData[5])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[5];
                    DecimalPlaces = 0 : 5;
                    Visible = Field5Visible;
                }
                field(Field6; MATRIX_CellData[6])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[6];
                    DecimalPlaces = 0 : 5;
                    Visible = Field6Visible;
                }
                field(Field7; MATRIX_CellData[7])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[7];
                    DecimalPlaces = 0 : 5;
                    Visible = Field7Visible;
                }
                field(Field8; MATRIX_CellData[8])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[8];
                    DecimalPlaces = 0 : 5;
                    Visible = Field8Visible;
                }
                field(Field9; MATRIX_CellData[9])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[9];
                    DecimalPlaces = 0 : 5;
                    Visible = Field9Visible;
                }
                field(Field10; MATRIX_CellData[10])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[10];
                    DecimalPlaces = 0 : 5;
                    Visible = Field10Visible;
                }
                field(Field11; MATRIX_CellData[11])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[11];
                    DecimalPlaces = 0 : 5;
                    Visible = Field11Visible;
                }
                field(Field12; MATRIX_CellData[12])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[12];
                    DecimalPlaces = 0 : 5;
                    Visible = Field12Visible;
                }
                field(Field13; MATRIX_CellData[13])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[13];
                    DecimalPlaces = 0 : 5;
                    Visible = Field13Visible;
                }
                field(Field14; MATRIX_CellData[14])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[14];
                    DecimalPlaces = 0 : 5;
                    Visible = Field14Visible;
                }
                field(Field15; MATRIX_CellData[15])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[15];
                    DecimalPlaces = 0 : 5;
                    Visible = Field15Visible;
                }
                field(Field16; MATRIX_CellData[16])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[16];
                    DecimalPlaces = 0 : 5;
                    Visible = Field16Visible;
                }
                field(Field17; MATRIX_CellData[17])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[17];
                    DecimalPlaces = 0 : 5;
                    Visible = Field17Visible;
                }
                field(Field18; MATRIX_CellData[18])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[18];
                    DecimalPlaces = 0 : 5;
                    Visible = Field18Visible;
                }
                field(Field19; MATRIX_CellData[19])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[19];
                    DecimalPlaces = 0 : 5;
                    Visible = Field19Visible;
                }
                field(Field20; MATRIX_CellData[20])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[20];
                    DecimalPlaces = 0 : 5;
                    Visible = Field20Visible;
                }
                field(Field21; MATRIX_CellData[21])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[21];
                    DecimalPlaces = 0 : 5;
                    Visible = Field21Visible;
                }
                field(Field22; MATRIX_CellData[22])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[22];
                    DecimalPlaces = 0 : 5;
                    Visible = Field22Visible;
                }
                field(Field23; MATRIX_CellData[23])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[23];
                    DecimalPlaces = 0 : 5;
                    Visible = Field23Visible;
                }
                field(Field24; MATRIX_CellData[24])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[24];
                    DecimalPlaces = 0 : 5;
                    Visible = Field24Visible;
                }
                field(Field25; MATRIX_CellData[25])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[25];
                    DecimalPlaces = 0 : 5;
                    Visible = Field25Visible;
                }
                field(Field26; MATRIX_CellData[26])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[26];
                    DecimalPlaces = 0 : 5;
                    Visible = Field26Visible;
                }
                field(Field27; MATRIX_CellData[27])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[27];
                    DecimalPlaces = 0 : 5;
                    Visible = Field27Visible;
                }
                field(Field28; MATRIX_CellData[28])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[28];
                    DecimalPlaces = 0 : 5;
                    Visible = Field28Visible;
                }
                field(Field29; MATRIX_CellData[29])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[29];
                    DecimalPlaces = 0 : 5;
                    Visible = Field29Visible;
                }
                field(Field30; MATRIX_CellData[30])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[30];
                    DecimalPlaces = 0 : 5;
                    Visible = Field30Visible;
                }
                field(Field31; MATRIX_CellData[31])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[31];
                    DecimalPlaces = 0 : 5;
                    Visible = Field31Visible;
                }
                field(Field32; MATRIX_CellData[32])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[32];
                    DecimalPlaces = 0 : 5;
                    Visible = Field32Visible;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Make Orders")
            {
                Caption = 'Make Order';
                Image = MakeOrder;
                action("Make Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Make &Order';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) then
                            Codeunit.Run(Codeunit::"Purch.-Quote to Order (Yes/No)", Rec);

                        Clear(VendorSerienanfrage);
                        VendorSerienanfrage.SetRange(Serienanfragenr, Rec.Serienanfragennr);
                        if VendorSerienanfrage.FindSet then
                            repeat
                                VendorSerienanfrage.Erledigt := true;
                                VendorSerienanfrage.Modify;
                            until VendorSerienanfrage.Next = 0;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        MATRIX_CurrentColumnOrdinal: Integer;
    begin
        //MATRIX_CurrentColumnOrdinal := 0;
        if MatrixRecord.FindFirst then
            repeat
                MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
                MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
            until (MatrixRecord.Next = 0) or (MATRIX_CurrentColumnOrdinal = MATRIX_NoOfMatrixColumns);
    end;

    trigger OnInit()
    begin
        Field32Visible := true;
        Field31Visible := true;
        Field30Visible := true;
        Field29Visible := true;
        Field28Visible := true;
        Field27Visible := true;
        Field26Visible := true;
        Field25Visible := true;
        Field24Visible := true;
        Field23Visible := true;
        Field22Visible := true;
        Field21Visible := true;
        Field20Visible := true;
        Field19Visible := true;
        Field18Visible := true;
        Field17Visible := true;
        Field16Visible := true;
        Field15Visible := true;
        Field14Visible := true;
        Field13Visible := true;
        Field12Visible := true;
        Field11Visible := true;
        Field10Visible := true;
        Field9Visible := true;
        Field8Visible := true;
        Field7Visible := true;
        Field6Visible := true;
        Field5Visible := true;
        Field4Visible := true;
        Field3Visible := true;
        Field2Visible := true;
        Field1Visible := true;
    end;

    trigger OnOpenPage()
    begin
        MATRIX_NoOfMatrixColumns := ArrayLen(MATRIX_CellData);
    end;

    var
        MatrixRecord: Record "Purchase Line";
        MatrixRecords: array[32] of Record "Purchase Line";
        MATRIX_CellData: array[32] of Decimal;
        MATRIX_ColumnCaption: array[32] of Text[1024];
        MATRIX_NoOfMatrixColumns: Integer;
        VendorSerienanfrage: Record "Vendor - Serienanfrage";
        [InDataSet]
        Field1Visible: Boolean;
        [InDataSet]
        Field2Visible: Boolean;
        [InDataSet]
        Field3Visible: Boolean;
        [InDataSet]
        Field4Visible: Boolean;
        [InDataSet]
        Field5Visible: Boolean;
        [InDataSet]
        Field6Visible: Boolean;
        [InDataSet]
        Field7Visible: Boolean;
        [InDataSet]
        Field8Visible: Boolean;
        [InDataSet]
        Field9Visible: Boolean;
        [InDataSet]
        Field10Visible: Boolean;
        [InDataSet]
        Field11Visible: Boolean;
        [InDataSet]
        Field12Visible: Boolean;
        [InDataSet]
        Field13Visible: Boolean;
        [InDataSet]
        Field14Visible: Boolean;
        [InDataSet]
        Field15Visible: Boolean;
        [InDataSet]
        Field16Visible: Boolean;
        [InDataSet]
        Field17Visible: Boolean;
        [InDataSet]
        Field18Visible: Boolean;
        [InDataSet]
        Field19Visible: Boolean;
        [InDataSet]
        Field20Visible: Boolean;
        [InDataSet]
        Field21Visible: Boolean;
        [InDataSet]
        Field22Visible: Boolean;
        [InDataSet]
        Field23Visible: Boolean;
        [InDataSet]
        Field24Visible: Boolean;
        [InDataSet]
        Field25Visible: Boolean;
        [InDataSet]
        Field26Visible: Boolean;
        [InDataSet]
        Field27Visible: Boolean;
        [InDataSet]
        Field28Visible: Boolean;
        [InDataSet]
        Field29Visible: Boolean;
        [InDataSet]
        Field30Visible: Boolean;
        [InDataSet]
        Field31Visible: Boolean;
        [InDataSet]
        Field32Visible: Boolean;
        MatrixColumnCount: Integer;
        SumZeile: Decimal;
        No_alt: Code[20];
        LineNo_alt: Integer;
        ItemNo_alt: Code[20];


    procedure Load(MatrixColumns1: array[32] of Text[1024]; var MatrixRecords1: array[32] of Record "Purchase Line"; var MatrixRecord1: Record "Purchase Line")
    begin
        CopyArray(MATRIX_ColumnCaption, MatrixColumns1, 1);
        CopyArray(MatrixRecords, MatrixRecords1, 1);
        MatrixRecord.Copy(MatrixRecord1);
        No_alt := '';
        LineNo_alt := 0;
        ItemNo_alt := '';
    end;

    local procedure MATRIX_OnAfterGetRecord(ColumnID: Integer)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        Clear(PurchaseLine);
        //PurchaseLine.copy(Rec);
        PurchaseLine.SetRange("Document Type", Rec."Document Type");
        PurchaseLine.SetRange("Document No.", Rec."No.");
        PurchaseLine.SetRange("Line No.", MatrixRecords[ColumnID]."Line No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if PurchaseLine.FindFirst then;
        MATRIX_CellData[ColumnID] := PurchaseLine.Amount;

        if (Rec."No." = No_alt) and (PurchaseLine."Line No." <> 0) then //G-ERP.RS 2019-02-06
            if LineNo_alt > PurchaseLine."Line No." then
                SumZeile := 0;
        if No_alt <> Rec."No." then
            SumZeile := 0;

        if (LineNo_alt = PurchaseLine."Line No.") and (ItemNo_alt = PurchaseLine."No.") then
            if SumZeile <> 0 then
                MATRIX_CellData[ColumnID] := 0;

        No_alt := Rec."No.";
        LineNo_alt := PurchaseLine."Line No.";
        ItemNo_alt := PurchaseLine."No.";
        SumZeile := SumZeile + MATRIX_CellData[ColumnID];
        SetVisible;
    end;


    procedure SetVisible()
    begin
        Field1Visible := MATRIX_ColumnCaption[1] <> '';
        Field2Visible := MATRIX_ColumnCaption[2] <> '';
        Field3Visible := MATRIX_ColumnCaption[3] <> '';
        Field4Visible := MATRIX_ColumnCaption[4] <> '';
        Field5Visible := MATRIX_ColumnCaption[5] <> '';
        Field6Visible := MATRIX_ColumnCaption[6] <> '';
        Field7Visible := MATRIX_ColumnCaption[7] <> '';
        Field8Visible := MATRIX_ColumnCaption[8] <> '';
        Field9Visible := MATRIX_ColumnCaption[9] <> '';
        Field10Visible := MATRIX_ColumnCaption[10] <> '';
        Field11Visible := MATRIX_ColumnCaption[11] <> '';
        Field12Visible := MATRIX_ColumnCaption[12] <> '';
        Field13Visible := MATRIX_ColumnCaption[13] <> '';
        Field14Visible := MATRIX_ColumnCaption[14] <> '';
        Field15Visible := MATRIX_ColumnCaption[15] <> '';
        Field16Visible := MATRIX_ColumnCaption[16] <> '';
        Field17Visible := MATRIX_ColumnCaption[17] <> '';
        Field18Visible := MATRIX_ColumnCaption[18] <> '';
        Field19Visible := MATRIX_ColumnCaption[19] <> '';
        Field20Visible := MATRIX_ColumnCaption[20] <> '';
        Field21Visible := MATRIX_ColumnCaption[21] <> '';
        Field22Visible := MATRIX_ColumnCaption[22] <> '';
        Field23Visible := MATRIX_ColumnCaption[23] <> '';
        Field24Visible := MATRIX_ColumnCaption[24] <> '';
        Field25Visible := MATRIX_ColumnCaption[25] <> '';
        Field26Visible := MATRIX_ColumnCaption[26] <> '';
        Field27Visible := MATRIX_ColumnCaption[27] <> '';
        Field28Visible := MATRIX_ColumnCaption[28] <> '';
        Field29Visible := MATRIX_ColumnCaption[29] <> '';
        Field30Visible := MATRIX_ColumnCaption[30] <> '';
        Field31Visible := MATRIX_ColumnCaption[31] <> '';
        Field32Visible := MATRIX_ColumnCaption[32] <> '';
    end;
}

