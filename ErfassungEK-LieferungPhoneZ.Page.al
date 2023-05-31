#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50027 "Erfassung EK-Lieferung Phone Z"
{
    PageType = Card;
    SourceTable = "Purchase Header";

    layout
    {
        area(content)
        {
            field(Bestellnummer; Bestellnr)
            {
                ApplicationArea = Basic;
                Caption = 'Bestellnummer';

                trigger OnValidate()
                begin
                    Clear(PurchaseLine);
                    PurchaseLine.SetRange("Document Type", PurchaseLine."document type"::Order);
                    PurchaseLine.SetRange("Document No.", Bestellnr);
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                    PurchaseLine.SetFilter("Outstanding Quantity", '<>%1', 0);
                    PurchaseLine.SetFilter("No.", '<>%1', '');
                    if PurchaseLine.FindSet then
                        repeat
                            PurchaseLine.Validate("Qty. to Receive", 0);
                            PurchaseLine.Modify;
                        until PurchaseLine.Next = 0;


                    Rec.SetRange("Document Type", Rec."document type"::Order);
                    Rec.SetRange("No.", Bestellnr);
                    if Rec.FindFirst then;
                    CurrPage.Update(false);
                end;
            }
            field("Lieferscheinnr."; LFSNr)
            {
                ApplicationArea = Basic;
                Caption = 'Lieferscheinnr.';
            }
            part(Control1000000008; "EK-Lieferung Subpage")
            {
                Caption = 'EK-Lieferung Zeilen';
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("No."),
                              "Qty. to Receive" = const(0);
                ApplicationArea = All;
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
                    Message(Format(Rec.RecordId));
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
                Enabled = false;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = false;

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
                    LFSNr := '';
                    Clear(PurchaseLine);
                end;
            }
            action(Abbrechen)
            {
                ApplicationArea = Basic;
                Caption = 'Abbrechen';
                Enabled = false;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = false;

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
                    LFSNr := '';
                    Clear(PurchaseLine);
                end;
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Posting)
                {
                    ApplicationArea = Suite;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Post(Codeunit::"Purch.-Post (Yes/No)");
                        Clear(PurchaseLine);
                        PurchaseLine.SetRange("Document Type", PurchaseLine."document type"::Order);
                        PurchaseLine.SetRange("Document No.", Bestellnr);
                        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                        if PurchaseLine.FindSet then begin
                            repeat
                                PurchaseLine.Geliefert := false;
                                PurchaseLine.Modify;
                            until PurchaseLine.Next = 0;
                        end;
                        CurrPage.Update(false);
                    end;
                }
            }
            group(Bilderfassung)
            {
                Visible = CameraAvailable;
                action("Foto aufnehmen")
                {
                    ApplicationArea = Basic;
                    Image = Camera;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = CameraAvailable;

                    // trigger OnAction()
                    // begin
                    //     CameraOptions := CameraOptions.CameraOptions;
                    //     CameraOptions.Quality := 60; //60%
                    //     Camera.RequestPictureAsync(CameraOptions);
                    // end;
                }
                action("Kartonetikett drucken")
                {
                    ApplicationArea = Basic;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        GerwingERPTool.DruckerTabelleFuellen(50038, 38, '1', Rec."No.", '', '', '', '', 1);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        // if Camera.IsAvailable then begin
        //     Camera := Camera.Create;
        //     CameraAvailable := true;
        // end;

        Bestellnr := Rec."No.";

        Clear(PurchaseLine);
        PurchaseLine.SetRange("Document Type", PurchaseLine."document type"::Order);
        PurchaseLine.SetRange("Document No.", Bestellnr);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetFilter("Outstanding Quantity", '<>%1', 0);
        PurchaseLine.SetFilter("No.", '<>%1', '');
        if PurchaseLine.FindSet then
            repeat
                PurchaseLine.Validate("Qty. to Receive", 0);
                PurchaseLine.Validate(Geliefert, false);
                PurchaseLine.Modify;
            until PurchaseLine.Next = 0;

        Rec.SetRange("Document Type", Rec."document type"::Order);
        Rec.SetRange("No.", Bestellnr);
        if Rec.FindFirst then;
        CurrPage.Update(false);
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if not DocumentIsPosted then
            if Confirm('Es wurde nicht gebucht. Wirklich schließen?', false) then
                exit(true)
            else
                exit(false);
    end;

    var
        Bestellnr: Code[20];
        LFSNr: Text[30];
        PurchaseLine: Record "Purchase Line";
        AnzEtiketten: Integer;
        ReservationEntry: Record "Reservation Entry";
        Wareneingangskontrolle: Record Wareneingangskontrolle;
        //EinkaufszeileBarcode: Report UnknownReport50049;
        // Camera: dotnet CameraProvider;
        // CameraOptions: dotnet CameraOptions;
        CameraAvailable: Boolean;
        DocumentIsPosted: Boolean;
        GerwingERPTool: Codeunit 50001;

    local procedure Post(PostingCodeunitID: Integer)
    var
        PurchaseHeader: Record "Purchase Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        PurchaseHeader.SetRange("Document Type", Rec."Document Type");
        PurchaseHeader.SetRange("No.", Rec."No.");
        if PurchaseHeader.FindFirst then begin
            PurchaseHeader."Vendor Shipment No." := LFSNr;
            PurchaseHeader.Modify;
            PurchaseHeader.SendToPosting(PostingCodeunitID);

            DocumentIsPosted := true;

            if PostingCodeunitID <> Codeunit::"Purch.-Post (Yes/No)" then
                exit;

        end;
    end;

    //     trigger Camera::PictureAvailable(PictureName: Text; PictureFilePath: Text)
    //     var
    //         Bildspeicherung: Record Bildspeicherung;
    //         RecRef: RecordRef;
    //         TableID: Integer;
    //     begin
    //         RecRef.GetTable(Rec);
    //         TableID := RecRef.Number;
    //         Bildspeicherung.SavePictureInDatabase(PictureName, PictureFilePath, TableID, "No.", "Document Type", 0, Rec."Job No.");
    //     end;
}

