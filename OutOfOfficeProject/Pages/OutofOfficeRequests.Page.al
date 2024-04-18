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
                field("Entry No"; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
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
                    Rec.SetRange("No.", Rec."No.");
                    Rec."Rejection Reason" := RejectionReasonPage.Set();
                    if Rec."Rejection Reason" <> '' then
                        ChangeStatus(RequestDeclineLbl, Rec.Status::Declined);
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

    procedure ChangeStatus(ChangedLbl: Text; StatusOption: Option)
    var
        SendEmails: Codeunit SendEmails;
    begin
        Rec.SetRange("No.", Rec."No.");
        Rec.Status := StatusOption;
        if StatusOption <> Rec.Status::Declined then
            Clear(Rec."Rejection Reason");
        Message(ChangedLbl);

        if StatusOption = Rec.Status::Approved then
            SendEmails.ApprovalEmail(Rec);
        if StatusOption = Rec.Status::Declined then
            SendEmails.DeclinedEmail(Rec);

        Rec.Modify();
        Clear(Rec);
        SetupFilters();
        Rec.FIND('-');
        Rec.SetCurrentKey(Status);
        Rec.SetAscending(Status, true);
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