CLASS lhc_zr_handlingunittp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_handlingunittp RESULT result.
    METHODS post_gr_hu FOR MODIFY
      IMPORTING keys FOR ACTION zr_handlingunittp~post_gr_hu.
    METHODS validatehandlingunit FOR VALIDATE ON SAVE
      IMPORTING keys FOR zr_handlingunittp~validatehandlingunit.
    METHODS validatewarehouse FOR VALIDATE ON SAVE
      IMPORTING keys FOR zr_handlingunittp~validatewarehouse.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zr_handlingunittp.

ENDCLASS.

CLASS lhc_zr_handlingunittp IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD post_gr_hu.


  data : guid_hus   TYPE /SCWM/TT_GUID_HU,
         hus_header TYPE /SCWM/TT_HUHDR_INT,
         hus_gm     TYPE /scwm/t_gm_hu,
         lo_sp_prd_in      TYPE REF TO /scdl/cl_sp_prd_inb.

*         READ ENTITIES of zr_handlingunittp IN LOCAL MODE ENTITY ZR_handlingunittp
*         ALL FIELDS
*         WITH VALUE #( ( handlingunitinternalid = keys[ 1 ]-handlingunitinternalid ) )
*         RESULT data(HANDLINGUNIT).
*
*         DATA(hu_exid) = HANDLINGUNIT[ 1 ]-HandlingUnitExternalID.
*         SELECT SINGLE GUID_HU
*         FROM /SCWM/HUHDR
*         WHERE HUIDENT = @hu_exid
*         INTO @DATA(hu_uuid).
*
*
*
*
*
*        MOVE-CORRESPONDING guid_hus TO hus_gm.
*    LOOP AT hus_gm ASSIGNING FIELD-SYMBOL(<ls_hu_gm>).
*      <ls_hu_gm>-lgnum = /scwm/cl_tm=>sv_lgnum.
*    ENDLOOP.

 "Create service provider for inbound delivery
*  CREATE OBJECT lo_sp_prd_in.
**    EXPORTING
**      io_message_box = lo_message_box.
**
*
*  "Lock delivery
*  CALL METHOD lo_sp_prd_in->/scdl/if_sp1_locking~lock
*    EXPORTING
*      inkeys       = lt_sp_k_head
*      aspect       = /scdl/if_sp_c=>sc_asp_head
*      lockmode     = 'E'
*    IMPORTING
*      rejected     = lv_rejected
*      return_codes = lt_return_codes.
*
*
*     DATA(hu_exid) = keys[ 1 ]-HandlingUnitExternalID.
*         SELECT SINGLE GUID_HU
*         FROM /SCWM/HUHDR
*         WHERE HUIDENT = @hu_exid
*         INTO @DATA(hu_uuid).
*
*    /scwm/cl_api_helper_sap=>get_instance( )->verify_luw( ).
**
*     APPEND VALUE #( GUID_HU = hu_uuid ) TO guid_hus.
*  CALL FUNCTION '/SCWM/HU_READ_MULT'
*      EXPORTING
*        it_guid_hu   = guid_hus
*      IMPORTING
*        et_huhdr     = hus_header
*      EXCEPTIONS
*        wrong_input  = 1
*        not_possible = 2
*        OTHERS       = 3.
*    IF sy-subrc <> 0.
*      RAISE EXCEPTION TYPE /scdl/cx_delivery_t100
*        MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ENDIF.
*
*     APPEND VALUE #( lgnum = keys[ 1 ]-Warehouse
*                     HUIDENT = keys[ 1 ]-HandlingUnitExternalID
*                     guid_hu = hu_uuid )
*                    to hus_gm.
*
*     /scwm/cl_goods_movement=>post_hu(
*      EXPORTING
*        it_hu        = hus_gm
*        iv_gmcat     = 'GR'
*      IMPORTING
*        eo_message   = data(eo_message) ).

  "Create service provider for inbound delivery

*  call function 'ZTEST_GR_HU2'
*  EXPORTING HANDLINGUNITEXTERNALID = keys[ 1 ]-HandlingUnitExternalID.

   "Save changes
*   CALL METHOD lo_sp_prd_in->/scdl/if_sp1_transaction~save
*     EXPORTING
*       synchronously = abap_false
*     IMPORTING
*       rejected      = lv_rejected.
*
*    "remove lock
*    CALL METHOD lo_sp_prd_in->/scdl/if_sp1_transaction~cleanup
*      EXPORTING
*        reason = 'END'.

