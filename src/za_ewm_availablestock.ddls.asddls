@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EWM Warehouse Available Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity za_ewm_availablestock as select from ZI_EWM_AvailableStock 
association [0..*] to ZA_EWM_DELIVERYHUSERIALNUMBERS as _AvailableHUSerialNumbers 
                    on $projection.StockItemUUID = _AvailableHUSerialNumbers.GuidStock
                    and $projection.HandlingUnitExternalID = _AvailableHUSerialNumbers.HandlingUnitExternalID 
{
    key StockItemParentUUID,
    key StockItemUUID,
    EWMWarehouse,
    StorageType,
    StorageBin,
    EWMResource,
    ltrim( HandlingUnitExternalID, '0' ) as HandlingUnitExternalID,
    TranspUnitInternalNumber,
    HandlingUnitOpenTaskInd,
    ProductUUID,
    Product,
    StockType,
    StockDocumentCategory,
    StockDocumentNumber,
    StockItemNumber,
    EWMDocumentCategory,
    EWMStockUsage,
    EWMStockOwner,
    StockOwnerPartnerRole,
    EntitledToDisposeParty,
    EntitledToDisposePartnerRole,
    CounterForStockSeparation,
    Batch,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    AvailableQuantity,
    BaseUnit,
    AlternativeUnit,
    ShelfLifeExpirationDate,
    WhseTaskGoodsReceiptDateTime,
    WhseTaskQualityInspectionType,
    QualityInspectionDocUUID,
    CountryOfOrigin,
    ReadQuants,
    Brestr,
    Logpos,
    /* Associations */
    _AvailableHUSerialNumbers
 --   _Material
}
