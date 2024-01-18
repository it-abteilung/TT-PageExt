page 50101 "Sales Quote API"
{
    PageType = API;
    APIPublisher = 'cnette';
    APIGroup = 'demo';
    APIVersion = 'v2.0';
    EntityCaption = 'SalesQuoteSign';
    EntitySetCaption = 'SalesQuoteSign';
    EntityName = 'salesQuoteSign';
    EntitySetName = 'salesQuoteSign';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    SourceTable = "Sales Header";
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'System ID';
                    Editable = false;
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(firstSignMail; FirstSignMail)
                {
                    Caption = 'First Sign. Mail';
                }
                field(secondSignMail; SecondSignMail)
                {
                    Caption = 'Second Sign. Mail';
                }
                field(firstStatusApproval; Rec."Status Approval 1")
                {
                    Caption = 'First Status Approved';
                }
                field(secondStatusApproval; Rec."Status Approval 2")
                {
                    Caption = 'Second Status Approved';
                }
            }
        }
    }

    var
        FirstSignMail: Text;
        SecondSignMail: Text;

    trigger OnAfterGetRecord()
    var
        Purchaser1: Record "Salesperson/Purchaser";
        User1: Record User;
        Purchaser2: Record "Salesperson/Purchaser";
        User2: Record User;
    begin
        FirstSignMail := '';
        SecondSignMail := '';

        Purchaser1.SetRange(Code, Rec.Unterschriftscode);
        if Purchaser1.FindFirst() then begin
            User1.SetRange("User Name", Purchaser1."User ID");
            if User1.FindFirst() then FirstSignMail := User1."Authentication Email"
        end;

        Purchaser2.SetRange(Code, Rec."Unterschriftscode 2");
        if Purchaser2.FindFirst() then begin
            User2.SetRange("User Name", Purchaser2."User ID");
            if User2.FindFirst() then SecondSignMail := User2."Authentication Email"
        end;
    end;
}