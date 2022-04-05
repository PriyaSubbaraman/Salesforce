@isTest
private class MaintenanceRequestHelperTest {
    private static Case nc;
    private static Vehicle__c v;
    private static Product2 myEq1;
    
    // implement scheduled code here
    @testSetup static void createTestData() {
		
		// vehicle row        
        v = new Vehicle__c(
        	Name='Honda CRV'
        );
        insert v;
        
        // Equipment row
        myEq1 = new Product2();
        myEq1.Replacement_Part__c = True;
        myEq1.Name = 'Generator 1000 kW';
        myEq1.Maintenance_Cycle__c = 40;
        myEq1.Lifespan_Months__c = 120;
        myEq1.cost__c = 5000;
        myEq1.Warehouse_SKU__c = '100003';
        myEq1.Current_Inventory__c = 5;
        myEq1.ProductCode = '55d66226726b611100aaf741';
        insert myEq1;

        Product2 myEq2 = new Product2();
        myEq2.Replacement_Part__c = True;
        myEq2.Name = 'Fuse 20B';
        myEq2.Maintenance_Cycle__c = 30;
        //myEq2.Lifespan_Months__c = 0;
        myEq2.cost__c = 1000;
        //myEq2.Warehouse_SKU__c = '100003';
        //myEq2.Current_Inventory__c = 5;
        //myEq2.ProductCode = '55d66226726b611100aaf741';
        insert myEq2;

        Product2 myEq3 = new Product2();
        myEq3.Replacement_Part__c = True;
        myEq3.Name = 'Breaker 13C';
        myEq3.Maintenance_Cycle__c = 15;
        //myEq2.Lifespan_Months__c = 0;
        myEq3.cost__c = 100;
        //myEq2.Warehouse_SKU__c = '100003';
        //myEq2.Current_Inventory__c = 5;
        //myEq2.ProductCode = '55d66226726b611100aaf741';
        insert myEq3;
        
        nc = new Case(
                	Status = 'New',
                	Subject = 'Testing 1',
                	Type = 'Repair',
                	Vehicle__c = v.Id,
                    Equipment__c = myEq1.Id,
                	Origin = 'Web',
                	Date_Reported__c = Date.today()
        );
        
        insert nc;
        System.debug('nc = ' + nc);
        
       	Equipment_Maintenance_Item__c myEqItem1 = new Equipment_Maintenance_Item__c();
        myEqItem1.Equipment__c = myEq1.Id;
        myEqItem1.Maintenance_Request__c = nc.Id;
        insert myEqItem1;
        
        Equipment_Maintenance_Item__c myEqItem2 = new Equipment_Maintenance_Item__c();
        myEqItem2.Equipment__c = myEq2.Id;
        myEqItem2.Maintenance_Request__c = nc.Id;
        insert myEqItem2;
        
        Equipment_Maintenance_Item__c myEqItem3 = new Equipment_Maintenance_Item__c();
        myEqItem3.Equipment__c = myEq3.Id;
        myEqItem3.Maintenance_Request__c = nc.Id;
        insert myEqItem3;
        
		//nc.Status = 'Closed';
        //update nc;
    }
    
    @isTest
    static void testMethod1() {
        
        Case nc2 = [SELECT Id, Status, Subject, Origin, Date_Reported__c, Date_Due__c, Type, Vehicle__c, Equipment__c FROM Case LIMIT 1];
        System.debug('nc2 = ' + nc2);

        nc2.Status = 'Closed';
        update nc2;
        
        System.assertEquals(2, [SELECT COUNT() FROM Case], 'The count is not two');

        Case nc1 = [SELECT id, Status, Date_Due__c, Type, Vehicle__c, Equipment__c FROM Case WHERE ParentId=:nc2.Id];
        System.debug('nc1 = ' + nc1);
        
        System.assertEquals(1, [SELECT COUNT() FROM Case WHERE ParentId = :nc2.Id], 'A new case pointing to the Parent has not been created');
        
        System.assertEquals('New', nc1.Status, 'Status of the new Maintenance Request is NEW');
        System.assertEquals('Routine Maintenance', nc1.Type, 'Type of the new Maintenance Request is not Routine Maintenance');
        System.assertEquals(nc2.Vehicle__c, nc1.Vehicle__c, 'Vehicle of the new Maintenance Request does not match the Parent Vehicle');
        System.assertEquals(nc2.Equipment__c, nc1.Equipment__c, 'Equipment of the new Maintenance Request does not match the Parent Vehicle');
        System.assertEquals(nc1.Date_Due__c, Date.today()+15, 'Both the dates do not match');
        
        System.assertEquals(3, [SELECT COUNT() FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c = :nc1.Id], 'A new Maintenance Request with 3 Maintenance Request Items has not been created');

    }
    
    
}