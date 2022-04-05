@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    
	@isTest	// testing future callout method
	static void testPostCallout1() {
    	// Set mock callout class 
    	Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
    	// This causes a fake response to be sent
    	// from the class that implements HttpCalloutMock. 
    	//HttpResponse response = WarehouseCalloutService.runWarehouseEquipmentSync();
    	Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
        System.assertEquals(2, [SELECT COUNT() FROM Product2], '2 Products were not created');
    	// Verify that the response received contains fake values
    	//String contentType = response.getHeader('Content-Type');
    	//System.assert(contentType == 'application/json');
    	//String actualValue = response.getBody();
    	//System.debug(response.getBody());
    	//String expectedValue = '{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}';
    	//System.assertEquals(expectedValue, actualValue);
    	//System.assertEquals(200, response.getStatusCode());
    }
    
    
    @isTest	// testing Queueable 
	static void testPostCallout2() {
    	Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
    	Test.startTest();
        System.enqueueJob(new WarehouseCalloutService());
        Test.stopTest();
        System.assertEquals(2, [SELECT COUNT() FROM Product2], '2 Products were not created');
    }
	
}