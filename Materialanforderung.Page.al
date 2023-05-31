#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50062 Materialanforderung
{
    // 001 HF  17.10.19  new field in Header "Lfd Nr",Liefertermin,"zusätzliche Anforderungen"

    AutoSplitKey = true;
    PageType = Worksheet;
    SourceTable = Materialanforderungzeile;

    layout
    {
        area(content)
        {
            group(Projektauswahl)
            {
                Caption = 'Projektauswahl';
                field("Projekt Nr."; Projektnr)
                {
                    ApplicationArea = Basic;
                    TableRelation = Job."No.";

                    trigger OnValidate()
                    begin
                        Rec.SetRange("Projekt Nr", Projektnr);
                        CurrPage.Update(false);
                    end;
                }
                field("Lfd Nr"; Rec."Lfd Nr")
                {
                    ApplicationArea = Basic;
                }
            }
            repeater(Anforderungen)
            {
                field("Artikel Nr"; Rec."Artikel Nr")
                {
                    ApplicationArea = Basic;
                    TableRelation = Item."No." where(Blocked = filter(false));

                    trigger OnValidate()
                    begin
                        if Item.Get(Rec."Artikel Nr") then
                            Rec.Einheit := Item."Base Unit of Measure";
                    end;
                }
                field(Beschreibung; Rec.Beschreibung)
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field("Beschreibung 2"; Rec."Beschreibung 2")
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field(Menge; Rec.Menge)
                {
                    ApplicationArea = Basic;
                }
                field(Einheit; Rec.Einheit)
                {
                    ApplicationArea = Basic;
                }
                field("Anfrage erstellt"; Rec."Anfrage erstellt")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Liefertermin; Rec.Liefertermin)
                {
                    ApplicationArea = Basic;
                }
                field("zusätzliche Anforderungen"; Rec."zusätzliche Anforderungen")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(ItemPicture; "Item Picture")
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = "No." = field("Artikel Nr");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup1000000013)
            {
                action("Materialanforderung drucken")
                {
                    ApplicationArea = Basic;

                    trigger OnAction()
                    begin
                        Report.RunModal(50030, true, false, Rec);
                    end;
                }
                action("RecordID finden ")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Scope = Repeater;
                    Visible = false;

                    trigger OnAction()
                    var
                        RecordLink: Record "Record Link";
                    begin
                        if Rec.HasLinks then begin
                            Message('Link vorhanden');
                            RecordLink.SetFilter("Record ID", Format(Rec.RecordId));
                            RecordLink.FindFirst;
                            Message('Das ist die Datensatzverknüpfung: %1', RecordLink."Record ID");
                        end;
                    end;
                }
                action("Anfrage erstellen")
                {
                    ApplicationArea = Basic;
                    Scope = Repeater;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLine: Record "Purchase Line";
                        Vendor: Record Vendor;
                        RecordLink: Record "Record Link";
                    begin
                        PurchaseHeader.Init;
                        PurchaseHeader.Validate("Document Type", PurchaseHeader."document type"::Quote);

                        Vendor.SetRange(Blocked, Vendor.Blocked::" ");
                        if Page.RunModal(27, Vendor) = Action::LookupOK then
                            PurchaseHeader.Validate("Buy-from Vendor No.", Vendor."No.");

                        PurchaseHeader.Validate("Job No.", Projektnr);
                        PurchaseHeader.Insert(true);

                        PurchaseLine.Init;
                        PurchaseLine.Validate("Document Type", PurchaseLine."document type"::Quote);
                        PurchaseLine.Validate("Document No.", PurchaseHeader."No.");
                        PurchaseLine.Validate(Type, PurchaseLine.Type::Item);
                        PurchaseLine.Validate("No.", Rec."Artikel Nr");
                        PurchaseLine.Validate(Quantity, Rec.Menge);
                        PurchaseLine.Validate("Unit of Measure", Rec.Einheit);
                        PurchaseLine.CopyLinks(Rec);
                        PurchaseLine.Insert(true);

                        Rec."Anfrage erstellt" := true;
                        Rec."Anfrage Nr" := PurchaseHeader."No.";
                        Rec.Modify;

                        Page.Run(49, PurchaseHeader);
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec."Projekt Nr" <> '' then begin
            Materialanforderung2.SetRange("Projekt Nr", Rec."Projekt Nr");
            if Materialanforderung2.FindLast then
                Lfd := Materialanforderung2."Lfd Nr"
            else
                Lfd := 0;
            Lfd += 10000;
            Rec."Lfd Nr" := Lfd;
            Rec."Projekt Nr" := Projektnr;
            Rec.Anforderungsdatum := Today;
        end else
            Error('Keine Projekt Nr. !!!');
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("Projekt Nr", '');
        CurrPage.Update(false);
    end;

    var
        Projektnr: Code[20];
        Menge: Decimal;
        Anfordern: Boolean;
        Materialanforderung: Record Materialanforderungzeile;
        Materialanforderung2: Record Materialanforderungzeile;
        Lfd: Integer;
        Text1: label 'Projektnr. muss gefüllt sein.';
        Item: Record Item;
}

