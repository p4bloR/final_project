trigger ucl_ClientIdTrigger on Client__c (before insert) {
    for(Client__c c: Trigger.new) {

        if(c.Client_Id__c == 'null' || String.isBlank(c.Client_Id__c)){
            c.Client_Id__c = String.valueOf(c.AccountNumber__c) +':'+ c.ClientNumber__c;
        }
    }
}