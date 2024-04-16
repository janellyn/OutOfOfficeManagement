namespace OutOfOfficeProject.OutOfOfficeProject;
using Microsoft.Foundation.Attachment;

codeunit 60001 DocumentAttachment
{
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        PaymentTerms: Record "Out of Office Request";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"Out of Office Request":
                begin
                    RecRef.Open(DATABASE::"Out of Office Request");
                    if PaymentTerms.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(PaymentTerms);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Out of Office Request":
                begin
                    FieldRef := RecRef.Field(10);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Out of Office Request":
                begin
                    FieldRef := RecRef.Field(10);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;
}