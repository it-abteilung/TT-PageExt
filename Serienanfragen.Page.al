Page 50060 Serienanfragen
{
    DeleteAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Segmentation';
    SourceTable = "Purchase Header";

    layout
    {
        area(content)
        {
            group(Serienanfrage)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Zeilen; "Serienanfrage - SubPage")
            {
                SubPageLink = Serienanfragenr = field("No.");
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Erstellen)
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PurchSetup: Record "Purchases & Payables Setup";
                    UserSetup: Record "User Setup";
                    PurchaseLineOld: Record "Purchase Line";
                    PurchaseLineNew: Record "Purchase Line";
                begin
                    VendorSerienanfrage.SetRange(Serienanfragenr, Rec."No.");
                    VendorSerienanfrage.SetRange(Erledigt, false);
                    if VendorSerienanfrage.FindSet then begin
                        repeat
                            VendorSerienanfrage.TestField("Buy-from Contact No.");
                        until VendorSerienanfrage.Next = 0;
                    end;

                    // PurchaseLine.SETRANGE("Document No.", "No.");
                    // PurchaseLine.SETRANGE("Document Type", "Document Type");

                    if VendorSerienanfrage.FindSet then begin
                        PurchaseHeader.Get(Rec."Document Type", Rec."No.");
                        PurchaseHeader.Serienanfragennr := VendorSerienanfrage.Serienanfragenr;
                        PurchaseHeader.Modify;
                        PurchaseHeader2.Get(Rec."Document Type", Rec."No.");
                        repeat
                            Clear(PurchaseHeader);
                            PurchaseHeader.SetRange("Buy-from Vendor No.", VendorSerienanfrage."No.");
                            PurchaseHeader.SetRange("Buy-from Contact Ansprech", VendorSerienanfrage."Buy-from Contact No.");
                            PurchaseHeader.SetRange(Serienanfragennr, VendorSerienanfrage.Serienanfragenr);
                            if not PurchaseHeader.FindSet then begin
                                Clear(PurchaseHeader);
                                PurchaseHeader."Document Type" := PurchaseHeader."document type"::Quote;
                                PurchaseHeader.Insert(true);
                                PurchaseHeader."Document Date" := WorkDate;
                                PurchaseHeader.Status := PurchaseHeader.Status::Open;
                                PurchaseHeader.Validate("Buy-from Vendor No.", VendorSerienanfrage."No.");
                                PurchaseHeader."Buy-from Vendor Name" := VendorSerienanfrage.Name;
                                PurchaseHeader."Buy-from Vendor Name 2" := VendorSerienanfrage."Name 2";
                                PurchaseHeader."Buy-from Address" := VendorSerienanfrage.Address;
                                PurchaseHeader."Buy-from Address 2" := VendorSerienanfrage."Address 2";
                                PurchaseHeader."Buy-from Post Code" := VendorSerienanfrage."Post Code";
                                PurchaseHeader."Buy-from Contact No." := VendorSerienanfrage."Buy-from Contact No.";
                                PurchaseHeader."Buy-from Contact" := VendorSerienanfrage."Buy-from Contact";
                                PurchaseHeader."Buy-from City" := VendorSerienanfrage.City;
                                PurchaseHeader."Job No." := Rec."Job No.";
                                PurchaseHeader.Serienanfragennr := VendorSerienanfrage.Serienanfragenr;
                                PurchaseHeader."Buy-from Contact Ansprech" := VendorSerienanfrage."Buy-from Contact No.";
                                PurchaseHeader.Leistung := PurchaseHeader2.Leistung;
                                PurchaseHeader."Angebotsabgabe bis" := PurchaseHeader2."Angebotsabgabe bis";
                                PurchaseHeader."Requested Receipt Date" := PurchaseHeader2."Requested Receipt Date";
                                PurchaseHeader.TreeNo := 2;
                                if UserSetup.Get(UserId) then
                                    PurchaseHeader."Purchaser Code" := UserSetup."Salespers./Purch. Code";
                                PurchaseHeader.Modify;
                                PurchSetup.Get;

                                //TODO muss auskommentiert werden, weil line no neu berechnet werden
                                // if UpperCase(UserId) = 'TURBO-TECHNIK\GERWING-ERP' then
                                //     CopyDocMgt.SetProperties(
                                //       false, true, false, false, false, PurchSetup."Exact Cost Reversing Mandatory", false)
                                // else
                                //     CopyDocMgt.SetProperties(
                                //       false, true, false, false, false, PurchSetup."Exact Cost Reversing Mandatory", false);

                                // CopyDocMgt.CopyPurchDoc(PurchaseHeader2."Document Type", PurchaseHeader2."No.", PurchaseHeader);

                                //TODO hier weitermachen es fehlen noch felder
                                Clear(PurchaseLineOld);
                                PurchaseLineOld.SetRange("Document Type", PurchaseHeader2."Document Type");
                                PurchaseLineOld.SetRange("Document No.", PurchaseHeader2."No.");
                                if PurchaseLineOld.FindFirst() then begin
                                    repeat
                                        PurchaseLineNew.Init();
                                        PurchaseLineNew.TransferFields(PurchaseLineOld);
                                        PurchaseLineNew."Document Type" := PurchaseHeader."Document Type";
                                        PurchaseLineNew."Document No." := PurchaseHeader."No.";
                                        PurchaseLineNew."Line No." := PurchaseLineOld."Line No.";
                                        PurchaseLineNew.Amount := PurchaseLineOld.Amount;
                                        if PurchaseLineOld.HasLinks() then
                                            PurchaseLineNew.CopyLinks(PurchaseLineOld);
                                        PurchaseLineNew.Insert(true);
                                    until PurchaseLineOld.Next() = 0;
                                end;

                                //      IF PurchaseLine.FINDSET THEN
                                //        REPEAT
                                //          NewPurchaseLine.TRANSFERFIELDS(PurchaseLine);
                                //          NewPurchaseLine."Document No." := PurchaseHeader."No.";
                                //          NewPurchaseLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                                //          NewPurchaseLine."Pay-to Vendor No." := PurchaseHeader."Pay-to Vendor No.";
                                //          NewPurchaseLine.VALIDATE("Unit of Measure Code",PurchaseLine."Unit of Measure Code");
                                //          IF PurchaseLine.HASLINKS THEN
                                //            NewPurchaseLine.COPYLINKS(PurchaseLine);
                                //          NewPurchaseLine.INSERT;
                                //        UNTIL PurchaseLine.NEXT = 0;
                                PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                                PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                                PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                                if PurchaseLine.FindSet then begin
                                    repeat
                                        PurchaseLine.Validate("Direct Unit Cost", 0);
                                        PurchaseLine.Modify;
                                    until PurchaseLine.Next = 0;
                                end
                            end;

                            VendorSerienanfrage.Erledigt := true;
                            VendorSerienanfrage.Modify;
                        until VendorSerienanfrage.Next = 0;
                        // RepairLineNos(Rec."No.", Rec."No."); Funktioniert nicht, sollte es funktionieren dann sind die Einkaufspreise leer.
                        Message('Serienanfragen abgeschlossen');
                    end;
                end;
            }
            action("Mail senden")
            {
                ApplicationArea = Basic;
                Caption = 'Serienanfragen Mail';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    l_PurchaseHeader: Record "Purchase Header";
                begin
                    l_PurchaseHeader.SetRange("Document Type", Rec."Document Type");
                    l_PurchaseHeader.SetRange(Serienanfragennr, Rec."No.");

                    if l_PurchaseHeader.FindSet then begin
                        repeat
                            OpenEditor(l_PurchaseHeader);
                        until l_PurchaseHeader.Next = 0;
                    end;
                end;
            }
            action("Mail senden Alternative")
            {
                ApplicationArea = Basic;
                Caption = 'Serienanfragen Mail (Alternative)';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    l_PurchaseHeader: Record "Purchase Header";
                begin
                    l_PurchaseHeader.SetRange("Document Type", Rec."Document Type");
                    l_PurchaseHeader.SetRange(Serienanfragennr, Rec."No.");

                    if l_PurchaseHeader.FindSet then begin
                        repeat
                            OpenEditor_Alt(l_PurchaseHeader);
                        until l_PurchaseHeader.Next = 0;
                    end;
                end;
            }
            action("Kreditor nach Segmentierung")
            {
                ApplicationArea = Basic;
                Caption = 'Kreditor nach Segmentierung';
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
                    PurchaseLine: Record "Purchase Line";
                    Item: Record Item;
                    LineNo: Integer;
                begin
                    if UpperCase(UserId) = 'TURBO-TECHNIK\GERWING-ERP' then begin

                        //Ermittlung welche Segmentierungen in der Anfrage vorhanden sind.
                        PurchaseLine.SetRange("Document Type", PurchaseLine."document type"::Quote);
                        PurchaseLine.SetRange("Document No.", Rec."No.");
                        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);

                        if PurchaseLine.FindSet() then begin
                            repeat
                                //IF Item.GET(PurchaseLine."No.") AND (Item.Segmentation <> '') THEN BEGIN
                                if Item.Get(PurchaseLine."No.") and (Item."Item Category Code" <> '')
                                                                and (Item."Item Category Code" <> '') then begin
                                    if not Segmentation_tmp.Get(Item."Item Category Code", Item."Item Category Code") then begin
                                        Segmentation_tmp.Code := Item."Item Category Code";
                                        Segmentation_tmp.Group := Item."Item Category Code";
                                        Segmentation_tmp.Insert();
                                    end;
                                end;
                            until (PurchaseLine.Next() = 0);
                        end;

                        //Kreditoren zur Serienanfrage hinzufügen
                        if Segmentation_tmp.FindSet() then begin
                            LineNo += 10000;

                            repeat
                                VendorSegmentation.SetRange(Segmentation, Segmentation_tmp.Code);
                                VendorSegmentation.SetRange(Group, Segmentation_tmp.Group);

                                if VendorSegmentation.FindFirst() then begin
                                    repeat
                                        VendorSerienanfrage_Find.SetRange(Serienanfragenr, Rec."No.");
                                        VendorSerienanfrage_Find.SetRange("No.", VendorSegmentation.Vendor);
                                        if not VendorSerienanfrage_Find.FindSet() then begin
                                            VendorSerienanfrage_Find.SetRange("No.");
                                            VendorSerienanfrage.Serienanfragenr := Rec."No.";
                                            VendorSerienanfrage.Validate("No.", VendorSegmentation.Vendor);
                                            VendorSerienanfrage."Line No." := LineNo;
                                            if VendorSerienanfrage.Insert() then
                                                LineNo += 10000;
                                        end else begin
                                            VendorSerienanfrage_Find.SetRange("No.");
                                        end;
                                    until (VendorSegmentation.Next() = 0);
                                end;
                            until (Segmentation_tmp.Next() = 0);
                        end;
                    end;
                end;
            }
            action("Erstellen nach Segmentierung")
            {
                ApplicationArea = Basic;
                Caption = 'Erstellen nach Segmentierung';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PurchSetup: Record "Purchases & Payables Setup";
                    PurchaseLine2: Record "Purchase Line";
                    Item: Record Item;
                    VendorSegmentation: Record "Vendor Segmentation";
                begin
                    if UpperCase(UserId) = 'TURBO-TECHNIK\GERWING-ERP' then begin

                        VendorSerienanfrage.SetRange(Serienanfragenr, Rec."No.");
                        VendorSerienanfrage.SetRange(Erledigt, false);
                        if VendorSerienanfrage.FindSet then begin
                            repeat
                                VendorSerienanfrage.TestField("Buy-from Contact No.");
                            until VendorSerienanfrage.Next = 0;
                        end;

                        // PurchaseLine.SETRANGE("Document No.", "No.");
                        // PurchaseLine.SETRANGE("Document Type", "Document Type");

                        if VendorSerienanfrage.FindSet then begin
                            PurchaseHeader.Get(Rec."Document Type", Rec."No.");
                            PurchaseHeader.Serienanfragennr := VendorSerienanfrage.Serienanfragenr;
                            PurchaseHeader.Modify;
                            PurchaseHeader2.Get(Rec."Document Type", Rec."No.");
                            repeat
                                Clear(PurchaseHeader);
                                PurchaseHeader.SetRange("Buy-from Vendor No.", VendorSerienanfrage."No.");
                                PurchaseHeader.SetRange("Buy-from Contact Ansprech", VendorSerienanfrage."Buy-from Contact No.");
                                PurchaseHeader.SetRange(Serienanfragennr, VendorSerienanfrage.Serienanfragenr);
                                if not PurchaseHeader.FindSet then begin
                                    Clear(PurchaseHeader);
                                    PurchaseHeader."Document Type" := PurchaseHeader."document type"::Quote;
                                    PurchaseHeader.Insert(true);
                                    PurchaseHeader."Document Date" := WorkDate;
                                    PurchaseHeader.Status := PurchaseHeader.Status::Open;
                                    PurchaseHeader.Validate("Buy-from Vendor No.", VendorSerienanfrage."No.");
                                    PurchaseHeader."Buy-from Vendor Name" := VendorSerienanfrage.Name;
                                    PurchaseHeader."Buy-from Vendor Name 2" := VendorSerienanfrage."Name 2";
                                    PurchaseHeader."Buy-from Address" := VendorSerienanfrage.Address;
                                    PurchaseHeader."Buy-from Address 2" := VendorSerienanfrage."Address 2";
                                    PurchaseHeader."Buy-from Post Code" := VendorSerienanfrage."Post Code";
                                    PurchaseHeader."Buy-from Contact No." := VendorSerienanfrage."Buy-from Contact No.";
                                    PurchaseHeader."Buy-from Contact" := VendorSerienanfrage."Buy-from Contact";
                                    PurchaseHeader."Buy-from City" := VendorSerienanfrage.City;
                                    PurchaseHeader."Job No." := Rec."Job No.";
                                    PurchaseHeader.Serienanfragennr := VendorSerienanfrage.Serienanfragenr;
                                    PurchaseHeader."Buy-from Contact Ansprech" := VendorSerienanfrage."Buy-from Contact No.";
                                    PurchaseHeader.Leistung := PurchaseHeader2.Leistung;
                                    PurchaseHeader."Angebotsabgabe bis" := PurchaseHeader2."Angebotsabgabe bis";
                                    PurchaseHeader."Requested Receipt Date" := PurchaseHeader2."Requested Receipt Date";
                                    PurchaseHeader.TreeNo := 2;
                                    PurchaseHeader.Modify;
                                    PurchSetup.Get;
                                    CopyDocMgt.SetProperties(
                                      false, true, false, false, false, PurchSetup."Exact Cost Reversing Mandatory", false);
                                    CopyDocMgt.CopyPurchDoc(PurchaseHeader2."Document Type", PurchaseHeader2."No.", PurchaseHeader);

                                    PurchaseLine2.SetRange("Document Type", PurchaseHeader."Document Type");
                                    PurchaseLine2.SetRange("Document No.", PurchaseHeader."No.");
                                    PurchaseLine2.SetRange(Type, PurchaseLine2.Type::Item);

                                    if PurchaseLine2.FindSet(true) then
                                        repeat
                                            Item.Get(PurchaseLine2."No.");
                                            if not VendorSegmentation.Get(PurchaseHeader."Buy-from Vendor No.", Item."Item Category Code", Item."Item Category Code") then
                                                PurchaseLine2.Delete();
                                        until PurchaseLine2.Next = 0;
                                    PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                                    PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                                    if PurchaseLine.FindSet then begin
                                        repeat
                                            PurchaseLine.Validate("Direct Unit Cost", 0);
                                            PurchaseLine.Modify;
                                        until PurchaseLine.Next = 0;
                                    end
                                end;
                                VendorSerienanfrage.Erledigt := true;
                                VendorSerienanfrage.Modify;
                            until VendorSerienanfrage.Next = 0;
                            Message('Serienanfragen abgeschlossen');
                        end;
                    end;
                end;
            }
        }
    }

    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseHeader2: Record "Purchase Header";
        Vendor: Record Vendor;
        PurchaseLine: Record "Purchase Line";
        VendorSerienanfrage: Record "Vendor - Serienanfrage";
        NewPurchaseLine: Record "Purchase Line";
        ItemVendor: Record "Item Vendor";
        CopyDocMgt: Codeunit "Copy Document Mgt.";

    procedure OpenEditor(L_PurchaseHeader: Record "Purchase Header")
    var
        l_PurchaseHeader2: Record "Purchase Header";
        l_Cont: Record Contact;
        l_Vendor: Record Vendor;
        Mail: Codeunit EMail;
        MailMsg: Codeunit "Email Message";
        Name: Text[250];
        tmpBlob: Codeunit "Temp Blob";
        cnv64: Codeunit "Base64 Convert";
        InStr: InStream;
        OutStr: OutStream;
        txtB64: Text;
        format: ReportFormat;
        recRef: RecordRef;
        InStrMailBody: InStream;
        OutStrMailBody: OutStream;
        Body: Text;
        VendorName: Text;
    begin
        Clear(tmpBlob);
        Clear(InStr);
        Clear(InStrMailBody);
        Clear(OutStr);
        Clear(OutStrMailBody);
        Clear(Body);
        Clear(MailMsg);
        Clear(Mail);
        txtB64 := '';
        Name := '';
        VendorName := '';

        l_Vendor.Get(l_PurchaseHeader."Buy-from Vendor No.");
        if StrPos(l_Vendor."Search Name", ' ') <> 0 then
            VendorName := Lowercase(CopyStr(l_Vendor."Search Name", 1, StrPos(l_Vendor."Search Name", ' ') - 1))
        else
            VendorName := Lowercase(CopyStr(l_Vendor."Search Name", 1, StrLen(l_Vendor."Search Name")));

        Name := Lowercase(l_PurchaseHeader."Job No.") + '-' + l_PurchaseHeader."No." + '-' +
                VendorName + '.pdf';

        l_PurchaseHeader2.SetRange("No.", l_PurchaseHeader."No.");
        recRef.GetTable(l_PurchaseHeader2);
        tmpBlob.CreateOutStream(OutStr);
        tmpBlob.CreateOutStream(OutStrMailBody);
        if Report.SaveAs(report::"TT Purchase - Quote RTC", '', format::Pdf, OutStr, recRef) then begin
            tmpBlob.CreateInStream(InStr);
            txtB64 := cnv64.ToBase64(InStr, true);
        end;
        if Report.SaveAs(Report::"Email Body Text PurchQuote", '', format::Html, OutStrMailBody, recRef) then begin
            tmpBlob.CreateInStream(InStrMailBody);
            InStrMailBody.ReadText(Body);
        end;
        if l_Cont.Get(l_PurchaseHeader."Buy-from Contact Ansprech") then begin
            if l_Cont."E-Mail" = '' then begin
                l_Cont.Get(l_PurchaseHeader."Buy-from Contact No.");
            end;
        end else
            l_Cont.Get(l_PurchaseHeader."Buy-from Contact No.");
        if l_PurchaseHeader."Language Code" = 'ENU' then
            MailMsg.Create(l_Cont."E-Mail", 'Our Inquiry ' + l_PurchaseHeader."Job No." + '/' + l_PurchaseHeader."No.", Body, true)
        else
            MailMsg.Create(l_Cont."E-Mail", 'Unsere Anfrage ' + l_PurchaseHeader."Job No." + '/' + l_PurchaseHeader."No.", Body, true);
        MailMsg.AddAttachment(Name, 'pdf', txtB64);
        Mail.OpenInEditor(MailMsg);
    end;

    procedure OpenEditor_Alt(L_PurchaseHeader: Record "Purchase Header")
    var
        l_PurchaseHeader2: Record "Purchase Header";
        l_Cont: Record Contact;
        l_Vendor: Record Vendor;
        Mail: Codeunit EMail;
        MailMsg: Codeunit "Email Message";
        Name: Text[250];
        tmpBlob: Codeunit "Temp Blob";
        cnv64: Codeunit "Base64 Convert";
        InStr: InStream;
        OutStr: OutStream;
        txtB64: Text;
        format: ReportFormat;
        recRef: RecordRef;
        InStrMailBody: InStream;
        OutStrMailBody: OutStream;
        Body: Text;
        VendorName: Text;
        MailEditor: Page "Mail Editor";
    begin
        Clear(MailEditor);
        Clear(tmpBlob);
        Clear(InStr);
        Clear(InStrMailBody);
        Clear(OutStr);
        Clear(OutStrMailBody);
        Clear(Body);
        Clear(MailMsg);
        Clear(Mail);
        txtB64 := '';
        Name := '';
        VendorName := '';

        l_Vendor.Get(l_PurchaseHeader."Buy-from Vendor No.");
        if StrPos(l_Vendor."Search Name", ' ') <> 0 then
            VendorName := Lowercase(CopyStr(l_Vendor."Search Name", 1, StrPos(l_Vendor."Search Name", ' ') - 1))
        else
            VendorName := Lowercase(CopyStr(l_Vendor."Search Name", 1, StrLen(l_Vendor."Search Name")));

        Name := Lowercase(l_PurchaseHeader."Job No.") + '-' + l_PurchaseHeader."No." + '-' +
                VendorName + '.pdf';

        l_PurchaseHeader2.SetRange("No.", l_PurchaseHeader."No.");
        recRef.GetTable(l_PurchaseHeader2);
        tmpBlob.CreateOutStream(OutStr);
        tmpBlob.CreateOutStream(OutStrMailBody);
        if Report.SaveAs(report::"TT Purchase - Quote RTC", '', format::Pdf, OutStr, recRef) then begin
            tmpBlob.CreateInStream(InStr);
            txtB64 := cnv64.ToBase64(InStr, true);
        end;
        if Report.SaveAs(Report::"Email Body Text PurchQuote", '', format::Html, OutStrMailBody, recRef) then begin
            tmpBlob.CreateInStream(InStrMailBody);
            InStrMailBody.ReadText(Body);
        end;
        if l_Cont.Get(l_PurchaseHeader."Buy-from Contact Ansprech") then begin
            if l_Cont."E-Mail" = '' then begin
                l_Cont.Get(l_PurchaseHeader."Buy-from Contact No.");
            end;
        end else
            l_Cont.Get(l_PurchaseHeader."Buy-from Contact No.");
        if l_PurchaseHeader."Language Code" = 'ENU' then
            MailMsg.Create(l_Cont."E-Mail", 'Our Inquiry ' + l_PurchaseHeader."Job No." + '/' + l_PurchaseHeader."No.", Body, true)
        else
            MailMsg.Create(l_Cont."E-Mail", 'Unsere Anfrage ' + l_PurchaseHeader."Job No." + '/' + l_PurchaseHeader."No.", Body, true);
        MailMsg.AddAttachment(Name, 'pdf', txtB64);
        Maileditor.SetMail(Mail);
        Maileditor.SetMailMsg(MailMsg);
        Maileditor.Run();
    end;

    procedure RepairLineNos(FromPurchHeaderNo: Code[20]; SerialNo: Code[20])
    var
        FromPurchaseHeader: Record "Purchase Header";
        FromPurchaseLine: Record "Purchase Line";
        ToPurchaseHeader: Record "Purchase Header";
        ToPurchaseLine: Record "Purchase Line";
        LineNoList: List of [Integer];
        Counter: Integer;
    begin
        FromPurchaseHeader.SetRange("Document Type", FromPurchaseHeader."Document Type"::Quote);
        FromPurchaseHeader.SetRange("No.", FromPurchHeaderNo);
        FromPurchaseHeader.SetRange(Serienanfragennr, SerialNo);

        if FromPurchaseHeader.FindFirst() then begin
            FromPurchaseLine.SetRange("Document Type", FromPurchaseHeader."Document Type");
            FromPurchaseLine.SetRange("Document No.", FromPurchaseHeader."No.");
            if FromPurchaseLine.FindSet() then begin

                repeat
                    LineNoList.Add(FromPurchaseLine."Line No.");
                until FromPurchaseLine.Next() = 0;

                if LineNoList.Count > 0 then begin

                    ToPurchaseHeader.SetRange("Document Type", FromPurchaseHeader."Document Type"::Quote);
                    ToPurchaseHeader.SetRange(Serienanfragennr, SerialNo);
                    ToPurchaseHeader.SetFilter("No.", '<>%1', FromPurchHeaderNo);

                    if ToPurchaseHeader.FindSet() then begin
                        repeat
                            ToPurchaseLine.SetRange("Document Type", ToPurchaseHeader."Document Type");
                            ToPurchaseLine.SetRange("Document No.", ToPurchaseHeader."No.");
                            if ToPurchaseLine.FindSet() then begin
                                repeat
                                    ToPurchaseLine."Line No." := LineNoList.Get(ToPurchaseLine."Line No." / 10000);
                                    ToPurchaseLine.Modify();
                                until ToPurchaseLine.Next() = 0;
                            end;

                        until ToPurchaseHeader.Next() = 0;
                    end
                end;
            end;
        end;
    end;
}

