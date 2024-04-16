page 60000 "Out of Office Reasons"
{
    ApplicationArea = All;
    Caption = 'Out of Office Reasons';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Out of Office Reason";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
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
