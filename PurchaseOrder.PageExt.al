PageExtension 50020 pageextension50020 extends "Purchase Order"
{
    layout
    {
        addafter("No.")
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Basic;
                Caption = 'Projektnr.';
            }
        }
        addafter("Job Queue Status")
        {
            field(Leistung; Rec.Leistung)
            {
                ApplicationArea = Basic;
            }
            field(Unterschriftscode; Rec.Unterschriftscode)
            {
                ApplicationArea = Basic;
                Caption = 'Unterschriftscode';
            }
            field("Unterschriftscode 2"; Rec."Unterschriftscode 2")
            {
                ApplicationArea = Basic;
                Caption = 'Unterschriftscode 2';
            }
            field(Leistungsart; Rec.Leistungsart)
            {
                ApplicationArea = Basic;
                NotBlank = true;
                ShowMandatory = true;
            }
            field(Leistungszeitraum; Rec.Leistungszeitraum)
            {
                ApplicationArea = Basic;
            }
            field(Besteller; Rec.Besteller)
            {
                ApplicationArea = Basic;
            }
            field(Bestellername; Rec.Bestellername)
            {
                ApplicationArea = Basic;
            }
            field("Goods Receiving Date"; Rec."Goods Receiving Date")
            {
                ApplicationArea = Basic;
                Caption = 'Wareneingangsdatum';
            }
            field("Employee No."; Rec."Employee No.")
            {
                ApplicationArea = Basic;
            }
            field(Employee; Rec.Employee)
            {
                ApplicationArea = Basic;
                Caption = 'Mitarbeiter';
            }
            field("CO2 Menge in Kilogramm"; Rec."CO2 Menge in Kilogramm")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Ship-to Code")
        {
            field("Ship-to Name 2"; Rec."Ship-to Name 2")
            {
                ApplicationArea = Basic;
                Caption = 'Name 2';
            }
        }
        addfirst(Control71)
        {
            field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor No.';
                Importance = Promoted;

            }
        }
        addafter("Pay-to Name")
        {
            field("Pay-to Name 2"; Rec."Pay-to Name 2")
            {
                ApplicationArea = Basic;
                Caption = 'Name 2';
            }
        }
        addafter("Shipping and Payment")
        {
            group(Abschlag)
            {
                Caption = 'Abschlag';
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
    }
    actions
    {
        addafter(SendCustom)
        {
            action(Mail)
            {
                ApplicationArea = Basic;
                Caption = 'Mail';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    l_PurchaseHeader: Record "Purchase Header";
                    l_Cont: Record Contact;
                    l_Vendor: Record Vendor;
                    Mail: Codeunit Mail;
                    Name: Text[250];
                    FileName: Text[250];
                    FileName2: Text[250];
                    ToFile: Text[250];
                    GERW: Codeunit 50001;
                    ToFile2: Text[250];
                    R50000: Report 50000;
                begin
                    MailErstellen(false);
                end;
            }
            action("Mail Schiff")
            {
                ApplicationArea = Basic;
                Caption = 'Mail Schiff';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    l_PurchaseHeader: Record "Purchase Header";
                    l_Cont: Record Contact;
                    l_Vendor: Record Vendor;
                    Mail: Codeunit Mail;
                    Name: Text[250];
                    FileName: Text[250];
                    FileName2: Text[250];
                    ToFile: Text[250];
                    GERW: Codeunit 50001;
                    R50000: Report 50000;
                    ToFile2: Text[250];
                begin
                    MailErstellen(true);
                end;
            }
            action(Fax)
            {
                ApplicationArea = Basic;
                Caption = 'Fax';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FaxErstellen(false);
                end;
            }
            action("Fax Schiff")
            {
                ApplicationArea = Basic;
                Caption = 'Fax Schiff';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FaxErstellen(true);
                end;
            }
            action(Warenannahme)
            {
                ApplicationArea = Basic;
                Caption = 'Warenannahme';
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    l_PurchaseHeader: Record "Purchase Header";
                begin
                    CurrPage.SetSelectionFilter(l_PurchaseHeader);
                    //REPORT.RUNMODAL(50040,TRUE,FALSE,l_PurchaseHeader);
                    Report.RunModal(50051, true, false, l_PurchaseHeader);
                end;
            }
            action(Import)
            {
                ApplicationArea = Basic;
                Caption = 'Import';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    l_PurchaseHeader: Record "Purchase Header";
                begin
                    l_PurchaseHeader.SetRange("Document Type", Rec."Document Type");
                    l_PurchaseHeader.SetRange("No.", Rec."No.");
                    Report.RunModal(50053, true, false, l_PurchaseHeader);
                end;
            }
        }
    }

    var
    local procedure MailErstellen(AnzeigeSchiff: Boolean)
    var
        l_PurchaseHeader: Record "Purchase Header";
        l_Cont: Record Contact;
        l_Vendor: Record Vendor;
        Mail: Codeunit EMail;
        MailMsg: Codeunit "Email Message";
        Name: Text[250];
        GERW: Codeunit 50001;
        TTOrderRTC: Report 50000;
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
        CurrPage.SetSelectionFilter(l_PurchaseHeader);
        l_Vendor.Get(rec."Buy-from Vendor No.");

        Clear(tmpBlob);
        Clear(InStr);
        Clear(InStrMailBody);
        Clear(OutStr);
        Clear(OutStrMailBody);
        Clear(Body);
        txtB64 := '';
        Name := '';
        VendorName := '';

        //Dateinamen bestimmen
        if StrPos(l_Vendor."Search Name", ' ') <> 0 then
            VendorName := Lowercase(CopyStr(l_Vendor."Search Name", 1, StrPos(l_Vendor."Search Name", ' ') - 1))
        else
            VendorName := Lowercase(CopyStr(l_Vendor."Search Name", 1, StrLen(l_Vendor."Search Name")));

        Name := Lowercase(Rec."Job No.") + '-' + Rec."No." + '-' +
                VendorName + '.pdf';

        l_PurchaseHeader.SetRange("No.", Rec."No.");
        recRef.GetTable(l_PurchaseHeader);
        tmpBlob.CreateOutStream(OutStr);
        tmpBlob.CreateOutStream(OutStrMailBody);
        TTOrderRTC."AnzeigeSchiffÜbergeben"(AnzeigeSchiff);
        TTOrderRTC.SetTableView(l_PurchaseHeader);
        if TTOrderRTC.SaveAs('', format::Pdf, OutStr, recRef) then begin
            tmpBlob.CreateInStream(InStr);
            txtB64 := cnv64.ToBase64(InStr, true);
        end;

        if Report.SaveAs(Report::"Email Body Text PurchQuote", '', format::Html, OutStrMailBody, recRef) then begin
            tmpBlob.CreateInStream(InStrMailBody, TextEncoding::Windows);
            InStrMailBody.ReadText(Body);
        end;

        l_Cont.Get(rec."Buy-from Contact No.");
        if l_PurchaseHeader."Language Code" = 'ENU' then
            MailMsg.Create(l_Cont."E-Mail", 'Our Order ' + Rec."Job No." + '/' + Rec."No.", Body, true)
        else
            MailMsg.Create(l_Cont."E-Mail", 'Unsere Bestellung ' + Rec."Job No." + '/' + Rec."No.", Body, true);
        MailMsg.AddAttachment(Name, 'pdf', txtB64);
        Mail.OpenInEditor(MailMsg);
    end;

    local procedure FaxErstellen(AnzeigeSchiff: Boolean)
    var
        l_PurchaseHeader: Record "Purchase Header";
        l_Cont: Record Contact;
        Mail: Codeunit Mail;
        Name: Text[250];
        FileName: Text[250];
        ToFile: Text[250];
        GERW: Codeunit 50001;
        l_Vendor: Record Vendor;
    // R50000: Report 50000;
    begin
        // CurrPage.SetSelectionFilter(l_PurchaseHeader);
        // l_Vendor.Get("Buy-from Vendor No.");
        // Name := Lowercase("Job No.") + '-' + "No." + '-' +
        //         Lowercase(CopyStr(l_Vendor."Search Name",1,StrPos(l_Vendor."Search Name",' ')))
        //         + '.pdf';
        // ToFile := Name;
        // FileName := TemporaryPath + ToFile;
        // //REPORT.SAVEASPDF(50000, FileName, l_PurchaseHeader);
        // R50000.AnzeigeSchiffÜbergeben(AnzeigeSchiff);
        // R50000.SetTableview(l_PurchaseHeader);
        // R50000.SaveAsPdf(FileName);
        // ToFile := GERW.DownloadToClientFileName(FileName, ToFile);
        // l_Cont.Get("Buy-from Contact No.");
        // if l_Cont."Fax No." = '' then begin
        //   l_Vendor.Get("Buy-from Vendor No.");
        //   l_Cont."Fax No." := l_Vendor."Fax No.";
        // end;
        // if "Language Code" = 'ENU' then
        //   Mail.NewMessage('[fax:' + l_Cont."Fax No." + ']','','','Our Order ' + "Job No." + '/' + "No.",
        //                   '',ToFile,true)
        // else
        //   Mail.NewMessage('[fax:' + l_Cont."Fax No." + ']','','','Unsere Bestellung ' + "Job No." + '/' + "No.",
        //                   '',ToFile,true);

        // FILE.Copy(FileName,'C:\Tageskopie\' + Name);
        // FILE.Erase(FileName);
    end;
}

