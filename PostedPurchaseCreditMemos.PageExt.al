PageExtension 50041 pageextension50041 extends "Posted Purchase Credit Memos"
{
    layout
    {
        addafter("Applies-to Doc. Type")
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Basic;
            }
            field(Leistung; Rec.Leistung)
            {
                ApplicationArea = Basic;
            }
            field("Vendor Cr. Memo No."; Rec."Vendor Cr. Memo No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

