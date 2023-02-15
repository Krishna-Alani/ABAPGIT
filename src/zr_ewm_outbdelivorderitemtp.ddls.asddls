@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Outbound Delivery Item - TP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #XL,
    dataClass: #TRANSACTIONAL
}

@VDM.viewType:#TRANSACTIONAL
define view entity ZR_EWM_OutbDelivOrderItemTP
  as select from P_EWM_OutbDlvOrderItem01_2
  association        to parent ZR_EWM_OutbDelivOrderHeaderTP as _WhseOutbDeliveryOrderHead  on  $projection.EWMOutboundDeliveryOrder = _WhseOutbDeliveryOrderHead.EWMOutboundDeliveryOrder
  composition [0..*] of zr_ewm_outbdelivorderstatustp as _WhseOutbDeliveryOrderStatus

{
  key EWMOutboundDeliveryOrder,
  key EWMOutboundDeliveryOrderItem,
      EWMWarehouse,
      EWMDeliveryDocumentCategory,
      EWMOutbDelivOrderItemCategory,
      EWMOutbDeliveryOrderItemType,
      Product,
      ProductExternalID,
      Batch,
      @Semantics.quantity.unitOfMeasure: 'QuantityUnit'
      ProductQuantity,
      QuantityUnit,
      StagingArea,
      StagingAreaGroup,
      StagingBay,
      GoodsIssueStatus,
      PlannedPickingStatus,
      PickingStatus,
      CompletionStatus,
      WarehouseProcessType,
      ShippingCondition,
      GoodsMovementBin,
      EWMProductionSupplyArea,
      EWMDelivLastChangeUTCDateTime,
      EWMStorageType,
      EWMStorageSection,
      PlndGoodsIssueStartUTCDateTime,
      ActlGoodsIssueStartUTCDateTime,
      RouteSchedule,
      EntitledToDisposeParty,
      EWMStockUsage,
      EWMStockType,
      EWMStockOwner,
      DeliveryItemStockTypeDetnCode,
      WBSElementInternalID,
      WBSElementExternalID,
      SpecialStockIdfgSalesOrder,
      SpecialStockIdfgSalesOrderItem,
      CountryOfOrigin,
      SalesOrder,
      SalesOrderItem,
      ManufacturingOrder,
      _WhseOutbDeliveryOrderHead,
      _WhseOutbDeliveryOrderStatus
    
}
