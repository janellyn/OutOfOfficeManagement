namespace OutOfOfficeProject.OutOfOfficeProject;

using Microsoft.HumanResources.Employee;

pageextension 60002 EmployeesExt extends "Employee Card"
{
    layout
    {
        addafter("Last Name")
        {
            field(UserId; Rec.UserId)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the User Id.';
            }
        }
    }
}