import { LightningElement } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent"
import findShipmentByTrackingCode from '@salesforce/apex/TrackerPageController.findShipmentByTrackingCode';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import { wire } from 'lwc';

export default class TrackerPage extends NavigationMixin(LightningElement) {

    center;
    mapMarker = [];
    shipment;
    shipmentStatusList = {};

    shipmentFound = false;
    findingShipment = false;
    codeLength = 0;
    trackingCode = '';

    currentPageReference = null; 
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
           var state = currentPageReference.state;
           this.trackingCode = state.trackingCode || null;
           if(this.trackingCode){
                onclickFindButton(null);
           }
        }
     }

    get codeLengthInsufficient(){
        return this.codeLength < 16;
    }

    get returnDisabled(){
        return this.shipment.Delivered__c;
    }

    onchangeTrackingCodeInput(e){
        this.trackingCode = e.target.value;
        this.codeLength = this.trackingCode.length;
    }

    onclickFindButton(e){
        this.findingShipment = true;

        findShipmentByTrackingCode({trackingCode: this.trackingCode})
        .then((shipment) => {
            if(shipment != null){
                this.shipment = shipment;
                this.shipmentStatusList = shipment.Shipment_Statuses__r;

                console.log(shipment);
                console.log(this.shipmentStatusList);

                this.mapMarker = [];
                console.log(this.mapMarker.length);
                this.shipmentStatusList.forEach(element => {
                    var newMarker = {
                        location: {
                            Latitude: element.Location__Latitude__s,
                            Longitude: element.Location__Longitude__s
                        },
                        title: element.Status__c,
                        description: element.Notes__c
                    };

                    console.log(newMarker);
                    if(this.mapMarker.length == 0){
                        this.mapMarker.push(newMarker);
                        return;
                    }
                    
                    var prevLocation = this.mapMarker[this.mapMarker.length-1].location;
                    if(newMarker.location.Latitude == prevLocation.Latitude && newMarker.location.Longitude == prevLocation.Longitude){
                        console.log('not adding');
                        return;
                    }
                    else{
                        console.log('adding');
                        this.mapMarker.push(newMarker);
                    }
                });
                this.center = this.mapMarker[0];

                const event = new ShowToastEvent({
                    title: 'Shipment found',
                    variant: 'success'
                });
                this.dispatchEvent(event);
                this.shipmentFound = true;
            }
            else{        
                const event = new ShowToastEvent({
                    title: 'No shipment found',
                    variant: 'error'
                });
                this.dispatchEvent(event);
                this.shipmentFound = false;
            }
            this.findingShipment = false;
        });
    }

    onselectStatus(e){
        this.center = {
            location: {
                Latitude: e.detail.Location__Latitude__s,
                Longitude: e.detail.Location__Longitude__s
            }
        };
    }

    onclickFindNew(e){
        this.shipmentFound = false;
        this.codeLength = 0;
        this.trackingCode = '';
    }

    onclickReportIssueGeneral(e){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Case',
                actionName: 'new'
            },
            state : {
                nooverride: '1',
                defaultFieldValues: "Subject=Issue on Shipment ["+this.trackingCode+"],Shipment__c="+this.shipment.Id
            }
        });

        
    }

    onclickNewShipmentStatus(e){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Shipment_Status__c',
                actionName: 'new'
            },
            state : {
                nooverride: '1',
                defaultFieldValues: "Shipment__c="+this.shipment.Id
            }
        });
    }
}