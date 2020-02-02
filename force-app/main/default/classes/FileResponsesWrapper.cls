public with sharing class FileResponsesWrapper {

    public class Response {

        @AuraEnabled
        public Boolean isSuccess;

        @AuraEnabled
        public String message;

        @AuraEnabled
        public List<RelatedObjectWrapper> data;

    }

    public class RelatedObjectWrapper {

        @AuraEnabled
        public String id;

        @AuraEnabled
        public String name;   

        @AuraEnabled
        public String createdDate;

        @AuraEnabled
        public List<FileWrapper> files;  

    }

    public class FileWrapper {

        @AuraEnabled
        public String id;

        @AuraEnabled
        public String downloadUrl;

        @AuraEnabled
        public String name;

        @AuraEnabled
        public String createdDate;

    }

}
