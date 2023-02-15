@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EWM Handling Unit Status - TP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #M,
    dataClass: #TRANSACTIONAL
}
@VDM.viewType: #TRANSACTIONAL
define view entity ZR_EWM_HANDLINGUNITSTATUSTP as select from zI_ewm_handlingunitstatus 
association to parent ZR_handlingunittp as _HandlingUnit on $projection.HandlingUnitExternalID = _HandlingUnit.HandlingUnitExternalID
                                                         and $projection.EWMWarehouse = _HandlingUnit.Warehouse {
    key binToHex(HandlingUnitUUID) as HandlingUnitUUID,
    key HandlingUnitStatus,
    HandlingUnitIsInactive,
    HandlingUnitExternalID,
    EWMWarehouse,
    _HandlingUnit
}
