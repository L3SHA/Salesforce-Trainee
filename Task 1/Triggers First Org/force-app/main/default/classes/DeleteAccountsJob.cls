public with sharing class DeleteAccountsJob implements Queueable, Database.AllowsCallouts{
    private List<Id> externalIds;
    
    public DeleteAccountsJob(List<Id> externalIds) {
        this.externalIds = externalIds;
    }

    public void execute(QueueableContext context){
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
}
