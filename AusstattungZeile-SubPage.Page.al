#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50002 "AusstattungZeile-SubPage"
{
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = Ausstattung_Zeile;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Lfd Nr"; Rec."Lfd Nr")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Projekt Nr"; Rec."Projekt Nr")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Mitarbeiter Nr"; Rec."Mitarbeiter Nr")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Artikel Nr"; Rec."Artikel Nr")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("ItemRec.Description"; ItemRec.Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Beschreibung';
                    Editable = false;
                }
                field("ItemRec.""Description 2"""; ItemRec."Description 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Beschreibung 2';
                    Editable = false;
                }
                field(Seriennummer; Rec.Seriennummer)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Postenart; Rec.Postenart)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Buchungsdatum; Rec.Buchungsdatum)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Menge; Rec.Menge)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Restmenge; Rec.Restmenge)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Offen; Rec.Offen)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Einheit; Rec.Einheit)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(gebucht; Rec.gebucht)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(uebertragen; Rec.uebertragen)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Mitarbeiter Name"; Rec."Mitarbeiter Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = Basic;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemLedgerEntry: Record "Item Ledger Entry";
                    begin
                        //G-ERP.RS 2019-03-19
                        ItemLedgerEntry.FilterGroup(29);
                        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."entry type"::Purchase);
                        ItemLedgerEntry.SetRange("Item No.", Rec."Artikel Nr");
                        ItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
                        ItemLedgerEntry.SetFilter("Remaining Quantity", '>0');
                        ItemLedgerEntry.FilterGroup(0);

                        if Page.RunModal(0, ItemLedgerEntry) = Action::LookupOK then begin
                            if Rec.Restmenge >= Rec.Menge then begin
                                Rec."Lot No." := ItemLedgerEntry."Lot No.";
                                CurrPage.Update();
                            end else begin
                                Error(ERR_Quantity, Rec.Menge);
                            end;
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Clear(ItemRec);
        if ItemRec.Get(Rec."Artikel Nr") then begin
            if (Rec."Artikel Nr" = '1') or (Rec."Artikel Nr" = '2') then begin
                ItemRec.Description := Rec.Beschreibung;
                ItemRec."Description 2" := Rec."Beschreibung 2";
            end;
        end;
    end;

    var
        ItemRec: Record Item;
        LotNoVisible: Boolean;
        ERR_Quantity: label 'Die Menge der Auswahl muss gleich oder größer sein als %1.';
}

