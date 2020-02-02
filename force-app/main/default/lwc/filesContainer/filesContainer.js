import { LightningElement, track, wire } from 'lwc';
import getRecordRelatedFiles from '@salesforce/apex/FilesController.getRecordRelatedFiles';
import shareFile from '@salesforce/apex/FilesController.shareFile';

export default class FilesContainer extends LightningElement {

    @track data;

    @wire(getRecordRelatedFiles, { objectAPI: 'Account', linkedEntitiesIds: null }) 
    wiredFiles({ error, data }) {
        if (data && data.isSuccess) {
            this.data = data.data;
        } else if (error) {
            console.log(JSON.stringify(error));
        } 
    }

    handleDownloadFile(e) {

        const url = e.target.dataset.downloadUrl;

        shareFile({
            fileId: e.target.dataset.id
        })
        .then(response => {
            if(response.isSuccess) {
                window.open(url);
            }
        })
        .error(error => {

        })

    }
}