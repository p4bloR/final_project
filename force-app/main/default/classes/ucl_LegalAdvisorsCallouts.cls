public with sharing class ucl_LegalAdvisorsCallouts {
        
    public static HttpResponse makeGetCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://altimetrik-bootcamp.herokuapp.com/LegalAccounts');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.

        if(response.getStatusCode() == 200) {
            ucl_LegalAdvisorProcessor.processJson(response.getBody());
        }
        
        else{
            ucl_Error.new_error(String.valueOf(response.getStatusCode()));

        }
        return response;
    }
    

        
    
}