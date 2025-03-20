pageextension 50047 InterLogEntryCommentList extends "Inter. Log Entry Comment List"
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