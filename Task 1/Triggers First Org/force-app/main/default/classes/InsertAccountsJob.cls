public with sharing class InsertAccountsJob implements Queueable, Database.AllowsCallouts {
    private List<Id> accsToInsert;

    public InsertAccountsJob(List<Id> accsToInsert){
        this.accsToInsert = accsToInsert;
    }

    public void execute(QueueableContext context){

        List<Account> accounts = getAccountsByIds(accsToInsert);
        List<Account> cloned = cloneAccounts(accounts);

        SObjectsRequestWrapper wrapper = new SObjectsRequestWrapper(true, cloned);

        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        request.setEndpoint('callout:First_Org_Creds/services/data/v49.0/composite/sobjects');  
        request.setMethod('POST');    
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');

        request.setBody(JSON.serialize(wrapper)); 
        
        HttpResponse response = http.send(request);
        System.debug(response + '  ' + response.getBody());
    
        List<SObjectInsertResponse> resultItems = (List<SObjectInsertResponse>) JSON.deserialize(
            response.getBody(), List<SObjectInsertResponse>.class);

        
        for(Integer i = 0; i < resultItems.size(); i++) {
            accounts[i].External_Id__c = (String)resultItems[i].id;
        }
        
        upsert accounts;

    }

    private static List<Account> getAccountsByIds(List<Id> accIds) {
        return [SELECT Name, Phone, BillingStreet, 
            BillingCity, BillingCountry, BillingState, 
            BillingPostalCode, BillingLatitude, BillingLongitude, 
            ShippingStreet, ShippingCity, ShippingCountry, 
            ShippingState, ShippingPostalCode, ShippingLatitude, 
            ShippingLongitude, External_Id__c
            FROM Account WHERE Id = :accIds];
    }

    private static List<Account> cloneAccounts(List<Account> accs) {
        List<Account> clonedList = new List<Account>();

        for(Account a: accs) {
            Account clonedAcc = a.clone(false, true, true, true);
            clonedAcc.Id = a.External_Id__c;
            clonedAcc.External_Id__c = a.Id;

            clonedList.add(clonedAcc);
        }

        return clonedList;
    }
}
