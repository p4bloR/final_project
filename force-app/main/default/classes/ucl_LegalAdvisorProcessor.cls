public with sharing class ucl_LegalAdvisorProcessor {
    
    public static Map<Legal_advisor__c, List<Client__c>> processJson(string json_input){
        
        List<Map<String, Object>> objects = ucl_LegalAdvisorProcessor.parseJson(json_input);
        Map<String, Legal_advisor__c> legal_advisor_map = new Map<String, Legal_advisor__c>();
        Map<String, Client__c> client_list = new Map<String, Client__c>();
        
        //First let's upsert the Legal Advisors so they have ids
        for(Map<String, Object> obj: objects) {
            
            Legal_advisor__c a = new Legal_advisor__c(
                AccountNumber__c = String.valueOf(obj.get('AccountNumber')),
            	AccountName__c = String.valueOf(obj.get('AccountName')),
                Name = String.valueOf(obj.get('AccountName')),
                AccountStatus__c = String.valueOf(obj.get('AccountStatus')),
                AsOfDate__c = date.parse(fixDateFormat(String.valueOf(obj.get('AsOfDate'))))
                );
                
            legal_advisor_map.put(a.AccountNumber__c, a);
            
        }
        
		Database.upsert(legal_advisor_map.values(), Legal_advisor__c.Fields.AccountNumber__c, false);
        
        // Now let's upsert the clients
        for(Map<String, Object> obj: objects) {
            List<Object> clients = (List<Object>) obj.get('Clients');
                        
            for (Object c : clients){
                Map<String,Object> client_data = (Map<String,Object>)c;
                
                Legal_advisor__c leg_adv = legal_advisor_map.get(String.valueOf(obj.get('AccountNumber')));
                
                string first_name = String.valueOf(client_data.get('FirstName'));
                string last_name = String.valueOf(client_data.get('LastName'));
                string ClientNumber = String.valueOf(client_data.get('ClientNumber'));
                
                Client__c client = new Client__c(
                    AccountNumber__c = leg_adv.Id,
                    Deleteable__c = true,
                    Name = first_name + ' ' + last_name,
                    FirstName__c = String.valueOf(client_data.get('FirstName')),
                    LastName__c = String.valueOf(client_data.get('LastName')),
                    Email__c = String.valueOf(client_data.get('Email')),
                    Phone__c = String.valueOf(client_data.get('Phone')),
                    Address__c = String.valueOf(client_data.get('Address')),
                    ClientNumber__c = ClientNumber,
                    Client_Id__c = String.valueOf(leg_adv.Id) +':'+ ClientNumber
                );
                
                client_list.put(client.Client_Id__c, client);
                
        	}
        }
        List<Client__c> SobjLst = [SELECT id FROM Client__c WHERE Deleteable__c = TRUE AND Client_Id__c NOT IN :client_list.keySet()];
        delete SobjLst;        
        
		Database.upsert(client_list.values(), Client__c.Fields.Client_Id__c, false);
        
        //This return serves only testing purposes
        //That's why it's so disconnected from the rest of the code
        //and why it repeats work
        Map<Legal_advisor__c, List<Client__c>> output = new Map<Legal_advisor__c, List<Client__c>>();
        
        for (Legal_advisor__c l : legal_advisor_map.values()){
            
            List<Client__c> clients_sublist = new List<Client__c>();
            
            for (Client__c c : client_list.values()){
                boolean cond_1 = String.valueOf(l.Id) == String.valueOf(c.AccountNumber__c);
                boolean cond_2 = String.valueOf(l.Id) != null && String.valueOf(c.AccountNumber__c) != null;
                if(cond_1 && cond_2){
                    clients_sublist.add(c);
                }
            output.put(l, clients_sublist);
                
            }            
        }
        
        return output;
    }
    
    public static List<Map<String, Object>> parseJson(String response_body){
        List<Object> object_list = (List<Object>) JSON.deserializeUntyped(response_body);
        List<Map<String, Object>> results = new List<Map<String, Object>>();
        for(Object o: object_list) {
            
            Map<String, Object> item = (Map<String,Object>)o;
            results.add(item);
        }
        
        return results;
    }    
    
    public static string fixDateFormat(String input_date){
        //converts from mm/dd/yyyy to dd/mm/yyyy using regular expressions
        String output_date = input_date.replaceAll('([0-9]{1,2})/([0-9]{1,2})/([0-9]{4})', '$2/$1/$3');
        return output_date;
    }

}