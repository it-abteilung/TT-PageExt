PageExtension 50021 pageextension50021 extends "Purchase Invoice"
{
    layout
    {
        addafter("Job Queue Status")
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Basic;
            }
            field(Leistung; Rec.Leistung)
            {
                ApplicationArea = Basic;
            }
            field(Leistungsart; Rec.Leistungsart)
            {
                ApplicationArea = Basic;
                ShowMandatory = true;
            }
            field(Leistungszeitraum; Rec.Leistungszeitraum)
            {
                ApplicationArea = Basic;
                ShowMandatory = true;
            }
            field("CO2 Menge in Kilogramm"; Rec."CO2 Menge in Kilogramm")
            {
                ApplicationArea = Basic;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        Job_L: Record Job;
    begin
        Rec.Invoice := true;
        if Job_L.Get(Rec."Job No.") then
            if (Job_L.Status = Job_L.Status::Invoiced) OR (Job_L.Status = Job_L.Status::Completed) then
                Message('Das zugeordnete Projekt %1 befindet sich im Status %2. Bitte prüfen Sie, ob für dieses Projekt noch Rechnungen erfasst werden dürfen.', Rec."Job No.", Job_L.Status);
    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Invoice := true;
    end;
}

