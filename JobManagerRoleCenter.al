pageextension 50201 "JobRoleCenterExt" extends "Job Project Manager RC"
{
    layout
    {
        addafter(Control34)
        {
            part(JobMarineOpenPart; JobMarineOpenPart)
            {
                ApplicationArea = all;
                Visible = true;
            }
            part(JobMarineQuotePart; JobMarineQuotePart)
            {
                ApplicationArea = all;
                Visible = true;
            }
            part(JobMarinePlanningPart; JobMarinePlanningPart)
            {
                ApplicationArea = all;
                Visible = true;
            }
        }
        addafter(ApprovalsActivities)
        {
            part("Werkzeuganforderung Activities"; "Werkzeuganforderung Activities")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {

    }
}