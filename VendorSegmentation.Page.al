Page 50070 "Vendor Segmentation"
{
    Caption = 'TT Kreditor Segmentierung';
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
        area(Promoted)
        {
            actionref(PopulateProductGroup; "Populate Product Group") { }
        }

        area(Processing)
        {
            action("Populate Product Group")
            {
                ApplicationArea = all;
                Caption = 'Produktgruppen erstellen';
                Image = Group;

                trigger OnAction()
                var
                    VendorSegmentation: Record "Vendor Segmentation";
                    ProductGroup: Record "TT Product Group";
                    ProductGroupNew: Record "TT Product Group";
                begin
                    if VendorSegmentation.FindSet() then
                        repeat
                            Clear(ProductGroup);
                            if NOT ProductGroup.Get(VendorSegmentation.Segmentation, VendorSegmentation.Group) then
                                if VendorSegmentation.Group <> '' then begin
                                    ProductGroupNew.Init();
                                    ProductGroupNew."Item Category Code" := VendorSegmentation.Segmentation;
                                    ProductGroupNew.Code := VendorSegmentation.Group;
                                    ProductGroupNew.Insert();
                                end;
                        until VendorSegmentation.Next() = 0;
                end;
            }
        }
    }
}

