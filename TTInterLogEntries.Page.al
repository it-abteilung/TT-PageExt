page 50094 "TT Inter. Log Entries"
{
    Caption = 'Alle Aktivitäten';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Interaction Log Entry";
    SourceTableView = Sorting("Entry No.") order(descending);

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the contact involved in this interaction. This field is not editable.';
                }
                field("Contact Name"; Rec."Contact Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the contact for which an interaction has been logged.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the salesperson who carried out the interaction.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the interaction.';
                }
                field("Attachment No."; Rec."Attachment No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Attachment No. field.', Comment = '%';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that a comment exists for this interaction log entry.';
                }
                field("Opportunity No."; Rec."Opportunity No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the opportunity to which the interaction is linked.';
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the campaign (if any) to which the interaction is linked. This field is not editable.';
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date that you have entered in the Date field in the Create Interaction wizard or the Segment window when you created the interaction. The field is not editable.';
                }
                field("Attempt Failed"; Rec."Attempt Failed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the interaction records an failed attempt to reach the contact. This field is not editable.';
                    Visible = false;
                }
                field("Campaign Entry No."; Rec."Campaign Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the campaign entry to which the interaction log entry is linked.';
                    Visible = false;
                }
                field("Campaign Response"; Rec."Campaign Response")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the interaction records a response to a campaign.';
                    Visible = false;
                }
                field("Campaign Target"; Rec."Campaign Target")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the interaction is applied to contacts that are part of the campaign target. This field is not editable.';
                }
                field(Canceled; Rec.Canceled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the interaction has been canceled. The field is not editable.';
                    Visible = false;
                }
                field("Contact Alt. Address Code"; Rec."Contact Alt. Address Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact Alt. Address Code field.', Comment = '%';
                    Visible = false;
                }
                field("Contact Company Name"; Rec."Contact Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the contact company for which an interaction has been logged.';
                    Visible = false;
                }
                field("Contact Company No."; Rec."Contact Company No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the contact company.';
                    Visible = false;
                }
                field("Contact Via"; Rec."Contact Via")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the telephone number that you used when calling the contact.';
                    Visible = false;
                }
                field("Correspondence Type"; Rec."Correspondence Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of correspondence of the attachment in the interaction template. This field is not editable.';
                    Visible = false;
                }
                field("Cost (LCY)"; Rec."Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cost of the interaction.';
                    Visible = false;
                }
                field("Delivery Status"; Rec."Delivery Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the delivery of the attachment. There are three options:';
                    Visible = false;
                }
                field("Doc. No. Occurrence"; Rec."Doc. No. Occurrence")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Doc. No. Occurrence field.', Comment = '%';
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the document (if any) that the interaction log entry records.';
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of document if there is one that the interaction log entry records. You cannot change the contents of this field.';
                    Visible = false;
                }
                field("Duration (Min.)"; Rec."Duration (Min.)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the duration of the interaction.';
                    Visible = false;
                }
                field("E-Mail Logged"; Rec."E-Mail Logged")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email Logged field.', Comment = '%';
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                    Visible = false;
                }
                field(Evaluation; Rec.Evaluation)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the evaluation of the interaction. There are five options: Very Positive, Positive, Neutral, Negative, and Very Negative.';
                    Visible = false;
                }
                field("Information Flow"; Rec."Information Flow")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the direction of information flow recorded by the interaction. There are two options: Outbound (the information was received by your contact) and Inbound (the information was received by your company).';
                    Visible = false;
                }
                field("Initiated By"; Rec."Initiated By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who initiated the interaction. There are two options: Us (the interaction was initiated by your company) and Them (the interaction was initiated by your contact).';
                    Visible = false;
                }
                field("Interaction Group Code"; Rec."Interaction Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the interaction group used to create this interaction. This field is not editable.';
                    Visible = false;
                }
                field("Interaction Language Code"; Rec."Interaction Language Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the language code for the interaction for the interaction log. The code is copied from the language code of the interaction template, if one is specified.';
                    Visible = false;
                }
                field("Interaction Template Code"; Rec."Interaction Template Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the interaction template used to create the interaction. This field is not editable.';
                    Visible = false;
                }
                field("Logged Segment Entry No."; Rec."Logged Segment Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Logged Segment Entry No. field.', Comment = '%';
                    Visible = false;
                }
                field(Merged; Rec.Merged)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Merged field.', Comment = '%';
                    Visible = false;
                }
                field("Modified Word Template"; Rec."Modified Word Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Modified Word Template field.', Comment = '%';
                    Visible = false;
                }

                field(Postponed; Rec.Postponed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Postponed field.', Comment = '%';
                    Visible = false;
                }

                field("Segment No."; Rec."Segment No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the segment. This field is valid only for interactions created for segments, and is not editable.';
                    Visible = false;
                }
                field("Send Word Docs. as Attmt."; Rec."Send Word Docs. as Attmt.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Send Word Docs. as Attmt. field.', Comment = '%';
                    Visible = false;
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the subject text that will be used for this interaction.';
                    Visible = false;
                }
                field("Time of Interaction"; Rec."Time of Interaction")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the time when the interaction was created. This field is not editable.';
                    Visible = false;
                }
                field("To-do No."; Rec."To-do No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the task if the interaction has been created to complete a task. This field is not editable.';
                    Visible = false;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the user who logged this entry. This field is not editable.';
                    Visible = false;
                }
                field("Version No."; Rec."Version No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Version No. field.', Comment = '%';
                    Visible = false;
                }
                field("Word Template Code"; Rec."Word Template Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Word Template Code field.', Comment = '%';
                    Visible = false;
                }
            }
        }
    }
}