ENDMETHOD.

  METHOD earlynumbering_create.
        DATA(lo_huid_service) = NEW /SCWM/CL_HUID_SERVICE(  ).
    LOOP AT entities INTO DATA(entity).
    IF entity-HandlingUnitExternalID IS INITIAL.
    TRY.
      SELECT SINGLE vhart FROM mara INTO @DATA(lv_vhart) WHERE matnr = @entity-PackagingMaterial.
      DATA(lv_huident) = lo_huid_service->/SCWM/IF_AF_HUID_SERVICE~GENERATE_NUMBER(
        EXPORTING
          iv_pmtyp   =  lv_vhart
          iv_lgnum   = entity-Warehouse ).
    CATCH /scwm/cx_huid_service INTO DATA(lx_huid_service).
    ENDTRY.
    entity-HandlingUnitExternalID = lv_huident.
      APPEND VALUE #( %cid      = entity-%cid
                   %key      = entity-%key
                 ) TO mapped-zr_handlingunittp.
    ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD ValidateHandlingUnit.

    READ ENTITIES OF ZR_handlingunittp IN LOCAL MODE
         ENTITY ZR_handlingunittp
         FIELDS ( HandlingUnitExternalID ) WITH CORRESPONDING #( keys )
         RESULT DATA(HandlingUnits).
*
*    DATA(HandlingUnit) = condense(  | { HandlingUnits[ 1 ]-HandlingUnitExternalID ALPHA = IN } | ).
*    IF handlingunit IS NOT INITIAL.
*        SELECT SINGLE FROM /scwm/huhdr FIELDS huident WHERE huident = @HandlingUnit
*                                       INTO @DATA(lv_huident) .
*
*        LOOP AT HandlingUnits INTO DATA(ls_HandlingUnit).
**          APPEND VALUE #( %tky  = ls_HandlingUnit-%tky
**                          %state_area = 'VALIDATE_HANDLING_UNIT' ) TO reported-zr_handlingunittp.
*          IF lv_huident IS INITIAL.
*            APPEND VALUE #( %tky = ls_HandlingUnit-%tky ) TO failed-zr_handlingunittp.
*
*            APPEND VALUE #( %tky = ls_HandlingUnit-%tky
*                            %state_area = 'VALIDATE_HANDLING_UNIT'
*                            %msg = NEW zcx_ewm_exceptions( severity = if_abap_behv_message=>severity-error
*                                                          textid   = zcx_ewm_exceptions=>handlingunit_unknown
*                                                          HandlingUnitExternalID = ls_HandlingUnit-HandlingUnitExternalID )
*                            %element-HandlingUnitExternalID = if_abap_behv=>mk-on ) TO reported-zr_handlingunittp.
*          ENDIF.
*        ENDLOOP.
*    ENDIF.
  ENDMETHOD.

  METHOD ValidateWareHouse.

*    DATA ls_cause TYPE if_abap_behv=>t_fail_cause.
*
*      READ ENTITIES OF ZR_handlingunittp IN LOCAL MODE
*         ENTITY ZR_handlingunittp
*         FIELDS ( Warehouse ) WITH CORRESPONDING #( keys )
*         RESULT DATA(Warehouses).
*
*    DATA(Warehouse) = condense(  | { Warehouses[ 1 ]-Warehouse ALPHA = IN } | ).
*    IF Warehouse IS NOT INITIAL.
*        SELECT SINGLE FROM /scwm/t300 FIELDS lgnum WHERE lgnum = @warehouse
*                                       INTO @DATA(lv_lgnum) .
*
*        LOOP AT Warehouses INTO DATA(ls_warehouse).
*          APPEND VALUE #( %tky  = ls_warehouse-%tky
*                          %state_area = 'VALIDATE_WAREHOUSE' ) TO reported-zr_handlingunittp.
*          IF lv_lgnum IS INITIAL.
**            ls_cause .
*            APPEND VALUE #( %tky = ls_warehouse-%tky
*                            %fail-cause = ls_cause ) TO failed-zr_handlingunittp.
*
*            APPEND VALUE #( %tky = ls_warehouse-%tky
*                            %state_area = 'VALIDATE_WAREHOUSE'
**                            %msg = NEW zcx_ewm_exceptions( severity = if_abap_behv_message=>severity-error
**                                                          textid   = zcx_ewm_exceptions=>warehouse_unknown
**                                                          Warehouse = ls_warehouse-Warehouse )
*                         %msg      = new_message( id       = 'ZEWM_S4'
*                                                  number   = '001'
*                                                  v1       = ls_warehouse-Warehouse
*                                                  severity = if_abap_behv_message=>severity-error )
*                            %element-Warehouse = if_abap_behv=>mk-on
*                             ) TO reported-zr_handlingunittp.
*          ENDIF.
*        ENDLOOP.
*    ENDIF.
  ENDMETHOD.

