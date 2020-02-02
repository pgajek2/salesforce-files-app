public with sharing class CaseListController {
    
    public class CaseWrapper {
        @AuraEnabled
        public String id;

        @AuraEnabled
        public String caseNumber;

        @AuraEnabled
        public String subject;

        @AuraEnabled
        public String status;

        @AuraEnabled
        public String priority;

        @AuraEnabled
        public Datetime createdDate;
    }

    public class ActionWrapper {
        @AuraEnabled
        public Boolean isSuccess;

        @AuraEnabled
        public String errorMessage;
    }

    @AuraEnabled(Cacheable=true)
    public static List<CaseWrapper> getCases() {

        List<CaseWrapper> response = new List<CaseWrapper>();
        CaseWrapper caseWrapper;

        for (Case caseItem : [SELECT Id, CaseNumber, Subject, Status, Priority, CreatedDate FROM Case LIMIT 10]) {
            caseWrapper = new CaseWrapper();

            caseWrapper.id = caseItem.Id;
            caseWrapper.caseNumber = caseItem.CaseNumber;
            caseWrapper.subject = caseItem.Subject;
            caseWrapper.status = caseItem.Status;
            caseWrapper.priority = caseItem.Priority;
            caseWrapper.createdDate = caseItem.CreatedDate;

            response.add(caseWrapper);
        }

        return response;

    }

    @AuraEnabled
    public static ActionWrapper deleteCase(String caseId) {

        ActionWrapper response = new ActionWrapper();

        try {
            Case c = [SELECT Id FROM Case WHERE Id =: caseId];
            delete c;
            response.isSuccess = true;
        } catch(DmlException e) {
            response.isSuccess = false;
            response.errorMessage = e.getMessage();
        }
        return response;

    }

}