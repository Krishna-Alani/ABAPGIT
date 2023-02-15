FUNCTION ZEWM_PRINT_LABELS.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_ACTION) TYPE  CHAR10
*"     VALUE(IV_HUID) TYPE  CHAR20 OPTIONAL
*"     VALUE(IV_LGNUM) TYPE  CHAR4
*"     VALUE(IV_LGPLA_FROM) TYPE  /SCWM/LAGP-LGPLA OPTIONAL
*"     VALUE(IV_LGPLA_TO) TYPE  /SCWM/LAGP-LGPLA OPTIONAL
*"     VALUE(IV_LDEST) TYPE  TSP03-PADEST OPTIONAL
*"     VALUE(IV_EBELN) TYPE  EBELN OPTIONAL
*"     VALUE(IV_COPIES) TYPE  RSPOCOPIES OPTIONAL
*"     VALUE(LS_PRINT_REQUEST) TYPE  ZCW_EWM_R_PRINTREQUESTSTP OPTIONAL
*"----------------------------------------------------------------------

  TYPES : BEGIN OF typ_business_key ,
           huident TYPE /scwm/de_huident ,
           lgnum   TYPE /scwm/lgnum ,
          END OF typ_business_key .

  DATA: lr_huident    TYPE rseloption,
        lt_huhdr      TYPE TABLE OF /scwm/huhdr,
        lt_huhdr_int  TYPE /scwm/tt_huhdr_int,
        ls_hu_key     TYPE typ_business_key,
        lr_lgpla      TYPE RANGE OF /scwm/lagp-lgpla.

  DATA: lo_container TYPE REF TO if_swj_ppf_container,
        lo_partner   TYPE REF TO cl_partner_ppf,
        lv_application_log TYPE  balloghndl,
        lv_preview   TYPE char1.

  DATA: lo_appl_object  TYPE REF TO /scwm/cl_hu_ppf,
        lo_output_mgmt TYPE REF TO /scwm/if_af_output_mgmt.

  CASE iv_action.
  WHEN 'HULABEL'.
    ls_hu_key-huident = iv_huid.
    ls_hu_key-lgnum   = iv_lgnum.
    APPEND VALUE #( sign = 'I' option = 'EQ'
                    low = iv_huid
                    high = '' ) TO lr_huident.
    CALL FUNCTION '/SCWM/HU_SELECT_HUHDR'
      EXPORTING
        iv_lgnum    = iv_lgnum
        ir_huident  = lr_huident
      IMPORTING
        et_huhdr    = lt_huhdr
      EXCEPTIONS
        wrong_input = 1
        OTHERS      = 2.

    IF sy-subrc <> 0.
    ENDIF.

    lt_huhdr_int = CORRESPONDING #( lt_huhdr ).

    "get adapter framework service instance (classic or S/4 EWM)
    lo_output_mgmt ?= /scdl/cl_af_management=>get_instance( )->get_service( EXPORTING iv_service = /scwm/if_af_output_mgmt=>sc_service ).

    LOOP AT lr_huident ASSIGNING FIELD-SYMBOL(<ls_huident>).
      <ls_huident>-option = 'CP'.
      CONCATENATE '*' iv_huid '*' INTO <ls_huident>-low.
    ENDLOOP.
    SELECT applkey FROM ppfttrigg INTO TABLE @DATA(lt_ppfttrigg) WHERE applkey IN @lr_huident.
    IF sy-subrc NE 0.
      "Original Printing
      lo_output_mgmt->print_hu_mon(
        EXPORTING
          it_huhdr       = lt_huhdr_int
          iv_caller      = wmegc_hu_processing
          iv_hustep      = 'P'
          iv_nodialog    = abap_true
          iv_reprint     = abap_false
          iv_noexe       = abap_false
        IMPORTING
          et_protocol    = DATA(lt_protocol)
          et_contexts    = DATA(lt_contexts)
        EXCEPTIONS
          no_previous_print       = 1
          error_on_log_save       = 2
          previous_print          = 3
          OTHERS                  = 4
             ).
      IF sy-subrc <> 0.
      ENDIF.
    ELSE.
      "Original Printing
      lo_output_mgmt->print_hu_mon(
        EXPORTING
          it_huhdr       = lt_huhdr_int
          iv_caller      = wmegc_hu_processing
          iv_hustep      = 'P'
          iv_nodialog    = abap_true
          iv_reprint     = abap_true
          iv_noexe       = abap_true
        IMPORTING
          et_protocol    = lt_protocol
          et_contexts    = lt_contexts
        EXCEPTIONS
          no_previous_print       = 1
          error_on_log_save       = 2
          previous_print          = 3
          OTHERS                  = 4
             ).
      IF sy-subrc <> 0.
      ENDIF.

      DATA: lo_manager_ppf TYPE REF TO CL_MANAGER_PPF.

      lo_manager_ppf = cl_manager_ppf=>get_instance( ).
      DATA(lo_ttypes) = lo_manager_ppf->get_ttypes( io_context = lt_contexts[ 1 ] ).
      lo_manager_ppf->get_active_triggers(
        EXPORTING
*          ip_ttype    =                  " Action Definition
          it_contexts = lt_contexts                 " Action Profile
        IMPORTING
          et_triggers = DATA(lt_triggers)                 " Active Actions
          eo_trigger  = DATA(lo_trigger)                 " Active Actions as Collection
      ).

    CALL METHOD lo_manager_ppf->repeat_trigger
      EXPORTING
        io_context = lt_contexts[ 1 ]
        io_trigger = lt_triggers[ 1 ]
      RECEIVING
        ro_trigger = DATA(l_new_trigger)
      EXCEPTIONS
        OTHERS     = 1.

      CALL METHOD l_new_trigger->execute
        EXCEPTIONS
          OTHERS = 1.

