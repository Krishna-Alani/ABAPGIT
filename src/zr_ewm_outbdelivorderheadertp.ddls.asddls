@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Outbound Delivery Header - TP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #M,
    dataClass: #TRANSACTIONAL
}

@VDM.viewType:#TRANSACTIONAL
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define root view entity ZR_EWM_OutbDelivOrderHeaderTP
  as select from P_EWM_OutbDlvOrderHeader01_2
  composition [0..*] of ZR_EWM_OutbDelivOrderItemTP as _WhseOutbDeliveryOrderItem
{
  key EWMOutboundDeliveryOrder,
      EWMWarehouse,
      EWMDeliveryDocumentCategory,
      EWMDeliveryDocumentType,
      ShipToParty,
      ShipToPartyName,
      Carrier,
      CarrierName,
      PlannedDeliveryUTCDateTime,
      PlannedOutOfYardUTCDateTime,
      IncotermsPart1,
      IncotermsPart2,
      EWMRoute,
      SalesOrganization,
      ShippingOffice,
      EWMDelivLastChangeUTCDateTime,
      _WhseOutbDeliveryOrderItem
}