ENDCLASS.

class lcl_saver definition inheriting from cl_abap_behavior_saver.

  protected section.
    methods SAVE_MODIFIED REDEFINITION.
  PRIVATE SECTION.
    METHODS verify_luw.
endclass.

class lcl_saver implementation.
method save_modified.
DATA lo_message_box TYPE REF TO /scdl/cl_sp_message_box.
   DATA(lo_sp_prd_in) = new /scdl/cl_sp_prd_inb( io_message_box =  lo_message_box ).

IF sy-uname EQ 'INC02308'.
BREAK-POINT.
ENDIF.
   IF update-zr_handlingunittp IS NOT INITIAL.

   DATA(hu_exid) = update-zr_handlingunittp[ 1 ]-HandlingUnitExternalID.
   SELECT SINGLE GUID_HU
          FROM /SCWM/HUHDR
          WHERE HUIDENT = @hu_exid
          INTO @DATA(hu_uuid).

   select single docid
          from /scwm/huref
          where guid_hu = @hu_uuid
          into @data(doc_uuid).

   data lt_hu       TYPE /scwm/t_gm_hu.
   APPEND VALUE #( huident = hu_exid
                   guid_hu  = hu_uuid
                   lgnum = '1710' ) to lt_hu.

   data lt_sp_k_head      TYPE /scdl/t_sp_k_head.
   APPEND VALUE #( docid = doc_uuid ) TO lt_sp_k_head.


"Lock delivery
   lo_sp_prd_in->/scdl/if_sp1_locking~lock(
    EXPORTING
      inkeys       = lt_sp_k_head
      aspect       = /scdl/if_sp_c=>sc_asp_head
      lockmode     = 'E'
    IMPORTING
      rejected     = data(lv_rejected)
      return_codes = data(lt_return_codes) ).

     data lt_sp_a_hu_scwm   TYPE /scwm/t_sp_a_hu.
    lo_sp_prd_in->/scdl/if_sp1_aspect~select_by_relation(
      EXPORTING
        relation     = /scwm/if_sp_c=>sc_rel_head_to_hu
        inrecords    = lt_sp_k_head
        aspect       = /scdl/if_sp_c=>sc_asp_head
*       options      =
      IMPORTING
        outrecords   = lt_sp_a_hu_scwm
        rejected     = lv_rejected
        return_codes = lt_return_codes ).


   /scwm/cl_goods_movement=>post_hu(
      EXPORTING
        it_hu      = lt_hu
        iv_gmcat   = /scwm/if_docflow_c=>sc_gr
      IMPORTING
        eo_message = data(lo_message) ).


    "Save changes
    lo_sp_prd_in->/scdl/if_sp1_transaction~save(
      EXPORTING
        synchronously = abap_false
      IMPORTING
        rejected      = lv_rejected ).

    "remove lock
    lo_sp_prd_in->/scdl/if_sp1_transaction~cleanup(  reason = 'END' ).

    ELSEIF create-zr_ewm_handlingunitstatustp IS NOT INITIAL.

      TYPES: "redundant fields
    BEGIN OF ys_huident ,
      huident TYPE /scwm/de_huident,
    END OF ys_huident .
  DATA:
    it_huident TYPE STANDARD TABLE OF ys_huident WITH NON-UNIQUE KEY huident .
    DATA:
      lt_huident  TYPE /scwm/tt_huident,
      lt_return   TYPE scol_return_code_t,
      lv_dummymsg TYPE string ##NEEDED.

    verify_luw( ).

    APPEND VALUE #( huident = create-zr_ewm_handlingunitstatustp[ 1 ]-HandlingUnitExternalID ) TO it_huident.
    IF it_huident IS INITIAL.
      RAISE EXCEPTION TYPE /scwm/cx_api_faulty_call
        MESSAGE e002(/scwm/hu_api).
      "Enter a handling unit
    ENDIF.

    DATA(lv_huguid) = create-zr_ewm_handlingunitstatustp[ 1 ]-HandlingUnitUUID.
   select single docid
          from /scwm/huref
          where guid_hu = @lv_huguid
          into @doc_uuid.

   APPEND VALUE #( docid = doc_uuid ) TO lt_sp_k_head.

