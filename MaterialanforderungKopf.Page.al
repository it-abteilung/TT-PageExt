Page 50065 "Materialanforderung Kopf"
{
    // AC01 10.12.2021 DAP  Fehlermeldung korrigiert, sodass die korrekte Artikelnummer und nicht die zuletzt gefundene angezeigt wird.

    Caption = 'Materialanforderung';
    DelayedInsert = true;
    PageType = Document;
    SourceTable = Materialanforderungskopf;

    layout
    {
        area(content)
        {
            group(Allgemein)
            {
                field("Projekt Nr"; Rec."Projekt Nr")
                {
                    ApplicationArea = Basic;
                    Caption = 'Projekt-Nr.';
                    ShowMandatory = true;
                    Editable = IsEditable;

                    trigger OnValidate()
                    begin
                        //G-ERP.RS 2021-07-06 +
                        if (xRec."Projekt Nr" <> '') and (xRec."Projekt Nr" <> Rec."Projekt Nr") then
                            Error('Die Projektnummer darf nicht verändert werden.');
                        //G-ERP.RS 2021-07-06 +

                        if Rec."Projekt Nr" <> '' then begin
                            Materialanforderung.SetRange("Projekt Nr", Rec."Projekt Nr");
                            if Materialanforderung.FindLast then
                                Lfd := Materialanforderung."Lfd Nr"
                            else
                                Lfd := 0;
                            Lfd += 10;
                            Rec."Lfd Nr" := Lfd;
                        end else
                            Rec."Lfd Nr" := 0;
                        ToggleShipToOption();
                    end;
                }
                field(Beschreibung; Rec.Beschreibung)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    QuickEntry = false;
                }
                field("Lfd Nr"; Rec."Lfd Nr")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    QuickEntry = false;
                }
                field(Stichwort; Rec.Stichwort)
                {
                    ApplicationArea = Basic;
                    Caption = 'Anforderungsgrund';
                    Editable = IsEditable;
                    NotBlank = true;
                    ShowMandatory = true;
                }
            }
            group(Information)
            {
                ShowCaption = false;
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    QuickEntry = false;
                }
                field(Belegdatum; Rec.Belegdatum)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    QuickEntry = false;
                }
                field(Leistung; Rec.Leistung)
                {
                    ApplicationArea = Basic;
                    Editable = IsEditable;
                }
                field("Purchase Order Date"; Rec."Purchase Order Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Spätester Bestelltermin';
                    Editable = IsEditable;

                    trigger OnValidate()
                    begin
                        if Rec.GewünschtesWareneingangsdatum < Today then
                            Error('Das Datum liegt in der Vergangenheit.');
                    end;
                }
                field("GewünschtesWareneingangsdatum"; Rec.GewünschtesWareneingangsdatum)
                {
                    ApplicationArea = Basic;
                    Editable = IsEditable;

                    trigger OnValidate()
                    begin
                        if Rec.GewünschtesWareneingangsdatum < Today then
                            Error('Das Datum liegt in der Vergangenheit.');
                    end;
                }
                field("Delivery Period"; Rec."Delivery Period")
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                    Caption = 'Gewünschter Leitungszeitraum';
                    Tooltip = 'Erlaubt eine Zeichenkette mit einer maximalen Länge von 7 Zeichen.';
                }
                field(AngebotsAbgabeBis; Rec.AngebotsAbgabeBis)
                {
                    ApplicationArea = Basic;
                    Editable = IsEditable;
                    Caption = 'Angebotsabgabe bis';

                    trigger OnValidate()
                    begin
                        if Rec.AngebotsAbgabeBis < Today then
                            Error('Das Datum liegt in der Vergangenheit.');
                    end;
                }
                field("Geplantes Versanddatum"; Rec."Geplantes Versanddatum")
                {
                    ApplicationArea = Basic;
                    NotBlank = true;
                    Editable = IsEditable;

                    trigger OnValidate()
                    begin
                        if Rec."Geplantes Versanddatum" < Today then
                            Error('Das Datum liegt in der Vergangenheit.');
                    end;
                }
                group(Delivery)
                {
                    // Caption = 'Lieferung';
                    ShowCaption = false;
                    field("Place of Delivery"; Rec."Place of Delivery")
                    {
                        ApplicationArea = All;
                        Caption = 'Lieferort';
                        Editable = IsEditable;
                        ShowMandatory = true;
                        trigger OnValidate()
                        begin
                            ToggleShipToOption();
                        end;
                    }
                    field("Ship-to Name"; Rec."Ship-to Name")
                    {
                        ApplicationArea = All;
                        Caption = 'Name';
                        Editable = (Rec."Place of Delivery" = Rec."Place of Delivery"::Benutzerdefinitert) AND (Rec.Status = Rec.Status::erfasst);
                        ShowMandatory = true;
                    }
                    field("Ship-to Name 2"; Rec."Ship-to Name 2")
                    {
                        ApplicationArea = All;
                        Caption = 'Name 2';
                        Editable = (Rec."Place of Delivery" = Rec."Place of Delivery"::Benutzerdefinitert) AND (Rec.Status = Rec.Status::erfasst);
                        Visible = false;
                    }
                    field("Ship-to Address"; Rec."Ship-to Address")
                    {
                        ApplicationArea = All;
                        Caption = 'Adresse';
                        Editable = (Rec."Place of Delivery" = Rec."Place of Delivery"::Benutzerdefinitert) AND (Rec.Status = Rec.Status::erfasst);
                        ShowMandatory = true;
                    }
                    field("Ship-to Address 2"; Rec."Ship-to Address 2")
                    {
                        ApplicationArea = All;
                        Editable = (Rec."Place of Delivery" = Rec."Place of Delivery"::Benutzerdefinitert) AND (Rec.Status = Rec.Status::erfasst);
                        Caption = 'Adresse 2';
                    }
                    field("Ship-to Post Code"; Rec."Ship-to Post Code")
                    {
                        ApplicationArea = All;
                        Caption = 'PLZ';
                        Editable = (Rec."Place of Delivery" = Rec."Place of Delivery"::Benutzerdefinitert) AND (Rec.Status = Rec.Status::erfasst);
                        ShowMandatory = true;
                    }
                    field("Ship-to City"; Rec."Ship-to City")
                    {
                        ApplicationArea = All;
                        Caption = 'Ort';
                        Editable = (Rec."Place of Delivery" = Rec."Place of Delivery"::Benutzerdefinitert) AND (Rec.Status = Rec.Status::erfasst);
                        ShowMandatory = true;
                    }
                    field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                    {
                        ApplicationArea = All;
                        Caption = 'Land/Region';
                        Editable = (Rec."Place of Delivery" = Rec."Place of Delivery"::Benutzerdefinitert) AND (Rec.Status = Rec.Status::erfasst);
                        ShowMandatory = true;
                    }
                    field("Ship-to Contact"; Rec."Ship-to Contact")
                    {
                        ApplicationArea = All;
                        Caption = 'Kontakt vor Ort';
                        Editable = IsEditable;
                        trigger OnValidate()
                        var
                            Resource: Record Resource;
                        begin
                            if Rec."Ship-to Contact" <> xRec."Ship-To Contact" then if StrLen(Rec."Ship-to Contact") < 20 then if Resource.Get(Rec."Ship-to Contact") then Rec."Ship-to Contact" := Resource.Name;
                        end;
                    }
                }
            }

            group(Texte)
            {
                Editable = IsPurchaser;
                ShowCaption = true;
                Caption = 'Bemerkungszeilen';
                Visible = IsPurchaser;
                Enabled = IsPurchaser;

                grid(GridColumnText)
                {
                    GridLayout = Columns;
                    grid(Control100000010)
                    {
                        GridLayout = Rows;
                        group("Vortext")
                        {
                            ShowCaption = false;
                            field(Vorlauftext; Rec.Vorlauftext)
                            {
                                ApplicationArea = All;
                                Caption = 'Vortext 1';
                            }
                            field("Vorlauftext 2"; Rec."Vorlauftext 2")
                            {
                                ApplicationArea = All;
                                Caption = 'Vortext 2';
                            }
                            field("Vorlauftext m"; Rec."Vorlauftext m")
                            {
                                ApplicationArea = All;
                                Caption = 'Vortext manuell';
                                MultiLine = true;
                            }
                        }
                    }
                    grid(Control100000015)
                    {
                        GridLayout = Rows;
                        group("Nachtext")
                        {
                            ShowCaption = false;
                            field(Nachlauftext; Rec.Nachlauftext)
                            {
                                ApplicationArea = All;
                                Caption = 'Nachtext 1';
                            }
                            field("Nachlauftext 2"; Rec."Nachlauftext 2")
                            {
                                ApplicationArea = All;
                                Caption = 'Nachtext 2';
                            }
                            field("Nachlauftext m"; Rec."Nachlauftext m")
                            {
                                ApplicationArea = All;
                                Caption = 'Nachtext manuell';
                                MultiLine = true;
                            }
                        }
                    }
                }
            }
            part(Control1000000008; "Materialanforderung Subform")
            {
                SubPageLink = "Projekt Nr" = field("Projekt Nr"),
                              "Lfd Nr" = field("Lfd Nr");
                ApplicationArea = All;
                Editable = IsEditable or IsPurchaser;
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            group("New Document")
            {
                Caption = 'Neu';
                Image = Add;

                actionref(NewHeader; "New Header") { }
                actionref(NewHeaderLines; "New Header Lines") { }
            }
            group(Release)
            {
                Caption = 'Anforderung senden';
                Image = ReleaseDoc;
                actionref(ReleaseDoc; "Release Doc") { }
                actionref(UnReleaseDoc; "Unrelease Doc") { }
            }
            group(Purchasing)
            {
                Caption = 'Status';
                Image = Purchasing;
                Enabled = IsPurchaser;
                Visible = IsPurchaser;

                actionref(CloseDoc; "Close Doc") { }
                actionref(OpenDoc; "Open Doc") { }
            }
            // group(Reports)
            // {
            //     Caption = 'Berichte';
            //     Image = Report;
            //     actionref(PrintMaterialList; "Materialanforderung drucken") { }
            // }
            actionref(CommentList; "Comment List") { }
            actionref(VendorSelection; "Vendor Selection") { }
            actionref(NewQuote; "New Quote") { }
            actionref(OpenInspection; "Open Inspection") { }
        }
        area(processing)
        {
            action("New Header Lines")
            {
                ApplicationArea = all;
                Caption = 'Kopiere Materialanforderung';
                trigger OnAction()
                var
                    MaterialanforderungKopf_Copy: Record Materialanforderungskopf;
                begin
                    MaterialanforderungKopf_Copy := CopyHeader(Rec);
                    CopyLines(Rec, MaterialanforderungKopf_Copy);
                    Page.Run(50065, MaterialanforderungKopf_Copy);
                end;
            }
            action("New Header")
            {
                ApplicationArea = all;
                Caption = 'Kopiere nur Materialanforderung Kopf';
                trigger OnAction()
                var
                    MaterialanforderungKopf_Copy: Record Materialanforderungskopf;
                begin
                    MaterialanforderungKopf_Copy := CopyHeader(Rec);
                    Page.Run(50065, MaterialanforderungKopf_Copy);
                end;
            }
            group(ActionGroup1000000010)
            {
                // action("Materialanforderung drucken")
                // {
                //     ApplicationArea = Basic;
                //     Image = Print;

                //     trigger OnAction()
                //     begin
                //         Materialanforderung.SetRange("Projekt Nr", Rec."Projekt Nr");
                //         Materialanforderung.SetRange("Lfd Nr", Rec."Lfd Nr");
                //         Report.RunModal(50065, true, false, Materialanforderung);
                //     end;
                // }
                action("Release Doc")
                {
                    ApplicationArea = Basic;
                    Caption = 'Anforderung senden';
                    Enabled = Rec.Status = Rec.Status::erfasst;
                    Image = ReleaseDoc;
                    trigger OnAction()
                    begin
                        Rec.TestField("Projekt Nr");
                        Rec.TestField(Stichwort);
                        Rec.TestField("Ship-to Name");
                        Rec.TestField("Ship-to Address");
                        Rec.TestField("Ship-to Post Code");
                        Rec.TestField("Ship-to City");
                        Rec.TestField("Ship-to Country/Region Code");
                        if Rec.Status < Rec.Status::freigegeben then begin
                            Rec.Status := Rec.Status::freigegeben;
                            Rec.Modify;
                            CurrPage.Update;
                        end;
                    end;
                }
                action("Unrelease Doc")
                {
                    ApplicationArea = Basic;
                    Caption = 'Anforderung stornieren';
                    Enabled = Rec.Status = Rec.Status::freigegeben;
                    Image = CloseDocument;
                    trigger OnAction()
                    begin
                        if Rec.Status = Rec.Status::freigegeben then begin
                            Rec.Status := Rec.Status::erfasst;
                            Rec.Modify();
                            CurrPage.Update();
                        end;
                    end;
                }
                action("Close Doc")
                {
                    ApplicationArea = Basic;
                    Caption = 'Status: Erledigt';
                    Enabled = IsPurchaser AND (Rec.Status = Rec.Status::freigegeben);
                    Image = Document;
                    Visible = IsPurchaser;

                    trigger OnAction()
                    begin
                        if Rec.Status = Rec.Status::freigegeben then begin
                            Rec.Status := Rec.Status::beendet;
                            Rec.Modify();
                            CurrPage.Update();
                        end;
                    end;
                }
                action("Open Doc")
                {
                    ApplicationArea = Basic;
                    Caption = 'Status: Angefordert';
                    Enabled = IsPurchaser AND (Rec.Status = Rec.Status::beendet);
                    Image = Document;
                    Visible = IsPurchaser;

                    trigger OnAction()
                    begin
                        if Rec.Status = Rec.Status::beendet then begin
                            Rec.Status := Rec.Status::freigegeben;
                            Rec.Modify();
                            CurrPage.Update();
                        end;
                    end;
                }
                action("Comment List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bemerkungen';
                    Image = Comment;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "No." = field("Projekt Nr");
                    ToolTip = 'Zeigt alle erstellten Bemerkungen für die Projekt-Nr. an.';
                }
                action("Vendor Selection")
                {
                    ApplicationArea = Basic;
                    Caption = 'Kreditorauswahl (Schritt 1)';
                    Enabled = IsPurchaser AND (Rec.Status = Rec.Status::freigegeben);
                    Visible = IsPurchaser;
                    Image = Vendor;
                    ToolTip = 'Enthält eine gefilterte Auswahl an Kreditoren.\Filterung verwendet Artikelkategorie- und Produktgruppencodes der Artikel und Segementierungen.\Materialanforderung muss im Status "Angefordert" sein.';

                    trigger OnAction()
                    var
                        Vendor: Record Vendor;
                        VendorSegmentation: Record "Vendor Segmentation";
                        VendorSerienanfrage: Record "Vendor - Serienanfrage";
                        VendorSerienanfrage_Find: Record "Vendor - Serienanfrage";
                        Segmentation_tmp: Record Segmentation temporary;
                        Materialanforderungzeile: Record Materialanforderungzeile;
                        Item: Record Item;
                        Contact_l: Record Contact;
                        KreditorSeriennummer_l: Page "Kreditor - Seriennummer";
                        LineNo: Integer;
                        ItemAttribute: Record "Item Attribute";
                    begin
                        //Ermittlung welche Segmentierungen in der Anfrage vorhanden sind.
                        Clear(Segmentation_tmp);
                        Segmentation_tmp.DeleteAll();

                        Materialanforderungzeile.SetRange("Projekt Nr", Rec."Projekt Nr");
                        Materialanforderungzeile.SetRange("Lfd Nr", Rec."Lfd Nr");
                        // Materialanforderungzeile.SetFilter("Menge", '>0');

                        if Materialanforderungzeile.FindSet() then begin
                            repeat
                                if Materialanforderungzeile."Artikel Nr" <> '' then
                                    if (Item.Get(Materialanforderungzeile."Artikel Nr") and (Item."Item Category Code" <> '') and (Item."Product Group Code TT" <> '')) then begin
                                        Segmentation_tmp.Reset();
                                        Segmentation_tmp.SetRange(Code, Item."Item Category Code");
                                        Segmentation_tmp.SetRange(Group, Item."Product Group Code TT");
                                        if Segmentation_tmp.IsEmpty() then begin
                                            Segmentation_tmp.Code := Item."Item Category Code";
                                            Segmentation_tmp.Group := Item."Product Group Code TT";
                                            Segmentation_tmp.Insert();
                                        end;
                                    end else begin
                                        // AC01 B
                                        // Old  ERROR('Für den Artikel %1 ist kein Artikelkategorie- und/oder Produktgruppencode hinterlegt. ' +
                                        //        '\Bitte ergänzen und Segmentierung erneut ausführen.',Item."No.");
                                        Error('Für den Artikel %1 ist kein Artikelkategorie- und/oder Produktgruppencode hinterlegt. ' +
                                              '\Bitte ergänzen und Segmentierung erneut ausführen.', Materialanforderungzeile."Artikel Nr");
                                        // AC01 E
                                    end;
                            until (Materialanforderungzeile.Next() = 0);
                        end;
                        Clear(Segmentation_tmp);
                        //Kreditoren zur Serienanfrage hinzufügen
                        if Segmentation_tmp.FindSet() then begin
                            LineNo += 10000;
                            repeat
                                VendorSegmentation.SetRange(Segmentation, Segmentation_tmp.Code);
                                //VendorSegmentation.SETRANGE(Group,Segmentation_tmp.Group);
                                VendorSegmentation.SetFilter(Group, '%1|%2', Segmentation_tmp.Group, '');

                                if VendorSegmentation.FindFirst() then begin
                                    repeat
                                        Clear(Vendor);
                                        if (Vendor.Get(VendorSegmentation.Vendor)) and (Vendor.Blocked <> Vendor.Blocked::All) then begin
                                            VendorSerienanfrage_Find.SetRange(Serienanfragenr, Format(Rec."Projekt Nr") + ';' + Format(Rec."Lfd Nr"));
                                            VendorSerienanfrage_Find.SetRange("No.", VendorSegmentation.Vendor);
                                            if not VendorSerienanfrage_Find.FindSet() then begin
                                                VendorSerienanfrage_Find.SetRange("No.");
                                                VendorSerienanfrage.Serienanfragenr := Format(Rec."Projekt Nr") + ';' + Format(Rec."Lfd Nr");
                                                VendorSerienanfrage.Validate("No.", VendorSegmentation.Vendor);
                                                VendorSerienanfrage."Line No." := LineNo;
                                                VendorSerienanfrage."Send Mail" := true;
                                                if VendorSerienanfrage.Insert() then
                                                    LineNo += 10000;
                                            end else begin
                                                VendorSerienanfrage_Find.SetRange("No.");
                                            end;
                                        end;
                                    until (VendorSegmentation.Next() = 0);
                                end else begin
                                    Error(ERR_NoVenderSegment, Segmentation_tmp.Code, Segmentation_tmp.Group);
                                end;
                            until (Segmentation_tmp.Next() = 0);

                            Commit();

                            VendorSerienanfrage.SetRange(Serienanfragenr, Format(Rec."Projekt Nr") + ';' + Format(Rec."Lfd Nr"));
                            KreditorSeriennummer_l.SetRecord(VendorSerienanfrage);
                            KreditorSeriennummer_l.SetTableview(VendorSerienanfrage);
                            if KreditorSeriennummer_l.RunModal() = Action::OK then begin
                            end
                        end;
                    end;
                }
                action("New Quote")
                {
                    ApplicationArea = Basic;
                    Caption = 'Anfrage erz. (Schritt 2)';
                    Enabled = IsPurchaser AND (Rec.Status = Rec.Status::freigegeben);
                    Visible = IsPurchaser;
                    Image = CreateDocument;
                    ToolTip = 'Erzeugt Serienanfragen und versendet automatisch E-Mails an die ausgewählten Kontakte.\Materialanforderung muss im Status "Angefordert" sein.';

                    trigger OnAction()
                    var
                        PurchSetup: Record "Purchases & Payables Setup";
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseHeader2: Record "Purchase Header";
                        PurchaseLine: Record "Purchase Line";
                        PurchaseLine2: Record "Purchase Line";
                        SalespersonPurchaser: Record "Salesperson/Purchaser";
                        Item: Record Item;
                        Materialanforderungzeile: Record Materialanforderungzeile;
                        VendorSerienanfrage: Record "Vendor - Serienanfrage";
                        VendorSerienanfrage_Find: Record "Vendor - Serienanfrage";
                        VendorSegmentation: Record "Vendor Segmentation";
                        Segmentation_tmp: Record Segmentation temporary;
                        CopyDocumentMgt: Codeunit "Copy Document Mgt.";
                        LineNo: Integer;
                        Serienanfragenummer: Code[20];
                        ExtendedTextHeader_l: Record "Extended Text Header";
                        ExtendedTextLine_l: Record "Extended Text Line";
                        MaterialToQuote: Record "Material To Quote";
                        Counter: Integer;
                        VendorPicked: Boolean;
                        VendorUsed: Boolean;
                    begin
                        Clear(VendorSerienanfrage);
                        VendorSerienanfrage.SetRange(Serienanfragenr, Format(Rec."Projekt Nr") + ';' + Format(Rec."Lfd Nr"));
                        VendorSerienanfrage.SetRange("Use Vendor", true);
                        if VendorSerienanfrage.FindFirst() then
                            VendorPicked := true;
                        VendorSerienanfrage.SetRange(Erledigt, false);
                        if VendorSerienanfrage.FindSet then begin
                            VendorUsed := true;
                            repeat
                                VendorSerienanfrage.TestField("Buy-from Contact No.");
                            until VendorSerienanfrage.Next = 0;
                        end;

                        if VendorSerienanfrage.FindSet then begin
                            /*//G-ERP.RS 2021-07-06 +
                            MESSAGE('Die folgenden Informationen werden noch benötigt.');
                            CLEAR(Eingabe);
                            Eingabe.SetCaptionText_1(PurchaseHeader.FIELDCAPTION(Leistung));
                            Eingabe.SetCaptionDate_1(PurchaseHeader.FIELDCAPTION("Angebotsabgabe bis"));
                            Eingabe.SetCaptionDate_2(PurchaseHeader.FIELDCAPTION("Requested Receipt Date"));
                            IF Eingabe.RUNMODAL() = ACTION::OK THEN BEGIN
                              Leistung                        := Eingabe.GetValueText_1();
                              AngebotsabgabeBis               := Eingabe.GetValueDate_1();
                              GewünschtesWareneingangsdatum := Eingabe.GetValueDate_2();
                            END;
                            *///G-ERP.RS 2021-07-06 -

                            Clear(SalespersonPurchaser);
                            SalespersonPurchaser.SetRange("User ID", UserId);
                            if SalespersonPurchaser.Count() > 1 then
                                Error('Es wurden mehrere Einkäufer der UserID %1 gefunden. Bitte einmal überprüfen.', UserId);

                            if not SalespersonPurchaser.FindSet() then
                                Error('Es konnte kein Einkäufer zu der UserID %1 gefunden werden. Bitte einmal überprüfen.', UserId);

                            repeat
                                Clear(PurchaseHeader);
                                PurchaseHeader.Init();
                                PurchaseHeader.Validate("No.", '');
                                PurchaseHeader.Validate("Document Type", PurchaseHeader."Document Type"::Quote);
                                PurchaseHeader.Insert(true);

                                if Serienanfragenummer = '' then begin
                                    PurchaseHeader.Validate(Serienanfragennr, PurchaseHeader."No.");
                                    PurchaseHeader.Validate(TreeNo, 1);
                                    Serienanfragenummer := PurchaseHeader.Serienanfragennr;
                                end else begin
                                    PurchaseHeader.Validate(Serienanfragennr, Serienanfragenummer);
                                    PurchaseHeader.Validate(TreeNo, 2);
                                end;

                                PurchaseHeader.Validate("Document Date", WorkDate);
                                PurchaseHeader.Validate(Status, PurchaseHeader.Status::Open);
                                PurchaseHeader.Validate("Buy-from Vendor No.", VendorSerienanfrage."No.");
                                PurchaseHeader.Validate("Buy-from Vendor Name", VendorSerienanfrage.Name);
                                PurchaseHeader.Validate("Buy-from Vendor Name 2", VendorSerienanfrage."Name 2");
                                PurchaseHeader.Validate("Buy-from Address", VendorSerienanfrage.Address);
                                PurchaseHeader.Validate("Buy-from Address 2", VendorSerienanfrage."Address 2");
                                PurchaseHeader.Validate("Buy-from Post Code", VendorSerienanfrage."Post Code");
                                //PurchaseHeader.VALIDATE("Buy-from Contact No.", VendorSerienanfrage."Buy-from Contact No.");
                                PurchaseHeader."Buy-from Contact No." := VendorSerienanfrage."Buy-from Contact No.";
                                PurchaseHeader.Validate("Buy-from Contact", VendorSerienanfrage."Buy-from Contact");
                                PurchaseHeader."Buy-from Contact" := VendorSerienanfrage."Buy-from Contact";
                                PurchaseHeader.Validate("Buy-from City", VendorSerienanfrage.City);
                                PurchaseHeader.Validate("Job No.", Rec."Projekt Nr");
                                PurchaseHeader.Validate(Serienanfragennr, Serienanfragenummer);
                                //PurchaseHeader.VALIDATE("Buy-from Contact Ansprech", VendorSerienanfrage."Buy-from Contact No.");
                                PurchaseHeader."Buy-from Contact Ansprech" := VendorSerienanfrage."Buy-from Contact No.";
                                //G-ERP.RS 2021-07-06 +
                                //PurchaseHeader.VALIDATE(Leistung, Leistung);
                                //PurchaseHeader.VALIDATE("Angebotsabgabe bis", AngebotsabgabeBis);
                                //PurchaseHeader.VALIDATE("Requested Receipt Date", GewünschtesWareneingangsdatum);
                                PurchaseHeader.Validate(Leistung, Rec.Leistung);
                                PurchaseHeader.Validate("Angebotsabgabe bis", Rec.AngebotsAbgabeBis);
                                PurchaseHeader.Validate("Requested Receipt Date", Rec.GewünschtesWareneingangsdatum);
                                //G-ERP.RS 2021-07-06 -
                                PurchaseHeader.Validate("Purchaser Code", SalespersonPurchaser.Code);
                                PurchaseHeader.Validate(Anforderer, Rec.Anforderer);
                                PurchaseHeader.Modify(true);
                                PurchSetup.Get();
                                //CopyDocumentMgt.SetProperties(FALSE,TRUE,FALSE,FALSE,FALSE,PurchSetup."Exact Cost Reversing Mandatory",FALSE);
                                //CopyDocumentMgt.CopyPurchDoc(PurchaseHeader2."Document Type",PurchaseHeader2."No.",PurchaseHeader);

                                //Vorlauftext
                                TextEinfuegen(Rec.Vorlauftext, PurchaseHeader);
                                TextEinfuegen(Rec."Vorlauftext 2", PurchaseHeader);
                                TextEinfuegenManuell(Rec."Vorlauftext m", PurchaseHeader);

                                Materialanforderungzeile.SetRange("Projekt Nr", Rec."Projekt Nr");
                                Materialanforderungzeile.SetRange("Lfd Nr", Rec."Lfd Nr");
                                // Materialanforderungzeile.SetFilter("Menge", '>0');
                                if Materialanforderungzeile.FindSet() then begin
                                    repeat
                                        if Materialanforderungzeile."Artikel Nr" <> '' then begin
                                            Item.Get(Materialanforderungzeile."Artikel Nr");
                                            if (VendorSegmentation.Get(PurchaseHeader."Buy-from Vendor No.", Item."Item Category Code", Item."Product Group Code TT")) or
                                               (VendorSegmentation.Get(PurchaseHeader."Buy-from Vendor No.", Item."Item Category Code", '')) then begin
                                                Clear(PurchaseLine);
                                                PurchaseLine.Init();
                                                PurchaseLine.Validate("Document No.", PurchaseHeader."No.");
                                                PurchaseLine.Validate("Document Type", PurchaseHeader."Document Type");
                                                PurchaseLine.Validate("Line No.", Materialanforderungzeile."Zeilen Nr");
                                                PurchaseLine.Insert(true);

                                                PurchaseLine.Validate(Type, PurchaseLine.Type::Item);
                                                PurchaseLine.Validate("No.", Materialanforderungzeile."Artikel Nr");
                                                PurchaseLine.Validate(Description, Materialanforderungzeile.Beschreibung);
                                                PurchaseLine.Validate("Description 2", Materialanforderungzeile."Beschreibung 2");
                                                //G-ERP.RS 2021-07-18 PurchaseLine.VALIDATE("Description 3",Materialanforderungzeile."Beschreibung 3");
                                                PurchaseLine.Validate("Description 4", Materialanforderungzeile."Beschreibung 4");
                                                PurchaseLine.Validate("Description 5", Materialanforderungzeile."Beschreibung 5");
                                                PurchaseLine.Validate("Unit of Measure", Materialanforderungzeile.Einheit);
                                                PurchaseLine.Validate(Quantity, Materialanforderungzeile."Quoted Quantity");
                                                PurchaseLine.Validate("Unit Cost", 0);
                                                PurchaseLine.Validate("Unit Cost (LCY)", 0);
                                                PurchaseLine.Validate("Direct Unit Cost", 0);
                                                PurchaseLine.Modify(true);

                                                Materialanforderungzeile."Anfrage erstellt" := true;
                                                Materialanforderungzeile.Modify();

                                                Clear(MaterialToQuote);
                                                Counter := MaterialToQuote.Count;

                                                MaterialToQuote.Init();
                                                MaterialToQuote."Entry No." := Counter + 3;
                                                MaterialToQuote.Insert(true);
                                                MaterialToQuote."Material No." := Materialanforderungzeile."Projekt Nr";
                                                MaterialToQuote."Material Entry No." := Materialanforderungzeile."Lfd Nr";
                                                MaterialToQuote."Item No." := Materialanforderungzeile."Artikel Nr";
                                                MaterialToQuote."Serial Quote No." := Serienanfragenummer;
                                                MaterialToQuote.Modify();
                                            end;
                                        end;
                                    until (Materialanforderungzeile.Next() = 0);
                                end;
                                VendorSerienanfrage.Erledigt := true;
                                VendorSerienanfrage.Modify;
                                //Nachlauftext
                                AddEmptyLine(PurchaseHeader, FindLastLine(PurchaseHeader));
                                TextEinfuegen(Rec.Nachlauftext, PurchaseHeader);
                                TextEinfuegen(Rec."Nachlauftext 2", PurchaseHeader);
                                TextEinfuegenManuell(Rec."Nachlauftext m", PurchaseHeader);

                                if VendorSerienanfrage."Send Mail" then
                                    if SendMailToVendor(PurchaseHeader."Document Type", PurchaseHeader."No.", VendorSerienanfrage."No.", VendorSerienanfrage."Send Mail To") then
                                        VendorSerienanfrage."Mail is Send" := true;

                                if VendorSerienanfrage."Use Vendor" then begin
                                    VendorSerienanfrage."Serienanfrage erstellt" := true;
                                    VendorSerienanfrage.Modify();
                                end;
                            until VendorSerienanfrage.Next = 0;
                            Message('Serienanfragen abgeschlossen');
                        end else
                            if NOT VendorPicked then
                                Message('In der Kreditorauswahl wurde kein Kreditor ausgewählt.')
                            else
                                if Not VendorUsed then
                                    Message('Die ausgewählten Kreditoren wurden bereits in Serienanfragen verwendet.');
                    end;
                }

                action("Open Inspection")
                {
                    ApplicationArea = All;
                    Caption = 'Prüfung';
                    Enabled = IsPurchaser;
                    Image = CheckList;
                    Visible = IsPurchaser;
                    ToolTip = 'Ansicht mit einer Filterung nach Projekt-Nr. und Lfd. Nr., um nicht abgehakte Posten auf der Materialanforderung anzuzeigen.';

                    trigger OnAction()
                    var
                        MaterialPrüfung: Page "Materialanforderung Prüfung";
                    begin
                        "MaterialPrüfung".SetParameters(Rec."Projekt Nr", Rec."Lfd Nr");
                        "MaterialPrüfung".Run();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        UserPermissions: Codeunit "User Permissions";
    begin
        if UserPermissions.HasUserPermissionSetAssigned(UserSecurityId(), CompanyName, 'TT EINKAUF', 1, '00000000-0000-0000-0000-000000000000') then begin
            IsPurchaser := true;
        end;
        IsEditable := true;
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Projekt Nr" <> '' then
            IsEditable := Rec.Status = Rec.Status::erfasst
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.TestField(Stichwort);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.TestField(Stichwort);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Belegdatum := Today;
    end;

    var
        Materialanforderung: Record Materialanforderungskopf;
        Lfd: Integer;
        ERR_StandardText: label 'The standard text %1 could not be found in the table %2. \ Please check your entry and try again.';
        ERR_NoVenderSegment: label 'Für die Artikelkategorie- und/oder Produktgruppencode %1 und %2 konnte kein Kreditor gefunden werden.';
        IsPurchaser: Boolean;
        IsEditable: Boolean;
        AddressFieldsEdit: Boolean;


    local procedure SendMailToVendor(DocumentType_L: enum "Purchase Document Type"; DocumentNo_L: Code[20];
                                                         VendorNo_L: Code[20];
                                                         MailTo_L: Text[80]) SendMailTo: Boolean
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        Vendor: Record Vendor;
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine_C: Record "Purchase Line";
        Email: Codeunit EMail;
        MailMsg: Codeunit "EMail Message";
        MailInStream: InStream;
        MailOutStream: OutStream;
        AttachmentTempBlob: Codeunit "Temp Blob";
        AttachmentInStream: InStream;
        AttachmentOutStream: OutStream;
        FileMgt: Codeunit "File Management";
        Base64Convert: Codeunit "Base64 Convert";
        txtB64: Text;
        FileName: Text;
        VendorName: Text;
        MailBody: Text;
        TTQuoteRTC: Report "TT Purchase - Quote RTC";
    begin
        Clear(PurchaseHeader);
        Clear(PurchaseLine_C);
        Clear(TTQuoteRTC);
        Clear(RecRef);
        Clear(AttachmentTempBlob);
        Clear(AttachmentInStream);
        Clear(AttachmentOutStream);

        if NOT Vendor.Get(VendorNo_L) then
            Error('Keditor %1 nicht gefunden.', VendorNo_L);

        txtB64 := '';
        FileName := '';
        VendorName := '';

        // test - should be removed
        MailTo_L := 'christian.nette@turbotechnik.com';

        if PurchaseHeader.Get(DocumentType_L, DocumentNo_L) then begin
            // declare file name for pdf
            if StrPos(Vendor."Search Name", ' ') <> 0 then
                VendorName := Lowercase(CopyStr(Vendor."Search Name", 1, StrPos(Vendor."Search Name", ' ') - 1))
            else
                VendorName := Lowercase(CopyStr(Vendor."Search Name", 1, StrLen(Vendor."Search Name")));
            FileName := Lowercase(PurchaseHeader."Job No.") + '-' + PurchaseHeader."No." + '-' + VendorName + '.pdf';
            // create pdf with tempblob and report.saveas()
            RecRef.GetTable(PurchaseHeader);
            FldRef := RecRef.Field(PurchaseHeader.FieldNo("No."));
            FldRef.SetRange(PurchaseHeader."No.");
            if RecRef.FindFirst() then begin
                AttachmentTempBlob.CreateOutStream(AttachmentOutStream);
                AttachmentTempBlob.CreateOutStream(MailOutStream);
                TTQuoteRTC.SetTableView(PurchaseHeader);
                TTQuoteRTC.SaveAs('', ReportFormat::Pdf, AttachmentOutStream, RecRef);
                AttachmentTempBlob.CreateInStream(AttachmentInStream);
                txtB64 := Base64Convert.ToBase64(AttachmentInStream, true);
                Message('E-Mail wird noch auf %1 umgeleitet, diese Funktion ist noch in der Testphase', MailTo_L);
                // if Confirm('Mail an den Kreditor %1 %2 senden?', true, VendorNo_L, Vendor.Name) then begin
                // FileMgt.BLOBExport(AttachmentTempBlob, VendorName + '.pdf', true);
                // create mailbody with report "email body text purchquote"
                if Report.SaveAs(Report::"Email Body Text PurchQuote", '', ReportFormat::Html, MailOutStream, RecRef) then begin
                    AttachmentTempBlob.CreateInStream(MailInStream, TextEncoding::Windows);
                    MailInStream.ReadText(MailBody);
                end;
                // create subject
                if PurchaseHeader."Language Code" = 'ENU' then
                    MailMsg.Create(MailTo_L, 'Our Quote ' + PurchaseHeader."Job No." + '/' + PurchaseHeader."No.", MailBody, true)
                else
                    MailMsg.Create(MailTo_L, 'Unsere Anfrage ' + PurchaseHeader."Job No." + '/' + PurchaseHeader."No.", MailBody, true);
                // add pdf file to mail
                MailMsg.AddAttachment(FileName, 'pdf', txtB64);
                // send mail
                Email.Send(MailMsg, Enum::"Email Scenario"::"Purchase Quote");
                SendMailTo := true;
                // end;
            end;
            Commit();
        end;
    end;

    local procedure SendMail(_DocumentType: enum "Purchase Document Type"; _DocumentNo: Code[20];
                                                _Mail: Text[80])
    var
        PurchaseHeader_l: Record "Purchase Header";
        PurchaseHeader2_l: Record "Purchase Header";
        Vendor_l: Record Vendor;
        Mail_l: Codeunit Mail;
        Name_l: Text[250];
        FileName_l: Text[250];
        ToFile_l: Text[250];
        GERW_l: Codeunit 50001;
    begin
        // PurchaseHeader_l.SetRange("Document Type", _DocumentType);
        // PurchaseHeader_l.SetRange("No.", _DocumentNo);

        // if PurchaseHeader_l.FindSet then begin
        //     Vendor_l.Get(PurchaseHeader_l."Buy-from Vendor No.");
        //     Name_l := Lowercase(PurchaseHeader_l."Job No.") + '-' + PurchaseHeader_l."No." + '-' +
        //               Lowercase(CopyStr(Vendor_l."Search Name", 1, StrPos(Vendor_l."Search Name", ' ')))
        //               + '.pdf';
        //     ToFile_l := Name_l;
        //     FileName_l := TemporaryPath + ToFile_l;
        //     PurchaseHeader2_l.SetRange("No.", PurchaseHeader_l."No.");
        // Report.SaveAsPdf(50001, FileName_l, PurchaseHeader2_l);
        //     ToFile_l := GERW_l.DownloadToClientFileName(FileName_l, ToFile_l);
        //     if PurchaseHeader_l."Language Code" = 'ENU' then
        //         Mail_l.NewMessage(_Mail, '', '', 'Our Inquiry ' + PurchaseHeader_l."Job No." + '/' + PurchaseHeader_l."No.",
        //                         '', ToFile_l, true)
        //     else
        //         Mail_l.NewMessage(_Mail, '', '', 'Unsere Anfrage ' + PurchaseHeader_l."Job No." + '/' + PurchaseHeader_l."No.",
        //                         '', ToFile_l, true);
        //     FILE.Copy(FileName_l, 'C:\Tageskopie\' + Name_l);
        //     FILE.Erase(FileName_l);
    end;

    local procedure TextEinfuegen(_StandardTextCode: Code[20]; _PurchaseHeader: Record "Purchase Header")
    var
        ExtendedTextHeader_l: Record "Extended Text Header";
        ExtendedTextLine_l: Record "Extended Text Line";
        StandardText_l: Record "Standard Text";
        PurchaseLine: Record "Purchase Line";
        LineNo_l: Integer;
    begin
        if _StandardTextCode <> '' then begin
            Clear(StandardText_l);
            if not StandardText_l.Get(_StandardTextCode) then
                Error(ERR_StandardText, _StandardTextCode, StandardText_l.TableCaption);

            Clear(ExtendedTextHeader_l);
            ExtendedTextHeader_l.SetCurrentkey("Table Name", "No.", "Language Code", "Text No.");
            ExtendedTextHeader_l.Ascending();

            ExtendedTextHeader_l.SetRange("Table Name", ExtendedTextHeader_l."table name"::"Standard Text");
            ExtendedTextHeader_l.SetRange("No.", _StandardTextCode);
            //TODO >=%1 | %2 for starting date, but <=%1 | %2 was given
            ExtendedTextHeader_l.SetFilter("Starting Date", '>=%1 | %2', Today, 0D);
            ExtendedTextHeader_l.SetFilter("Ending Date", '<=%1 | %2', Today, 0D);

            // if _PurchaseHeader."Language Code" = '' then
            //     ExtendedTextHeader_l.SetRange("Language Code", 'DEU')
            // else
            //     ExtendedTextHeader_l.SetRange("Language Code", _PurchaseHeader."Language Code");

            if not ExtendedTextHeader_l.FindLast() then
                ExtendedTextHeader_l.SetFilter("Language Code", '%1', '');


            //Letzte Zeilennr. + 100
            Clear(PurchaseLine);
            LineNo_l := FindLastLine(_PurchaseHeader);
            //1. Zeile der Textes Anlegen.
            LineNo_l += 100;
            Clear(PurchaseLine);
            PurchaseLine.Validate("Document No.", _PurchaseHeader."No.");
            PurchaseLine.Validate("Document Type", _PurchaseHeader."Document Type");
            PurchaseLine.Validate("Line No.", LineNo_l);
            PurchaseLine.Insert(true);
            PurchaseLine.Validate(Type, PurchaseLine.Type::" ");
            PurchaseLine.Validate(Description, StandardText_l.Description);
            PurchaseLine.Modify(true);
            LineNo_l += 100;
            AddEmptyLine(_PurchaseHeader, FindLastLine(_PurchaseHeader));

            if ExtendedTextHeader_l.FindLast() then begin
                ExtendedTextLine_l.SetRange("Table Name", ExtendedTextHeader_l."Table Name");
                ExtendedTextLine_l.SetRange("No.", ExtendedTextHeader_l."No.");
                ExtendedTextLine_l.SetRange("Language Code", ExtendedTextHeader_l."Language Code");
                ExtendedTextLine_l.SetRange("Text No.", ExtendedTextHeader_l."Text No.");

                //Weitere Textbausteinzeilen aus den Textbausteinzeilen
                if ExtendedTextLine_l.FindSet() then begin
                    repeat
                        LineNo_l += 100;
                        Clear(PurchaseLine);
                        PurchaseLine.Validate("Document No.", _PurchaseHeader."No.");
                        PurchaseLine.Validate("Document Type", _PurchaseHeader."Document Type");
                        PurchaseLine.Validate("Line No.", LineNo_l);
                        PurchaseLine.Insert(true);
                        PurchaseLine.Validate(Type, PurchaseLine.Type::" ");
                        PurchaseLine.Validate(Description, ExtendedTextLine_l.Text);
                        PurchaseLine.Modify(true);
                    until ExtendedTextLine_l.Next() = 0;
                end;

                AddEmptyLine(_PurchaseHeader, FindLastLine(_PurchaseHeader));
            end;
        end;
    end;

    local procedure TextEinfuegenManuell(_Text: Text[1000]; _PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        LineNo_l: Integer;
        ListTexts: List of [Text];
        ListItemText: Text;
    begin
        if _Text <> '' then begin
            LineNo_l := FindLastLine(_PurchaseHeader);
            ListTexts := SplitStringByCRLF(_Text, 100);

            foreach ListItemText in ListTexts do begin
                LineNo_l += 100;
                Clear(PurchaseLine);
                PurchaseLine.Validate("Document No.", _PurchaseHeader."No.");
                PurchaseLine.Validate("Document Type", _PurchaseHeader."Document Type");
                PurchaseLine.Validate("Line No.", LineNo_l);
                PurchaseLine.Insert(true);
                PurchaseLine.Validate(Type, PurchaseLine.Type::" ");
                PurchaseLine.Validate(Description, ListItemText);
                PurchaseLine.Modify(true);
            end;

            AddEmptyLine(_PurchaseHeader, FindLastLine(_PurchaseHeader));
        end;
    end;

    local procedure FindLastLine(_PurchaseHeader: Record "Purchase Header") ResultLineNo: Integer
    var
        PurchaseLine_l: Record "Purchase Line";
    begin
        ResultLineNo := 0;
        PurchaseLine_l.SetRange("Document No.", _PurchaseHeader."No.");
        PurchaseLine_l.SetRange("Document Type", _PurchaseHeader."Document Type");
        if PurchaseLine_l.FindLast() then
            ResultLineNo := PurchaseLine_l."Line No.";
    end;

    local procedure AddEmptyLine(_PurchaseHeader: Record "Purchase Header"; _LineNo: Integer)
    var
        PurchaseLine_l: Record "Purchase Line";
    begin
        _LineNo += 100;
        Clear(PurchaseLine_l);
        PurchaseLine_l.Validate("Document No.", _PurchaseHeader."No.");
        PurchaseLine_l.Validate("Document Type", _PurchaseHeader."Document Type");
        PurchaseLine_l.Validate("Line No.", _LineNo);
        PurchaseLine_l.Insert(true);
    end;

    // better function to cut the string into multiple lines
    local procedure SplitStringByCRLF(InputText: Text; FieldLength: Integer) ListOfText: List of [Text]
    var
        CLRF: Char;
        TmpText: Text;
        TmpList: List of [Text];
        TmpListSplit: List of [Text];
    begin
        CLRF := 10;
        TmpList := InputText.Split(CLRF);
        foreach TmpText in TmpList do begin
            if StrLen(TmpText) > FieldLength then begin
                TmpListSplit := SplitStringIntoFixedLength(TmpText, FieldLength);
                foreach TmpText in TmpListSplit do begin
                    ListOfText.Add(TmpText);
                end;
            end
            else begin
                ListOfText.Add(TmpText);
            end;
        end;
    end;

    local procedure SplitStringIntoFixedLength(InputText: Text; FieldLength: Integer) ListOfText: List of [Text]
    var
        DivValue: Integer;
        I: Integer;
        ModValue: Integer;
        SplitTo: Integer;
        RemainValue: Text[1024];
        SplitResult: Text[1024];
    begin
        DivValue := StrLen(InputText) div FieldLength;
        ModValue := StrLen(InputText) mod FieldLength;

        if ModValue = 0 then
            SplitTo := DivValue
        else
            SplitTo := DivValue + 1;

        RemainValue := InputText;
        for I := 1 to SplitTo do begin
            SplitResult := CopyStr(RemainValue, 1, FieldLength);
            if StrLen(RemainValue) >= FieldLength + 1 then
                RemainValue := CopyStr(RemainValue, FieldLength + 1, StrLen(RemainValue));
            ListOfText.Add(SplitResult);
        end;
    end;

    local procedure CopyHeader(Original: Record Materialanforderungskopf) NewCopy: Record Materialanforderungskopf
    begin
        NewCopy.Init();
        NewCopy."Projekt Nr" := Original."Projekt Nr";
        NewCopy."Lfd Nr" := FindNewEntryNo(Original);
        NewCopy.Insert(true);
        NewCopy.Validate(Anforderer, Original.Anforderer);
        NewCopy.Validate(AngebotsAbgabeBis, Original.AngebotsAbgabeBis);
        NewCopy.Validate(Belegdatum, Original.Belegdatum);
        NewCopy.Validate("Delivery Period", Original."Delivery Period");
        NewCopy.Validate("Place of Delivery", Original."Place of Delivery");
        NewCopy.Validate("Ship-to Name", Original."Ship-to Name");
        NewCopy.Validate("Ship-to Name 2", Original."Ship-to Name 2");
        NewCopy.Validate("Ship-to Address", Original."Ship-to Address");
        NewCopy.Validate("Ship-to Address 2", Original."Ship-to Address 2");
        NewCopy.Validate("Ship-to Post Code", Original."Ship-to Post Code");
        NewCopy.Validate("Ship-to City", Original."Ship-to City");
        NewCopy.Validate("Ship-to Country/Region Code", Original."Ship-to Country/Region Code");
        NewCopy.Validate("Ship-to Contact", Original."Ship-to Contact");
        NewCopy.Validate("Purchase Order Date", Rec."Purchase Order Date");
        NewCopy.Validate("Geplantes Versanddatum", Original."Geplantes Versanddatum");
        NewCopy.Validate("GewünschtesWareneingangsdatum", Original."GewünschtesWareneingangsdatum");
        NewCopy.Validate(Leistung, Original.Leistung);
        NewCopy.Validate(Nachlauftext, Original.Nachlauftext);
        NewCopy.Validate("Nachlauftext 2", Original."Nachlauftext 2");
        NewCopy.Validate("Nachlauftext m", Original."Nachlauftext m");
        NewCopy.Validate(Status, NewCopy.Status::erfasst);
        NewCopy.Validate(Stichwort, Original.Stichwort);
        NewCopy.Validate(Typ, Original.Typ);
        NewCopy.Validate(Vorlauftext, Original.Vorlauftext);
        NewCopy.Validate("Vorlauftext 2", Original."Vorlauftext 2");
        NewCopy.Validate("Vorlauftext m", Original."Vorlauftext m");
        NewCopy.Modify();
        exit(NewCopy);
    end;

    procedure CopyLines(Original: Record "Materialanforderungskopf"; NewCopy: Record "Materialanforderungskopf")
    var
        MaterialZeile: Record Materialanforderungzeile;
        MaterialZeile_Copy: Record Materialanforderungzeile;
        Counter: Integer;
    begin
        Counter := 10000;
        MaterialZeile.SetRange("Projekt Nr", Original."Projekt Nr");
        MaterialZeile.SetRange("Lfd Nr", Original."Lfd Nr");
        if MaterialZeile.FindSet() then
            repeat
                MaterialZeile_Copy.Init();
                MaterialZeile_Copy."Projekt Nr" := NewCopy."Projekt Nr";
                MaterialZeile_Copy."Lfd Nr" := NewCopy."Lfd Nr";
                MaterialZeile_Copy."Zeilen Nr" := Counter;
                MaterialZeile_Copy.Insert();
                MaterialZeile_Copy.Abgehakt := false;
                MaterialZeile_Copy.Validate("Artikel Nr", MaterialZeile."Artikel Nr");
                MaterialZeile_Copy.Validate(Beschreibung, MaterialZeile."Beschreibung");
                MaterialZeile_Copy.Validate("Beschreibung 2", MaterialZeile."Beschreibung 2");
                MaterialZeile_Copy.Validate("Beschreibung 3", MaterialZeile."Beschreibung 3");
                MaterialZeile_Copy.Validate("Beschreibung 4", MaterialZeile."Beschreibung 4");
                MaterialZeile_Copy.Validate("Beschreibung 5", MaterialZeile."Beschreibung 5");
                MaterialZeile_Copy.Validate(Einheit, MaterialZeile.Einheit);
                MaterialZeile_Copy.Validate("Gehört zu Zeilen Nr", MaterialZeile."Gehört zu Zeilen Nr");
                MaterialZeile_Copy.Validate(Menge, MaterialZeile."Menge");
                MaterialZeile_Copy.Validate("zusätzliche Anforderungen", MaterialZeile."zusätzliche Anforderungen");
                MaterialZeile_Copy.Validate("zusätzliche Anforderungen", MaterialZeile."zusätzliche Anforderungen");
                MaterialZeile_Copy.Validate("Is Item No.", MaterialZeile."Is Item No.");
                MaterialZeile_Copy.Modify();
                Counter += 10000;
            until MaterialZeile.Next() = 0;
    end;

    local procedure FindNewEntryNo(Original: Record Materialanforderungskopf): Integer
    var
        Materialanforderungskopf: Record Materialanforderungskopf;
    begin
        Materialanforderungskopf.SetRange("Projekt Nr", Original."Projekt Nr");
        if Materialanforderungskopf.FindLast() then
            exit(Materialanforderungskopf."Lfd Nr" + 10);
        Error('Die Materialanforderung kann nicht kopiert werden');
    end;

    local procedure ToggleShipToOption()
    var
        Location: Record Location;
    begin
        if Rec."Place of Delivery" = Rec."Place of Delivery"::WHV then begin
            if Location.Get('WHV') then begin
                Rec."Ship-to Name" := Location.Name;
                Rec."Ship-to Address" := Location.Address;
                Rec."Ship-to Address 2" := Location."Address 2";
                Rec."Ship-to City" := Location.City;
                Rec."Ship-to Post Code" := Location."Post Code";
                Rec."Ship-to Country/Region Code" := Location."Country/Region Code";
                Rec."Ship-to Contact" := Location.Contact;
                AddressFieldsEdit := false;
            end;
        end else begin
            Rec."Ship-to Name" := '';
            Rec."Ship-to Address" := '';
            Rec."Ship-to Address 2" := '';
            Rec."Ship-to City" := '';
            Rec."Ship-to Post Code" := '';
            Rec."Ship-to Country/Region Code" := '';
            Rec."Ship-to Contact" := '';
            AddressFieldsEdit := true;
        end;
    end;
}

