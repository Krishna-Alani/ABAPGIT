CLASS lhc_zr_ewm_print_labelstp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_ewm_print_labelstp RESULT result.
    METHODS printbinlabel FOR MODIFY
      IMPORTING keys FOR ACTION zr_ewm_print_labelstp~printbinlabel.
    METHODS precheck_create FOR PRECHECK
      IMPORTING entities FOR CREATE zr_ewm_print_labelstp.

ENDCLASS.

CLASS lhc_zr_ewm_print_labelstp IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD PrintBinLabel.

         READ ENTITIES of zr_ewm_print_labelstp IN LOCAL MODE ENTITY zr_ewm_print_labelstp
         ALL FIELDS
         WITH VALUE #( ( SpoolRequestNumber = keys[ 1 ]-SpoolRequestNumber ) )
         RESULT data(BinLabel).
         IF sy-subrc EQ 0.
         ENDIF.
  ENDMETHOD.

  METHOD precheck_create.
*    LOOP AT entities INTO DATA(entity) WHERE EWMWarehouse IS NOT INITIAL.
*      APPEND VALUE #( %cid        = entity-%cid
*                      %key        = entity-%key
*                      %create     = if_abap_behv=>mk-on ) TO failed-zr_ewm_print_labelstp.
*      APPEND VALUE #( %cid        = entity-%cid
*                      %key        = entity-%key
*                      %msg        = new_message_with_text(
*                                      severity = if_abap_behv_message=>severity-error
*                                      text     = 'Warehouse is not valid - BTPRFC'
*                                    ) ) TO reported-zr_ewm_print_labelstp.
*
*    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zr_ewm_print_labelstp DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zr_ewm_print_labelstp IMPLEMENTATION.

  METHOD save_modified.

    DATA(lv_action) = create-zr_ewm_print_labelstp[ 1 ]-action.
    DATA(lv_huid) = create-zr_ewm_print_labelstp[ 1 ]-HandlingUnitExternalID.
    DATA(lv_lgnum) = create-zr_ewm_print_labelstp[ 1 ]-EWMWareHouse.
    DATA(lv_lgpla_from) = create-zr_ewm_print_labelstp[ 1 ]-StorageBinFrom.
    DATA(lv_lgpla_to) = create-zr_ewm_print_labelstp[ 1 ]-StorageBinTo.
    DATA(lv_ldest) = create-zr_ewm_print_labelstp[ 1 ]-OutputDevice.
    DATA(lv_copies) = create-zr_ewm_print_labelstp[ 1 ]-NumberOfCopies.
    DATA(lv_ebeln) = create-zr_ewm_print_labelstp[ 1 ]-PurchaseOrder.

CALL FUNCTION 'ZEWM_PRINT_LABELS' DESTINATION 'NONE'
  EXPORTING
    iv_action       = lv_action
    iv_huid         = lv_huid
    iv_lgnum        = lv_lgnum
    iv_lgpla_from   = lv_lgpla_from
    iv_lgpla_to     = lv_lgpla_to
    iv_ldest        = lv_ldest
    iv_copies       = lv_copies
    iv_ebeln        = lv_ebeln
          .
*  CASE create-zr_ewm_print_labelstp[ 1 ]-action.
*  WHEN 'HULABEL'.
*
*  DATA lo_message_box TYPE REF TO /scdl/cl_sp_message_box.
*   DATA(lo_sp_prd_in) = new /scdl/cl_sp_prd_inb( io_message_box =  lo_message_box ).
*
*    DATA: lv_lgnum   TYPE /scwm/lgnum,
*          lr_huident TYPE rseloption,
*          lt_huhdr   TYPE TABLE OF /scwm/huhdr,
*          lt_huhdr_int TYPE /scwm/tt_huhdr_int.
*
*    APPEND VALUE #( sign = 'I' option = 'EQ'
*                    low = create-zr_ewm_print_labelstp[ 1 ]-HandlingUnitExternalID
*                    high = '' ) TO lr_huident.
*    CALL FUNCTION '/SCWM/HU_SELECT_HUHDR'
*      EXPORTING
*        iv_lgnum    = lv_lgnum
*        ir_huident  = lr_huident
*      IMPORTING
*        et_huhdr    = lt_huhdr
*      EXCEPTIONS
*        wrong_input = 1
*        OTHERS      = 2.
*
*    IF sy-subrc <> 0.
*    ENDIF.
*
*    lt_huhdr_int = CORRESPONDING #( lt_huhdr ).
*
*    DATA: lo_output_mgmt TYPE REF TO /scwm/if_af_output_mgmt.
*
*    "get adapter framework service instance (classic or S/4 EWM)
*    lo_output_mgmt ?= /scdl/cl_af_management=>get_instance( )->get_service( EXPORTING iv_service = /scwm/if_af_output_mgmt=>sc_service ).
*
*    lo_output_mgmt->print_hu_mon(
*      EXPORTING
*        it_huhdr       = lt_huhdr_int
*        iv_caller      = wmegc_hu_processing
*        iv_hustep      = 'P'
*        iv_nodialog    = abap_true
*        iv_reprint     = abap_false
*        iv_noexe       = abap_false
**      IMPORTING
**        et_protocol    = lt_protocol
**        et_contexts    = lt_contexts
*      EXCEPTIONS
*        no_previous_print       = 1
*        error_on_log_save       = 2
*        previous_print          = 3
*        OTHERS                  = 4
*           ).
*
*    IF sy-subrc <> 0.
*    ENDIF.
*
*  "BOPF Handling
*  DATA(lo_bopf_manager) = /scwm/cl_bopf_manager=>get_instance( ).
*
*  " This will be done once in the CHECK_SAVE of EWM Transaction Manager
*  lo_bopf_manager->do_pre_commit( ).
*
*        "Save changes
*    lo_sp_prd_in->/scdl/if_sp1_transaction~save(
*      EXPORTING
*        synchronously = abap_false
*      IMPORTING
*        rejected      = DATA(lv_rejected) ).
*
*  /scwm/cl_tm=>cleanup( ).
*    WHEN 'BINLABEL'.
*
*    WHEN OTHERS.
*    ENDCASE.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
