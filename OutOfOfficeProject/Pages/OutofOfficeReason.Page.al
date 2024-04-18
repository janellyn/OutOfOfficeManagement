namespace OutOfOfficeProject.OutOfOfficeProject;

page 60004 "Out of Office Reason"
{
    ApplicationArea = All;
    Caption = 'Out of Office Reason';
    PageType = Card;
    SourceTable = "Out of Office Reason";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}
