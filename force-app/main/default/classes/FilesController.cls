public without sharing class FilesController {
    
    @AuraEnabled(Cacheable=true) //linkedEntitiesIds can by null or blank
    public static FileResponsesWrapper.Response getRecordRelatedFiles(String objectAPI, List<Id> linkedEntitiesIds) {

        FileResponsesWrapper.Response response = new FileResponsesWrapper.Response();

        try {

            response.isSuccess = true;
            response.message = 'OK';
            response.data = FilesHelper.preparesObjectsWithFiles(objectAPI, linkedEntitiesIds);

        } catch (DmlException e) {
            
            response.isSuccess = false;
            response.message = e.getMessage();
            response.data = null;
        }
 
        return response;
    }

  

    @AuraEnabled
    public static FileResponsesWrapper.Response shareFile(String fileId) {

        FileResponsesWrapper.Response response = new FileResponsesWrapper.Response();

        try {
            Id currentContactId = [SELECT Id, contactId FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].contactId;

            List<ContentDocumentLink> contentDocumentLinks = [ SELECT ContentDocumentId, Id, ShareType, Visibility, LinkedEntityId, SystemModstamp
                                                               FROM ContentDocumentLink WHERE ContentDocumentId =: fileId ORDER BY SystemModstamp DESC ];

            Set<Id> contentDocumentAlreadyShared = new Set<Id>();

            for (ContentDocumentLink cdl : contentDocumentLinks) {
                if (cdl.LinkedEntityId == currentContactId) {
                    contentDocumentAlreadyShared.add(cdl.ContentDocumentId);
                }
            }

            List<ContentDocumentLink> contentDocumentsNeedsToBeShare = new List<ContentDocumentLink>();

            for (ContentDocumentLink cdl : contentDocumentLinks) {

                if(!contentDocumentAlreadyShared.contains(cdl.ContentDocumentId)) { 

                    contentDocumentsNeedsToBeShare.add(
                            new ContentDocumentLink(
                                LinkedEntityId = currentContactId,
                                ContentDocumentId = cdl.ContentDocumentId,
                                shareType = 'V',
                                Visibility = 'AllUsers'
                            )
                        );

               } 
            }

            if (!contentDocumentsNeedsToBeShare.isEmpty()) {
                //Database.insert(contentDocumentsNeedsToBeShare, false);
            }

            response.isSuccess = true;
            response.message = 'OK';
            
        } catch (DmlException e) {

            response.isSuccess = false;
            response.message = e.getMessage();

        }
 
        return response;
    }

}