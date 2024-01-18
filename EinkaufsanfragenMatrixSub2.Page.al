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
                field(Field33; MATRIX_CellData[33])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[33];
                    DecimalPlaces = 0 : 5;
                    Visible = Field33Visible;
                }
                field(Field34; MATRIX_CellData[34])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[34];
                    DecimalPlaces = 0 : 5;
                    Visible = Field34Visible;
                }
                field(Field35; MATRIX_CellData[35])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[35];
                    DecimalPlaces = 0 : 5;
                    Visible = Field35Visible;
                }
                field(Field36; MATRIX_CellData[36])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[36];
                    DecimalPlaces = 0 : 5;
                    Visible = Field36Visible;
                }
                field(Field37; MATRIX_CellData[37])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[37];
                    DecimalPlaces = 0 : 5;
                    Visible = Field37Visible;
                }
                field(Field38; MATRIX_CellData[38])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[38];
                    DecimalPlaces = 0 : 5;
                    Visible = Field38Visible;
                }
                field(Field39; MATRIX_CellData[39])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[39];
                    DecimalPlaces = 0 : 5;
                    Visible = Field39Visible;
                }
                field(Field40; MATRIX_CellData[40])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[40];
                    DecimalPlaces = 0 : 5;
                    Visible = Field40Visible;
                }
                field(Field41; MATRIX_CellData[41])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[41];
                    DecimalPlaces = 0 : 5;
                    Visible = Field41Visible;
                }
                field(Field42; MATRIX_CellData[42])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[42];
                    DecimalPlaces = 0 : 5;
                    Visible = Field42Visible;
                }
                field(Field43; MATRIX_CellData[43])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[43];
                    DecimalPlaces = 0 : 5;
                    Visible = Field43Visible;
                }
                field(Field44; MATRIX_CellData[44])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[44];
                    DecimalPlaces = 0 : 5;
                    Visible = Field44Visible;
                }
                field(Field45; MATRIX_CellData[45])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[45];
                    DecimalPlaces = 0 : 5;
                    Visible = Field45Visible;
                }
                field(Field46; MATRIX_CellData[46])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[46];
                    DecimalPlaces = 0 : 5;
                    Visible = Field46Visible;
                }
                field(Field47; MATRIX_CellData[47])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[47];
                    DecimalPlaces = 0 : 5;
                    Visible = Field47Visible;
                }
                field(Field48; MATRIX_CellData[48])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[48];
                    DecimalPlaces = 0 : 5;
                    Visible = Field48Visible;
                }
                field(Field49; MATRIX_CellData[49])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[49];
                    DecimalPlaces = 0 : 5;
                    Visible = Field49Visible;
                }
                field(Field50; MATRIX_CellData[50])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[50];
                    DecimalPlaces = 0 : 5;
                    Visible = Field50Visible;
                }
                field(Field51; MATRIX_CellData[51])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[51];
                    DecimalPlaces = 0 : 5;
                    Visible = Field51Visible;
                }
                field(Field52; MATRIX_CellData[52])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[52];
                    DecimalPlaces = 0 : 5;
                    Visible = Field52Visible;
                }
                field(Field53; MATRIX_CellData[53])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[53];
                    DecimalPlaces = 0 : 5;
                    Visible = Field53Visible;
                }
                field(Field54; MATRIX_CellData[54])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[54];
                    DecimalPlaces = 0 : 5;
                    Visible = Field54Visible;
                }
                field(Field55; MATRIX_CellData[55])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[55];
                    DecimalPlaces = 0 : 5;
                    Visible = Field55Visible;
                }
                field(Field56; MATRIX_CellData[56])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[56];
                    DecimalPlaces = 0 : 5;
                    Visible = Field56Visible;
                }
                field(Field57; MATRIX_CellData[57])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[57];
                    DecimalPlaces = 0 : 5;
                    Visible = Field57Visible;
                }
                field(Field58; MATRIX_CellData[58])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[58];
                    DecimalPlaces = 0 : 5;
                    Visible = Field58Visible;
                }
                field(Field59; MATRIX_CellData[59])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[59];
                    DecimalPlaces = 0 : 5;
                    Visible = Field59Visible;
                }
                field(Field60; MATRIX_CellData[60])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[60];
                    DecimalPlaces = 0 : 5;
                    Visible = Field60Visible;
                }
                field(Field61; MATRIX_CellData[61])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[61];
                    DecimalPlaces = 0 : 5;
                    Visible = Field61Visible;
                }
                field(Field62; MATRIX_CellData[62])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[62];
                    DecimalPlaces = 0 : 5;
                    Visible = Field62Visible;
                }
                field(Field63; MATRIX_CellData[63])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[63];
                    DecimalPlaces = 0 : 5;
                    Visible = Field63Visible;
                }
                field(Field64; MATRIX_CellData[64])
                {
                    ApplicationArea = Basic;
                    BlankNumbers = BlankZero;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[64];
                    DecimalPlaces = 0 : 5;
                    Visible = Field64Visible;
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
        Field64Visible := true;
        Field63Visible := true;
        Field62Visible := true;
        Field61Visible := true;
        Field60Visible := true;
        Field59Visible := true;
        Field58Visible := true;
        Field57Visible := true;
        Field56Visible := true;
        Field55Visible := true;
        Field54Visible := true;
        Field53Visible := true;
        Field52Visible := true;
        Field51Visible := true;
        Field50Visible := true;
        Field49Visible := true;
        Field48Visible := true;
        Field47Visible := true;
        Field46Visible := true;
        Field45Visible := true;
        Field44Visible := true;
        Field43Visible := true;
        Field42Visible := true;
        Field41Visible := true;
        Field40Visible := true;
        Field39Visible := true;
        Field38Visible := true;
        Field37Visible := true;
        Field36Visible := true;
        Field35Visible := true;
        Field34Visible := true;
        Field33Visible := true;
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
        MatrixRecords: array[64] of Record "Purchase Line";
        MATRIX_CellData: array[64] of Decimal;
        MATRIX_ColumnCaption: array[64] of Text[1024];
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
        [InDataSet]
        Field33Visible: Boolean;
        [InDataSet]
        Field34Visible: Boolean;
        [InDataSet]
        Field35Visible: Boolean;
        [InDataSet]
        Field36Visible: Boolean;
        [InDataSet]
        Field37Visible: Boolean;
        [InDataSet]
        Field38Visible: Boolean;
        [InDataSet]
        Field39Visible: Boolean;
        [InDataSet]
        Field40Visible: Boolean;
        [InDataSet]
        Field41Visible: Boolean;
        [InDataSet]
        Field42Visible: Boolean;
        [InDataSet]
        Field43Visible: Boolean;
        [InDataSet]
        Field44Visible: Boolean;
        [InDataSet]
        Field45Visible: Boolean;
        [InDataSet]
        Field46Visible: Boolean;
        [InDataSet]
        Field47Visible: Boolean;
        [InDataSet]
        Field48Visible: Boolean;
        [InDataSet]
        Field49Visible: Boolean;
        [InDataSet]
        Field50Visible: Boolean;
        [InDataSet]
        Field51Visible: Boolean;
        [InDataSet]
        Field52Visible: Boolean;
        [InDataSet]
        Field53Visible: Boolean;
        [InDataSet]
        Field54Visible: Boolean;
        [InDataSet]
        Field55Visible: Boolean;
        [InDataSet]
        Field56Visible: Boolean;
        [InDataSet]
        Field57Visible: Boolean;
        [InDataSet]
        Field58Visible: Boolean;
        [InDataSet]
        Field59Visible: Boolean;
        [InDataSet]
        Field60Visible: Boolean;
        [InDataSet]
        Field61Visible: Boolean;
        [InDataSet]
        Field62Visible: Boolean;
        [InDataSet]
        Field63Visible: Boolean;
        [InDataSet]
        Field64Visible: Boolean;

        MatrixColumnCount: Integer;
        SumZeile: Decimal;
        No_alt: Code[20];
        LineNo_alt: Integer;
        ItemNo_alt: Code[20];


    procedure Load(MatrixColumns1: array[64] of Text[1024]; var MatrixRecords1: array[64] of Record "Purchase Line"; var MatrixRecord1: Record "Purchase Line")
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
        PurchaseLine.SetFilter(Type, '%1 | %2', PurchaseLine.Type::Item, PurchaseLine.Type::"Charge (Item)");
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
        Field33Visible := MATRIX_ColumnCaption[33] <> '';
        Field34Visible := MATRIX_ColumnCaption[34] <> '';
        Field35Visible := MATRIX_ColumnCaption[35] <> '';
        Field36Visible := MATRIX_ColumnCaption[36] <> '';
        Field37Visible := MATRIX_ColumnCaption[37] <> '';
        Field38Visible := MATRIX_ColumnCaption[38] <> '';
        Field39Visible := MATRIX_ColumnCaption[39] <> '';
        Field40Visible := MATRIX_ColumnCaption[40] <> '';
        Field41Visible := MATRIX_ColumnCaption[41] <> '';
        Field42Visible := MATRIX_ColumnCaption[42] <> '';
        Field43Visible := MATRIX_ColumnCaption[43] <> '';
        Field44Visible := MATRIX_ColumnCaption[44] <> '';
        Field45Visible := MATRIX_ColumnCaption[45] <> '';
        Field46Visible := MATRIX_ColumnCaption[46] <> '';
        Field47Visible := MATRIX_ColumnCaption[47] <> '';
        Field48Visible := MATRIX_ColumnCaption[48] <> '';
        Field49Visible := MATRIX_ColumnCaption[49] <> '';
        Field50Visible := MATRIX_ColumnCaption[50] <> '';
        Field51Visible := MATRIX_ColumnCaption[51] <> '';
        Field52Visible := MATRIX_ColumnCaption[52] <> '';
        Field53Visible := MATRIX_ColumnCaption[53] <> '';
        Field54Visible := MATRIX_ColumnCaption[54] <> '';
        Field55Visible := MATRIX_ColumnCaption[55] <> '';
        Field56Visible := MATRIX_ColumnCaption[56] <> '';
        Field57Visible := MATRIX_ColumnCaption[57] <> '';
        Field58Visible := MATRIX_ColumnCaption[58] <> '';
        Field59Visible := MATRIX_ColumnCaption[59] <> '';
        Field60Visible := MATRIX_ColumnCaption[60] <> '';
        Field61Visible := MATRIX_ColumnCaption[61] <> '';
        Field62Visible := MATRIX_ColumnCaption[62] <> '';
        Field63Visible := MATRIX_ColumnCaption[63] <> '';
        Field64Visible := MATRIX_ColumnCaption[64] <> '';
    end;
}

