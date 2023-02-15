@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Outbound Delivery Status - TP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #XL,
    dataClass: #TRANSACTIONAL
}
define view entity zr_ewm_outbdelivorderstatustp as select from I_EWM_DeliveryStatus 
association [1] to I_EWM_OutbDelivOrdItem as _OutBDeliveryItem on $projection.DeliveryUUID = _OutBDeliveryItem.OutboundDeliveryOrderUUID
                                                               and $projection.DeliveryItemUUID = _OutBDeliveryItem.OutboundDeliveryOrderItemUUID
association to parent ZR_EWM_OutbDelivOrderItemTP as _WhseOutbDeliveryOrderItem on $projection.ewmoutbounddeliveryorder = _WhseOutbDeliveryOrderItem.EWMOutboundDeliveryOrder
                                                                                and $projection.ewmoutbounddeliveryorderitem = _WhseOutbDeliveryOrderItem.EWMOutboundDeliveryOrderItem
association [1] to ZR_EWM_OutbDelivOrderHeaderTP as _WhseOutbDeliveryOrderHead  on  $projection.ewmoutbounddeliveryorder = _WhseOutbDeliveryOrderHead.EWMOutboundDeliveryOrder
                                                                                
{
    key _OutBDeliveryItem.EWMOutboundDeliveryOrder,
    key _OutBDeliveryItem.EWMOutboundDeliveryOrderItem,
    key DeliveryStatusType,
    DeliveryUUID,
    DeliveryItemUUID,
    EWMDeliveryDocumentCategory,
    EWMDeliveryStatus,
    _OutBDeliveryItem.EWMWarehouse,
    _OutBDeliveryItem,
    _WhseOutbDeliveryOrderItem,
    _WhseOutbDeliveryOrderHead
} where EWMDeliveryDocumentCategory = 'PDO'
