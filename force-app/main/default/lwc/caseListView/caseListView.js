import { LightningElement, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getCases from '@salesforce/apex/CaseListController.getCases';
import deleteCase from '@salesforce/apex/CaseListController.deleteCase';

const COLUMNS = [
    { label: 'Case Number', fieldName: 'caseNumber', type: 'text', sortable: true },
    { label: 'Subject', fieldName: 'subject', type: 'text', sortable: true },
    { label: 'Status', fieldName: 'status', type: 'text', sortable: true },
    { label: 'Priority', fieldName: 'priority', type: 'text', sortable: true },
    {
        label: '', type: 'downloadRow', fieldName: 'id', fixedWidth: 40, typeAttributes: {
            fileUrl: { fieldName: 'status' }
        }
    },{
        label: '', type: 'deleteRow', fieldName: 'id', fixedWidth: 40, typeAttributes: {
            attrA: { fieldName: 'status' },
            attrB: 'Test'
        }
    }
];

export default class CaseListView extends LightningElement {

    @track data;
    @track columns = COLUMNS;

    @track sortedBy;
    @track sortedDirection = 'desc';

    @wire(getCases)
    wiredDocuments(value) {
        this.data = value;
    }

    handleDownloadRow(event) {
        const { rowId, fileLink } = event.detail;
    }

    handleDeleteRow(event) {

        const { rowId } = event.detail;
 
        deleteCase({
            caseId: rowId
        })
        .then(result => {
            if(result.isSuccess) {
                console.log('Case deleted.');
                refreshApex(this.data);
            } else {
                console.log(result.errorMessage);
            }
        })
        .catch(error => {
            console.log(JSON.stringify(error));
        });
        
    }

    handleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        this.data.data = this.sortData(this.sortedBy, this.sortedDirection, this.data.data);
    }

    sortData(fieldName, sortDirection, dataToSort) {

        let sortedData = JSON.parse(JSON.stringify(dataToSort));

        let key = function (a) {
            return a[fieldName];
        }

        let reverse = sortDirection === 'asc' ? 1 : -1;

        if (typeof key == "string") {
            sortedData.sort((a, b) => {
                let valueA = key(a) ? key(a).toLowerCase() : '';
                let valueB = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((valueA > valueB) - (valueB > valueA));
            });
        } else {
            sortedData.sort((a, b) => {
                let valueA = key(a) ? key(a) : '';
                let valueB = key(b) ? key(b) : '';
                return reverse * ((valueA > valueB) - (valueB > valueA));
            });
        }
        return sortedData;
    }
}