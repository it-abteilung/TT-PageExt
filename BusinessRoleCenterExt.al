pageextension 50200 "BusinessRoleCenterExt" extends "Business Manager Role Center"
{
    layout
    {

        addlast(rolecenter)
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
        modify("Job Queue Tasks Activities")
        {
            Visible = false;
        }
    }
}