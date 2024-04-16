table 60000 "Out of Office Reason"
{
    Caption = 'Out of Office Reason';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
