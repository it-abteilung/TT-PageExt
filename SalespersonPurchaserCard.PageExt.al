PageExtension 50050 pageextension50050 extends "Salesperson/Purchaser Card"
{
    layout
    {
        addafter("Phone No.")
        {
            field("Fax No. TT"; rec."Fax No. TT")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Next Task Date")
        {
            field("User ID"; rec."User ID")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Phone No.")
        {
            field(Durchwahlnummer; rec.Durchwahlnummer)
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Blocked)
        {
            field("Allow Edit Item"; Rec."Allow Edit Item")
            {
                ApplicationArea = All;
                Caption = 'Kann Artikel bearbeiten';
            }
            field("Just Sales"; Rec."Just Sales")
            {
                ApplicationArea = All;
                Caption = 'Nur Vertrieb';
                ToolTip = 'Wenn aktiviert, hat der Benutzer Zugriff auf die Unternehmensgruppen in der Kontaktverwaltung, die nur Vertriebsmitarbeiter sehen können.';
            }
        }
    }
}

