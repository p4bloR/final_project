public with sharing class ucl_LegalAdvisorsNightly implements Schedulable {
    public void execute(SchedulableContext ctx) {
        synchCallout();
    }
    
    @future(callout=true)
    public static void synchCallout(){
        ucl_LegalAdvisorsCallouts.makeGetCallout();
        
    }

}