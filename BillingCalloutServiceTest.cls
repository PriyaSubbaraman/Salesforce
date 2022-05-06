@IsTest
private class BillingCalloutServiceTest {
    
    // Helper method
    //static void createTestRecord() {
    @testSetup static void createTestRecord() {
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
        
        insert oppsToInsert;
   
	    Project__c proj1 = new Project__c();
        
        proj1.ProjectRef__c = '12345';
        proj1.Opportunity__c = oppsToInsert[0].Id;
        proj1.Name='Test Project 2';
        proj1.Start_Date__c = date.valueOf('2022-05-01');
        proj1.End_Date__c = date.valueOf('2022-05-10');
        proj1.Billable_Amount__c = 5000;
        proj1.Status__c = 'Running';
        
        insert proj1;
        
        ServiceCredentials__c st = new ServiceCredentials__c();
        st.Name = 'BillingServiceCredential';
        st.Username__c = 'testuser';
        st.Password__c = 'testpassword';
        insert st;
        
    }
    
    @IsTest
    private static void testSuccess() {
        //Test.setMock(HttpCalloutMock.class, new BillingCalloutServiceMock());
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
		//createTestRecord();
        Test.startTest();
        //force the ProjectTrigger to execute
        Project__c proj1 = [SELECT Id, Status__c FROM Project__c LIMIT 1];
        proj1.Status__c = 'Billable';
        Update proj1;
        
        Test.stopTest();

        // runs callout and check results
        proj1 = [SELECT Id, Status__c FROM Project__c LIMIT 1];
        System.assertEquals(proj1.Status__c, 'Billed');
    }
    
    @IsTest
    private static void testFailure() {
        //Test.setMock(HttpCalloutMock.class, new BillingCalloutServiceMockFailure());
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
		//createTestRecord();
        Test.startTest();
        //force the ProjectTrigger to execute
        Project__c proj1 = [SELECT Id, Status__c FROM Project__c LIMIT 1];
        proj1.Status__c = 'Billable';
        Update proj1;
        
        Test.stopTest();

        // runs callout and check results
        proj1 = [SELECT Id, Status__c FROM Project__c LIMIT 1];
        System.debug('Status in Failure class = ' + proj1.Status__c);
        System.assertNotEquals(proj1.Status__c, 'Billed');
    }
    
    
}