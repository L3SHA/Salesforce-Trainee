@isTest
public with sharing class AccountTriggerTest {
    private static AccountRestServiceMock mock = new AccountRestServiceMock();
    private static final String ACCOUNT_NAME = 'Test account';

    @TestSetup
    public static void setup(){
        Account account = new Account(Name = ACCOUNT_NAME);

        Test.setMock(HttpCalloutMock.class, new AccountRestServiceMock()); 

        Test.startTest();
        insert account;
        Test.stopTest();
    }

    @IsTest
    public static void testInsertWithNoExternalId() {
        Account account = new Account(Name = ACCOUNT_NAME);
            
        Test.setMock(HttpCalloutMock.class, mock); 

        Test.startTest();
        insert account;
        Test.stopTest();

        Account resultAccount = [SELECT External_Id__c FROM Account WHERE Id = :account.Id];

        System.assertEquals(AccountRestServiceMock.EXTERNAL_ID, resultAccount.External_Id__c);
    }

    @IsTest
    public static void testUpdateName() {
        Account account = [SELECT Name FROM Account LIMIT 1];
        account.Name = ACCOUNT_NAME + 'update';
        
        Test.setMock(HttpCalloutMock.class, mock); 

        Test.startTest();
        upsert account;
        Test.stopTest();

        Account resultAccount = [SELECT Name FROM Account WHERE Id = :account.Id];
        System.assertEquals(account.Name, resultAccount.Name);
    }

    @IsTest
    public static void testDeleteAccount() {
        Account account = [SELECT Name FROM Account LIMIT 1];
        
        Test.setMock(HttpCalloutMock.class, mock); 

        Test.startTest();
        delete account;
        Test.stopTest();

        List<Account> accounts = [SELECT Name FROM Account];
        System.assertEquals(0, accounts.size());
    }
}