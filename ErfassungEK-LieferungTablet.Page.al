#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50021 "Erfassung EK-Lieferung Tablet"
{

    layout
    {
        area(content)
        {
            field(Bestellnr; Bestellnr)
            {
                ApplicationArea = Basic;
                Caption = 'Bestellnummer';

                trigger OnValidate()
                begin
                    Clear(PurchaseLine);
                    PurchaseLine.SetRange("Document Type", PurchaseLine."document type"::Order);
                    PurchaseLine.SetRange("Document No.", Bestellnr);
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                    PurchaseLine.SetFilter("No.", '<>%1', '');
                    if PurchaseLine.FindSet then
                        repeat
                            PurchaseLine.Validate("Qty. to Receive", 0);
                            PurchaseLine.Modify;
                        until PurchaseLine.Next = 0;
                end;
            }
            field(LFSNr; LFSNr)
            {
                ApplicationArea = Basic;
                Caption = 'Lieferscheinnr.';
            }
            field(Bestellzeile; Bestellzeile)
            {
                ApplicationArea = Basic;
                Caption = 'Zeile';

                trigger OnValidate()
                begin
                    Evaluate(BestellzeileNr, Bestellzeile);
                    PurchaseLine.Get(PurchaseLine."document type"::Order, Bestellnr, BestellzeileNr);
                    //Meng := PurchaseLine.Quantity;
                    Meng := 0;
                    AnzEtiketten := 0;
                    Charg := '';
                end;
            }
            field("PurchaseLine.Description + ' ' + PurchaseLine.""Description 2"""; PurchaseLine.Description + ' ' + PurchaseLine."Description 2")
            {
                ApplicationArea = Basic;
                Caption = 'Beschreibung';
            }
            field(Meng; Meng)
            {
                ApplicationArea = Basic;
                Caption = 'Menge';

                trigger OnValidate()
                begin
                    if Meng <> 0 then begin
                        PurchaseLine.Validate("Qty. to Receive", PurchaseLine."Qty. to Receive" + Meng);
                        PurchaseLine.Modify;
                    end;
                end;
            }
            field(Charg; Charg)
            {
                ApplicationArea = Basic;
                Caption = 'Chargenr.';

                trigger OnValidate()
                var
                    Llfdnr_Reserve: Integer;
                begin
                    if Charg <> '' then begin
                        Clear(ReservationEntry);
                        if ReservationEntry.FindLast then
                            Llfdnr_Reserve := ReservationEntry."Entry No."
                        else
                            Llfdnr_Reserve := 0;
                        Clear(ReservationEntry);
                        ReservationEntry."Entry No." := Llfdnr_Reserve;
                        ReservationEntry.Validate("Reservation Status", ReservationEntry."reservation status"::Reservation);
                        ReservationEntry.Validate("Item No.", PurchaseLine."No.");
                        ReservationEntry.Validate("Quantity (Base)", Meng);
                        ReservationEntry.Validate("Reservation Status", ReservationEntry."reservation status"::Surplus);
                        ReservationEntry.Validate("Creation Date", Today);
                        ReservationEntry.Validate("Source Type", 39);
                        ReservationEntry.Validate("Source Subtype", 1);
                        ReservationEntry.Validate("Source ID", PurchaseLine."Document No.");
                        ReservationEntry.Validate("Source Ref. No.", PurchaseLine."Line No.");
                        ReservationEntry.Validate("Shipment Date", Today);                           //?????????????????????????
                        ReservationEntry."Created By" := UserId;
                        ReservationEntry.Validate("Qty. per Unit of Measure", PurchaseLine."Qty. per Unit of Measure");
                        ReservationEntry.Validate("Lot No.", Charg);
                        ReservationEntry.Validate("Item Tracking", ReservationEntry."item tracking"::"Lot No.");
                        ReservationEntry.Insert;
                    end;
                end;
            }
            field(AnzEtiketten; AnzEtiketten)
            {
                ApplicationArea = Basic;
                Caption = 'Anz. Etiketten';

                trigger OnValidate()
                begin
                    // if AnzEtiketten > 0 then begin
                    //   Clear(EinkaufszeileBarcode);
                    //   EinkaufszeileBarcode.WerteÜbergeben(Bestellnr,BestellzeileNr,AnzEtiketten);
                    //   EinkaufszeileBarcode.RunModal();
                    // end;
                    Bestellzeile := '';
                    BestellzeileNr := 0;
                    Meng := 0;
                    AnzEtiketten := 0;
                    Charg := '';
                    Clear(PurchaseLine);
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Wareneingangskontrolle)
            {
                ApplicationArea = Basic;
                Caption = 'Wareneingangskontrolle';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Clear(Wareneingangskontrolle);
                    Wareneingangskontrolle.SetRange(Bestellnr, Bestellnr);
                    if not Wareneingangskontrolle.FindFirst then begin
                        Wareneingangskontrolle.Bestellnr := Bestellnr;
                        Wareneingangskontrolle.Insert;
                        Commit;
                    end;
                    Page.RunModal(50017, Wareneingangskontrolle);
                end;
            }
            action(Buchen)
            {
                ApplicationArea = Basic;
                Caption = 'Buchen';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PurchPost: Codeunit "Purch.-Post";
                    L_PurchaseHeader: Record "Purchase Header";
                begin
                    L_PurchaseHeader.Get(L_PurchaseHeader."document type"::Order, Bestellnr);
                    L_PurchaseHeader."Vendor Shipment No." := LFSNr;
                    L_PurchaseHeader.Ship := false;
                    L_PurchaseHeader.Receive := true;
                    L_PurchaseHeader.Invoice := false;
                    L_PurchaseHeader.Modify;
                    PurchPost.Run(L_PurchaseHeader);
                    Bestellnr := '';
                    Bestellzeile := '';
                    BestellzeileNr := 0;
                    Meng := 0;
                    LFSNr := '';
                    Clear(PurchaseLine);
                end;
            }
            action(Abbrechen)
            {
                ApplicationArea = Basic;
                Caption = 'Abbrechen';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Clear(PurchaseLine);
                    PurchaseLine.SetRange("Document Type", PurchaseLine."document type"::Order);
                    PurchaseLine.SetRange("Document No.", Bestellnr);
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                    PurchaseLine.SetFilter("No.", '<>%1', '');
                    if PurchaseLine.FindSet then
                        repeat
                            PurchaseLine.Validate("Qty. to Receive", PurchaseLine."Outstanding Quantity");
                            PurchaseLine.Modify;
                        until PurchaseLine.Next = 0;

                    Bestellnr := '';
                    Bestellzeile := '';
                    BestellzeileNr := 0;
                    Meng := 0;
                    LFSNr := '';
                    Clear(PurchaseLine);
                end;
            }
        }
    }

    var
        Bestellnr: Code[20];
        Bestellzeile: Text[50];
        BestellzeileNr: Integer;
        Meng: Decimal;
        LFSNr: Text[30];
        Charg: Code[20];
        PurchaseLine: Record "Purchase Line";
        AnzEtiketten: Integer;
        ReservationEntry: Record "Reservation Entry";
        Wareneingangskontrolle: Record Wareneingangskontrolle;
    //EinkaufszeileBarcode: Report UnknownReport50049;
}

