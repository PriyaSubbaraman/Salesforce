public class BillingCalloutService {
    //Implement business and callout logic methods here
   
    public static void callBillingService(String projectRef, Decimal Billable_Amount, String Username, String Password) {
        //List<Project__c> projects = [SELECT Billable_Amount__c,End_Date__c,Id,Name,Opportunity__c,ProjectRef__c,Start_Date__c,Status__c FROM Project__c WHERE ProjectRef__c = :ProjectRef];
        Project__c project = [SELECT Status__c, ProjectRef__c FROM Project__c WHERE ProjectRef__c = :projectRef LIMIT 1];
        
        if (project.Status__c == 'Billable') {
            callWebserviceCallout(projectRef, Billable_Amount, Username, Password);
        }
    }
    
    // implement future method here
    @future(callout=true)
    public static void callWebserviceCallout(String projectRef, Decimal Billable_Amount, String Username, String Password) {
        BillingServiceProxy.project projectClass = new BillingServiceProxy.project();
        
        projectClass.username = Username;
        projectClass.password = Password;
        projectClass.projectid = projectRef;
        projectClass.billAmount = Billable_Amount;
        
        BillingServiceProxy.InvoicesPortSoap11 invoicesClass = new BillingServiceProxy.InvoicesPortSoap11();
        String status = invoicesClass.billProject(projectClass);
        System.debug('status = ' + status);
        
        if (status == 'OK') {
        	Project__c project = [SELECT Status__c, ProjectRef__c FROM Project__c WHERE ProjectRef__c = :projectRef LIMIT 1];
			project.Status__c = 'Billed';
        	update project;
        }

    }
        
}