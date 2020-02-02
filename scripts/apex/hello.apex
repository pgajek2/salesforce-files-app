         List<Id> recordsIds = new List<Id>();
            recordsIds.add('0013X00002WF49jQAD');
            recordsIds.add('0013X00002WF4CJQA1');
      
           // List<ContentDocumentLink> contentDocumentsLinks = FilesHelper.getContentDocumentsLinks(recordsIds); 
           // System.debug(contentDocumentsLinks);
            //List<Id> contentDocumentsIds = new List<Id>();

            System.debug(FilesController.getRecordRelatedFiles('Account', recordsIds));