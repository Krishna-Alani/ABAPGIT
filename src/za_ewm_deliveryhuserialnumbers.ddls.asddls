@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EWM Delivery HU Serial Numbers'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #L,
    dataClass: #TRANSACTIONAL
}
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZA_EWM_DELIVERYHUSERIALNUMBERS as select from ZI_EWM_DELIVERYHUSERIALNUMBERS {
    key ltrim( HandlingUnitExternalID, '0' ) as HandlingUnitExternalID,
    key GuidStock,
    key SerialNumber,
    DocumentID,
    ItemID,
    EWMDocumentCategory,
    StockID,
    SerialNumberInvalid,
    SerialNumberIndicaror,
    UniqueItemIdentifier
}
