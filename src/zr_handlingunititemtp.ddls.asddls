@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Handling Unit Item - TP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #XL,
    dataClass: #TRANSACTIONAL
}


@VDM.viewType: #TRANSACTIONAL

/*+[hideWarning] { "IDS" : [ "CALCULATED_FIELD_CHECK", "CARDINALITY_CHECK"]  } */
define view entity ZR_HandlingUnitItemTP
  as select from I_HandlingUnitItemCombined
  association to parent ZR_handlingunittp as _HandlingUnit on  $projection.HandlingUnitExternalID = _HandlingUnit.HandlingUnitExternalID
                                                           and $projection.Warehouse              = _HandlingUnit.Warehouse
  association[0..1] to ZA_EWM_DELIVERYITEM_REFDOC as _refdoc on $projection.HandlingUnitReferenceDocument = 
_refdoc.EWMRefDeliveryDocumentNumber 
                                                       and $projection.HandlingUnitRefDocumentItem =     
_refdoc.EWMRefDeliveryDocumentItem                                                                                           
association[0..1] to ZR_EWM_HANDLINGUNITSTATUSTP as _HandlingUnitStatus on  $projection.HandlingUnitExternalID = _HandlingUnitStatus.HandlingUnitExternalID  
                                                       and _HandlingUnitStatus.HandlingUnitStatus = 'IHU05'   
                                                       and _HandlingUnitStatus.HandlingUnitIsInactive = ' '                       
{
      @Search.defaultSearchElement : true
      @Search.fuzzinessThreshold : 0.8
      @Search.ranking : #HIGH
  key HandlingUnitExternalID,
  key Warehouse,
  key StockItemUUID,

      HandlingUnitItem,
      HandlingUnitInternalID,
      HandlingUnitTypeOfContent,
      cast( '00000000000000000000' as char20) as HandlingUnitNestedExternalID,     
      HandlingUnitReferenceDocument,
      HandlingUnitRefDocumentItem,
      @Semantics.quantity.unitOfMeasure: 'HandlingUnitQuantityUnit'
      HandlingUnitQuantity,
      HandlingUnitQuantityUnit,
      HandlingUnitAltUnitOfMeasure,
      
      Material,
      MaterialName,
      
      Batch,
      
      Plant,
      StorageLocation,
      
      ShelfLifeExpirationDate,
      HandlingUnitGoodsReceiptDate,
      
      CountryOfOrigin,
      
      HandlingUnitNrOfAuxPackgMat,
      _refdoc.EWMDelivery,
      _refdoc.EWMDeliveryItem,
      _refdoc.DeliveryType,
      case when _HandlingUnitStatus.HandlingUnitExternalID is initial
          then 'X' 
          else ' '
          end as LoadingDone,
      
      /* Associations */
      _HandlingUnit,
      _HandlingUnitAltUnitOfMeasure,
      _HandlingUnitQuantityUnit,
      _refdoc,
      _HandlingUnitStatus
}
