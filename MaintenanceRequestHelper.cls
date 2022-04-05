public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> updWorkOrders, Map<Id,Case> nonUpdCaseMap ) {
        // TODO: Complete the method to update workorders
        Set<Id> validIds = new Set<Id>();
        For (Case c : updWorkOrders){
            if (c.Status=='Closed' && nonUpdCaseMap.get(c.Id).Status != 'Closed') {
                if (c.Type == 'Repair' || c.Type == 'Routine Maintenance') {
                    validIds.add(c.Id);
                }
            }
        }
        
        if (!validIds.isEmpty()) {
            System.debug('within if validIds not isEmpty');
        	List<Case> newCases = new List<Case>();
            Map<Id,Case> closedCasesM = new Map<Id,Case>([SELECT Id, Vehicle__c,Equipment__c, Equipment__r.Maintenance_Cycle__c, (SELECT Id, Equipment__c, Quantity__c FROM Equipment_Maintenance_Items__r) FROM Case WHERE Id IN :validIds]);
        	Map<Id,Decimal> maintenanceCycles = new Map<Id,Decimal>();
        
        	AggregateResult[] results = [SELECT Maintenance_Request__c, MIN(Equipment__r.Maintenance_Cycle__c) cycle
                                     	FROM Equipment_Maintenance_Item__c
                                    	WHERE Maintenance_Request__c in :validIds
                                    	GROUP BY Maintenance_Request__c];
            
            System.debug('number of rows in closedCasesM = ' + closedCasesM.size());
            
            for (AggregateResult ar : results) {
                maintenanceCycles.put((Id)ar.get('Maintenance_Request__c'),(Decimal)ar.get('cycle'));
            }
        
            integer i = 0;
        	for (Case cc : closedCasesM.values()) {
                i = i + 1;
                System.debug('within the loop ' + i);
            	Case nc = new Case(
                	ParentId = cc.Id,
                	Status = 'New',
                	Subject = 'Routine Maintenance',
                	Type = 'Routine Maintenance',
                	Vehicle__c = cc.Vehicle__c,
                    Equipment__c = cc.Equipment__c,
                	Origin = 'Web',
                	Date_Reported__c = Date.today()
            	);
        	
            
                if (maintenanceCycles.containsKey(cc.Id)){
            		nc.Date_Due__c = Date.today().addDays((Integer)maintenanceCycles.get(cc.Id));
                }
                //else {
                //    nc.Date_Due__c = Date.today();
                //}
                
                newCases.add(nc);
            } // for
            
            insert newCases;
            System.debug('newCases = ' + newCases);
            
            List<Equipment_Maintenance_Item__c> clonedWPs = new List<Equipment_Maintenance_Item__c>();
            for (Case nc : newCases) {
                for (Equipment_Maintenance_Item__c wp : closedCasesM.get(nc.ParentId).Equipment_Maintenance_Items__r){
                    Equipment_Maintenance_Item__c wpClone = wp.clone();
                    wpClone.Maintenance_Request__c = nc.Id;
                    clonedWPs.add(wpClone);
                }
            }
            insert clonedWPs;
        } //if (!validIds.isEmpty())
        
        
    } 
}