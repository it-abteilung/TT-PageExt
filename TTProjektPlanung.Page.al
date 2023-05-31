Page 50022 "TT Projekt Planung"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Job Planning Line";
    Caption = 'TT Projektplanung';

    layout
    {
        area(content)
        {
            group("Projekt Planung")
            {
                field("JobAufschlag.""Currency Code"""; JobAufschlag."Currency Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Währungscode';
                    Lookup = true;
                    TableRelation = Currency;

                    trigger OnValidate()
                    begin
                        JobAufschlag.Validate("Currency Code");
                        JobAufschlag.Modify;

                        Clear(JobPlanningLine);
                        JobPlanningLine.SetRange("Job No.", Rec."Job No.");
                        if JobPlanningLine.FindSet then
                            repeat
                                JobPlanningLine.Validate(Währungscode, JobAufschlag."Currency Code");
                                JobPlanningLine.Validate(Währungskurs, JobAufschlag.Währungskurs);
                                JobPlanningLine.Modify;
                            until JobPlanningLine.Next = 0;

                        JobAufschlag.CalcFields(Gesamt);

                        CurrPage.Update();
                    end;
                }
                field("JobAufschlag.Währungskurs"; JobAufschlag.Währungskurs)
                {
                    ApplicationArea = Basic;
                    Caption = 'Währungskurs';

                    trigger OnValidate()
                    begin
                        JobAufschlag.Modify;

                        Clear(JobPlanningLine);
                        JobPlanningLine.SetRange("Job No.", Rec."Job No.");
                        if JobPlanningLine.FindSet then
                            repeat
                                JobPlanningLine.Validate(Währungskurs, JobAufschlag.Währungskurs);
                                JobPlanningLine.Modify;
                            until JobPlanningLine.Next = 0;

                        JobAufschlag.CalcFields(Gesamt);

                        CurrPage.Update();
                    end;
                }
                field("JobAufschlag.""Einkaufsrabatt %"""; JobAufschlag."Einkaufsrabatt %")
                {
                    ApplicationArea = Basic;
                    Caption = 'Einkaufsrabatt %';

                    trigger OnValidate()
                    begin
                        JobAufschlag.Modify;

                        Clear(JobPlanningLine);
                        JobPlanningLine.SetRange("Job No.", Rec."Job No.");
                        if JobPlanningLine.FindSet then
                            repeat
                                JobPlanningLine.Validate("Einkaufsrabatt %", JobAufschlag."Einkaufsrabatt %");
                                JobPlanningLine.Modify;
                            until JobPlanningLine.Next = 0;

                        JobAufschlag.CalcFields(Gesamt);

                        CurrPage.Update();
                    end;
                }
                field("JobAufschlag.""Aufschlag %"""; JobAufschlag."Aufschlag %")
                {
                    ApplicationArea = Basic;
                    Caption = 'Aufschlag %';
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        JobAufschlag.Modify;

                        Clear(JobPlanningLine);
                        JobPlanningLine.SetRange("Job No.", Rec."Job No.");
                        if JobPlanningLine.FindSet then
                            repeat
                                JobPlanningLine.Validate("Aufschlag %", JobAufschlag."Aufschlag %");
                                JobPlanningLine.Modify;
                            until JobPlanningLine.Next = 0;

                        JobAufschlag.CalcFields(Gesamt);

                        CurrPage.Update();
                    end;
                }
                field("JobAufschlag.Gesamt"; JobAufschlag.Gesamt)
                {
                    ApplicationArea = Basic;
                    Caption = 'Gesamt';
                    Editable = false;
                    Importance = Promoted;
                }
            }
            repeater(Group)
            {
                field(Baugruppe; Rec.Baugruppe)
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Stückpreis in Währungscode"; Rec."Stückpreis in Währungscode")
                {
                    ApplicationArea = Basic;
                }
                field("Stückpreis EUR"; Rec."Stückpreis EUR")
                {
                    ApplicationArea = Basic;
                }
                field("Einkaufsrabatt %"; Rec."Einkaufsrabatt %")
                {
                    ApplicationArea = Basic;
                }
                field("Einkaufsrabatt EUR"; Rec."Einkaufsrabatt EUR")
                {
                    ApplicationArea = Basic;
                }
                field("Aufschlag %"; Rec."Aufschlag %")
                {
                    ApplicationArea = Basic;
                }
                field("Aufschlag EUR"; Rec."Aufschlag EUR")
                {
                    ApplicationArea = Basic;
                }
                field("<Unit Price>"; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field("Total Price"; Rec."Total Price")
                {
                    ApplicationArea = Basic;
                }
                field(Delivery; Rec.Delivery)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Pro&jekt")
            {
                Caption = 'Pro&jekt';
                action("<Action1000000013>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Einkaufsanfrage';
                    Image = TaskList;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.MakePurchaseQuote();
                    end;
                }
                action("<Action1000000014>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Einkaufsbestellung';
                    Image = TaskList;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.MakePurchaseOrder();
                    end;
                }
                action(Verkaufsangebot)
                {
                    ApplicationArea = Basic;
                    Caption = 'Verkaufsangebot';
                    Image = TaskList;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.MakeSalesQuote();
                    end;
                }
                action(Verkaufsauftrag)
                {
                    ApplicationArea = Basic;
                    Caption = 'Verkaufsauftrag';
                    Image = TaskList;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.MakeSalesOrder();
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Aufschlag %" := JobAufschlag."Aufschlag %";
        Rec."Einkaufsrabatt %" := JobAufschlag."Einkaufsrabatt %";
        Rec.Währungscode := JobAufschlag."Currency Code";
        Rec.Währungskurs := JobAufschlag.Währungskurs;
    end;

    trigger OnOpenPage()
    begin
        if not JobAufschlag.Get('ZUSCHLAG', Rec."Job No.") then begin
            JobAufschlag.Kennzeichen := 'ZUSCHLAG';
            JobAufschlag.Code := Rec."Job No.";
            JobAufschlag.Insert;
        end;
        JobAufschlag.CalcFields(Gesamt);
    end;

    var
        JobAufschlag: Record "Multi Table";
        JobPlanningLine: Record "Job Planning Line";
        Aufschlag: Integer;
}

