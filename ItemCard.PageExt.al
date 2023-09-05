PageExtension 50010 pageextension50010 extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            // Feld wurde mit v22.3.5.... in die Base-App aufgenommen 04.08.2023 CN 
            // field("Description 2"; Rec."Description 2")
            // {
            //     ApplicationArea = All;
            // }
            field("Description 3"; Rec."Description 3")
            {
                ApplicationArea = All;
            }
        }
        addafter("Automatic Ext. Texts")
        {
            field("Seriennr. pflichtig"; Rec."Seriennr. pflichtig")
            {
                ApplicationArea = All;
            }
            field("Für Inventur berücksichtigen"; Rec."Für Inventur berücksichtigen")
            {
                ApplicationArea = All;
            }
            field("TT Type"; Rec."TT Type")
            {
                ApplicationArea = All;
                Caption = 'TT-Art';
            }
            group(Normen)
            {
                field(DIN; Rec.DIN)
                {
                    ApplicationArea = All;
                }
                field(ASME; Rec.ASME)
                {
                    ApplicationArea = All;
                }
                field(ISO; Rec.ISO)
                {
                    ApplicationArea = All;
                }
            }
            part(Seriennummern; "Artikel-Seriennr-SubPage")
            {
                SubPageLink = "Item No." = field("No.");
                Visible = false;
                ApplicationArea = All;
            }
            part(Control100000001; "Item Serial Subpage")
            {
                SubPageLink = "Item No." = field("No."),
                              "Serial No." = filter(<> '');
                Visible = (Rec."Item Tracking Code" = 'SNALLE');
                ApplicationArea = All;
            }
            part(Chargennummern; "Artikel-Chargennr")
            {
                Editable = false;
                SubPageLink = "Item No." = field("No."),
                              Open = const(true),
                              "Lot No." = filter(<> ''),
                              "Entry Type" = filter(Purchase | "Positive Adjmt." | Transfer);
                Visible = (Rec."Item Tracking Code" = 'CHARGEALLE');
                ApplicationArea = All;
            }
        }
        addafter(Inventory)
        {
            field("Inventory complete"; Rec."Inventory complete")
            {
                ApplicationArea = All;
            }
        }
        addafter("Cost is Adjusted")
        {
            field("Net Invoiced Quantity."; Rec."Net Invoiced Qty.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Purch. Unit of Measure")
        {
            field(Segmentation; Rec.Segmentation)
            {
                ApplicationArea = All;
            }
        }
        addafter(ItemPicture)
        {
            part(Control1000000004; "Item Seriennr Factbox")
            {
                Caption = 'Seriennr.';
                SubPageLink = "Item No." = field("No.");
                SubPageView = sorting("Item No.", "Serial No.");
                ApplicationArea = All;
            }
        }
        modify("Service Item Group")
        {
            ApplicationArea = All;
            Importance = Standard;
        }
        addlast(ItemTracking)
        {
            field("Blocked Tool Requirement"; Rec."Blocked Tool Requirement")
            {
                ApplicationArea = all;
                Caption = 'Gesperrt Werkzeuganforderung';
            }
        }
    }
    actions
    {
        addafter(Identifiers)
        {
            action(Seriennr)
            {
                ApplicationArea = All;
                Caption = 'Seriennr';
                Image = ItemLedger;
                RunObject = Page "Artikel-Seriennr";
                RunPageLink = "Item No." = field("No.");
                RunPageView = sorting("Item No.", "Serial No.");
            }
        }
        addafter(CalculateCountingPeriod)
        {
            separator(Action241)
            {
            }
        }
        addfirst(Resources)
        {
            group("R&esource")
            {
                Caption = 'R&esource';
                Image = Resource;
            }
        }
    }

    var
        ItemAttributeManagement: Codeunit "Item Attribute Management";

    local procedure "***G-ERP***"()
    begin
    end;

    local procedure SetVisibleSerialNumbers()
    begin
        CurrPage.Seriennummern.Page.SetVisibleSpalten(Rec."No.");
    end;

}

