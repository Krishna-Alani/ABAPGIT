CLASS lhc_zr_ewm_outbdelivorderheade DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_ewm_outbdelivorderheadertp RESULT result.

ENDCLASS.

CLASS lhc_zr_ewm_outbdelivorderheade IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.



CLASS lsc_zr_ewm_outbdelivorderheade DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zr_ewm_outbdelivorderheade IMPLEMENTATION.

  METHOD save_modified.
DATA:
*      lo_sp     TYPE REF TO /scdl/cl_sp,
      lt_outrec TYPE /scdl/t_sp_a_head ##NEEDED,
      IT_WHR_KEY TYPE /SCDL/T_SP_K_HEAD.

    IF update-zr_ewm_outbdelivorderstatustp IS NOT INITIAL AND update-zr_ewm_outbdelivorderstatustp[ 1 ]-DeliveryStatusType EQ 'DLO' .
    /scwm/cl_api_helper_sap=>get_instance( )->verify_luw( ).
    /scwm/cl_api_helper_sap=>get_instance( )->CHECK_AND_SET_WHNO( update-zr_ewm_outbdelivorderstatustp[ 1 ]-EWMWarehouse ).

    data(lo_sp) = NEW /scdl/cl_sp_prd_out(
        io_message_box       = NEW /scdl/cl_sp_message_box( )
        iv_doccat            = /scdl/if_dl_doc_c=>sc_doccat_out_prd
        io_attribute_handler = NEW /scwm/cl_dlv_ah_adapter( ) ).
    lo_sp->get_message_box( )->cleanup( ).
    " There is no actual WT creation, because class /SCWM/CL_IM_SP_EX_ASPECT
    " uses the non-WT constants of the wmesr_act_* group for simple loading.
    " The API will act like /SCWM/PRDO and call /SCWM/TO_POST to save the HU
    " status anyway to keep the behavior identical.
 "   SET HANDLER on_wt_created.
    " no check for sy-subrc, ABAP will ignore double registration
    " when method is called multiple times before Save

    DATA(lv_docid) = update-zr_ewm_outbdelivorderstatustp[ 1 ]-EWMOutboundDeliveryOrder.
    SELECT SINGLE docid FROM /SCDL/DB_PROCI_O INTO @DATA(lv_docuuid) WHERE docno = @lv_docid.
*    READ ENTITIES OF ZR_EWM_OutbDelivOrderHeaderTP IN LOCAL MODE ENTITY zr_ewm_outbdelivorderstatustp
*    fields ( deliveryuuid ) with value #( ( EWMOutboundDeliveryOrder = update-zr_ewm_outbdelivorderstatustp[ 1 ]-EWMOutboundDeliveryOrder ) ) RESULT DATA(ewm_status).


    APPEND VALUE #( docid = lv_docuuid ) to it_whr_key.
    lo_sp->execute(
      EXPORTING
        aspect     = /scdl/if_sp_c=>sc_asp_head
        inkeys     = it_whr_key
        action     = /scwm/if_sp_c=>sc_act_loading
      IMPORTING
        outrecords = lt_outrec ).
    DATA(eo_message) = NEW /scwm/cl_dlv_message_api( ).
    CAST /scwm/cl_dlv_message_api( eo_message )->add_dlv(
        io_message = lo_sp->get_message_box( ) ).

    lo_sp->/SCDL/IF_SP1_TRANSACTION~SAVE(
    EXPORTING
        synchronously = abap_false
      IMPORTING
        rejected      = data(lv_rejected) ).

    lo_sp->get_message_box( )->cleanup( ).
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
