import { LightningElement, api } from 'lwc';

export default class DeleteRowTypeDatatable extends LightningElement {

    @api rowId;
    @api attrA;
    @api attrB;

    handleDeleteRow() {
        const event = new CustomEvent('deleterow', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                rowId: this.rowId
            },
        });
        this.dispatchEvent(event);
    }

}