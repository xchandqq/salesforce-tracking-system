import { LightningElement } from 'lwc';
import { api } from 'lwc';

export default class TrackerStatusChild extends LightningElement {
    @api status;

    get hasStatusNotes(){
        return this.status.Notes__c != null;
    }

    onclickStatus(e){
        const event = new CustomEvent('select', {
            detail: this.status
        });
        this.dispatchEvent(event);
    }
}