@RestResource(urlMapping='/project/*')
global with sharing class ProjectRESTService {
    //Implement service logic here
    @HttpPost
    global static string postProjectData(String ProjectRef, String ProjectName, String OpportunityId,Date StartDate, Date EndDate, Double Amount, String Status) {
        
        String var_status = '';
        
        List<Project__c> projects = [SELECT Billable_Amount__c,End_Date__c,Id,Name,Opportunity__c,ProjectRef__c,Start_Date__c,Status__c FROM Project__c WHERE ProjectRef__c = :ProjectRef];
      	Project__c project = new Project__c();
        
        if(projects.size() > 0)
        	project = projects.get(0);
        else
            // as when I try to overwrite Opportunity__c for an existing project I get this error
            // ExecutionException: Field is not writeable: 
            project.Opportunity__c = OpportunityId;
        
        Savepoint sp = Database.setSavepoint();
        
        try{
            project.Billable_Amount__c = Amount;
          	project.End_Date__c = EndDate;
          	project.Name = ProjectName;
          	//project.Opportunity__c = OpportunityId;
          	project.ProjectRef__c = ProjectRef;
          	project.Start_Date__c = StartDate;
          	project.Status__c = Status;
            
          	upsert project;
        
        	List<Opportunity> oppList = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id=:OpportunityId];
        	if (oppList.size() > 0) {
            	oppList[0].DeliveryInstallationStatus__c='In progress';
        	}
            
        	update oppList;
            var_status = 'OK';
        }
        catch (Exception e) {
            Database.rollback(sp);
            var_status = e.getMessage();
        }
        return var_status;        
    }
}