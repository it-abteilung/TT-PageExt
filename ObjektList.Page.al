#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50008 "Objekt List"
{
    CardPageID = Objekt;
    PageType = List;
    SourceTable = "Multi Table";
    SourceTableView = sorting(Kennzeichen, Code)
                      where(Kennzeichen = const('SCHIFF'));
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'Objekt Liste';
    AdditionalSearchTerms = 'Objekt Liste, Schiffe';

    layout
    {
        area(content)
        {
            repeater(Control1000000001)
            {
                field("Code"; rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Objektname';
                }
                field(Baujahr; rec.Baujahr)
                {
                    ApplicationArea = Basic;
                }
                field(Hersteller; rec.Hersteller)
                {
                    ApplicationArea = Basic;
                    Caption = 'Yard';
                }
                field(Owner; rec.Owner)
                {
                    ApplicationArea = Basic;
                    Caption = 'Owner';
                }
                field("Owner Name"; rec."Owner Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Owner Name';
                }
                field(Info; rec.Info)
                {
                    ApplicationArea = Basic;
                }
                field(Type; rec.Type)
                {
                    ApplicationArea = Basic;
                    Caption = 'Type';
                }
                field("LLoyds No."; rec."LLoyds No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'IMO';
                }
                field("Hull No."; rec."Hull No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Hull No.';
                }
                field(Class; rec.Class)
                {
                    ApplicationArea = Basic;
                    Caption = 'Class';
                }
                field(Flag; rec.Flag)
                {
                    ApplicationArea = Basic;
                    Caption = 'Flag';
                }
                field(Superintendent; rec.Superintendent)
                {
                    ApplicationArea = Basic;
                    Caption = 'Superintendent';
                }
                field("Superintendent Name"; rec."Superintendent Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Superintendent Name';
                }
                field(Fleetmanager; rec.Fleetmanager)
                {
                    ApplicationArea = Basic;
                    Caption = 'Fleetmanager';
                }
                field("Fleetmanager Name"; rec."Fleetmanager Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fleetmanager Name';
                }
                field(Manager; rec.Manager)
                {
                    ApplicationArea = Basic;
                    Caption = 'Manager';
                }
                field("Manager Name"; rec."Manager Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Manager Name';
                }
                field(Charterer; rec.Charterer)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bareboat Charterer';
                }
                field("Bareboat Charterer Name"; rec."Bareboat Charterer Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Charterer Name';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if rec.Code = '' then begin
            SchiffRec.SetRange(Kennzeichen, 'SCHIFF');
            SchiffRec.FindLast();
            SchiffRec.Next(-1);
            rec.Code := SchiffRec.Code;
            repeat
                rec.Code := IncStr(rec.Code);
            until not SchiffRec.Get('SCHIFF', rec.Code);
        end;
    end;

    var
        SchiffRec: Record "Multi Table";
}

