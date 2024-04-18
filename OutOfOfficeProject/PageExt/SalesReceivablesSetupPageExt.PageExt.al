namespace OutOfOfficeProject.OutOfOfficeProject;

using Microsoft.Sales.Setup;

pageextension 60001 SalesReceivablesSetupPageExt extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Customer Nos.")
        {
            field("OutOfOffice Request Nos."; Rec."OutOfOffice Request Nos.")
            {
                Caption = 'Out of Office Request Nos.';
                ApplicationArea = All;
                ToolTip = 'Specifies number of series Out of Office Request Nos.';
            }
        }
    }
}