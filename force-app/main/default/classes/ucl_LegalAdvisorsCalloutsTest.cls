@isTest
private class ucl_LegalAdvisorsCalloutsTest {
    @isTest static  void testGetCallout() {

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetLegalAdvisorsResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpResponse result = ucl_LegalAdvisorsCallouts.makeGetCallout();
        
        System.assertNotEquals(null,result, 'The callout returned a null response.');

        System.assertEquals(200,result.getStatusCode(), 'The status code is not 200.');

        System.assertEquals('application/json;charset=UTF-8',
          result.getHeader('Content-Type'),
          'The content type value is not expected.');  
        
        Map<Legal_advisor__c, List<Client__c>> objects_created = ucl_LegalAdvisorProcessor.processJson(result.getBody());
        
        //Checking if it created the correct amount of Legal Advisors
        System.assertEquals(7, objects_created.keySet().size(), 'The script did not create 7 Advisors');

        Integer number_of_clients = 0;
        
        for(List<Client__c> c: objects_created.values()){
            number_of_clients += c.size();
        }
        
        //Checking if it created the correct amount of Legal Clients        
        System.assertEquals(20, number_of_clients, 'The script did not create 20 Clients');        
        
    }

}