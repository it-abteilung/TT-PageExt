PageExtension 50151 ProjectListExt extends "Job List"
{
    Caption = 'Job List';
    AdditionalSearchTerms = 'Jobs';
    layout
    {
        addafter("Bill-to Customer No.")
        {
            field("Bill-to Name"; Rec."Bill-to Name")
            {
                ApplicationArea = Basic;
            }
            field("Bill-to Address"; Rec."Bill-to Address")
            {
                ApplicationArea = Basic;
            }
            field("Bill-to Post Code"; Rec."Bill-to Post Code")
            {
                ApplicationArea = Basic;
            }
            field("Bill-to City"; Rec."Bill-to City")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Person Responsible")
        {
            field("Object"; Rec.Object)
            {
                ApplicationArea = Basic;
                Caption = 'Objekt';
            }
            field(Objektname; Rec.Objektname)
            {
                ApplicationArea = Basic;
                Caption = 'Object Name';
            }
        }
        addafter("Search Description")
        {
            field("Job Type"; Rec."Job Type")
            {
                ApplicationArea = Basic;
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = Basic;
            }
            field("Letzte Notiz"; Rec."Letzte Notiz")
            {
                ApplicationArea = Basic;
                Caption = 'Last Note';
            }
            field("Anfrage von"; Rec."Anfrage von")
            {
                ApplicationArea = Basic;
                Caption = 'Request from';
            }
            field("Anfrage am"; Rec."Anfrage am")
            {
                ApplicationArea = Basic;
                Caption = 'Request at';
            }
            field("Anfrage per"; Rec."Anfrage per")
            {
                ApplicationArea = Basic;
                Caption = 'Request per';
            }
            field("Angebotsabgabe bis"; Rec."Angebotsabgabe bis")
            {
                ApplicationArea = Basic;
                Caption = 'Submission until';
            }
        }
        addafter("% Invoiced")
        {
            field("Person Responsible Name"; Rec."Person Responsible Name")
            {
                ApplicationArea = Basic;
            }
            field("Bill-to Name 2"; Rec."Bill-to Name 2")
            {
                ApplicationArea = Basic;
            }
            field("Bill-to Address 2"; Rec."Bill-to Address 2")
            {
                ApplicationArea = Basic;
            }
            field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
            {
                ApplicationArea = Basic;
            }
            field("Ship Owner Bearbeiter"; Rec."Ship Owner Bearbeiter")
            {
                ApplicationArea = Basic;
                Caption = 'Ship Owner Bearbeiter';
            }
            field("Bill-to Contact"; Rec."Bill-to Contact")
            {
                ApplicationArea = Basic;
            }
            field("Leistungsfortschritt %"; Rec."Leistungsfortschritt %")
            {
                ApplicationArea = Basic;
                Caption = 'Performance progress %';
            }
            field("Starting Date"; Rec."Starting Date")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Ending Date"; Rec."Ending Date")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(TotalInclDiscount; TotalPriceIncludingDiscount_g)
            {
                ApplicationArea = Basic;
                Caption = 'Total Price including Discount';
                Visible = false;
            }
            field("Prev. Status"; Rec."Prev. Status")
            {
                ApplicationArea = Basic;
                Caption = 'Vorheriger Status';
                Visible = false;
            }
            field("Status Modify Date"; Rec."Status Modify Date")
            {
                ApplicationArea = Basic;
                Caption = 'Status geändert am';
                Visible = false;
            }
        }
        modify("External Document No.")
        {
            Visible = true;
        }
        addafter(Control1902018507)
        {
            part("Soll / Ist Vergleich"; "Projekt Soll/Ist Vergleich")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No." = field("No.");
            }
            // Der Part wird doppelt angezeigt, es werden auch die selben Informationen angezeigt.
            // part("Projektdetails - WIP/Umsatzrealisierung"; "Job WIP/Recognition FactBox")
            // {
            //     ApplicationArea = Jobs;
            //     SubPageLink = "No." = field("No."), "Resource Filter" = field("Resource Filter"), "Posting Date Filter" = field("Posting Date Filter"), "Resource Gr. Filter" = field("Resource Gr. Filter"), "Planning Date Filter" = field("Planning Date Filter");
            // }
        }
    }
    actions
    {
        modify("&Statistics")
        {
            Visible = false;
        }
        modify(SalesInvoicesCreditMemos)
        {
            Visible = false;
        }
        modify("W&IP")
        {
            Visible = false;
        }
        modify("&WIP Entries")
        {
            Visible = false;
        }
        modify("WIP &G/L Entries")
        {
            Visible = false;
        }
        modify("Plan&ning")
        {
            Visible = false;
        }
        modify("Resource &Allocated per Job")
        {
            Visible = false;
        }
        modify("Res. Group All&ocated per Job")
        {
            Visible = false;
        }
        modify("Create Job &Sales Invoice")
        {
            Visible = false;
        }
        modify("<Action151>")
        {
            Visible = false;
        }
        modify("<Action152>")
        {
            Visible = false;
        }
        modify("Job Actual to Budget")
        {
            Visible = false;
        }
        modify("Job Analysis")
        {
            Visible = false;
        }
        modify("Job - Planning Lines")
        {
            Visible = false;
        }
        modify("Job - Suggested Billing")
        {
            Visible = false;
        }
        modify("Jobs per Customer")
        {
            Visible = false;
        }
        modify("Items per Job")
        {
            Visible = false;
        }
        modify("Jobs per Item")
        {
            Visible = false;
        }
        modify("Report Job Quote")
        {
            Visible = false;
        }
        modify("Send Job Quote")
        {
            Visible = false;
        }
        modify("Financial Management")
        {
            Visible = false;
        }
        modify("Job WIP to G/L")
        {
            Visible = false;
        }
        modify("Jobs - Transaction Detail")
        {
            Visible = false;
        }
        modify("Job Register")
        {
            Visible = false;
        }
        addafter("Ledger E&ntries")
        {
            action(Bilder)
            {
                ApplicationArea = Basic;
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Bildspeicherung: Record 50015;
                begin
                    Bildspeicherung.SetRange("Job No.", Rec."No.");
                    Page.RunModal(50015, Bildspeicherung);
                end;
            }
        }
    }

    var
        TotalPriceIncludingDiscount_g: Decimal;
        TempExternalDocumentNo_G: Text;

    trigger OnAfterGetRecord()
    begin
    end;
}

