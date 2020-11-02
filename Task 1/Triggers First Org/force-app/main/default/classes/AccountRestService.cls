public with sharing class AccountRestService {
    
    public static void insertAccountsToRemote(List<Id> accsToInsert) {
        InsertAccountsJob insertJob = new InsertAccountsJob(accsToInsert);
        ID jobID = System.enqueueJob(insertJob);    
    }

    public static void updateAccountsInRemote(List<Id> accsToUpdate) {    
        UpdateAccountsJob updateJob = new UpdateAccountsJob(accsToUpdate);
        ID jobID = System.enqueueJob(updateJob);  
    }

    public static void deleteAccountsFromRemote(List<Id> externalIds) {
        DeleteAccountsJob deleteJob = new DeleteAccountsJob(externalIds);
        ID jobID = System.enqueueJob(deleteJob); 
    }

}