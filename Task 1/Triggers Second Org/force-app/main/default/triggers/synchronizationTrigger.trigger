trigger synchronizationTrigger on Account (after insert, after update) {
    if(Trigger.isInsert){
        for(Account account : Trigger.New) {
            if(account.External_Id__c == null) {
                RESTService.makeRequest(account.id);
            }
        }
    }

    if(Trigger.isUpdate){
        List<Id> idForUpdate = new List<Id>();
        for (Account account: Trigger.new) {
            Account oldAccount = Trigger.oldMap.get(account.Id);
            if((account.Name != oldAccount.Name || account.AccountNumber != oldAccount.AccountNumber || 
            account.Phone != oldAccount.Phone) && !account.FromApi__c) {
                RESTService.makeRequest(account.id);
            } 
        
            if(account.FromApi__c) {
                idForUpdate.add(account.Id);
            }
        }
        
        List<Account> accountForUpdate = new List<Account>();
        
        for (Account account : [SELECT Id, FromApi__c FROM Account WHERE Id IN :idForUpdate]) {
            account.FromApi__c = false;
            accountForUpdate.add(account);
        }
        
        update accountForUpdate;
    }
}