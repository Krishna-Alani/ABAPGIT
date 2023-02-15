@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Handling Unit Transactional Processing'
@ObjectModel: {
   usageType: {
     serviceQuality:  #C,
     dataClass:       #MIXED,
     sizeCategory:    #XL
   }
}

@VDM.viewType: #TRANSACTIONAL
define root view entity ZR_handlingunittp as select from I_HandlingUnitHeaderCombined
composition [0..*] of ZR_HandlingUnitItemTP as _HandlingUnitItem
composition [0..*] of ZR_EWM_HANDLINGUNITSTATUSTP as _HandlingUnitStatus
composition [0..*] of ZR_EWM_HANDLINGUNITSERIALNUMTP as _HandlingUnitSerialNumber
{
  key HandlingUnitExternalID,
  key Warehouse,
  cast(HandlingUnitCharUUID as char32 preserving type) as HandlingUnitCharUUID, //proper casting needs to be implemented | Edm.GUID 
  
  HandlingUnitExternalIdType,
  
  Plant,
  StorageLocation,
  ShippingPoint,
  
  HandlingUnitInternalID,
  HandlingUnitLowerLevelRefer,
  ParentHandlingUnitNumber,
  
  PackagingMaterial,
  PackagingMaterialType,
          
  @Semantics.quantity.unitOfMeasure: 'WeightUnit'
  GrossWeight,
  @Semantics.quantity.unitOfMeasure: 'WeightUnit'
  NetWeight,
  @Semantics.quantity.unitOfMeasure: 'WeightUnit'
  HandlingUnitMaxWeight,
  WeightUnit,
  
  @Semantics.quantity.unitOfMeasure: 'HandlingUnitTareWeightUnit'
  HandlingUnitTareWeight,
  HandlingUnitTareWeightUnit,
  
  @Semantics.quantity.unitOfMeasure: 'VolumeUnit'
  GrossVolume,
  @Semantics.quantity.unitOfMeasure: 'VolumeUnit'
  HandlingUnitNetVolume,
  @Semantics.quantity.unitOfMeasure: 'VolumeUnit'
  HandlingUnitMaxVolume,
  VolumeUnit,
  
  @Semantics.quantity.unitOfMeasure: 'HandlingUnitTareVolumeUnit'
  HandlingUnitTareVolume,
  HandlingUnitTareVolumeUnit,
  
  @Semantics.quantity.unitOfMeasure: 'UnitOfMeasureDimension'
  HandlingUnitLength,
  HandlingUnitWidth,
  HandlingUnitHeight,
  UnitOfMeasureDimension,
  
  HandlingUnitPackingObjectType,
  
  //remove leading zeros
  ltrim( HandlingUnitReferenceDocument, '0'   ) as HandlingUnitReferenceDocument,
  
  CreatedByUser,
  @Semantics.systemDateTime.createdAt: true
  CreationDateTime,
  LastChangedByUser,
  @Semantics.systemDateTime.lastChangedAt: true
  LastChangeDateTime,
  
  HandlingUnitInternalStatus,
  
  HandlingUnitProcessStatus,
  
  SourceHandlingUnitUUID,
  PackingInstruction,
  HandlingUnitSecondExternalId,
  
  // EWM fields
  StorageType,
  StorageSection,
  StorageBin,
  
  HandlingUnitType as EWMHandlingUnitType,
  
  @Semantics.quantity.unitOfMeasure: 'HandlingUnitMaxDimensionUnit'
  HandlingUnitMaxLength,
  @Semantics.quantity.unitOfMeasure: 'HandlingUnitMaxDimensionUnit'
  HandlingUnitMaxWidth,
  @Semantics.quantity.unitOfMeasure: 'HandlingUnitMaxDimensionUnit'
  HandlingUnitMaxHeight,
  HandlingUnitMaxDimensionUnit,
  cast( '' as char10 ) as action,
  /* Associations */
  _UnitOfMeasureDimension,
  _VolumeUnit,
  _VolumeUnitTare,
  _WeightUnit,
  _WeightUnitTare,
  _HandlingUnitStatus,
  _HandlingUnitItem,
  _HandlingUnitSerialNumber
}
