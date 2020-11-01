public with sharing class AccountPDFGenerator {
    @future(callout=true)
    public static void generatePdfs(List<Id> sobjectIds) {
        PageReference pageRef = Page.AccountPDF;
        List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :sobjectIds];

        for(Account a: accounts) {
            a.Add_PDF__c = false;
            createAndSavePdf(a.Id, pageRef);
        }

        update accounts;
    }

    private static void createAndSavePdf(Id accId, PageReference pdfPage) {
        pdfPage.getParameters().put('id', accId);

        Attachment pdf = new Attachment();
        pdf.IsPrivate = false;
        pdf.ParentId = accId;
        Datetime generationTime = Datetime.now();
        pdf.Name = 'Report_' + generationTime.format('d.M.Y h:mm a') + '.pdf';

        Blob docBody;
        try {
            docBody = pdfPage.getContentAsPdf(); 
        } catch (Exception e) {
            docBody = Blob.valueOf('Error occurred while pdf generation');
        }

        pdf.body = docBody;

        insert pdf;

    }
}