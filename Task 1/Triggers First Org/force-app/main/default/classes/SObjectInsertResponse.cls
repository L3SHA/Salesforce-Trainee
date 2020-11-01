public with sharing class SObjectInsertResponse {
    public String id;
    public Boolean success;

    public SObjectInsertResponse(String id, Boolean success) {
        this.id = id;
        this.success = success;
    }
}