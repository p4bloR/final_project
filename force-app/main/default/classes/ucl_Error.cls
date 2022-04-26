public with sharing class ucl_Error {
    
    public static void new_error(string input){
        
        //insert error object
        Error__c err = new Error__c(Error_Message__c = input);
        upsert err;
        
        //Send email to system admin
        String subject = 'Error ocurred on UCL app';
        String body = 'The following error ocurred' + input;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
		List<User> users = [SELECT Email FROM User WHERE Profile.Name = 'System Administrator'];
        List<String> toAddresses = new List<String>();

        for (User u : users){
            toAddresses.add(u.email);
        }
        mail.setToAddresses(toAddresses);
        
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        
        Messaging.sendEmail(
            new Messaging.SingleEmailMessage[] { mail });
        System.debug(body);

    }

}