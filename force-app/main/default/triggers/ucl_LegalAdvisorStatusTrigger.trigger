trigger ucl_LegalAdvisorStatusTrigger on Legal_advisor__c (before insert, before update) {
	// Trigger makes sure Advisors with status of Disabled 
    // can only be added to reflect a status change
    Map<String, Legal_advisor__c> disabled_advisors = new Map<String, Legal_advisor__c>();
    
    for (Legal_advisor__c l: Trigger.new){
        if (l.AccountStatus__c == 'Disabled'){
            disabled_advisors.put(l.AccountNumber__c, l);
        }
    }
    
    //These can be inserted
    List<Legal_advisor__c> previous_advisors = [
        SELECT Id, AccountNumber__c From Legal_advisor__c WHERE
    	AccountStatus__c = 'Enabled' AND AccountNumber__c IN :disabled_advisors.keySet()];

    // account numbers of already existing enabled legal advisors
    List<String> previous_enabled = new List<String>();
    
    for(Legal_advisor__c l : previous_advisors){
        previous_enabled.add(l.AccountNumber__c);
    }
	    
    for(Legal_advisor__c l : disabled_advisors.values()){
        if(!previous_enabled.contains(l.AccountNumber__c)){
            l.addError('You cannot enter legal advisors with status of "disabled" unless it is to update the status of an already existing legal advisor');
        } 
    }   
}