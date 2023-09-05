pageextension 50000 "CustomerLookup" extends "Customer Lookup"
{
    layout
    {

        modify(City)
        {
            ApplicationArea = Basic;
            Visible = true;
        }
        modify("Post Code")
        {
            ApplicationArea = Basic;
            Visible = true;
        }
        modify("Address")
        {
            ApplicationArea = Basic;
            Visible = true;
        }

        movebefore("Phone No."; City)
        movebefore("Phone No."; "Post Code")
        movebefore("Phone No."; Address)
    }
}