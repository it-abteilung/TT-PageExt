page 51000 "Mail Editor"
{
    PageType = Document;
    Caption = 'E-Mail Verfassen (TT)';

    ApplicationArea = All;
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    Extensible = true;

    layout
    {
        area(Content)
        {
            group("Email Details")
            {
                Caption = 'E-Mail Details';

                grid("Email Details Grid")
                {
                    group("Email Inner Details")
                    {
                        ShowCaption = false;

                        field(FromText; FromText)
                        {
                            ShowMandatory = true;
                            ApplicationArea = All;
                            Caption = 'Von';
                            Editable = false;
                        }

                        field(ToText; ToText)
                        {
                            ShowMandatory = true;
                            ApplicationArea = All;
                            Caption = 'An';

                            trigger OnValidate()
                            begin
                                MailMsg.SetRecipients(Enum::"Email Recipient Type"::"To", ToText);
                            end;
                        }

                        field(CcText; CcText)
                        {
                            ApplicationArea = All;
                            Caption = 'Cc';

                            trigger OnValidate()
                            begin
                                MailMsg.SetRecipients(Enum::"Email Recipient Type"::"Cc", CcText);
                            end;
                        }

                        field(BccText; BccText)
                        {
                            ApplicationArea = All;
                            Caption = 'Bcc';

                            trigger OnValidate()
                            begin
                                MailMsg.SetRecipients(Enum::"Email Recipient Type"::"Bcc", BccText);
                            end;
                        }

                        field(SubjectText; SubjectText)
                        {
                            Caption = 'Betreff';
                            ApplicationArea = All;
                        }
                    }
                }
            }
            group(HTMLFormattedBody)
            {
                ShowCaption = false;
                Caption = ' ';

                field("Email Editor"; Message1)
                {
                    ApplicationArea = All;
                    Caption = 'Nachricht';
                    MultiLine = true;
                    RowSpan = 20;

                    trigger OnValidate()
                    begin
                        MailMsg.SetBody(Message1);
                    end;
                }
            }

            group(RawTextBody)
            {
                ShowCaption = false;
                Caption = ' ';

                field(BodyField; Message1)
                {
                    Caption = 'Nachricht';
                    ApplicationArea = All;
                    MultiLine = true;
                    RowSpan = 5;

                    trigger OnValidate()
                    begin
                        MailMsg.SetBody(Message1);
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Send)
            {
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Caption = 'Send email';
                ToolTip = 'Send the email.';
                ApplicationArea = All;
                Image = SendMail;

                trigger OnAction()
                begin
                    Mail.Send(MailMsg, Enum::"Email Scenario"::"Purchase Quote");
                    CurrPage.Close();
                end;
            }
            action(Discard)
            {
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Caption = 'Discard draft';
                ToolTip = 'Discard the draft email and close the page.';
                ApplicationArea = All;
                Image = Delete;

                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        Receipts: List of [Text];
        Receipt: Text;
    begin
        FromText := 'purchasing@turbotechnik.com';
        // ToText := 'christian.nette@turbotechnik.com';
        MailMsg.GetRecipients(Enum::"Email Recipient Type"::"To", Receipts);
        foreach Receipt in Receipts do begin
            ToText += Receipt + ';';
        end;
        MailMsg.GetRecipients(Enum::"Email Recipient Type"::"Cc", Receipts);
        foreach Receipt in Receipts do begin
            CcText += Receipt + ';';
        end;
        MailMsg.GetRecipients(Enum::"Email Recipient Type"::"Bcc", Receipts);
        foreach Receipt in Receipts do begin
            BccText += Receipt + ';';
        end;

        SubjectText := MailMsg.GetSubject();
        Message1 := MailMsg.GetBody();
    end;


    var
        Mail: Codeunit EMail;
        MailMsg: Codeunit "Email Message";

        ToText: Text;
        FromText: Text;
        CcText: Text;
        BccText: Text;
        SubjectText: Text;
        Message1: Text;
        Message2: Text;

    protected var
        IsNewOutbox: Boolean;
        ToRecipient, CcRecipient, BccRecipient : Text;
        DefaultExitOption: Integer;

    procedure SetMailMsg(MailMsg_L: Codeunit "Email Message")
    begin
        MailMsg := MailMsg_L;
    end;

    procedure SetMail(Mail_L: Codeunit "Email")
    begin
        Mail := Mail_L;
    end;
}
