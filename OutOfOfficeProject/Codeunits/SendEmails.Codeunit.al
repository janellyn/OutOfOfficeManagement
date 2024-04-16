namespace OutOfOfficeProject.OutOfOfficeProject;
using Microsoft.HumanResources.Employee;
using System.Email;

codeunit 60003 SendEmails
{
    procedure ApprovalEmail(OutOfOfficeRequest: Record "Out of Office Request")
    var
        Employee: Record Employee;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;
        EmployeeFirstName: Text[30];
        EmployeeLastName: Text[30];
        EmployeeEmail: Text[80];
        ApproverFirstName: Text[30];
        ApproverLastName: Text[30];
        ApprovalBodyLbl: Text;
    begin
        ApprovalBodyLbl := '<p style="margin-top:0cm;"><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:gray;">Hello %1 %2,</span></p>';
        ApprovalBodyLbl += '<p style="margin-top:-0.5cm;"><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:gray;">You are registered to receive notifications related to ТОВ &quot;СМАРТ БІЗНЕС&quot;.</span><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:gray;"><br> <span>This is a message to notify you that:</span></span></p>';
        ApprovalBodyLbl += '<table><tbody><tr><td colspan="2" style="width: 481.4pt; border-top: 1pt solid rgb(165, 165, 165);"><p style="margin-top:0cm;"><span style="font-size:16px;font-family:"Calibri Light",sans-serif;color:#2E74B5;"><i>%1 %2 (%3) %4 %5 %6-%7 %8 <br> has been approved.</i></span></p></td></tr>';
        ApprovalBodyLbl += '<tr><td><p style="margin-top:0cm;"><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:gray;">Notes&nbsp;</span><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:black;"><strong>%9</strong></span></p></td>';
        ApprovalBodyLbl += '<td style="vertical-align: top;"><p style="margin-top:0cm;"><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:gray;">Due Date&nbsp;</span><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:black;"><strong>%7</strong></span></p></td></tr>';
        ApprovalBodyLbl += '<tr><td style="width: 240.7pt;vertical-align: top;"><p style="margin-top:0cm;"><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:gray;">Duration&nbsp;</span><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:black;"><strong>%10</strong></span></p></td>';
        ApprovalBodyLbl += '<td style="width: 240.7pt;"><p style="margin-top:0cm;"><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:gray;">Details&nbsp;</span><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:black;"><strong>Approved By %11 %12</strong></span></p></td></tr>';
        ApprovalBodyLbl += '<tr><td colspan="2" style="width: 481.4pt;border-bottom: 1pt solid rgb(165, 165, 165);"></td></tr></tbody></table>';

        Employee.SetRange("No.", OutOfOfficeRequest."Employee No.");
        if Employee.FindFirst() then begin
            EmployeeFirstName := Employee."First Name";
            EmployeeLastName := Employee."Last Name";
            EmployeeEmail := Employee."Company E-Mail";
        end;

        Clear(Employee);
        Employee.SetRange(UserID, UserSecurityId());
        if Employee.FindFirst() then begin
            ApproverFirstName := Employee."First Name";
            ApproverLastName := Employee."Last Name";
        end;

        Subject := 'OutOfOffice Request Approval';
        Body := StrSubstNo(ApprovalBodyLbl, EmployeeFirstName, EmployeeLastName, OutOfOfficeRequest."Employee No.", OutOfOfficeRequest."Reason Code", OutOfOfficeRequest."Start Date", OutOfOfficeRequest."Start Time", OutOfOfficeRequest."End Date", OutOfOfficeRequest."End Time", OutOfOfficeRequest.Note, OutOfOfficeRequest.Duration, ApproverFirstName, ApproverLastName);
        EmailMessage.Create(EmployeeEmail, Subject, Body, true);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
            Message(EmailSentLbl)
        else
            Error(EmailNotSentLbl);
    end;

    procedure DeclinedEmail(OutOfOfficeRequest: Record "Out of Office Request")
    var
        Employee: Record Employee;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Subject: Text;
        Body: Text;
        EmployeeFirstName: Text[30];
        EmployeeLastName: Text[30];
        EmployeeEmail: Text[80];
        ApproverFirstName: Text[30];
        ApproverLastName: Text[30];
        ApprovalBodyLbl: Text;
    begin
        ApprovalBodyLbl := '<p style="margin-top:0cm;"><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:gray;">Hello %1 %2,</span></p>';
        ApprovalBodyLbl += '<p style="margin-top:-0.5cm;"><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:gray;">You are registered to receive notifications related to ТОВ &quot;СМАРТ БІЗНЕС&quot;.</span><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:gray;"><br> <span>This is a message to notify you that:</span></span></p>';
        ApprovalBodyLbl += '<table><tbody><tr><td colspan="2" style="width: 481.4pt; border-top: 1pt solid rgb(165, 165, 165);"><p style="margin-top:0cm;"><span style="font-size:16px;font-family:"Calibri Light",sans-serif;color:#2E74B5;"><i>%1 %2 (%3) %4 %5 %6-%7 %8 <br> has been declined.</i></span></p></td></tr>';
        ApprovalBodyLbl += '<tr><td colspan="2"><p style="margin-top:0cm;"><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:gray;">Rejection Reason&nbsp;</span><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:black;"><strong>%13</strong></span></p></td></tr>';
        ApprovalBodyLbl += '<tr><td><p style="margin-top:0cm;"><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:gray;">Notes&nbsp;</span><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:black;"><strong>%9</strong></span></p></td>';
        ApprovalBodyLbl += '<td style="vertical-align: top;"><p style="margin-top:0cm;"><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:gray;">Due Date&nbsp;</span><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:black;"><strong>%7</strong></span></p></td></tr>';
        ApprovalBodyLbl += '<tr><td style="width: 240.7pt;vertical-align: top;"><p style="margin-top:0cm;"><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:gray;">Duration&nbsp;</span><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:black;"><strong>%10</strong></span></p></td>';
        ApprovalBodyLbl += '<td style="width: 240.7pt;"><p style="margin-top:0cm;"><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:gray;">Details&nbsp;</span><span style="font-size:13px;font-family:"Segoe UI",sans-serif;color:black;"><strong>Declined By %11 %12</strong></span></p></td></tr>';
        ApprovalBodyLbl += '<tr><td colspan="2" style="width: 481.4pt;border-bottom: 1pt solid rgb(165, 165, 165);"></td></tr></tbody></table>';

        Employee.SetRange("No.", OutOfOfficeRequest."Employee No.");
        if Employee.FindFirst() then begin
            EmployeeFirstName := Employee."First Name";
            EmployeeLastName := Employee."Last Name";
            EmployeeEmail := Employee."Company E-Mail";
        end;

        Clear(Employee);
        Employee.SetRange(UserID, UserSecurityId());
        if Employee.FindFirst() then begin
            ApproverFirstName := Employee."First Name";
            ApproverLastName := Employee."Last Name";
        end;

        Subject := 'OutOfOffice Request Declined';
        Body := StrSubstNo(ApprovalBodyLbl, EmployeeFirstName, EmployeeLastName, OutOfOfficeRequest."Employee No.", OutOfOfficeRequest."Reason Code", OutOfOfficeRequest."Start Date", OutOfOfficeRequest."Start Time", OutOfOfficeRequest."End Date", OutOfOfficeRequest."End Time", OutOfOfficeRequest.Note, OutOfOfficeRequest.Duration, ApproverFirstName, ApproverLastName, OutOfOfficeRequest."Rejection Reason");
        EmailMessage.Create(EmployeeEmail, Subject, Body, true);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
            Message(EmailSentLbl)
        else
            Error(EmailNotSentLbl);
    end;

    var
        EmailSentLbl: Label 'E-mail sent.';
        EmailNotSentLbl: Label 'Error with sending e-mail.';
}
