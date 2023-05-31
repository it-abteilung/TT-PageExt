PageExtension 50033 pageextension50033 extends "Item Vendor Catalog"
{
    layout
    {
        addafter("Lead Time Calculation")
        {
            field(Description; Rec.Description)
            {
                ApplicationArea = Basic;
            }
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = Basic;
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = Basic;
            }
            field("Vendor Name 2"; Rec."Vendor Name 2")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

