public with sharing class UpdateAccountsJob implements Queueable, Database.AllowsCallouts {
    private List<Id> accsToUpdate;
    
    public UpdateAccountsJob(List<Id> accsToUpdate) {
        this.accsToUpdate = accsToUpdate;
    }

    public void execute(QueueableContext context){
        List<Account> accounts = getAccountsByIds(accsToUpdate);
        List<Account> cloned = cloneAccounts(accounts);
        
        SObjectsRequestWrapper wrapper = new SObjectsRequestWrapper(true, cloned);
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        request.setEndpoint('callout:First_Credentials/services/data/v49.0/composite/sobjects');  
        request.setMethod('PATCH');    
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(wrapper)); 

        system.debug(request.getBody());
        HttpResponse response = http.send(request);
        system.debug(response);
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
