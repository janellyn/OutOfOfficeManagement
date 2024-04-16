report 60000 "Out of Office Day Count"
{
    RDLCLayout = './Reports/OutofOfficeDayCount.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'Out of Office Day Count';

    dataset
    {
        dataitem(OutofOfficeRequest; "Out of Office Request")
        {
            RequestFilterFields = "Employee No.";
            dataitem(Employee; Employee)
            {
                DataItemLink = "No." = field("Employee No.");
                column(Employee_No; "No.")
                {
                }
                column(First_Name; "First Name")
                {
                }
                column(Last_Name; "Last Name")
                {
                }
            }
            column(StartingDate; Format(StartingDate, 0, 0))
            {
            }
            column(EndingDate; Format(EndingDate, 0, 0))
            {
            }
            column(Reason; "Reason Code")
            {
            }
            column(Durations; Duration)
            {
            }

            trigger OnPreDataItem()
            begin
                SetRange("Start Date", StartingDate, EndingDate);
                SetRange("End Date", StartingDate, EndingDate);
            end;

        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate; StartingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the date from which the report processes information.';
                    }
                    field(EndDate; EndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the date to which the report processes information.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    var
        StartingDate: Date;
        EndingDate: Date;
}