namespace OutOfOfficeProject.OutOfOfficeProject;

page 60003 RejectionReason
{
    ApplicationArea = All;
    Caption = 'Rejection Reason';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field("Rejection Reason"; RejectReason)
            {
                ApplicationArea = All;
                Caption = 'Rejection Reason';
                ToolTip = 'Specifies the rejection reason';
                ShowMandatory = true;
            }
        }
    }

    var
        RejectReason: Text[250];
        EmptyReasonLbl: Label 'Rejection reason must not be empty.';

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = CloseAction::Ok then
            if RejectReason = '' then
                Error(EmptyReasonLbl)
            else
                exit(true);
    end;

    procedure Set(): text[250]
    begin
        exit(RejectReason);
    end;
}
