trigger ContentDocumentTrigger on ContentDocument (before insert) {

    for (ContentDocument cd : Trigger.New) {
        cd.shareType = 'V';
        cd.Visibility = 'AllUsers';
    }
    
}
                                