namespace OutOfOfficeProject.OutOfOfficeProject;

using Microsoft.HumanResources.Employee;
using System.Security.AccessControl;

tableextension 60001 EmployeeExt extends Employee
{
    fields
    {
        field(60000; "UserId"; Guid)
        {
            Caption = 'User Id';
            DataClassification = ToBeClassified;
            TableRelation = User;
        }
    }
}
