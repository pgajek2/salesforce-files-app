public with sharing class ApexWebService {

    public static FINAL String CLIENT_ID = '3MVG91BJr_0ZDQ4tNSfZdv5uys1vWupAq08Y2EHJK6mSLOvTaNksxY6w9q2O1q6lsiocU27QXgQ7teOMP9vIU';
    public static FINAL String CLIENT_SECRET = 'C56E3F8B3AC19AF8948471EB709185258F6334B570A7A1B83971721FA7CC21A3';
    public static FINAL String AUTHORIZATION_URL = 'https://login.salesforce.com/services/oauth2/authorize';
    public static FINAL String TOKEN_URL = 'https://login.salesforce.com/services/oauth2/token';
    public static FINAL String REVOKE_TOKEN_URL = 'https://login.salesforce.com/services/oauth2/revoke';
    private static FINAL String GRANT_TYPE = 'password';
    private static FINAL String USERNAME = 'piotr.gajek@salesforceprofs.com';
    private static FINAL String PASSWORD = 'FIFAstreet3rWEHfocFCVToGnA98Mn0QQ1X2';

    public class TokenResponseWrapper {
        public String access_token;
        public String instance_url;
        public String id;
        public String token_type;
        public String issued_at;
        public String signature;
    }

    public static String getSecurityToken() {

        String endpointWithParams = TOKEN_URL + '?';
        List<String> params = new List<String>{
            'grant_type=' + GRANT_TYPE,
            'client_id=' + CLIENT_ID,
            'client_secret=' + CLIENT_SECRET,
            'username=' + USERNAME,
            'password=' + PASSWORD
        };
        endpointWithParams += String.join(params, '&');

        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setMethod('POST');
        request.setEndpoint(endpointWithParams);

        Http http = new Http();
        HTTPResponse response = http.send(request); 
        
        TokenResponseWrapper tokenResponseWrapper = (TokenResponseWrapper) JSON.deserialize(response.getBody(), TokenResponseWrapper.class); 

        return tokenResponseWrapper.access_token;
    }

    public static void getAccount(Id accId) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();

        req.setMethod('GET');
        req.setEndpoint('callout:Salesforce_Credentials/services/apexrest/Account/' + accId);
        // req.setEndpoint('https://eu29.salesforce.com/services/apexrest/Account/' + accId);
        // req.setHeader('Authorization', 'Bearer ' + getSecurityToken());
        
        HTTPResponse response = http.send(req); 
        System.debug(response);
        System.debug(response.getBody());
    }
}