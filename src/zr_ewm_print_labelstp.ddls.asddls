@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EWM Print Labels - TP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #XL,
    dataClass: #TRANSACTIONAL
}
define root view entity ZR_EWM_PRINT_LABELSTP as select from ZI_SPOOLREQUESTS 
{
    key SpoolRequestNumber,
    SpoolRequestName,
    UserName,
    PrintImmediately,
    DeleteRequestAutomatically,
    cast( '' as char4 ) as OutputDevice,
    NumberOfCopies,
    DocumentType,
    cast( '' as char10 ) as Action,
    cast( '' as char4 ) as EWMWareHouse,
    cast( '' as char20 ) as HandlingUnitExternalID,
    cast( '' as char18 ) as StorageBinFrom,
    cast( '' as char18 ) as StorageBinTo,
    cast( '' as char10 ) as PurchaseOrder
}
