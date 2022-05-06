@isTest
private class ProjectRESTServiceTest {
  //Implement Apex REST service tests here
  //postProjectData
  @isTest static void testpostProjectData1() {
        String recordId = createOpptyRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
      	//https://curious-raccoon-93kmq2-dev-ed.lightning.force.com/lightning/page/home
      	/*
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Cases/'
            + recordId;
		*/
      	request.requestUri =
            'https://curious-raccoon-93kmq2-dev-ed.my.salesforce.com/services/apexrest/project/';
        request.httpMethod = 'POST';
        RestContext.request = request;

      // Call the method to test
        String result = ProjectRESTService.postProjectData('678910','Test Project 1',recordId,date.valueOf('2022-05-01'),date.valueOf('2022-05-10'),5000,'Billable');
        // Verify results
        System.assertEquals('OK', result);
    }
    
    // test with an already existing Project
      @isTest static void testpostProjectData2() {
        String recordId = createOpptyRecord();
        
        String var_projectRef = createProjRecord(recordId);
          
        // Set up a test request
        RestRequest request = new RestRequest();
      	//https://curious-raccoon-93kmq2-dev-ed.lightning.force.com/lightning/page/home
      	/*
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Cases/'
            + recordId;
		*/
      	request.requestUri =
            'https://curious-raccoon-93kmq2-dev-ed.my.salesforce.com/services/apexrest/project/';
        request.httpMethod = 'POST';
        RestContext.request = request;

      // Call the method to test
        String result = ProjectRESTService.postProjectData(var_projectRef,'Test Project 1',recordId,date.valueOf('2022-05-01'),date.valueOf('2022-05-10'),5000,'Billable');
        // Verify results
        System.assertEquals('OK', result);
    }
    
    // force it to go to exception in ProjectRESTService class, by making Project__c.status = xBillable
    @isTest static void testpostProjectData3() {
        String recordId = createOpptyRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
      	//https://curious-raccoon-93kmq2-dev-ed.lightning.force.com/lightning/page/home
      	/*
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Cases/'
            + recordId;
		*/
      	request.requestUri =
            'https://curious-raccoon-93kmq2-dev-ed.my.salesforce.com/services/apexrest/project/';
        request.httpMethod = 'POST';
        RestContext.request = request;

      // Call the method to test
        String result = ProjectRESTService.postProjectData('678910','Test Project 1',recordId,date.valueOf('2022-05-01'),date.valueOf('2022-05-10'),5000,'xBillable');
        // Verify results
        System.assertEquals('OK', result);
    }

    // Helper method
    static String createOpptyRecord() {
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
        
        return oppsToInsert[0].Id;
    }
    
    static string createProjRecord(String oppId) {
        Project__c proj1 = new Project__c();
        
        proj1.ProjectRef__c = '12345';
        proj1.Opportunity__c = oppId;
        proj1.Name='Test Project 2';
        proj1.Start_Date__c = date.valueOf('2022-05-01');
        proj1.End_Date__c = date.valueOf('2022-05-10');
        proj1.Billable_Amount__c = 5000;
        proj1.Status__c = 'Billable';
        
        insert proj1;
 		
		return proj1.projectRef__c;        
    }
}