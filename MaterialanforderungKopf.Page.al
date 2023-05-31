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
                    ShowMandatory = true;

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
                    end;
                }
                field("Lfd Nr"; Rec."Lfd Nr")
                {
                    ApplicationArea = Basic;
                }
                field(Stichwort; Rec.Stichwort)
                {
                    ApplicationArea = Basic;
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field(Belegdatum; Rec.Belegdatum)
                {
                    ApplicationArea = Basic;
                }
                field("Geplantes Versanddatum"; Rec."Geplantes Versanddatum")
                {
                    ApplicationArea = Basic;
                    NotBlank = true;
                }
                field(Beschreibung; Rec.Beschreibung)
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(Leistung; Rec.Leistung)
                {
                    ApplicationArea = Basic;
                }
                field(AngebotsAbgabeBis; Rec.AngebotsAbgabeBis)
                {
                    ApplicationArea = Basic;
                }
                field("GewünschtesWareneingangsdatum"; Rec.GewünschtesWareneingangsdatum)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Texte)
            {
                Caption = 'Vor-/Nachtext (durch KE auszufüllen)';
                grid(Control100000010)
                {
                    GridLayout = Rows;
                    group("Vortext 1")
                    {
                        Caption = 'Vortext 1';
                        field(Vorlauftext; Rec.Vorlauftext)
                        {
                            ApplicationArea = Basic;
                            ShowCaption = false;
                        }
                    }
                    group("Vortext 2")
                    {
                        Caption = 'Vortext 2';
                        field("Vorlauftext 2"; Rec."Vorlauftext 2")
                        {
                            ApplicationArea = Basic;
                            ShowCaption = false;
                        }
                    }
                    group("Vortext manuell")
                    {
                        Caption = 'Vortext manuell';
                        field("Vorlauftext m"; Rec."Vorlauftext m")
                        {
                            ApplicationArea = Basic;
                            MultiLine = true;
                            ShowCaption = false;
                        }
                    }
                }
                grid(Control100000015)
                {
                    GridLayout = Rows;
                    group("Nachtext 1")
                    {
                        Caption = 'Nachtext 1';
                        field(Nachlauftext; Rec.Nachlauftext)
                        {
                            ApplicationArea = Basic;
                            ShowCaption = false;
                        }
                    }
                    group("Nachtext 2")
                    {
                        Caption = 'Nachtext 2';
                        field("Nachlauftext 2"; Rec."Nachlauftext 2")
                        {
                            ApplicationArea = Basic;
                            ShowCaption = false;
                        }
                    }
                    group("Nachtext manuell")
                    {
                        Caption = 'Nachtext manuell';
                        field("Nachlauftext m"; Rec."Nachlauftext m")
                        {
                            ApplicationArea = Basic;
                            MultiLine = true;
                            ShowCaption = false;
                        }
                    }
                }
            }
            part(Control1000000008; "Materialanforderung Subform")
            {
                Caption = 'Werkzeuge/Verbrauchermaterialen';
                SubPageLink = "Projekt Nr" = field("Projekt Nr"),
                              "Lfd Nr" = field("Lfd Nr");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup1000000010)
            {
                action("Materialanforderung drucken")
                {
                    ApplicationArea = Basic;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Materialanforderung.SetRange("Projekt Nr", Rec."Projekt Nr");
                        Materialanforderung.SetRange("Lfd Nr", Rec."Lfd Nr");
                        Report.RunModal(50065, true, false, Materialanforderung);
                    end;
                }
                action(Freigeben)
                {
                    ApplicationArea = Basic;
                    Caption = 'Release';

                    trigger OnAction()
                    begin
                        if Rec.Status < Rec.Status::freigegeben then begin
                            Rec.Status := Rec.Status::freigegeben;
                            Rec.Modify;
                            CurrPage.Update;
                        end;
                    end;
                }
                action("Status zurücksetzen")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reject Status';

                    trigger OnAction()
                    begin
                        if Rec.Status = Rec.Status::freigegeben then begin
                            Rec.Status := Rec.Status::erfasst;
                            Rec.Modify;
                            CurrPage.Update;
                        end;
                    end;
                }
                action(Beenden)
                {
                    ApplicationArea = Basic;

                    trigger OnAction()
                    begin
                        if Rec.Status = Rec.Status::freigegeben then begin
                            Rec.Status := Rec.Status::beendet;
                            Rec.Modify;
                            CurrPage.Update;
                        end;
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bemerkungen';
                    Image = Comment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(14),
                                  "No." = field("Projekt Nr");
                }
                action("Kreditorauswahl (Schritt 1)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Kreditorauswahl (Schritt 1)';
                    Image = Vendor;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

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

                        if Materialanforderungzeile.FindSet() then begin
                            repeat
                                if (Item.Get(Materialanforderungzeile."Artikel Nr") and
                                            (Item."Item Category Code" <> '') and
                                            (Item."Item Category Code" <> '')) then begin
                                    if not Segmentation_tmp.Get(Item."Item Category Code", Item."Item Category Code") then begin
                                        Segmentation_tmp.Code := Item."Item Category Code";
                                        Segmentation_tmp.Group := Item."Item Category Code";
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

                        //Kreditoren zur Serienanfrage hinzufügen
                        if Segmentation_tmp.FindSet() then begin
                            LineNo += 10000;

                            repeat
                                VendorSegmentation.SetRange(Segmentation, Segmentation_tmp.Code);
                                //VendorSegmentation.SETRANGE(Group,Segmentation_tmp.Group);
                                VendorSegmentation.SetFilter(Group, '%1|%2', Segmentation_tmp.Group, '');

                                if VendorSegmentation.FindFirst() then begin
                                    repeat
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
                                    until (VendorSegmentation.Next() = 0);
                                end else begin
                                    Error(ERR_NoVenderSegment, Segmentation_tmp.Code, Segmentation_tmp.Group);
                                end;
                            until (Segmentation_tmp.Next() = 0);

                            Commit();

                            VendorSerienanfrage.SetRange(Serienanfragenr, Format(Rec."Projekt Nr") + ';' + Format(Rec."Lfd Nr"));
                            KreditorSeriennummer_l.SetRecord(VendorSerienanfrage);
                            KreditorSeriennummer_l.SetTableview(VendorSerienanfrage);
                            if KreditorSeriennummer_l.RunModal() = Action::OK then;

                        end;
                    end;
                }
                action("Anfrage erz. (Schritt 2)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Anfrage erz. (Schritt 2)';
                    Image = CreateDocument;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;

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
                        "-----------------------------1": Integer;
                        LineNo: Integer;
                        Serienanfragenummer: Code[20];
                        "-----------------------------2": Integer;
                        ExtendedTextHeader_l: Record "Extended Text Header";
                        ExtendedTextLine_l: Record "Extended Text Line";
                    begin
                        VendorSerienanfrage.SetRange(Serienanfragenr, Format(Rec."Projekt Nr") + ';' + Format(Rec."Lfd Nr"));
                        VendorSerienanfrage.SetRange(Erledigt, false);
                        VendorSerienanfrage.SetRange("Ignore Vendor", false);
                        if VendorSerienanfrage.FindSet then begin
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
                                Error('Es konnte kein kein Einkäufer zu der UserID %1 gefunden werden. Bitte einmal überprüfen.', UserId);

                            repeat
                                Clear(PurchaseHeader);
                                PurchaseHeader.Init();
                                PurchaseHeader.Validate("No.", '');
                                PurchaseHeader.Validate("Document Type", PurchaseHeader."document type"::Quote);
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
                                PurchSetup.Get;
                                //CopyDocumentMgt.SetProperties(FALSE,TRUE,FALSE,FALSE,FALSE,PurchSetup."Exact Cost Reversing Mandatory",FALSE);
                                //CopyDocumentMgt.CopyPurchDoc(PurchaseHeader2."Document Type",PurchaseHeader2."No.",PurchaseHeader);

                                //Vorlauftext
                                TextEinfuegen(Rec.Vorlauftext, PurchaseHeader);
                                TextEinfuegen(Rec."Vorlauftext 2", PurchaseHeader);
                                TextEinfuegenManuell(Rec."Vorlauftext m", PurchaseHeader);

                                Materialanforderungzeile.SetRange("Projekt Nr", Rec."Projekt Nr");
                                Materialanforderungzeile.SetRange("Lfd Nr", Rec."Lfd Nr");
                                if Materialanforderungzeile.FindSet() then begin
                                    repeat
                                        Item.Get(Materialanforderungzeile."Artikel Nr");
                                        if (VendorSegmentation.Get(PurchaseHeader."Buy-from Vendor No.", Item."Item Category Code", Item."Item Category Code")) or
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
                                            PurchaseLine.Validate(Quantity, Materialanforderungzeile.Menge);
                                            PurchaseLine.Validate("Unit Cost", 0);
                                            PurchaseLine.Validate("Unit Cost (LCY)", 0);
                                            PurchaseLine.Validate("Direct Unit Cost", 0);
                                            PurchaseLine.Modify(true);

                                            Materialanforderungzeile."Anfrage erstellt" := true;
                                        end;
                                    until (Materialanforderungzeile.Next() = 0);
                                end;
                                VendorSerienanfrage.Erledigt := true;
                                VendorSerienanfrage.Modify;

                                //Nachlauftext
                                LeereZeileEinfuegen(PurchaseHeader);
                                TextEinfuegen(Rec.Nachlauftext, PurchaseHeader);
                                TextEinfuegen(Rec."Nachlauftext 2", PurchaseHeader);
                                TextEinfuegenManuell(Rec."Nachlauftext m", PurchaseHeader);

                                if VendorSerienanfrage."Send Mail" then begin
                                    SendMail(PurchaseHeader."Document Type", PurchaseHeader."No.", VendorSerienanfrage."Send Mail To");
                                    VendorSerienanfrage."Mail is Send" := true;
                                end;

                            until VendorSerienanfrage.Next = 0;

                            Message('Serienanfragen abgeschlossen');
                        end;

                    end;
                }
            }
        }
    }

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

    local procedure SendMail(_DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; _DocumentNo: Code[20]; _Mail: Text[80])
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
        PurchaseHeader_l.SetRange("Document Type", _DocumentType);
        PurchaseHeader_l.SetRange("No.", _DocumentNo);

        // if PurchaseHeader_l.FindSet then begin
        //     Vendor_l.Get(PurchaseHeader_l."Buy-from Vendor No.");
        //     Name_l := Lowercase(PurchaseHeader_l."Job No.") + '-' + PurchaseHeader_l."No." + '-' +
        //               Lowercase(CopyStr(Vendor_l."Search Name", 1, StrPos(Vendor_l."Search Name", ' ')))
        //               + '.pdf';
        //     ToFile_l := Name_l;
        //     FileName_l := TemporaryPath + ToFile_l;
        //     PurchaseHeader2_l.SetRange("No.", PurchaseHeader_l."No.");
        //     Report.SaveAsPdf(50001, FileName_l, PurchaseHeader2_l);
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
            ExtendedTextHeader_l.SetFilter("Starting Date", '<=%1|%2', Today, 0D);
            ExtendedTextHeader_l.SetFilter("Ending Date", '>=%1|%2', Today, 0D);

            if _PurchaseHeader."Language Code" = '' then
                ExtendedTextHeader_l.SetRange("Language Code", 'DEU')
            else
                ExtendedTextHeader_l.SetRange("Language Code", _PurchaseHeader."Language Code");

            if not ExtendedTextHeader_l.FindLast() then
                ExtendedTextHeader_l.SetFilter("Language Code", '%1', '');

            if ExtendedTextHeader_l.FindLast() then begin
                ExtendedTextLine_l.SetRange("Table Name", ExtendedTextHeader_l."Table Name");
                ExtendedTextLine_l.SetRange("No.", ExtendedTextHeader_l."No.");
                ExtendedTextLine_l.SetRange("Language Code", ExtendedTextHeader_l."Language Code");
                ExtendedTextLine_l.SetRange("Text No.", ExtendedTextHeader_l."Text No.");

                //Letzte Zeilennr. + 100
                Clear(PurchaseLine);
                PurchaseLine.SetCurrentkey("Document Type", "Document No.", "Line No.");
                PurchaseLine.Ascending();
                PurchaseLine.SetRange("Document No.", _PurchaseHeader."No.");
                PurchaseLine.SetRange("Document Type", _PurchaseHeader."Document Type");
                if PurchaseLine.FindLast() then
                    LineNo_l := PurchaseLine."Line No.";

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
                    until (ExtendedTextLine_l.Next() = 0);
                end;

                //Weitere Leere Zeile einfürgen.
                LineNo_l += 100;
                Clear(PurchaseLine);
                PurchaseLine.Validate("Document No.", _PurchaseHeader."No.");
                PurchaseLine.Validate("Document Type", _PurchaseHeader."Document Type");
                PurchaseLine.Validate("Line No.", LineNo_l);
                PurchaseLine.Insert(true);

            end;
        end;
    end;

    local procedure TextEinfuegenManuell(_Text: Text[50]; _PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        LineNo_l: Integer;
        workingTextCopy: Text[50];
        workingTextCopySave: Text[50];
        cr: Char;
        lf: Char;
    begin
        cr := 13;
        lf := 10;

        workingTextCopy := _Text;

        if workingTextCopy <> '' then begin
            Clear(PurchaseLine);
            PurchaseLine.SetCurrentkey("Document Type", "Document No.", "Line No.");
            PurchaseLine.Ascending();
            PurchaseLine.SetRange("Document No.", _PurchaseHeader."No.");
            PurchaseLine.SetRange("Document Type", _PurchaseHeader."Document Type");
            if PurchaseLine.FindLast() then
                LineNo_l := PurchaseLine."Line No.";

            if StrPos(workingTextCopy, Format(cr) + Format(lf)) > 0 then begin
                repeat
                    LineNo_l += 100;
                    Clear(PurchaseLine);
                    PurchaseLine.Validate("Document No.", _PurchaseHeader."No.");
                    PurchaseLine.Validate("Document Type", _PurchaseHeader."Document Type");
                    PurchaseLine.Validate("Line No.", LineNo_l);
                    PurchaseLine.Insert(true);
                    PurchaseLine.Validate(Type, PurchaseLine.Type::" ");
                    PurchaseLine.Validate(Description, CopyStr(workingTextCopy, 1, StrPos(workingTextCopy, Format(cr) + Format(lf))));
                    PurchaseLine.Modify(true);
                    workingTextCopy := CopyStr(workingTextCopy, StrPos(workingTextCopy, Format(cr) + Format(lf)) + 2, StrLen(workingTextCopy));
                until (StrPos(workingTextCopy, Format(cr) + Format(lf)) = 0);
            end;

            //Letzten Teil einfügen
            LineNo_l += 100;
            Clear(PurchaseLine);
            PurchaseLine.Validate("Document No.", _PurchaseHeader."No.");
            PurchaseLine.Validate("Document Type", _PurchaseHeader."Document Type");
            PurchaseLine.Validate("Line No.", LineNo_l);
            PurchaseLine.Insert(true);
            PurchaseLine.Validate(Type, PurchaseLine.Type::" ");
            PurchaseLine.Validate(Description, workingTextCopy);
            PurchaseLine.Modify(true);

            //Weitere Leere Zeile einfürgen.
            LineNo_l += 100;
            Clear(PurchaseLine);
            PurchaseLine.Validate("Document No.", _PurchaseHeader."No.");
            PurchaseLine.Validate("Document Type", _PurchaseHeader."Document Type");
            PurchaseLine.Validate("Line No.", LineNo_l);
            PurchaseLine.Insert(true);

        end;
    end;

    local procedure LeereZeileEinfuegen(_PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        LineNo_l: Integer;
    begin
        Clear(PurchaseLine);
        PurchaseLine.SetCurrentkey("Document Type", "Document No.", "Line No.");
        PurchaseLine.Ascending();
        PurchaseLine.SetRange("Document No.", _PurchaseHeader."No.");
        PurchaseLine.SetRange("Document Type", _PurchaseHeader."Document Type");
        if PurchaseLine.FindLast() then
            LineNo_l := PurchaseLine."Line No.";

        LineNo_l += 100;
        Clear(PurchaseLine);
        PurchaseLine.Validate("Document No.", _PurchaseHeader."No.");
        PurchaseLine.Validate("Document Type", _PurchaseHeader."Document Type");
        PurchaseLine.Validate("Line No.", LineNo_l);
        PurchaseLine.Insert(true);
    end;
}

