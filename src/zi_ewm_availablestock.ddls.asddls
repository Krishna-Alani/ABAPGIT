@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Warehouse Available Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define view entity ZI_EWM_AvailableStock as select from /scwm/aqua
association [1] to I_Product             as _Material on  $projection.ProductUUID = _Material.ProductUUID
--association [0..*] to ZI_EWM_DELIVERYHUSERIALNUMBERS as AvailableHUSerialNumbers on $projection.StockItemUUID = AvailableHUSerialNumbers.GuidStock
--                                                                                 and $projection.HandlingUnitExternalID = AvailableHUSerialNumbers.HandlingUnitExternalID 
                                                                          {
    key guid_parent as StockItemParentUUID,
    key guid_stock as StockItemUUID,
    lgnum as EWMWarehouse,
    lgtyp as StorageType,
    lgpla as StorageBin,
    rsrc as EWMResource,
    cast( huident as char20 preserving type ) as HandlingUnitExternalID,
    tu_num as TranspUnitInternalNumber,
    flgmove as HandlingUnitOpenTaskInd,
    cast( matid as matid_no_conv preserving type )                    as ProductUUID,
    _Material.Product,
    cat as StockType,
    stock_doccat as StockDocumentCategory,
    stock_docno as StockDocumentNumber,
    stock_itmno as StockItemNumber,
    doccat as EWMDocumentCategory,
    stock_usage as EWMStockUsage,
    cast ( owner as char10 preserving type ) as EWMStockOwner,
    owner_role as StockOwnerPartnerRole,
    entitled as EntitledToDisposeParty,
    entitled_role as EntitledToDisposePartnerRole,
    stock_cnt as CounterForStockSeparation,
    charg as Batch,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    quan as AvailableQuantity,
    unit as BaseUnit,
    altme as AlternativeUnit,
    vfdat as ShelfLifeExpirationDate,
    cast ( wdatu as /scwm/lvs_wdatu_noconv preserving type )          as WhseTaskGoodsReceiptDateTime ,
    insptyp as WhseTaskQualityInspectionType,
    inspid as QualityInspectionDocUUID,
    coo as CountryOfOrigin,
    read_quants as ReadQuants,
    brestr as Brestr,
    logpos as Logpos,
    _Material
--    AvailableHUSerialNumbers
} where flgmove = ' '
