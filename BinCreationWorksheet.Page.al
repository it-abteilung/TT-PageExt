pageextension 50004 "BinCreationWorksheet" extends "Bin Creation Worksheet"
{
    actions
    {
        addafter(CalculateBins_Promoted)
        {
            actionref(RenameBins; Rename_Bins) { }
        }
        addlast(Processing)
        {
            action(Rename_Bins)
            {
                ApplicationArea = All;
                Caption = 'Lagerplätze umbenennen';
                Image = Description;

                trigger OnAction()
                var
                    BinCreationWorksheetDialog: Page "Bin Creation Worksheet Dialog";
                    BinCreationWorksheetLine: Record "Bin Creation Worksheet Line";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                    NewDescription: Text[20];
                begin
                    if BinCreationWorksheetDialog.RunModal() = Action::OK then begin
                        NewDescription := BinCreationWorksheetDialog.GetNewDescription();
                        CurrPage.SetSelectionFilter(BinCreationWorksheetLine);
                        BinCreationWorksheetLine.SetFilter("Worksheet Template Name", Rec."Worksheet Template Name");
                        BinCreationWorksheetLine.SetFilter(Name, Rec.Name);
                        RecRef.GetTable(BinCreationWorksheetLine);
                        BinCreationWorksheetLine.SetFilter("Line No.", SelectionFilterManagement.GetSelectionFilter(RecRef, BinCreationWorksheetLine.FieldNo("Line No.")));
                        BinCreationWorksheetLine.ModifyAll(Description, NewDescription);
                    end;
                end;
            }
        }
    }
}