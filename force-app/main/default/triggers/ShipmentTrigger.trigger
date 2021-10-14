/**
 * @description       : 
 * @author            : Christian Abellanosa
 * @group             : 
 * @last modified on  : 10-13-2021
 * @last modified by  : Christian Abellanosa
**/
trigger ShipmentTrigger on Shipment__c (before insert, before update) {
    if(Trigger.isBefore && Trigger.isInsert){
        ShipmentTriggerHandler.createShipmentTrackingCode(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        ShipmentTriggerHandler.restrictUpdateOnTrackingCode(Trigger.old, Trigger.newMap);
    }
}