"Lock delivery
   lo_sp_prd_in->/scdl/if_sp1_locking~lock(
    EXPORTING
      inkeys       = lt_sp_k_head
      aspect       = /scdl/if_sp_c=>sc_asp_head
      lockmode     = 'E'
    IMPORTING
      rejected     = lv_rejected
      return_codes = lt_return_codes ).

    DATA(lo_mover) = cl_abap_corresponding=>create_with_value(
        source      = it_huident
        destination = lt_huident
        mapping     = VALUE #( ( kind = 1  dstname = 'HUIDENT' srcname = 'HUIDENT' )
                               ( kind = 16 dstname = 'LGNUM'   value   = REF #( create-zr_ewm_handlingunitstatustp[ 1 ]-EWMWarehouse ) ) ) ).
    lo_mover->execute(
      EXPORTING
        source      = it_huident
      CHANGING
        destination = lt_huident ).

    DATA(lo_log) = NEW /scwm/cl_log( ).
    DATA(mo_load) = NEW /scwm/cl_load(  ).

    try.
        /scwm/cl_load=>obd_hu(
          exporting
            io_log     = lo_log     " Log
            iv_cancel  =  ' ' " reverse loading
            it_huident = lt_huident " HUs for loading
          importing
            ev_error   = DATA(ev_error)   " error / warning occured
            ev_post    = DATA(ev_post)    " WT / delivery to be posted
            et_return  = DATA(et_return) ).
      catch /scwm/cx_sr_error.
        "handle exception
    endtry.

        "Save changes
    lo_sp_prd_in->/scdl/if_sp1_transaction~save(
      EXPORTING
        synchronously = abap_false
      IMPORTING
        rejected      = lv_rejected ).


    "remove lock
    lo_sp_prd_in->/scdl/if_sp1_transaction~cleanup(  reason = 'END' ).
  ELSEIF create-zr_handlingunittp IS NOT INITIAL.
    DATA: ls_huhdr       TYPE /SCWM/S_HUHDR_INT.
      DATA: lo_wm_packing  TYPE REF TO /SCWM/CL_WM_PACKING,
            gs_workstation TYPE /SCWM/TWORKST.
      CREATE OBJECT lo_wm_packing.

    DATA(ls_create) = create-zr_handlingunittp[ 1 ].

        CALL FUNCTION '/SCWM/TO_INIT_NEW'
          EXPORTING
            iv_lgnum = ls_create-Warehouse.

          CALL FUNCTION '/SCWM/TWORKST_READ_SINGLE'
        EXPORTING
          iv_lgnum       = ls_create-Warehouse
          iv_workstation = 'Y831'
        IMPORTING
          es_workst      = gs_workstation
*          es_wrktyp      = gs_worksttyp
        EXCEPTIONS
          OTHERS         = 3.

        CALL METHOD lo_wm_packing->init_by_workstation
          EXPORTING
            is_workstation   = gs_workstation
            ir_bin           = VALUE #( sign = 'I' option = 'EQ'
                                        ( low = ls_create-StorageBin
                                          high = ' ' ) )
          EXCEPTIONS
            error            = 1
            others           = 2
                .
        IF sy-subrc <> 0.
*         Implement suitable error handling here
        ENDIF.
        SELECT SINGLE scm_matid_guid16 FROM mara INTO @DATA(lv_packing_material_uuid) WHERE matnr = @ls_create-PackagingMaterial.

        CALL METHOD lo_wm_packing->/scwm/if_pack_bas~create_hu
          EXPORTING
            iv_pmat      = lv_packing_material_uuid
            IV_HUIDENT   = ls_create-HandlingUnitExternalID
            i_location   = ls_create-StorageBin
          receiving
            es_huhdr     = ls_huhdr
          EXCEPTIONS
            error        = 1
            others       = 2
                .
        IF sy-subrc <> 0.
*         Implement suitable error handling here
        ENDIF.
        CALL METHOD lo_wm_packing->/scwm/if_pack_bas~save
          EXPORTING
            iv_commit = ' '
            iv_wait   = ' '
          EXCEPTIONS
            error     = 1
            others    = 2
                .

        CALL METHOD /scwm/cl_wm_packing=>/scwm/if_pack_bas~cleanup.

  ENDIF.

ENDMETHOD.

  METHOD verify_luw.
    TRY.
        CAST /scwm/if_tm( /scwm/cl_tm_factory=>get_service( /scwm/cl_tm_factory=>sc_manager ) )->check_luw_consistent( ).
      CATCH /scwm/cx_tm_check INTO DATA(lx_luw).
        cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_luw ).
        RAISE EXCEPTION TYPE /scwm/cx_api_faulty_call
          MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
          EXPORTING
            previous = lx_luw.
    ENDTRY.
  ENDMETHOD.

endclass.
