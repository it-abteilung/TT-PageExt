pageextension 50003 "User Setup" extends "User Setup"
{
    layout
    {
        addafter(LicenseType)
        {
            field(Block_Items; Rec.Block_Items)
            {
                ApplicationArea = All;
                Caption = 'Erlaube Artikelsperrung';
            }
            field(Upload_Files; Rec.Upload_Files)
            {
                ApplicationArea = All;
                Caption = 'Erlaube Artikelbilder-Import';
            }
            field("Edit Memo Goods Receipt"; Rec."Edit Memo Goods Receipt")
            {
                ApplicationArea = All;
                Caption = 'Erlaube "Fehler im Wareneingang"';
            }
        }
    }
}