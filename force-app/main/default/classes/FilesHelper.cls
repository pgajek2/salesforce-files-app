public without sharing class FilesHelper {
   
    private static final String  BASE_URL = URL.getSalesforceBaseUrl().toExternalForm();

    public static List<FileResponsesWrapper.RelatedObjectWrapper> preparesObjectsWithFiles(String objectAPI, List<Id> linkedEntitiesIds) { 

        Map<Id, sObject> id2LinkedEntity = getLinkedEntitiesId2DetailsMap(objectAPI, linkedEntitiesIds);    
        Map<Id, List<FileResponsesWrapper.FileWrapper>> linkedEntityId2Files = collectsObjectFilesMap(id2LinkedEntity.keySet());

        List<FileResponsesWrapper.RelatedObjectWrapper> sObjectsWithFiles = new List<FileResponsesWrapper.RelatedObjectWrapper>();
        FileResponsesWrapper.RelatedObjectWrapper tempsObject;

        for (sObject linkedEntity : id2LinkedEntity.values()) {
            tempsObject = new FileResponsesWrapper.RelatedObjectWrapper();

            tempsObject.id          = linkedEntity.Id;
            tempsObject.name        = String.valueOf(linkedEntity.get('Name'));
            tempsObject.createdDate = String.valueOf(linkedEntity.get('CreatedDate'));
            tempsObject.files       = linkedEntityId2Files.get(linkedEntity.Id);

            if (tempsObject.files != null && !tempsObject.files.isEmpty()) {
                sObjectsWithFiles.add(tempsObject);
            }
            
        }

        return sObjectsWithFiles;
    }

    private static Map<Id, List<FileResponsesWrapper.FileWrapper>> collectsObjectFilesMap(Set<Id> linkedEntities) {
            
        List<ContentDocumentLink> contentDocumentsLinks = getContentDocumentsLinks(linkedEntities);
        Map<Id, ContentDocument> id2ContentDocument = getContentDocumentDetails(contentDocumentsLinks);

        Map<Id, List<FileResponsesWrapper.FileWrapper>> linkedEntityId2RelatedFiles = new Map<Id, List<FileResponsesWrapper.FileWrapper>>();
        List<FileResponsesWrapper.FileWrapper> tempFilesList;

        for (ContentDocumentLink cdl : contentDocumentsLinks) {
            tempFilesList = linkedEntityId2RelatedFiles.get(cdl.LinkedEntityId);

            if (tempFilesList == null) {
                tempFilesList = new List<FileResponsesWrapper.FileWrapper>();
            } 

            tempFilesList.add(
                FilesHelper.prepareFileWrapper(
                    id2ContentDocument.get(cdl.ContentDocumentId)
                )
            );

            linkedEntityId2RelatedFiles.put(cdl.LinkedEntityId, tempFilesList);
        }

        return linkedEntityId2RelatedFiles;
    
    }

    private static FileResponsesWrapper.FileWrapper prepareFileWrapper(ContentDocument contentDocument) {
        
        FileResponsesWrapper.FileWrapper fileWrapper = new FileResponsesWrapper.FileWrapper();

        fileWrapper.id          = contentDocument.Id;
        fileWrapper.name        = contentDocument.Title + '.' + contentDocument.FileExtension;
        fileWrapper.downloadUrl = BASE_URL + '/sfc/servlet.shepherd/document/download/' + contentDocument.Id + '?operationContext=S1';
        fileWrapper.createdDate = String.valueOf(contentDocument.CreatedDate);

        return fileWrapper;
    }

   private static String buildQuery(String objectAPI, List<Id> linkedEntities) {
       
        String query = 'SELECT Id, Name, CreatedDate FROM ' + objectAPI;

        if (linkedEntities != null && !linkedEntities.isEmpty()) {
            query += ' WHERE Id =: linkedEntities';
        }

        query += ' ORDER BY CreatedDate DESC LIMIT 500';
        
        return query;
   }

    private static List<Id> collectContentDocumentsIds(List<ContentDocumentLink> contentDocumentsLinks) {
        
        List<Id> contentDocumentsIds = new List<Id>();

        for (ContentDocumentLink cdl : contentDocumentsLinks) {
            contentDocumentsIds.add(cdl.ContentDocumentId);
        }

        return contentDocumentsIds;
    }

    private static List<ContentDocumentLink>  getContentDocumentsLinks(Set<Id> linkedEntities) {
        return [ SELECT ContentDocumentId, Id, SystemModstamp, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: linkedEntities ORDER BY SystemModstamp DESC ];
    }

    private static Map<Id, sObject> getLinkedEntitiesId2DetailsMap(String objectAPI, List<Id> linkedEntities) {
        return new Map<Id, sObject>(
            (List<sObject>) Database.query(buildQuery(objectAPI, linkedEntities))
        );
    }
   
    private static Map<Id, ContentDocument> getContentDocumentDetails(List<ContentDocumentLink> contentDocumentsLinks) {
        return new Map<Id, ContentDocument>(
            (List<ContentDocument>) [ SELECT Id, Title, FileExtension, CreatedDate, SystemModstamp FROM ContentDocument WHERE Id =: collectContentDocumentsIds(contentDocumentsLinks) ORDER BY SystemModstamp DESC ]
        );
    }

}
