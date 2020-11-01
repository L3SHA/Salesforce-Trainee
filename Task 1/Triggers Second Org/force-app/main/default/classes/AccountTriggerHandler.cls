public class AccountTriggerHandler implements TriggerInterface {
    
    private static final List<String> fieldsToCompare = new String[]{
        'Name', 'AccountNumber', 'Phone', 'BillingStreet',
        'BillingCity', 'BillingCountry', 'BillingState', 'BillingPostalCode',
        'BillingLatitude', 'BillingLongitude', 'ShippingStreet', 'ShippingCity', 'ShippingCountry', 
        'ShippingState', 'ShippingPostalCode', 'ShippingLatitude', 
        'ShippingLongitude'
    };

    public void afterInsert(List<SObject> newRecordsList){
        List<Id> accsToInsert = new List<Id>();

        for(Account a: (List<Account>) newRecordsList) {
            if(a.External_Id__c == null) {
                accsToInsert.add(a.Id);
            }
        }

        if(!accsToInsert.isEmpty()) {
            AccountRestService.insertAccountsToRemote(accsToInsert);
        }
    }

    public void afterUpdate(List<SObject> newRecordsList, List<SObject> oldRecordsList){
        Map<Id, Account> newMap = new Map<Id, Account>((List<Account>) newRecordsList);
        Map<Id, Account> oldMap = new Map<Id, Account>((List<Account>) oldRecordsList);
        List<Id> accsForRemoteUpdate = new List<Id>();

        Boolean isExternal = String.valueOf(System.URL.getCurrentRequestUrl().getPath()).contains('composite');

        for(Account newAcc: (List<Account>)newRecordsList) {
            Account oldAcc = oldMap.get(newAcc.Id);

            if(!isExternal) {
                for(String field : fieldsToCompare) {
                    if((String) newAcc.get(field) != (String) oldAcc.get(field)) {
                        accsForRemoteUpdate.add(newAcc.Id);
                        break;
                    }
                }
            }
        }

        if(!accsForRemoteUpdate.isEmpty()) {
            AccountRestService.updateAccountsInRemote(accsForRemoteUpdate);
        }
    }
    
    public void beforeUpdate(List<SObject> newRecordsList, List<SObject> oldRecordsList){}

    public void beforeInsert(List<SObject> newRecordsList){}

    public void beforeDelete(List<SObject> oldRecordsList){
        Boolean isExternal = String.valueOf(System.URL.getCurrentRequestUrl().getPath()).contains('composite');

        if(!isExternal) {
            List<Id> externalIds = new List<Id>();
            for(Account a: (List<Account>) oldRecordsList) {
                externalIds.add(a.External_Id__c);
                
            }

            if(!externalIds.isEmpty()) {
                AccountRestService.deleteAccountsFromRemote(externalIds);
            }
        }
    }

    public void afterDelete(List<SObject> oldRecordsList){}

    public void afterUnDelete(List<SObject> newRecordsList){}
    
}