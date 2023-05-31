#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50073 "Artikel-Chargennr"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Item Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = Basic;
                }
                field(Beschreibung2; Beschreibung2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Beschreibung 2';
                }
                field("EK-Preis"; "EK-Preis")
                {
                    ApplicationArea = Basic;
                }
                field("EK-Datum"; "EK-Datum")
                {
                    ApplicationArea = Basic;
                }
                field(Kreditor; Kreditor_Name)
                {
                    ApplicationArea = Basic;
                }
                field(Bestellung; Bestellung)
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        PurchaseHeader_l: Record "Purchase Header";
                    begin
                        if PurchaseHeader_l.Get(PurchaseHeader_l."document type"::Order, Bestellung) then
                            Page.RunModal(50, PurchaseHeader_l)
                        else
                            Error(ERR_Order, Bestellung);
                    end;
                }
                field(Rechnung; Rechnung)
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        PurchInvHeader_l: Record "Purch. Inv. Header";
                    begin
                        if PurchInvHeader_l.Get(Rechnung) then
                            Page.RunModal(138, PurchInvHeader_l)
                        else
                            Error(ERR_Invoice, Rechnung);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        PurchInvLine: Record "Purch. Inv. Line";
        ValueEntry: Record "Value Entry";
        Kreditor: Record Vendor;
        PurchaseLine: Record "Purchase Line";
        WarehouseEntry_l: Record "Warehouse Entry";
        PurchRcptHeader_l: Record "Purch. Rcpt. Header";
        PurchRcptLine_l: Record "Purch. Rcpt. Line";
        Preis_alt: Decimal;
    begin
        //G-ERP.RS 2019-08-13 +++ Auftrag#233373
        "EK-Preis" := 0;
        "EK-Datum" := 0D;
        Kreditor_Name := '';
        Bestellung := '';
        Rechnung := '';
        Beschreibung2 := '';

        ValueEntry.SetRange("Item Ledger Entry No.", Rec."Entry No.");
        ValueEntry.SetRange("Document Type", ValueEntry."document type"::"Purchase Invoice");
        if ValueEntry.FindSet() then begin
            PurchInvLine.SetRange("Document No.", ValueEntry."Document No.");
            PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
            PurchInvLine.SetRange("No.", Rec."Item No.");

            "EK-Preis" := 0;
            "EK-Datum" := 0D;
            Kreditor_Name := '';
            Bestellung := '';
            Rechnung := '';
            Beschreibung2 := '';
            Preis_alt := 0;

            // G-ERP.RS 2020-12-02 +++
            Beschreibung2 := Rec."Description 2";
            "EK-Preis" := ValueEntry."Cost per Unit";
            "EK-Datum" := ValueEntry."Posting Date";
            // G-ERP.RS 2020-12-02 ---

            if PurchInvLine.FindSet() then begin
                repeat
                    if Preis_alt < PurchInvLine."Direct Unit Cost" then begin
                        "EK-Preis" := PurchInvLine."Direct Unit Cost";
                        "EK-Datum" := PurchInvLine."Posting Date";
                        if Kreditor.Get(ValueEntry."Source No.") then
                            Kreditor_Name := Kreditor.Name;
                        Bestellung := PurchInvLine."Order No.";
                        Rechnung := PurchInvLine."Document No.";

                        if PurchaseLine.Get(PurchaseLine."document type"::Order,
                                            PurchInvLine."Order No.",
                                            PurchInvLine."Order Line No.") then
                            Beschreibung2 := PurchaseLine."Description 2"
                        else
                            Beschreibung2 := Rec."Description 2";

                    end;
                until (PurchInvLine.Next() = 0);
                // G-ERP.RS 2020-11-24 +++
                // END;
            end;
        end else begin
            ValueEntry.SetRange("Item Ledger Entry No.", Rec."Entry No.");
            ValueEntry.SetRange("Document Type", ValueEntry."document type"::"Purchase Receipt");
            if ValueEntry.FindSet() then begin
                // G-ERP.RS 2020-12-02 +++
                //Beschreibung2 := "Description 2"
                Clear(PurchRcptLine_l);
                Clear(PurchaseLine);
                Clear(PurchRcptHeader_l);
                PurchRcptHeader_l.SetRange("No.", ValueEntry."Document No.");
                if PurchRcptHeader_l.FindSet() then begin
                    PurchRcptLine_l.SetRange("Document No.", PurchRcptHeader_l."No.");
                    PurchRcptLine_l.SetRange(Type, PurchRcptLine_l.Type::Item);
                    PurchRcptLine_l.SetRange("No.", Rec."Item No.");
                    if PurchRcptLine_l.FindSet() then begin
                        PurchaseLine.Get(PurchaseLine."document type"::Order,
                                         PurchRcptLine_l."Order No.",
                                         PurchRcptLine_l."Order Line No.");
                        Beschreibung2 := PurchaseLine."Description 2";
                        "EK-Preis" := PurchaseLine."Unit Cost";
                        Bestellung := PurchaseLine."Document No.";
                        if Kreditor.Get(ValueEntry."Source No.") then
                            Kreditor_Name := Kreditor.Name;
                    end;
                end;
                // G-ERP.RS 2020-12-02 ---
            end;
            // G-ERP.RS 2020-11-24 ---

        end;
        //G-ERP.RS 2019-08-13 ---

        //G-ERP.RS 2020-12-02 +++
        BinCode_g := '';
        Clear(WarehouseEntry_l);
        WarehouseEntry_l.SetCurrentkey("Entry No.");
        WarehouseEntry_l.Ascending();
        WarehouseEntry_l.SetRange("Item No.", Rec."Item No.");
        WarehouseEntry_l.SetRange("Serial No.", Rec."Serial No.");
        WarehouseEntry_l.SetRange("Location Code", Rec."Location Code");
        if WarehouseEntry_l.FindLast() then;
        BinCode_g := WarehouseEntry_l."Bin Code";
        //G-ERP.RS 2020-12-02 ---
    end;

    var
        "EK-Preis": Decimal;
        "EK-Datum": Date;
        Bestellung: Code[20];
        Kreditor_Name: Text[50];
        ERR_Order: label 'The Order %1 does not exist.';
        Rechnung: Code[20];
        ERR_Invoice: label 'The Invoice %1 does not exist.';
        Beschreibung2: Text[50];
        BinCode_g: Code[20];
}

