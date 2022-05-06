@isTest
public class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
	//Implement http mock callout failure here
   	public HTTPResponse respond(HTTPRequest request) {
	// Create a fake response
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setStatus('Error');
    res.setStatusCode(500);
    return res;
    }
}