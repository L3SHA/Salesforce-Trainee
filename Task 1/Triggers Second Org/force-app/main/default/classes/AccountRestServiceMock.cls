@isTest
global class AccountRestServiceMock implements HttpCalloutMock {
    global static String EXTERNAL_ID = '0099c00000TGfRQBC2';

    global HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{ "id" : "' + EXTERNAL_ID + '",'+
            ' "success" : true,' +
            ' "errors" : [ ] }]');
        response.setStatusCode(200);

        return response; 
    }
}