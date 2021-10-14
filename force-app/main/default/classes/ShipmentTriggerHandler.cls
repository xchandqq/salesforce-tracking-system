/**
 * @description       : 
 * @author            : Christian Abellanosa
 * @group             : 
 * @last modified on  : 10-15-2021
 * @last modified by  : Christian Abellanosa
**/

/*
-This Apex class is important for this application since it uses Salesforce Standard Math library to produce a randomized Tracking code which functional tools cannot do
-
*/
public with sharing class ShipmentTriggerHandler {
    public static void createShipmentTrackingCode(List<Shipment__c> shipmentList){
        Date dateToday = Date.today();
        for(Shipment__c s : shipmentList){            
            String trackingCode = dateToday.year() + '' + (Integer)(100000 + Math.random()*900000) + '' + (Integer)(100000 + Math.random()*900000); 
            s.Tracking_Code__c = trackingCode;
        }
    }

    public static void restrictUpdateOnTrackingCode(List<Shipment__c> newShipmentList, Map<Id, Shipment__c> oldShipmentMap){
        for(Shipment__c newShipment : newShipmentList){
            Shipment__c oldShipment = oldShipmentMap.get(newShipment.Id);
            if(newShipment.Tracking_Code__c != oldShipment.Tracking_Code__c){
                oldShipment.addError('Editting Tracking Code is not allowed');
            }
        }
    }
}