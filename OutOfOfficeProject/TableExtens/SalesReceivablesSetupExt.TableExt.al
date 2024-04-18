namespace OutOfOfficeProject.OutOfOfficeProject;

using Microsoft.Foundation.NoSeries;
using Microsoft.Sales.Setup;

tableextension 60002 SalesReceivablesSetupExt extends "Sales & Receivables Setup"
{
    fields
    {
        field(50200; "OutOfOffice Request Nos."; Code[20])
        {
            Caption = 'Out of Office Request Nos.';
            TableRelation = "No. Series";
        }
    }
}