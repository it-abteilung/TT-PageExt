#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50024 "EK-Lieferung Subpage"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Purchase Line";
    SourceTableView = where(Type = filter(Item),
                            "Outstanding Quantity" = filter(<> 0));

    layout
    {
        area(content)
        {
            repeater(Control1000000011)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Baugruppe; Rec.Baugruppe)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Pos; Rec.Pos)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("LOT-Nr. / Chargennr."; Rec."LOT-Nr. / Chargennr.")
                {
                    ApplicationArea = Basic;
                }
                field(Geliefert; Rec.Geliefert)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if Rec.Geliefert then
                            Rec.Validate("Qty. to Receive", Rec."Outstanding Quantity")
                        else
                            Rec.Validate("Qty. to Receive", 0);
                    end;
                }
                field("Qty. to Receive"; Rec."Qty. to Receive")
                {
                    ApplicationArea = Basic;
                }
                field("Location Code"; Rec."Location Code")
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
            // group(Bilderfassung)
            // {
            //     Caption = 'Image capturing';
            //     Visible = CameraAvailable;
            //     action(Bildaufnahme)
            //     {
            //         ApplicationArea = Basic;
            //         Caption = 'Take a picture';
            //         Gesture = RightSwipe;
            //         Image = Camera;
            //         Promoted = true;
            //         PromotedCategory = Process;
            //         PromotedIsBig = true;
            //         PromotedOnly = true;
            //         Scope = Repeater;
            //         Visible = CameraAvailable;

            //         trigger OnAction()
            //         begin
            //             CameraOptions := CameraOptions.CameraOptions;
            //             CameraOptions.Quality := 60; //60%
            //             Camera.RequestPictureAsync(CameraOptions);
            //         end;
            //     }
            // }
            group(Zeilen)
            {
                Caption = 'Zeilen';
                action("Komplett geliefert")
                {
                    ApplicationArea = Basic;
                    Gesture = LeftSwipe;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Scope = Repeater;

                    trigger OnAction()
                    begin
                        Rec.Validate(Geliefert, true);
                        Rec.Validate("Qty. to Receive", Rec."Outstanding Quantity");
                        CurrPage.Update;
                    end;
                }
                action("LOT-Nr. / Chargennr. eingeben")
                {
                    ApplicationArea = Basic;
                    Gesture = RightSwipe;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Scope = Repeater;

                    trigger OnAction()
                    var
                        LOTChargenNr: Code[20];
                        LOTNrChargennrEingabe: Page "LOT-Nr. / Chargennr. Eingabe";
                    begin
                        if LOTNrChargennrEingabe.RunModal = Action::OK then begin
                            LOTNrChargennrEingabe.WertHolen(LOTChargenNr);
                            Message(LOTChargenNr);
                            Rec.Validate("LOT-Nr. / Chargennr.", LOTChargenNr);
                            CurrPage.Update;
                        end;
                    end;
                }
                action("Etikett drucken")
                {
                    ApplicationArea = Basic;
                    Gesture = RightSwipe;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Scope = Repeater;

                    trigger OnAction()
                    begin
                        GerwingERPTool.DruckerTabelleFuellen(50037, 39, '1', Rec."Document No.", Format(Rec."Line No."), '', '', '', 1);
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    //trigger OnOpenPage()
    // begin
    //     if Camera.IsAvailable then begin
    //         Camera := Camera.Create;
    //         CameraAvailable := true;
    //     end;
    // end;

    var
        //     [RunOnClient]
        //     [WithEvents]
        //     Camera: dotnet CameraProvider;
        //     CameraOptions: dotnet CameraOptions;
        //     CameraAvailable: Boolean;
        GerwingERPTool: Codeunit 50001;

    // trigger Camera::PictureAvailable(PictureName: Text;PictureFilePath: Text)
    // var
    //     Bildspeicherung: Record Bildspeicherung;
    //     RecRef: RecordRef;
    //     TableID: Integer;
    // begin
    //     RecRef.GetTable(Rec);
    //     TableID := RecRef.Number;
    //     Bildspeicherung.SavePictureInDatabase(PictureName, PictureFilePath, TableID, "Document No.", "Document Type", "Line No.", Rec."Job No.");
    // end;
}

