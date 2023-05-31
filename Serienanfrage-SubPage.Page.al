Page 50059 "Serienanfrage - SubPage"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Vendor - Serienanfrage";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    TableRelation = Vendor."No.";
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field("Buy-from Contact No."; Rec."Buy-from Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field("Buy-from Contact"; Rec."Buy-from Contact")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    var
        Vendor: Record Vendor;
}

