public with sharing class ucl_getInvokerController {
    // false to avoid too many DML error
    @AuraEnabled(cacheable=false)
    public static boolean invoke_get_call(Id accountId) {
        
        try {
            HttpResponse response = ucl_LegalAdvisorsCallouts.makeGetCallout();
            if(response.getStatusCode() != 200) {
                throw new applicationException('Callout failed');
            }            
            return true;
        }
        catch (Exception e) {
            ucl_Error.new_error(e.getMessage());
            return false;
        }
    }
}