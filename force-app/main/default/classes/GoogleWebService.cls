public with sharing class GoogleWebService {
     
    public static Http http = new Http();
    public static HTTPResponse response;
    public static HttpRequest request;

    public static void getProfile(String userEmail) {

        request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('callout:GoogleAPI/gmail/v1/users/' + userEmail + '/profile');

        response = http.send(request); 

        System.debug(response.getBody());
    }

    public static void getUserDrafts(String userEmail) {

        request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('callout:GoogleAPI/gmail/v1/users/' + userEmail + '/drafts');

        response = http.send(request); 

        System.debug(response.getBody());
    }

    public static void getMyCalendar() {
        
        request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('callout:GoogleAPI/calendar/v3/users/me/calendarList');

        response = http.send(request); 

        System.debug(response.getBody());
    }

    public static void getFile(String fileId) {

        request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('callout:GoogleAPI/drive/v3/files/' + fileId);

        response = http.send(request); 

        System.debug(response.getBody());
    }
}