#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50017 Wareneingangskontrolle
{
    PageType = Card;
    SourceTable = Wareneingangskontrolle;
    Caption = 'Wareneingangskontrolle';
    UsageCategory = Tasks;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            grid(Control1)
            {
                GridLayout = Rows;
                group(Control1000000000)
                {
                    field(Kontrolleur; Rec.Kontrolleur)
                    {
                        ApplicationArea = Basic;
                    }
                    field("Allgemeine Sichtkontolle"; Rec."Allgemeine Sichtkontolle")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Sichtbare Beschädigungen"; Rec."Sichtbare Beschädigungen")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Welche Papiere vorhanden"; Rec."Welche Papiere vorhanden")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Vollzähligkeit"; Rec.Vollzähligkeit)
                    {
                        ApplicationArea = Basic;
                    }
                    field("Verpackung i.O."; Rec.Verpackung)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Verpackung i.O.';
                    }
                    field(Gefahrstoff; Rec.Gefahrstoff)
                    {
                        ApplicationArea = Basic;
                    }
                    field(Bemerkung; Rec.Bemerkung)
                    {
                        ApplicationArea = Basic;
                    }
                    field("erstellt am"; Rec."erstellt am")
                    {
                        ApplicationArea = Basic;
                    }
                    field("erstellt von"; Rec."erstellt von")
                    {
                        ApplicationArea = Basic;
                    }
                    field("geprüft am"; Rec."geprüft am")
                    {
                        ApplicationArea = Basic;
                    }
                    field("geprüft von"; Rec."geprüft von")
                    {
                        ApplicationArea = Basic;
                    }
                    field("geprüft QM am"; Rec."geprüft QM am")
                    {
                        ApplicationArea = Basic;
                    }
                    field("geprüft von QM"; Rec."geprüft von QM")
                    {
                        ApplicationArea = Basic;
                    }
                }
            }
        }
    }

    actions
    {
    }
}

