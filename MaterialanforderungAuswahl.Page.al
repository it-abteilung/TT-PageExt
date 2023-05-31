#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50067 "Materialanforderung Auswahl"
{
    Editable = true;
    PageType = Worksheet;
    SourceTable = "BOM Component";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Parent Item No."; Rec."Parent Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Quantity per"; Rec."Quantity per")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Auswahl; Rec.Auswahl)
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

