public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts{

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    //@future (callout=true)
    public static void runWarehouseEquipmentSync() {
		System.debug('within runWarehouseEquipment Sync');
        Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint(WAREHOUSE_URL);
		request.setMethod('GET');
		HttpResponse response = http.send(request);
        
		// If the request is successful, parse the JSON response.
		if(response.getStatusCode() == 200) {
    		// Deserialize the JSON string into collections of primitive data types.
    		//Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
    		List<Object> jsonResponse = (List<Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('jsonResponse = ' + jsonResponse);
            
    		// Cast the values in the 'animals' key as a list
    		List<Product2> warehouseEq =  new List<Product2>();
            
    		for(Object eq : jsonResponse) {
        		Map<String,Object> mapJson = (Map<String,Object>)eq;
                Product2 myEq = new Product2();
                myEq.Replacement_Part__c = (Boolean)mapJson.get('replacement');
                myEq.Name = (String)mapJson.get('name');
                myEq.Maintenance_Cycle__c = (Integer)mapJson.get('maintenanceperiod');
                myEq.Lifespan_Months__c = (Integer)mapJson.get('lifespan');
                myEq.cost__c = (Integer)mapJson.get('cost');
                myEq.Warehouse_SKU__c = (String)mapJson.get('sku');
                myEq.Current_Inventory__c = (Double)mapJson.get('quantity');
                myEq.ProductCode = (String)mapJson.get('_id');
                warehouseEq.add(myEq);
    		}
            
            if (warehouseEq.size() > 0) {
                upsert warehouseEq;
                System.debug('Your equipment was synced with the Warehouse one');
            }
		} // if
    } 
    
    public static void execute (QueueableContext context) {
        System.debug('within the execute method of WarehouseCalloutService class');
        runWarehouseEquipmentSync();
    }
}	// WarehouseCalloutService