*      lo_appl_object ?= /scwm/ca_hu_ppf=>agent->if_os_ca_persistency~get_persistent_by_key(
*                           i_key   = ls_hu_key ).
*
*      CALL FUNCTION '/SCWM/EXECUTE_PPF_HU'
*        EXPORTING
*          flt_val                  = '/SCWM/HULABEL'
*          io_appl_object           = lo_appl_object
*          io_partner               = lo_partner
*          ip_application_log       = lv_application_log
*          ip_preview               = lv_preview
*          ii_container             = lo_container
*         IP_ACTION                = 'HU_LABEL'
**       IMPORTING
**         RP_STATUS                =
*                .
    ENDIF.

  "BOPF Handling
  DATA(lo_bopf_manager) = /scwm/cl_bopf_manager=>get_instance( ).

  " This will be done once in the CHECK_SAVE of EWM Transaction Manager
  lo_bopf_manager->do_pre_commit( ).

  COMMIT WORK.

  /scwm/cl_tm=>cleanup( ).
    WHEN 'BINLABEL'.

  APPEND VALUE #( sign = 'I' option = 'EQ' low = iv_lgpla_from high = iv_lgpla_to ) TO lr_lgpla.
            SUBMIT /scwm/r_bin_print
*                    WITH p_autor ...
                    WITH p_bin EQ 'X'
                    WITH p_copis EQ iv_copies
                    WITH p_datas EQ 'BinPri'
**                    WITH p_formu EQ '/SCWM/BIN_LABEL'
                    WITH p_kind  EQ ' '
                    WITH p_ldest EQ iv_ldest
                    WITH p_lgber EQ ' '
                    WITH p_lgnum EQ iv_lgnum
                    WITH p_lgtyp EQ ' '
                    WITH p_tddel EQ 'X'
                    WITH p_tdimm EQ 'X'
                    WITH p_tdnew EQ 'X'
                    WITH p_verif EQ ' '
                    WITH s1_lgpla IN lr_lgpla AND RETURN .
    WHEN 'POPRINT'.

  DATA: lt_xnast TYPE STANDARD TABLE OF vnast,
        lt_nast  TYPE STANDARD TABLE OF vnast,
        lt_ynast TYPE STANDARD TABLE OF nast,
        lv_subrc TYPE sy-subrc,
        lv_objkey TYPE NAST-OBJKY.

  lv_objkey = iv_ebeln.
  CALL FUNCTION 'ENQUEUE_EMEKKOE'
    EXPORTING
      ebeln          = iv_ebeln
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.
  CALL FUNCTION 'RV_MESSAGES_READ'
    EXPORTING
      msg_kappl    = 'EF'
      msg_objky    = lv_objkey
      msg_objky_to = lv_objkey.

          CALL FUNCTION 'RV_MESSAGES_GET'
      EXPORTING
        msg_kappl      = 'EF'
        msg_objky_from = lv_objkey
        msg_objky_to   = lv_objkey
      TABLES
        tab_xnast      = lt_xnast
        tab_ynast      = lt_ynast.

      SORT lt_xnast BY erdat eruhr DESCENDING.
      READ TABLE lt_xnast INTO DATA(ls_nast) WITH KEY vstat = 0.
      IF sy-subrc EQ 0.
        ls_nast-ldest = iv_ldest.
        APPEND ls_nast TO lt_nast.
        CALL FUNCTION 'RV_MESSAGES_MODIFY'
          TABLES
            tab_xnast       = lt_nast
                  .
      ELSE.
        LOOP AT lt_xnast INTO ls_nast WHERE nacha = 1.
         EXIT.
        ENDLOOP.
        ls_nast-ldest = iv_ldest.
        APPEND ls_nast TO lt_nast.
        CALL FUNCTION 'RV_MESSAGES_INSERT'
          TABLES
            tab_xnast = lt_nast.
       ENDIF.
        CALL FUNCTION 'RV_MESSAGES_UPDATE'
          EXPORTING
            msg_no_update_task = ' '.

        COMMIT WORK AND WAIT.
*      IF line_exists( lt_xnast[ vstat = '0' ] ).
*        CALL FUNCTION 'WFMC_MESSAGE_SINGLE'
*          EXPORTING
*            pi_nast  = ls_nast
*          IMPORTING
*            pe_rcode = lv_subrc.
*        COMMIT WORK.
*      ENDIF.
  CALL FUNCTION 'DEQUEUE_EMEKKOE'
    EXPORTING
      ebeln = iv_ebeln.
    WHEN OTHERS.
    ENDCASE.

ENDFUNCTION.
