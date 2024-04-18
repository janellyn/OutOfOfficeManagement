page 60002 "Out of Office Request"
{
    ApplicationArea = All;
    Caption = 'Out of Office Request';
    PageType = Document;
    SourceTable = "Out of Office Request";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = (not AccessByUserId) and (Rec.Status = Rec.Status::New);
                field("Entry No"; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    Visible = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    Editable = false;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';

                    trigger OnValidate()
                    begin
                        if Rec."Start Date" < Today then
                            Error(StDateLbl);
                        CalcDuration();
                    end;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';

                    trigger OnValidate()
                    begin
                        if Rec."End Date" < Rec."Start Date" then
                            Error(EnDateLbl);
                        CalcDuration();
                    end;
                }
                field("Start Time"; Rec."Start Time")
                {
                    ToolTip = 'Specifies the value of the Start Time field.';

                    trigger OnValidate()
                    begin
                        if (Rec."End Time" < Rec."Start Time") and (Rec."End Date" = Rec."Start Date") then
                            Error(EnTimeLbl);
                        CalcDuration();
                    end;
                }
                field("End Time"; Rec."End Time")
                {
                    ToolTip = 'Specifies the value of the End Time field.';

                    trigger OnValidate()
                    begin
                        if (Rec."End Time" < Rec."Start Time") and (Rec."End Date" = Rec."Start Date") then
                            Error(EnTimeLbl);
                        CalcDuration();
                    end;
                }
                field(Duration; Rec.Duration)
                {
                    ToolTip = 'Specifies the value of the Duration field.';
                    Editable = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.';
                    ShowMandatory = true;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    Editable = false;
                    StyleExpr = StyleExprTxt;

                    trigger OnValidate()
                    begin
                        case Rec.Status of
                            Rec.Status::Approved:
                                StyleExprTxt := 'favorable';
                            Rec.Status::Declined:
                                StyleExprTxt := 'unfavorable';
                            else
                                StyleExprTxt := 'standard';
                        end;
                    end;
                }
                field(Note; Rec.Note)
                {
                    ToolTip = 'Specifies the value of the Note field.';
                    ShowMandatory = true;
                }
                field("Rejection Reason"; Rec."Rejection Reason")
                {
                    ToolTip = 'Specifies the value of the Rejection reason field.';
                    Editable = false;
                }
            }
        }

        area(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(60001),
                "No." = field("No.");
            }
            systempart(PaymentTermsLinks; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(PaymentTermsNotes; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Start process")
            {
                Caption = 'Start process';
                ToolTip = 'Specifies the action Start Process.';
                Visible = AccessByUserId;
                Enabled = Enabled and EnabledProcess;
                Image = Start;

                trigger OnAction()
                begin
                    ChangeStatus(RequestInProcessLbl, Rec.Status::"In process");
                end;
            }
            action("Approve")
            {
                Caption = 'Approve';
                ToolTip = 'Specifies the action Approve.';
                Visible = AccessByUserId;
                Enabled = Enabled;
                Image = Approve;

                trigger OnAction()
                begin
                    ChangeStatus(RequestApproveLbl, Rec.Status::Approved);
                end;
            }
            action("Decline")
            {
                Caption = 'Decline';
                ToolTip = 'Specifies the action Decline.';
                Visible = AccessByUserId;
                Enabled = Enabled;
                Image = Reject;

                trigger OnAction()
                var
                    RejectionReasonPage: Page RejectionReason;
                begin
                    RejectionReasonPage.RunModal();
                    Rec."Rejection Reason" := RejectionReasonPage.Set();
                    if Rec."Rejection Reason" <> '' then
                        ChangeStatus(RequestDeclineLbl, Rec.Status::Declined);
                end;
            }
        }
    }

    var
        StDateLbl: Label 'The Start date must be today or later.';
        EnDateLbl: Label 'The End date must be later than Start date.';
        EnTimeLbl: Label 'The End time must be later than Start time.';
        RequestInProcessLbl: Label 'Request in processing.';
        RequestApproveLbl: Label 'Request approve.';
        RequestDeclineLbl: Label 'Request decline.';
        AccessByUserId: Boolean;
        StyleExprTxt: Text[50];
        Enabled: Boolean;
        EnabledProcess: Boolean;

    trigger OnOpenPage()
    begin
        SetupFilters();
    end;

    trigger OnAfterGetRecord()
    begin
        Enabled := false;
        EnabledProcess := false;
        StyleExprTxt := 'standard';

        case Rec.Status of
            Rec.Status::Approved:
                StyleExprTxt := 'favorable';
            Rec.Status::Declined:
                StyleExprTxt := 'unfavorable';
            Rec.Status::"In process":
                Enabled := true;
            Rec.Status::New:
                begin
                    Enabled := true;
                    EnabledProcess := true;
                end;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        Employee: Record Employee;
    //OutOfOfficeRequest: Record "Out of Office Request";
    //TempInt: Integer;
    //MaxInt: Integer;
    begin
        /*MaxInt := 0;
        if OutOfOfficeRequest.FindSet() then
            repeat
                Evaluate(TempInt, OutOfOfficeRequest."No.");
                if TempInt > MaxInt then
                    MaxInt := TempInt;
            until OutOfOfficeRequest.NEXT() = 0;
        Evaluate(Rec."No.", Format(MaxInt + 1));*/

        Employee.SetRange(UserID, UserSecurityId());
        if Employee.FindFirst() then
            Rec."Employee No." := Employee."No.";

        Rec."Start Date" := DT2Date(CurrentDateTime());
        Rec."End Date" := DT2Date(CurrentDateTime());
        Rec.Modify();
    end;

    procedure ChangeStatus(ChangedLbl: Text; StatusOption: Option)
    var
        SendEmails: Codeunit SendEmails;
    begin
        Rec.Status := StatusOption;
        if StatusOption <> Rec.Status::Declined then
            Clear(Rec."Rejection Reason");
        Message(ChangedLbl);

        if StatusOption = Rec.Status::Approved then
            SendEmails.ApprovalEmail(Rec);
        if StatusOption = Rec.Status::Declined then
            SendEmails.DeclinedEmail(Rec);

        Rec.Modify();
    end;

    procedure SetupFilters()
    var
        Employee: Record Employee;
    begin
        Employee.SetRange(UserID, UserSecurityId());
        if Employee.FindFirst() then
            if (Rec."Employee No." = Employee."No.") or (Rec."Employee No." = '') then
                AccessByUserId := false
            else
                AccessByUserId := true;
    end;

    procedure CalcDuration()
    var
        DurationTime: Duration;
        StartTime: Time;
        EndTime: Time;
        CurrentDate: Date;
        WorkingHoursStart: Time;
        WorkingHoursEnd: Time;
        BreakTime: Duration;
        WorkingHours: Duration;

    begin
        DurationTime := 0;
        CurrentDate := Rec."Start Date";

        StartTime := Rec."Start Time";
        EndTime := Rec."End Time";

        WorkingHoursStart := 090000T;
        WorkingHoursEnd := 180000T;
        BreakTime := 1000 * 60 * 60;

        WorkingHours := WorkingHoursEnd - WorkingHoursStart - BreakTime;

        while CurrentDate <= Rec."End Date" do
            if Rec."Start Date" = Rec."End Date" then begin
                if (StartTime = WorkingHoursStart) and (EndTime = WorkingHoursEnd) then
                    DurationTime += WorkingHours
                else
                    DurationTime += EndTime - StartTime
            end
            else
                case CurrentDate of
                    Rec."Start Date":
                        if (StartTime > WorkingHoursStart) then
                            DurationTime += WorkingHoursEnd - StartTime
                        else
                            DurationTime += WorkingHours;

                    Rec."End Date":
                        if (EndTime < WorkingHoursEnd) then
                            DurationTime += EndTime - WorkingHoursStart
                        else
                            DurationTime += WorkingHours;

                    else
                        DurationTime += WorkingHours;
                end;
        CurrentDate := CurrentDate + 1;

        Rec.Duration := DurationTime / 3600000;
        Rec.Modify();
    end;
}