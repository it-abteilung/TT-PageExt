#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50074 "Lagerplatzposten modify"
{
    PageType = List;
    Permissions = TableData "Warehouse Entry" = rimd;
    SourceTable = "Warehouse Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = Basic;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Registering Date"; Rec."Registering Date")
                {
                    ApplicationArea = Basic;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Zone Code"; Rec."Zone Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Qty. (Base)"; Rec."Qty. (Base)")
                {
                    ApplicationArea = Basic;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field("Source Subtype"; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Source Subline No."; Rec."Source Subline No.")
                {
                    ApplicationArea = Basic;
                }
                field("Source Document"; Rec."Source Document")
                {
                    ApplicationArea = Basic;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = Basic;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Bin Type Code"; Rec."Bin Type Code")
                {
                    ApplicationArea = Basic;
                }
                field(Cubage; Rec.Cubage)
                {
                    ApplicationArea = Basic;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = Basic;
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = Basic;
                }
                field("Whse. Document No."; Rec."Whse. Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Whse. Document Type"; Rec."Whse. Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Whse. Document Line No."; Rec."Whse. Document Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field("Reference Document"; Rec."Reference Document")
                {
                    ApplicationArea = Basic;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ApplicationArea = Basic;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Basic;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = Basic;
                }
                field("Warranty Date"; Rec."Warranty Date")
                {
                    ApplicationArea = Basic;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = Basic;
                }
                field("Phys Invt Counting Period Code"; Rec."Phys Invt Counting Period Code")
                {
                    ApplicationArea = Basic;
                }
                field("Phys Invt Counting Period Type"; Rec."Phys Invt Counting Period Type")
                {
                    ApplicationArea = Basic;
                }
                field(Dedicated; Rec.Dedicated)
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

