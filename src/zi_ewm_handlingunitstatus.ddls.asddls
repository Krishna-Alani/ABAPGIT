@AbapCatalog.viewEnhancementCategory:[#NONE]
@AccessControl.authorizationCheck:#NOT_REQUIRED
@EndUserText.label:'EWM Handling Unit Status'
@Metadata.ignorePropagatedAnnotations:true
@ObjectModel.usageType:{
serviceQuality:#A,
sizeCategory:#M,
dataClass:#TRANSACTIONAL
}
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define view entity zI_ewm_handlingunitstatus as select from /scwm/husstat
association [0..1] to I_EWM_HandlingUnitHdr as _HandlingUnit on $projection.HandlingUnitUUID = _HandlingUnit.HandlingUnitUUID {
key objnr as HandlingUnitUUID,
key stat as HandlingUnitStatus,
inact as HandlingUnitIsInactive,
cast( '    ' as /scwm/lgnum ) as EWMWarehouse,
cast( _HandlingUnit.HandlingUnitNumber as char20 preserving type ) as HandlingUnitExternalID,
_HandlingUnit
}
