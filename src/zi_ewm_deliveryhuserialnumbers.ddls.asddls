@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EWM Delivery HU Serial Numbers'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #L,
    dataClass: #TRANSACTIONAL
}
@VDM.viewType: #BASIC
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZI_EWM_DELIVERYHUSERIALNUMBERS as select from /scwm/dlv_seri {
    key cast( huno as char20 preserving type ) as HandlingUnitExternalID,
    key guid_stock as GuidStock,
    key cast( serid as char30 preserving type ) as SerialNumber,
    docid as DocumentID,
    itemid as ItemID,
    doccat as EWMDocumentCategory,
    idplate as StockID,
    invalid as SerialNumberInvalid,
    sn_indicator as SerialNumberIndicaror,
    uii as UniqueItemIdentifier
}
