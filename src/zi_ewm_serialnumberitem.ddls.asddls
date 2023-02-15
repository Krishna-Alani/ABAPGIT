@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EWM Serial Number Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #L,
    dataClass: #TRANSACTIONAL
}
@VDM.viewType: #BASIC 
/*+[hideWarning] { "IDS" : [ "KEY_CHECK", "CARDINALITY_CHECK" ]  } */
define view entity ZI_EWM_SERIALNUMBERITEM as select from /scwm/seri 
association [0..1] to I_EWM_HandlingUnitHdr as _HandlingUnit on  $projection.Warehouse = _HandlingUnit.Warehouse
                                                             and $projection.HandlingUnitUUID = _HandlingUnit.HandlingUnitUUID {
    key lgnum                                       as Warehouse,
    key cast(guid_parent as raw16 preserving type)  as HandlingUnitUUID,
    key cast(serid as char30 preserving type)       as EWMSerialNumber,
    cast(matid as raw16 preserving type)            as Material,
    serstat                                         as Serstat,
    doccat                                          as Doccat,
    uii                                             as Uii,
    docid                                           as Docid,
    itmid                                           as Itmid,
    entitled                                        as Entitled,
    guid_stock                                      as GuidStock,
    created_by                                      as CreatedBy,
    created_at                                      as CreatedAt,
    cast( _HandlingUnit.HandlingUnitNumber as char20 preserving type ) as HandlingUnitExternalID,
    _HandlingUnit
}
