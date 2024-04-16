page 60001 "Out of Office Requests"
{
    ApplicationArea = All;
    Caption = 'Out of Office Requests';
    PageType = List;
    CardPageId = "Out of Office Request";
    SourceTable = "Out of Office Request";
    SourceTableView = sorting(Status) order(ascending);
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ToolTip = 'Specifies the value of the Entry No field.';
                    Visible = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("Start Time"; Rec."Start Time")
                {
                    ToolTip = 'Specifies the value of the Start Time field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("End Time"; Rec."End Time")
                {
                    ToolTip = 'Specifies the value of the End Time field.';
                }
                field(Duration; Rec.Duration)
                {
                    ToolTip = 'Specifies the value of the Duration field.';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    StyleExpr = StyleExprTxt;
                }
                field(Note; Rec.Note)
                {
                    ToolTip = 'Specifies the value of the Note field.';
                }
                field("Rejection Reason"; Rec."Rejection Reason")
                {
                    ToolTip = 'Specifies the value of the Rejection reason field.';
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
                "No." = field("Entry No");
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
            group(ShowRequests)
            {
                Caption = 'Show Requests';
                image = ShowList;
                action(ShowMyRequests)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show My Requests';
                    ToolTip = 'Show only your requests.';
                    Visible = AccessByUserId;

                    trigger OnAction()
                    var
                        Employee: Record Employee;
                    begin
                        Employee.SetRange(UserID, UserSecurityId());
                        if Employee.FindFirst() then
                            Rec.SetRange("Employee No.", Employee."No.");
                        AccessByUserId := false;
                    end;
                }

                action(ShowAllRequests)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show All Requests';
                    ToolTip = 'Show all requests.';

                    trigger OnAction()
                    begin
                        SetupFilters();
                    end;
                }
            }
            action("Start process")
            {
                Caption = 'Start process';
                ToolTip = 'Specifies the action Start Process.';
                Visible = AccessByUserId;
                Image = Start;

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::"In process" then
                        Message(InProcessLbl)
                    else begin
                        Rec.SetRange("Entry No", Rec."Entry No");
                        Rec.Status := Rec.Status::"In process";
                        Clear(Rec."Rejection Reason");
                        Message(RequestInProcessLbl);
                        Rec.Modify();
                        Clear(Rec);
                        SetupFilters();
                        Rec.FIND('-');
                        Rec.SetCurrentKey(Status);
                        Rec.SetAscending(Status, true);
                    end;
                end;
            }
            action("Approve")
            {
                Caption = 'Approve';
                ToolTip = 'Specifies the action Approve.';
                Visible = AccessByUserId;
                Image = Approve;

                trigger OnAction()
                var
                    SendEmails: Codeunit SendEmails;
                begin
                    if Rec.Status = Rec.Status::Approved then
                        Message(ApprovedLbl)
                    else begin
                        Rec.SetRange("Entry No", Rec."Entry No");
                        Rec.Status := Rec.Status::Approved;
                        Clear(Rec."Rejection Reason");
                        Message(RequestApproveLbl);
                        SendEmails.ApprovalEmail(Rec);
                        Rec.Modify();
                        Clear(Rec);
                        SetupFilters();
                        Rec.FIND('-');
                        Rec.SetCurrentKey(Status);
                        Rec.SetAscending(Status, true);
                    end;
                end;
            }
            action("Decline")
            {
                Caption = 'Decline';
                ToolTip = 'Specifies the action Decline.';
                Visible = AccessByUserId;
                Image = Reject;

                trigger OnAction()
                var
                    SendEmails: Codeunit SendEmails;
                    RejectionReasonPage: Page RejectionReason;
                begin
                    if Rec.Status = Rec.Status::Declined then
                        Message(DeclinedLbl)
                    else begin
                        RejectionReasonPage.RunModal();

                        Rec.SetRange("Entry No", Rec."Entry No");
                        Rec."Rejection Reason" := RejectionReasonPage.Set();
                        if Rec."Rejection Reason" <> '' then begin
                            Rec.Status := Rec.Status::Declined;
                            Message(RequestDeclineLbl);
                            SendEmails.DeclinedEmail(Rec);
                        end;
                        Rec.Modify();

                        Clear(Rec);
                        SetupFilters();
                        Rec.FIND('-');
                        Rec.SetCurrentKey(Status);
                        Rec.SetAscending(Status, true);
                    end;
                end;
            }
        }

        area(Reporting)
        {
            action(PrintOutOfOfficeDayCount)
            {
                ApplicationArea = All;
                Caption = 'Print Out of Office Day Count';
                ToolTip = 'Specifies the action Print Out of Office Day Count.';
                Image = Print;
                Visible = AccessByUserId;

                trigger OnAction()
                var
                    Report: Report "Out of Office Day Count";
                begin
                    Report.RunModal();
                end;
            }
        }
    }

    var
        AccessByUserId: Boolean;
        RequestInProcessLbl: Label 'Request in processing.';
        RequestApproveLbl: Label 'Request approve.';
        RequestDeclineLbl: Label 'Request decline.';
        StyleExprTxt: Text[50];
        InProcessLbl: Label 'Request already in process.';
        ApprovedLbl: Label 'Request already approved.';
        DeclinedLbl: Label 'Request already declined.';

    trigger OnOpenPage()
    begin
        SetupFilters();
    end;

    trigger OnAfterGetRecord()
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

    procedure SetupFilters()
    var
        Employee: Record Employee;
    begin
        Employee.SetRange(UserID, UserSecurityId());
        if Employee.FindFirst() then begin
            if Employee."Job Title" = 'General Manager' then begin
                AccessByUserId := true;
                Clear(Employee);
                Employee.SetRange("Job Title", 'HR');
                if Employee.FindFirst() then
                    Rec.SetRange("Employee No.", Employee."No.");
                Clear(Employee);
            end;

            if Employee."Job Title" = 'HR' then begin
                AccessByUserId := true;
                Clear(Employee);
                Employee.SetRange("Job Title", 'Developer');
                if Employee.FindFirst() then
                    Rec.SetRange("Employee No.", Employee."No.");
                Clear(Employee);
            end;

            if Employee."Job Title" = 'Developer' then begin
                AccessByUserId := false;
                Rec.SetRange("Employee No.", Employee."No.");
            end;
        end;
    end;
}