PageExtension 50024 pageextension50024 extends "Purchase Order Subform"
{
    layout
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin

                DeltaUpdateTotals;

                //G-ERP.RS 2019-08-21 +++ Anfrage#233671
                IF Rec.Quantity <> xRec.Quantity THEN BEGIN
                    PurchaseHeader_l.GET(Rec."Document Type", Rec."Document No.");

                    //Lieferung
                    IF Rec."Quantity Received" > 0 THEN
                        IF Rec.Quantity > Rec."Quantity Received" THEN
                            PurchaseHeader_l."Status Purchase" := PurchaseHeader_l."Status Purchase"::"partly delivered"
                        ELSE
                            PurchaseHeader_l."Status Purchase" := PurchaseHeader_l."Status Purchase"::delivered;

                    //Rechnung
                    IF Rec."Quantity Invoiced" > 0 THEN
                        IF Rec.Quantity > Rec."Quantity Invoiced" THEN
                            PurchaseHeader_l."Status Purchase" := PurchaseHeader_l."Status Purchase"::"partly invoiced"
                        ELSE
                            PurchaseHeader_l."Status Purchase" := PurchaseHeader_l."Status Purchase"::invoiced;

                    PurchaseHeader_l.MODIFY();

                END;
                //G-ERP.RS 2019-08-21 --- Anfrage#233671
            end;
        }

        addafter("Line No.")
        {
            field(Baugruppe; Rec.Baugruppe)
            {
                ApplicationArea = Basic;
            }
            field(Pos; Rec.Pos)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("No.")
        {
            field("LOT-Nr. / Chargennr."; Rec."LOT-Nr. / Chargennr.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Description 2")
        {
            field("Description 3 FlowField"; Rec."Description 3 FlowField")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Drop Shipment")
        {
            field("Vendor Item No."; Rec."Vendor Item No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Line Discount Amount")
        {
            field(Leistungsart; Rec.Leistungsart)
            {
                ApplicationArea = Basic;
            }
            field(Leistungszeitraum; Rec.Leistungszeitraum)
            {
                ApplicationArea = All;
            }
            field("CO2 Menge in Kilogramm"; Rec."CO2 Menge in Kilogramm")
            {
                ApplicationArea = Basic;
                BlankZero = true;
            }
        }
        addafter(ShortcutDimCode8)
        {
            field("Abschlag1 %"; Rec."Abschlag1 %")
            {
                ApplicationArea = Basic;
            }
            field("Abschlag1 Absolut"; Rec."Abschlag1 Absolut")
            {
                ApplicationArea = Basic;
            }
            field("Abschlag1 Datum"; Rec."Abschlag1 Datum")
            {
                ApplicationArea = Basic;
            }
            field("Abschlag2 %"; Rec."Abschlag2 %")
            {
                ApplicationArea = Basic;
            }
            field("Abschlag2 Absolut"; Rec."Abschlag2 Absolut")
            {
                ApplicationArea = Basic;
            }
            field("Abschlag2 Datum"; Rec."Abschlag2 Datum")
            {
                ApplicationArea = Basic;
            }
            field("Abschlag3 %"; Rec."Abschlag3 %")
            {
                ApplicationArea = Basic;
            }
            field("Abschlag3 Absolut"; Rec."Abschlag3 Absolut")
            {
                ApplicationArea = Basic;
            }
            field("Abschlag3 Datum"; Rec."Abschlag3 Datum")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addafter(DeferralSchedule)
        {
            action("&Edit")
            {
                ApplicationArea = Basic;
                Caption = '&Edit';
                ShortCutKey = 'Shift+Ctrl+E';
                ToolTip = 'Edit Text';

                trigger OnAction()
                begin
                    //1.00 B
                    EditText;
                    //1.00 E
                end;
            }
        }
        addafter("O&rder")
        {
            action("Etikett drucken")
            {
                ApplicationArea = Basic;
                Caption = 'Etikett drucken';

                trigger OnAction()
                var
                    L_PurchaseLine: Record "Purchase Line";
                begin
                    Clear(L_PurchaseLine);
                    L_PurchaseLine.SetRange("Document Type", Rec."Document Type");
                    L_PurchaseLine.SetRange("Document No.", Rec."Document No.");
                    L_PurchaseLine.SetRange("Line No.", Rec."Line No.");
                    if L_PurchaseLine.FindFirst then
                        Report.RunModal(50049, true, false, L_PurchaseLine);
                end;
            }
        }
    }

    var
        PurchaseHeader_l: Record "Purchase Header";
        PurchPost_l: Codeunit "Purch.-Post";
        PurchaseHeader: Record "Purchase Header";


    //Unsupported feature: Property Modification (Id) on "InvDiscAmountEditable(Variable 1012)".

    //var
    //>>>> ORIGINAL VALUE:
    //InvDiscAmountEditable : 1012;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //InvDiscAmountEditable : 1016;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "UpdateInvDiscountQst(Variable 1014)".

    //var
    //>>>> ORIGINAL VALUE:
    //UpdateInvDiscountQst : 1014;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //UpdateInvDiscountQst : 1020;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "UpdateInvDiscountQst(Variable 1014)".

    //var
    //>>>> ORIGINAL VALUE:
    //UpdateInvDiscountQst : DEU=Mindestens eine Zeile wurde fakturiert. Der auf fakturierte Zeilen verteilte Rabatt wird nicht berücksichtigt.\\Möchten Sie den Rechnungsrabatt aktualisieren?;ENU=One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //UpdateInvDiscountQst : DEU=One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?;ENU=One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?;
    //Variable type has not been exported.

    var
        PurchHeader: Record "Purchase Header";
        ApplicationAreaSetup: Record "Application Area Setup";
        TotalAmountStyle: Text;
        RefreshMessageEnabled: Boolean;
        RefreshMessageText: Text;
        TypeChosen: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;


    //Unsupported feature: Code Modification on "OnAfterGetCurrRecord".

    //trigger OnAfterGetCurrRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GetTotalsPurchaseHeader;
    CalculateTotals;
    UpdateEditableOnRow;
    UpdateTypeText;
    SetItemChargeFieldsStyle;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    UpdateEditableOnRow;
    IF PurchHeader.GET("Document Type","Document No.") THEN;

    DocumentTotals.PurchaseUpdateTotalsControls(Rec,TotalPurchaseHeader,TotalPurchaseLine,RefreshMessageEnabled,
      TotalAmountStyle,RefreshMessageText,InvDiscAmountEditable,VATAmount);
    */
    //end;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ShowShortcutDimCode(ShortcutDimCode);
    UpdateTypeText;
    SetItemChargeFieldsStyle;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ShowShortcutDimCode(ShortcutDimCode);
    TypeChosen := HasTypeToFillMandatotyFields;
    CLEAR(DocumentTotals);

    //G-ERP.RS 2017-07-17 +++
    ShowShortcutDimCode(ShortcutDimCode);
    //G-ERP.RS 2017-07-17 ---
    */
    //end;


    //Unsupported feature: Code Modification on "OnDeleteRecord".

    //trigger OnDeleteRecord(): Boolean
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
      COMMIT;
      IF NOT ReservePurchLine.DeleteLineConfirm(Rec) THEN
        EXIT(FALSE);
      ReservePurchLine.DeleteLine(Rec);
    END;
    DocumentTotals.PurchaseDocTotalsNotUpToDate;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6
    */
    //end;


    //Unsupported feature: Code Insertion on "OnInsertRecord".

    //trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    //begin
    /*
    IF ApplicationAreaSetup.IsFoundationEnabled THEN
      Type := Type::Item;
    */
    //end;


    //Unsupported feature: Code Modification on "OnNewRecord".

    //trigger OnNewRecord(BelowxRec: Boolean)
    //>>>> ORIGINAL CODE:
    //begin
    /*
    InitType;
    // Default to Item for the first line and to previous line type for the others
    IF ApplicationAreaMgmtFacade.IsFoundationEnabled THEN
      IF xRec."Document No." = '' THEN
        Type := Type::Item;

    CLEAR(ShortcutDimCode);
    UpdateTypeText;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF ApplicationAreaSetup.IsFoundationEnabled THEN
      Type := Type::Item
    ELSE
      InitType;
    CLEAR(ShortcutDimCode);

    // G-ERP+ 14.10.15
    Baugruppe := xRec.Baugruppe;
    Pos := xRec.Pos;
    // G-ERP- 14.10.15
    */
    //end;

    //Unsupported feature: Property Deletion (Attributes) on "ApproveCalcInvDisc(PROCEDURE 7)".



    //Unsupported feature: Code Modification on "ApproveCalcInvDisc(PROCEDURE 7)".

    //procedure ApproveCalcInvDisc();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)",Rec);
    DocumentTotals.PurchaseDocTotalsNotUpToDate;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)",Rec);
    */
    //end;


    //Unsupported feature: Code Modification on "ExplodeBOM(PROCEDURE 3)".

    //procedure ExplodeBOM();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF "Prepmt. Amt. Inv." <> 0 THEN
      ERROR(Text001);
    CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM",Rec);
    DocumentTotals.PurchaseDocTotalsNotUpToDate;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
    */
    //end;

    //Unsupported feature: Property Deletion (Attributes) on "InsertExtendedText(PROCEDURE 6)".


    //Unsupported feature: Property Insertion (Local) on "InsertExtendedText(PROCEDURE 6)".



    //Unsupported feature: Code Modification on "InsertExtendedText(PROCEDURE 6)".

    //procedure InsertExtendedText();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    OnBeforeInsertExtendedText(Rec);
    IF TransferExtendedText.PurchCheckIfAnyExtText(Rec,Unconditionally) THEN BEGIN
      CurrPage.SAVERECORD;
      TransferExtendedText.InsertPurchExtText(Rec);
    END;
    IF TransferExtendedText.MakeUpdate THEN
      UpdateForm(TRUE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #2..7
    */
    //end;

    //Unsupported feature: Property Deletion (Attributes) on "ShowTracking(PROCEDURE 10)".


    //Unsupported feature: Property Deletion (Attributes) on "UpdateForm(PROCEDURE 13)".


    //Unsupported feature: Property Modification (Name) on "DeltaUpdateTotals(PROCEDURE 2)".



    //Unsupported feature: Code Modification on "DeltaUpdateTotals(PROCEDURE 2)".

    //procedure DeltaUpdateTotals();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    DocumentTotals.PurchaseDeltaUpdateTotals(Rec,xRec,TotalPurchaseLine,VATAmount,InvoiceDiscountAmount,InvoiceDiscountPct);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    CurrPage.SAVERECORD;

    PurchHeader.GET("Document Type","Document No.");
    IF DocumentTotals.PurchaseCheckNumberOfLinesLimit(PurchHeader) THEN
      DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalPurchaseLine);
    CurrPage.UPDATE;
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateEditableOnRow(PROCEDURE 8)".

    //procedure UpdateEditableOnRow();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IsCommentLine := Type = Type::" ";
    CurrPageIsEditable := CurrPage.EDITABLE;
    IsBlankNumber := "No." = '';
    InvDiscAmountEditable := CurrPageIsEditable AND NOT PurchasesPayablesSetup."Calc. Inv. Discount";
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode;
    */
    //end;

    local procedure NoOnAfterValidate()
    begin
        UpdateEditableOnRow;
        InsertExtendedText(false);
        if (Rec.Type = Rec.Type::"Charge (Item)") and (Rec."No." <> xRec."No.") and
           (xRec."No." <> '')
        then
            CurrPage.SaveRecord;
    end;

    local procedure CrossReferenceNoOnAfterValidat()
    begin
        InsertExtendedText(false);
    end;

    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        Rec.ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
        CurrPage.SaveRecord;
    end;

    local procedure "*G-ERP****"()
    begin
    end;

    procedure EditText()
    var
        L_NewLine: Boolean;
        L_RecRef: RecordRef;
        L_TextEdit: Codeunit 60000;
        L_Text00001: label 'Edit Purchase Line';
    begin
        //1.00 B
        L_NewLine := false;
        if Rec."Line No." = 0 then begin
            Rec.Description := ' ';
            CurrPage.SaveRecord;
            L_NewLine := true;
        end;
        // Commit;
        // L_RecRef.GetTable(Rec);
        // if (not L_TextEdit.EditTextLines(L_RecRef,
        //                        'Description',
        //                        '',
        //                        '',
        //                        'Line No.',
        //                        'Attached to Line No.',
        //                        false,
        //                        '',
        //                        L_Text00001)) and L_NewLine then
        //     if Get("Document Type", "Document No.", "Line No.") then
        //         Delete;

        // Commit;
        //1.00 E
    end;
}

