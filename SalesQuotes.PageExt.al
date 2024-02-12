PageExtension 50066 pageextension50066 extends "Sales Quotes"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = Basic;
            }
        }
    }

    local procedure ShowEmployeeForSignature()
    var
        SalesHeader: Record "Sales Header";
        TextBuilderTmp: TextBuilder;
        WorkerList: List of [Code[20]];
        Worker: Text;
        Purchaser: Record "Salesperson/Purchaser";
    begin
        if SalesHeader.FindSet() then begin
            repeat
                if NOT WorkerList.Contains(SalesHeader.Unterschriftscode) then
                    WorkerList.Add(SalesHeader.Unterschriftscode);
                if NOT WorkerList.Contains(SalesHeader."Unterschriftscode 2") then
                    WorkerList.Add(SalesHeader."Unterschriftscode 2");
            until SalesHeader.Next() = 0;

            foreach Worker in WorkerList do begin
                Clear(Purchaser);
                Purchaser.SetRange("Code", Worker);
                if Purchaser.FindFirst() then
                    if TextBuilderTmp.Length > 0 then
                        TextBuilderTmp.Append(', ' + Purchaser.Name)
                    else
                        TextBuilderTmp.Append(Purchaser.Name);
            end;

            Message('%1', TextBuilderTmp.ToText());
        end;
    end;
}

