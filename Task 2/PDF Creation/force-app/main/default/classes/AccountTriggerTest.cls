@isTest
public with sharing class AccountTriggerTest {
    private static final String ACCOUNT_NAME ='TestAccount';

    @TestSetup
    public static void setup(){
        Account a = new Account(Name = ACCOUNT_NAME, Add_PDF__c = false);
        insert a;
    }

    @isTest
    public static void testGeneratePdf() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        acc.Add_PDF__c = true;
        
        Test.startTest();
        update acc;
        Test.stopTest();

        List<Attachment> attachments =  [SELECT Body FROM Attachment WHERE ParentId = :acc.id]; 
        System.assertEquals(1, attachments.size());

    }

}