import LightningDatatable from 'lightning/datatable';

//templates
import deleteRow from './deleteRow';
import downloadRow from './downloadRow';

export default class CustomDatatable extends LightningDatatable {

    static customTypes = {
        deleteRow: { //type: 'deleteRow' in columns
            template: deleteRow,
            typeAttributes: ['attrA', 'attrB'],
        },
        downloadRow: { //type: 'downloadRow' in columns
            template: downloadRow,
            typeAttributes: ['fileUrl']
        }
    };

}