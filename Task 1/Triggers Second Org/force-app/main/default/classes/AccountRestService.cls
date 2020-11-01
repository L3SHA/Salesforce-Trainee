public with sharing class AccountRestService {
    

    @future(callout=true)
    public static void insertAccountsToRemote(List<Id> accsToInsert) {
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

    @future(callout=true)
    public static void updateAccountsInRemote(List<Id> accsToUpdate) {    
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

    @future(callout=true)
    public static void deleteAccountsFromRemote(List<Id> externalIds) {
        String endPoint = 'callout:First_Credentials/services/data/v49.0/composite/sobjects?ids=';

        for(String id: externalIds) {
            endPoint = endpoint + id + ',';
        }

        endPoint = endPoint.removeEnd(',');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('DELETE');

        HTTPResponse response = http.send(request);
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