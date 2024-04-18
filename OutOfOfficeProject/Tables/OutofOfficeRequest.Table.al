table 60001 "Out of Office Request"
{
    Caption = 'Out of Office Request';
    DataClassification = ToBeClassified;
    DataCaptionFields = "Employee No.", "Start Date", "Start Time", "Reason Code";

    fields
    {
        field(10; "No."; Code[10])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SalesSetup.Get();
                    NoSeriesMgt.TestManual(SalesSetup."OutOfOffice Request Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(20; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
        }
        field(30; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(40; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(50; "Start Time"; Time)
        {
            Caption = 'Start Time';
            InitValue = 090000T;
        }
        field(60; "End Time"; Time)
        {
            Caption = 'End Time';
            InitValue = 180000T;
        }
        field(65; "Duration"; Decimal)
        {
            Caption = 'Duration';
            InitValue = 8;
        }
        field(70; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            TableRelation = "Out of Office Reason";
            InitValue = 'Day-off';
            NotBlank = true;
        }
        field(80; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = "New","In process","Approved","Declined";
            OptionCaption = 'New,In process,Approved,Declined';
        }
        field(90; Note; Text[250])
        {
            Caption = 'Note';
        }
        field(100; "Rejection Reason"; Text[250])
        {
            Caption = 'Rejection Reason';
        }
        field(110; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Status; "Status")
        {
            Clustered = false;
        }
    }

    trigger OnInsert()
    var
    begin
        if "No." = '' then begin
            SalesSetup.Get();
            SalesSetup.TestField("OutOfOffice Request Nos.");
            NoSeriesMgt.InitSeries(SalesSetup."OutOfOffice Request Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
