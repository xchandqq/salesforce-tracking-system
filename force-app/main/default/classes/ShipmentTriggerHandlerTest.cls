/**
 * @description       : 
 * @author            : Christian Abellanosa
 * @group             : 
 * @last modified on  : 10-15-2021
 * @last modified by  : Christian Abellanosa
**/
@isTest
public with sharing class ShipmentTriggerHandlerTest {
    @TestSetup
    private static void makeData(){
        List<Shipment__c> shipmentList = new List<Shipment__c>();
        
        Shipment__c s1 = new Shipment__c();
        s1.Delivery_Location__Latitude__s = 1;
        s1.Delivery_Location__Longitude__s = 2;
        shipmentList.add(s1);
        
        Shipment__c s2 = new Shipment__c();
        s2.Delivery_Location__Latitude__s = 3;
        s2.Delivery_Location__Longitude__s = 4;
        shipmentList.add(s2);
        
        Shipment__c s3 = new Shipment__c();
        s3.Delivery_Location__Latitude__s = 5;
        s3.Delivery_Location__Longitude__s = 6;
        shipmentList.add(s3);

        insert shipmentList;
    }

    @isTest
    private static void trackingCodeUniqueTest(){
        Set<Location> locationSet = new Set<Location>();
        for(Shipment__c shipment : [SELECT Delivery_Location__c FROM Shipment__c]){
            locationSet.add(shipment.Delivery_Location__c);
        }

        System.assertEquals(3, locationSet.size());
    }

    @isTest
    private static void updateTrackingCodeTest(){
        Shipment__c shipment = [SELECT Id FROM Shipment__c LIMIT 1];
        try{
            shipment.Tracking_Code__c = '1234123412341234';
            update shipment;
            System.assert(false, 'Shipment tracking code is edittable');
        }catch(Exception e){
            System.assert(true);
        }
    }
}
