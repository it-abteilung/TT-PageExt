PageExtension 50007 pageextension50007 extends "Vendor Card"
{
    layout
    {
        addafter("Responsibility Center")
        {
            field(Leistungsart; Rec.Leistungsart)
            {
                ApplicationArea = Basic;
            }
            field(DATEV; Rec.DATEV)
            {
                ApplicationArea = Basic;
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
}

