/**
 * @description       : 
 * @author            : Christian Abellanosa
 * @group             : 
 * @last modified on  : 10-15-2021
 * @last modified by  : Christian Abellanosa
**/
public with sharing class TrackerPageController {

    @AuraEnabled
    public static Shipment__c findShipmentByTrackingCode(String trackingCode){
        try{
            Shipment__c shipment = [SELECT Id, Delivered__c, Date_Delivered__c, Delivery_Location__Latitude__s, Delivery_Location__Longitude__s, 
                                        (SELECT Id, Status__c, Location__Latitude__s, Location__Longitude__s, Notes__c, CreatedDate FROM Shipment_Statuses__r ORDER BY CreatedDate DESC) 
                                    FROM Shipment__c 
                                    WHERE Tracking_Code__c = :trackingCode
                                    LIMIT 1];
            return shipment;
        }catch(Exception e){
            return null;
        }
    }
}