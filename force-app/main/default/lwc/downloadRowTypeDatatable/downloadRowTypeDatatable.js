import { LightningElement, api } from 'lwc';

export default class DownloadRowTypeDatatable extends LightningElement {

    @api rowId;
    @api fileUrl;

    handleDeleteRow() {
        const event = new CustomEvent('downloadrow', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                rowId: this.rowId,
                fileUrl: this.fileUrl
            },
        });
        this.dispatchEvent(event);
    }

}