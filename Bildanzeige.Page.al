#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50015 Bildanzeige
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Bildspeicherung;

    layout
    {
        area(content)
        {
            group(Ausgeblendet)
            {
                Visible = false;
                field("Projektnr."; ProjektNr)
                {
                    ApplicationArea = Basic;
                    TableRelation = Job."No.";

                    trigger OnValidate()
                    begin
                        Rec.SetRange("Job No.", ProjektNr);
                        CurrPage.Update;
                    end;
                }
            }
            repeater("Bilder zum Projekt")
            {
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bild-Nr."; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bild-Nr.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000011; "Bildanzeige FactBox")
            {
                SubPageLink = "Table ID" = field("Table ID"),
                              "Document No." = field("Document No."),
                              "Document Type" = field("Document Type"),
                              "Document Line No." = field("Document Line No."),
                              "Line No." = field("Line No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        ProjektNr := Rec."Job No.";
        CurrPage.Update;
    end;

    var
        ProjektNr: Code[20];
        Job: Record Job;
}

