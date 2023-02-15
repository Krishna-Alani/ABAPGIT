@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Spool Requests'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZI_SPOOLREQUESTS as select from tsp01 {
    key rqident as SpoolRequestNumber,
    rq0name as SpoolRequestName,
    rqowner as UserName,
    rq1dispo as PrintImmediately,
    rq2dispo as DeleteRequestAutomatically,
--    rqdest as OutputDevice,
    rqcopies as NumberOfCopies,
    rqdoctype as DocumentType,
    rqposname as Rqposname,
    @ObjectModel.virtualElement: true
    '                  ' as StorageBin
}
