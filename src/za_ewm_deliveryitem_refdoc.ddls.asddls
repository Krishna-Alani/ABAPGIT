@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EWM IBD and OBD Delivery Ref Doc'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory: #XL,
    dataClass: #TRANSACTIONAL
}
define view entity ZA_EWM_DELIVERYITEM_REFDOC as select from I_EWM_InbDeliveryItem as EWMInboundDelivery
inner join I_EWM_DeliveryReferenceDoc_2 as referencedelivery on EWMInboundDelivery.InboundDeliveryUUID = referencedelivery.DeliveryUUID 
                                                                        and EWMInboundDelivery.InboundDeliveryItemUUID = referencedelivery.DeliveryItemUUID
                                                                         {
    key EWMInboundDelivery.InboundDeliveryUUID as EWMDeliveryUUID,
    key EWMInboundDelivery.InboundDeliveryItemUUID as EWMDeliveryItemUUID,
    EWMInboundDelivery.EWMInboundDelivery as EWMDelivery,
    EWMInboundDelivery.EWMInboundDeliveryItem as EWMDeliveryItem,
    @Consumption.hidden: true 
    referencedelivery.EWMRefDeliveryDocumentNumber as EWMRefDeliveryDocumentNumber, 
    ltrim( referencedelivery.EWMRefDeliveryDocumentNumber, '0' ) as EWMRefDeliveryDocumentNumberTr,  
    @Consumption.hidden: true    
    referencedelivery.EWMRefDeliveryDocumentItem,
    ltrim( referencedelivery.EWMRefDeliveryDocumentItem, '0' ) as EWMRefDeliveryDocumentItemTr, 
    'I' as DeliveryType
}
where referencedelivery.EWMReferenceDocumentCategory = 'ERP'

union select from I_EWM_OutbDelivOrdItem as EWMOutboundDelivery
inner join I_EWM_DeliveryReferenceDoc_2 as referencedelivery on EWMOutboundDelivery.OutboundDeliveryOrderUUID = referencedelivery.DeliveryUUID 
                                                                        and EWMOutboundDelivery.OutboundDeliveryOrderItemUUID = referencedelivery.DeliveryItemUUID
                                                                         {
    key EWMOutboundDelivery.OutboundDeliveryOrderUUID as EWMDeliveryUUID,
    key EWMOutboundDelivery.OutboundDeliveryOrderItemUUID as EWMDeliveryItemUUID,
    EWMOutboundDelivery.EWMOutboundDeliveryOrder as EWMDelivery,
    EWMOutboundDelivery.EWMOutboundDeliveryOrderItem as EWMDeliveryItem, 
    referencedelivery.EWMRefDeliveryDocumentNumber as EWMRefDeliveryDocumentNumber,  
    ltrim( referencedelivery.EWMRefDeliveryDocumentNumber, '0' ) as EWMRefDeliveryDocumentNumberTr,     
    referencedelivery.EWMRefDeliveryDocumentItem,
    ltrim( referencedelivery.EWMRefDeliveryDocumentItem, '0' ) as EWMRefDeliveryDocumentItemTr,
    'O' as DeliveryType
}
where referencedelivery.EWMReferenceDocumentCategory = 'ERP'
