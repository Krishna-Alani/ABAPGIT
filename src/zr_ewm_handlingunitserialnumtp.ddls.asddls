@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EWM Handling Unit Serial Number - TP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #L,
    dataClass: #TRANSACTIONAL
}
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZR_EWM_HANDLINGUNITSERIALNUMTP as select from ZI_EWM_SERIALNUMBERITEM 
association to parent ZR_handlingunittp as _HandlingUnit on $projection.EWMWarehouse = _HandlingUnit.Warehouse 
                                                         and $projection.HandlingUnitExternalID = _HandlingUnit.HandlingUnitExternalID {
    key Warehouse                       as EWMWarehouse,
    key binToHex(HandlingUnitUUID)      as HandlingUnitUUID,
    key EWMSerialNumber                 as EWMSerialNumber,
    Material                            as Material,
    Serstat                             as DeliveryAssignment,
    Doccat                              as DocumentCategory,
    Uii                                 as UniqueItemIdentifier,
    Docid                               as DocumentIdentifier,
    Itmid                               as DocumentItem,
    Entitled                            as PartyEntitledToDispose,
    GuidStock                           as GUIDStockItem,
    CreatedBy                           as CreatedBy,
    CreatedAt                           as CreatedAt,
    HandlingUnitExternalID              as HandlingUnitExternalID,
    /* Associations */
    _HandlingUnit

} where HandlingUnitExternalID <> ' '
