#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 50050 Eingabe
{

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Allgemein';
                field(Code20_1; Code20_1)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Code20_1_Caption;
                    Visible = Code20_1_Caption <> '';
                }
                field(Code20_2; Code20_2)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Code20_2_Caption;
                    Visible = Code20_2_Caption <> '';
                }
                field(Code20_3; Code20_3)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Code20_3_Caption;
                    Visible = Code20_3_Caption <> '';
                }
                field(Code20_4; Code20_4)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Code20_4_Caption;
                    Visible = Code20_4_Caption <> '';
                }
                field(Code20_5; Code20_5)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Code20_5_Caption;
                    Visible = Code20_5_Caption <> '';
                }
                field(Text_1; Text_1)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text_1_Caption;
                    Visible = Text_1_Caption <> '';
                }
                field(Text_2; Text_2)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text_2_Caption;
                    Visible = Text_2_Caption <> '';
                }
                field(Text_3; Text_3)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text_3_Caption;
                    Visible = Text_3_Caption <> '';
                }
                field(Text_4; Text_4)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text_4_Caption;
                    Visible = Text_4_Caption <> '';
                }
                field(Text_5; Text_5)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text_5_Caption;
                    Visible = Text_5_Caption <> '';
                }
                field(Text_ML; Text_ML)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text_ML_Caption;
                    MultiLine = true;
                    Visible = Text_ML_Caption <> '';
                }
                field(Date_1; Date_1)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Date_1_Caption;
                    Visible = Date_1_Caption <> '';
                }
                field(Date_2; Date_2)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Date_2_Caption;
                    Visible = Date_2_Caption <> '';
                }
                field(Date_3; Date_3)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Date_3_Caption;
                    Visible = Date_3_Caption <> '';
                }
                field(Date_4; Date_4)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Date_4_Caption;
                    Visible = Date_4_Caption <> '';
                }
                field(Date_5; Date_5)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Date_5_Caption;
                    Visible = Date_5_Caption <> '';
                }
            }
        }
    }

    actions
    {
    }

    var
        Code20_1: Code[20];
        Code20_2: Code[20];
        Code20_3: Code[20];
        Code20_4: Code[20];
        Code20_5: Code[20];
        Code20_1_Caption: Text;
        Code20_2_Caption: Text;
        Code20_3_Caption: Text;
        Code20_4_Caption: Text;
        Code20_5_Caption: Text;
        "------------------------------1": Integer;
        Text_1: Text;
        Text_2: Text;
        Text_3: Text;
        Text_4: Text;
        Text_5: Text;
        Text_ML: Text[250];
        Text_1_Caption: Text;
        Text_2_Caption: Text;
        Text_3_Caption: Text;
        Text_4_Caption: Text;
        Text_5_Caption: Text;
        Text_ML_Caption: Text;
        "------------------------------2": Integer;
        Date_1: Date;
        Date_2: Date;
        Date_3: Date;
        Date_4: Date;
        Date_5: Date;
        Date_1_Caption: Text;
        Date_2_Caption: Text;
        Date_3_Caption: Text;
        Date_4_Caption: Text;
        Date_5_Caption: Text;


    procedure SetCaptionCode20_1(Caption: Text)
    begin
        Text_1_Caption := Caption;
    end;


    procedure SetCaptionCode20_2(Caption: Text)
    begin
        Text_2_Caption := Caption;
    end;


    procedure SetCaptionCode20_3(Caption: Text)
    begin
        Text_3_Caption := Caption;
    end;


    procedure SetCaptionCode20_4(Caption: Text)
    begin
        Text_4_Caption := Caption;
    end;


    procedure SetCaptionCode20_5(Caption: Text)
    begin
        Text_5_Caption := Caption;
    end;


    procedure SetCaptionText_1(Caption: Text)
    begin
        Text_1_Caption := Caption;
    end;


    procedure SetCaptionText_2(Caption: Text)
    begin
        Text_2_Caption := Caption;
    end;


    procedure SetCaptionText_3(Caption: Text)
    begin
        Text_3_Caption := Caption;
    end;


    procedure SetCaptionText_4(Caption: Text)
    begin
        Text_4_Caption := Caption;
    end;


    procedure SetCaptionText_5(Caption: Text)
    begin
        Text_5_Caption := Caption;
    end;


    procedure SetCaptionText_ML(Caption: Text)
    begin
        Text_ML_Caption := Caption;
    end;


    procedure SetCaptionDate_1(Caption: Text)
    begin
        Date_1_Caption := Caption;
    end;


    procedure SetCaptionDate_2(Caption: Text)
    begin
        Date_2_Caption := Caption;
    end;


    procedure SetCaptionDate_3(Caption: Text)
    begin
        Date_3_Caption := Caption;
    end;


    procedure SetCaptionDate_4(Caption: Text)
    begin
        Date_4_Caption := Caption;
    end;


    procedure SetCaptionDate_5(Caption: Text)
    begin
        Date_5_Caption := Caption;
    end;


    procedure SetValueText_ML(_Value: Text[250]): Text
    begin
        Text_ML := _Value;
    end;


    procedure GetValueCode20_1(): Code[20]
    begin
        exit(Code20_1);
    end;


    procedure GetValueCode20_2(): Code[20]
    begin
        exit(Code20_2);
    end;


    procedure GetValueCode20_3(): Code[20]
    begin
        exit(Code20_3);
    end;


    procedure GetValueCode20_4(): Code[20]
    begin
        exit(Code20_4);
    end;


    procedure GetValueCode20_5(): Code[20]
    begin
        exit(Code20_5);
    end;


    procedure GetValueText_1(): Text
    begin
        exit(Text_1);
    end;


    procedure GetValueText_2(): Text
    begin
        exit(Text_2);
    end;


    procedure GetValueText_3(): Text
    begin
        exit(Text_3);
    end;


    procedure GetValueText_4(): Text
    begin
        exit(Text_4);
    end;


    procedure GetValueText_5(): Text
    begin
        exit(Text_5);
    end;


    procedure GetValueText_ML(): Text
    begin
        exit(Text_ML);
    end;


    procedure GetValueDate_1(): Date
    begin
        exit(Date_1);
    end;


    procedure GetValueDate_2(): Date
    begin
        exit(Date_2);
    end;


    procedure GetValueDate_3(): Date
    begin
        exit(Date_3);
    end;


    procedure GetValueDate_4(): Date
    begin
        exit(Date_4);
    end;


    procedure GetValueDate_5(): Date
    begin
        exit(Date_5);
    end;
}

