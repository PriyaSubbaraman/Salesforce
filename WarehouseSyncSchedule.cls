/*
public with sharing class WarehouseSyncSchedule implements Schedulable {
    public void execute(SchedulableContext ctx) {
        System.enqueueJob(new WarehouseCalloutService());
    }
}
*/

global class WarehouseSyncSchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        
        //WarehouseCalloutService.runWarehouseEquipmentSync();
        System.enqueueJob(new WarehouseCalloutService());
    }
}