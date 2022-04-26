@IsTest
private class ucl_Error_test {
   @IsTest
   static void testThatEmailWasSent(){
       

       Test.startTest();
       System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');
       List<Error__c> error_list = [SELECT Id from Error__c];
       System.assertEquals(0, error_list.size(), '0 errors should exist');
       
       ucl_Error.new_error('An exception ocurred during upsertion');
       
       error_list = [SELECT Id from Error__c];
       System.assertEquals(1, error_list.size(), '1 error should exist');
       
       System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');
       Test.stopTest();
   }
}