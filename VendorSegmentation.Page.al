Page 50070 "Vendor Segmentation"
{
    Caption = 'Kreditor Segmentierung';
    PageType = List;
    SourceTable = "Vendor Segmentation";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Vendor; Rec.Vendor)
                {
                    ApplicationArea = Basic;
                }
                field(Segmentation; Rec.Segmentation)
                {
                    ApplicationArea = Basic;
                }
                field(Group1; Rec.Group)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

