pageextension 50043 InterLogEntryCommentSheet extends "Inter. Log Entry Comment Sheet"
{
    layout
    {
        addafter("Comment")
        {
            field(Participants; Rec.Participants)
            {
                ApplicationArea = All;
                Caption = 'Teilnehmer';
            }
        }
    }
}