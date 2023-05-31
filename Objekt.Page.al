#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50023 Objekt
{
    PageType = Card;
    SourceTable = "Multi Table";
    SourceTableView = sorting(Kennzeichen, Code)
                      where(Kennzeichen = const('SCHIFF'));

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Allgemein';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Objektname';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Baujahr; Rec.Baujahr)
                {
                    ApplicationArea = Basic;
                }
                field(Hersteller; Rec.Hersteller)
                {
                    ApplicationArea = Basic;
                    Caption = 'Yard';
                }
                field(Owner; Rec.Owner)
                {
                    ApplicationArea = Basic;
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = Basic;
                }
                field(Info; Rec.Info)
                {
                    ApplicationArea = Basic;
                }
                field(Sachbearbeiter; Rec.Sachbearbeiter)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Abteilungsleiter; Rec.Abteilungsleiter)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Technische Info"; Rec."Technische Info")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(TDW; Rec.TDW)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Length; Rec.Length)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Width; Rec.Width)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Depth; Rec.Depth)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Area"; Rec.Area)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Main Engine"; Rec."Main Engine")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Main Engine Type"; Rec."Main Engine Type")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("ME Turbo"; Rec."ME Turbo")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("AUX Engine"; Rec."AUX Engine")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("AUX Engine Type"; Rec."AUX Engine Type")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Seal Maker"; Rec."Seal Maker")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Seal Type"; Rec."Seal Type")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Ex Name"; Rec."Ex Name")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("LLoyds No."; Rec."LLoyds No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'IMO';
                }
                field("Hull No."; Rec."Hull No.")
                {
                    ApplicationArea = Basic;
                }
                field(NRT; Rec.NRT)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(GRT; Rec.GRT)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic;
                }
                field(Flag; Rec.Flag)
                {
                    ApplicationArea = Basic;
                }
                field(Superintendent; Rec.Superintendent)
                {
                    ApplicationArea = Basic;
                }
                field("Superintendent Name"; Rec."Superintendent Name")
                {
                    ApplicationArea = Basic;
                }
                field(Fleetmanager; Rec.Fleetmanager)
                {
                    ApplicationArea = Basic;
                }
                field("Fleetmanager Name"; Rec."Fleetmanager Name")
                {
                    ApplicationArea = Basic;
                }
                field(Manager; Rec.Manager)
                {
                    ApplicationArea = Basic;
                }
                field("Manager Name"; Rec."Manager Name")
                {
                    ApplicationArea = Basic;
                }
                field(Charterer; Rec.Charterer)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bareboat Charterer';
                }
                field("Bareboat Charterer Name"; Rec."Bareboat Charterer Name")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec.Code = '' then begin
            SchiffRec.SetRange(Kennzeichen, 'SCHIFF');
            SchiffRec.FindLast();
            SchiffRec.Next(-1);
            Rec.Code := SchiffRec.Code;
            repeat
                Rec.Code := IncStr(Rec.Code);
            until not SchiffRec.Get('SCHIFF', Rec.Code);
        end;
    end;

    var
        SchiffRec: Record "Multi Table";
}

