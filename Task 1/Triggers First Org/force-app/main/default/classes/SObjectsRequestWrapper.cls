public with sharing class SObjectsRequestWrapper {

    public boolean allOrNone;
    public List<SObject> records;

    public SObjectsRequestWrapper(boolean allOrNone, List<SObject> records) {
        this.allOrNone = allOrNone;
        this.records = records;
    }
}