@isTest
private class ProjectCalloutServiceTest {
    // implement your mock callout test here
            
    @isTest	
	static void testPostCalloutSuccess() {
        List<Opportunity> oppsToInsert = new List<Opportunity>();
        
        Account acct = new Account();
        acct.Name='test Account';
        insert acct;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Opp1';
        opp1.Type='New Customer';
        opp1.AccountId = acct.id;
        opp1.amount=500;
        opp1.CloseDate = date.today();
        opp1.StageName = 'Prospecting';
        oppsToInsert.add(opp1);
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Opp2';
        opp2.Type='New Customer';
        opp2.AccountId = acct.id;
        opp2.amount=2500;
        opp2.CloseDate = date.today().addDays(-3);
        opp2.StageName = 'Prospecting';
        oppsToInsert.add(opp2);
        
        insert oppsToInsert;
        
        ServiceTokens__c st = new ServiceTokens__c();
        st.Name = 'ProjectServiceToken';
        st.Token__c = 'thisistesttoken';
        insert st;
        
        List<Id> oppIds = new List<Id>();
        oppIds.add(oppsToInsert[0].Id);
        
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock()); 
        Test.startTest();
        ProjectCalloutService.postOpportunityToPMS(oppIds);
        Test.stopTest();
        
        List<Opportunity> oppList = [SELECT StageName FROM Opportunity WHERE Id=:oppsToInsert[0].Id];
        System.assertEquals('Submitted Project',oppList[0].StageName);
    }
    
    @isTest	
	static void testPostCalloutFailure() {
List<Opportunity> oppsToInsert = new List<Opportunity>();
        
        Account acct = new Account();
        acct.Name='test Account';
        insert acct;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Opp1';
        opp1.Type='New Customer';
        opp1.AccountId = acct.id;
        opp1.amount=500;
        opp1.CloseDate = date.today();
        opp1.StageName = 'Prospecting';
        oppsToInsert.add(opp1);
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Opp2';
        opp2.Type='New Customer';
        opp2.AccountId = acct.id;
        opp2.amount=2500;
        opp2.CloseDate = date.today().addDays(-3);
        opp2.StageName = 'Prospecting';
        oppsToInsert.add(opp2);
        
        insert oppsToInsert;
        
        ServiceTokens__c st = new ServiceTokens__c();
        st.Name = 'ProjectServiceToken';
        st.Token__c = 'thisistesttoken';
        insert st;
        
        List<Id> oppIds = new List<Id>();
        oppIds.add(oppsToInsert[0].Id);
        
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure()); 
        Test.startTest();
        ProjectCalloutService.postOpportunityToPMS(oppIds);
        Test.stopTest();
        
        List<Opportunity> oppList = [SELECT StageName FROM Opportunity WHERE Id=:oppsToInsert[0].Id];
        System.assertEquals('Resubmit Project',oppList[0].StageName);    
    }
	
}