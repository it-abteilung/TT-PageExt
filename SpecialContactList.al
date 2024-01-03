page 50100 "Special Contact List"
{
    Caption = 'Liste aller Kontakte';
    PageType = List;
    SourceTable = Contact;
    SourceTableView = sorting("Company Name", "Company No.", Type, Name);

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = all;
                    Caption = 'Unternehmensname';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    Caption = 'Art';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    Caption = 'Name';
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = all;
                    Caption = 'Name 2';
                }
                field("Name 3"; Rec."Name 3")
                {
                    ApplicationArea = all;
                    Caption = 'Name 3';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = all;
                    Caption = 'Adresse';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = all;
                    Caption = 'Adresse 2';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = all;
                    Caption = 'Ort';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = all;
                    Caption = 'PLZ';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = all;
                    Caption = 'Land/Region';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = all;
                    Caption = 'Telefonnr.';
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ApplicationArea = all;
                    Caption = 'Mobilenr.';
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = all;
                    Caption = 'Faxnr.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = all;
                    Caption = 'E-Mail';
                }
                field("E-Mail 2"; Rec."E-Mail 2")
                {
                    ApplicationArea = all;
                    Caption = 'E-Mail 2';
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = all;
                    Caption = 'Vorname';
                }
                field(Surname; Rec.Surname)
                {
                    ApplicationArea = all;
                    Caption = 'Nachname';
                }
                field("Contact Business Relation"; Rec."Contact Business Relation")
                {
                    ApplicationArea = all;
                    Caption = 'Geschäftsbeziehung';
                }
                field("Industry Group Text"; Rec."Industry Group Text")
                {
                    ApplicationArea = all;
                    Caption = 'Industriegruppe';
                }
            }
        }
    }

}