PageExtension 50007 pageextension50007 extends "Vendor Card"
{
    layout
    {

        modify("Payment Terms Code")
        {
            ShowMandatory = true;
        }
        modify("VAT Registration No.")
        {
            ShowMandatory = true;
        }
        addafter("Responsibility Center")
        {
            field(Leistungsart; Rec.Leistungsart)
            {
                ApplicationArea = Basic;
            }
            field(DATEV; Rec.DATEV)
            {
                ApplicationArea = Basic;
                ShowMandatory = true;
            }
        }
        moveafter("Address 2"; "Post Code")
    }
    actions
    {
        addlast(Coupling)
        {
            action(Segmentation)
            {
                Caption = 'Segmentierung';
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Segmentation: Record "Vendor Segmentation";
                begin
                    Segmentation.SetRange(Vendor, rec."No.");
                    Page.RunModal(50070, Segmentation);
                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        TextBuilder_L: TextBuilder;
    begin
        if Rec."Payment Terms Code" = '' then begin
            if NOT Confirm('Das Feld "Zlg.-Bedingungscode" ist leer und der Kreditor kann nicht für Bestellungen verwendet werden, soll die Seite trotzdem geschlossen werden?') then begin
                exit(false);
            end;
        end;
        if Rec."VAT Registration No." = '' then
            TextBuilder_L.Append('USt.-IdNr.');
        if Rec.DATEV = '' then begin
            if TextBuilder_L.Length > 0 then
                TextBuilder_L.Append('und ');
            TextBuilder_L.Append('DATEV');
        end;
        if TextBuilder_L.Length > 0 then
            if NOT Confirm('Die Pflichtfelder %1 sind leer und der Kontakt kann möglicherweise nicht für die weitere Verarbeitung verwendet werden, soll die Seite trotzdem geschlossen werden?', false, TextBuilder_L.ToText()) then
                exit(false);
    end;
}

