pageextension 50201 "JobRoleCenterExt" extends "Job Project Manager RC"
{
    layout
    {
        addafter(Control34)
        {
            part(JobMarineOpenPart; JobMarineOpenPart)
            {
                ApplicationArea = all;
                Visible = false;
            }
            part(JobMarineQuotePart; JobMarineQuotePart)
            {
                ApplicationArea = all;
                Visible = false;

            }
            part(JobMarinePlanningPart; JobMarinePlanningPart)
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }
    actions
    {

    }
}