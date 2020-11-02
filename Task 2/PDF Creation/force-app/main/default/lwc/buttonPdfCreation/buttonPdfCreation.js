import { LightningElement, api } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import ID_FIELD from '@salesforce/schema/Account.Id';
import ADD_PDF_FIELD from '@salesforce/schema/Account.Add_PDF__c';

export default class ButtonPdfCreation extends LightningElement {
    @api recordId;

    handleClick(){

        console.log("Id " + this.recordId);

        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[ADD_PDF_FIELD.fieldApiName] = true;
        
        const recordInput = { fields };

        updateRecord(recordInput)
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'PDF created',
                    variant: 'success'
                })
            );
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating PDF',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
        
        const closeQA = new CustomEvent('close');
        this.dispatchEvent(closeQA);

    }
}