public with sharing class RESTService {
    
    @future(callout = true)
    public static void makeRequest(Id id) {

        String SEND_RECORD_ENDPOINT = 'callout:Second_Org_Creds/services/data/v49.0/sobjects/Account/';

        Account account = [SELECT Name, AccountNumber, Phone, BillingAddress, ShippingAddress FROM Account WHERE Id = :id];
        Account newAccount = new Account(
            Name = account.Name,
            AccountNumber = account.AccountNumber,
            Phone = account.Phone
        );

        String finalEndPoint = SEND_RECORD_ENDPOINT + 'External_Id__c/' + id + '?_HttpMethod=PATCH';

        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        request.setEndpoint(finalEndPoint); 
        request.setMethod('POST');  
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(newAccount));
        HttpResponse response = http.send(request);

        Map <String, Object> resultObject = (Map <String, Object>)JSON.deserializeUntyped(response.getBody());
        String recordId = (String)resultObject.get('id');
        account.External_Id__c = recordId;
        update account;
    }
}