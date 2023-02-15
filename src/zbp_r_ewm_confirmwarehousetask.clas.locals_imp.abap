CLASS lhc_zr_ewm_confirmwarehousetas DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_ewm_confirmwarehousetasktp RESULT result.

ENDCLASS.

CLASS lhc_zr_ewm_confirmwarehousetas IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zr_ewm_confirmwarehousetas DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zr_ewm_confirmwarehousetas IMPLEMENTATION.

  METHOD save_modified.

      DATA: ls_huhdr       TYPE /SCWM/S_HUHDR_INT,
            ls_quantity    TYPE /SCWM/S_QUAN.
      DATA: lo_wm_packing  TYPE REF TO /SCWM/CL_WM_PACKING,
            gs_workstation TYPE /SCWM/TWORKST.
      CREATE OBJECT lo_wm_packing.
    if create-zr_ewm_confirmwarehousetasktp is not initial.

    DATA(ls_create) = create-zr_ewm_confirmwarehousetasktp[ 1 ].

        CALL FUNCTION '/SCWM/TO_INIT_NEW'
          EXPORTING
            iv_lgnum = ls_create-EWMWarehouse.

          CALL FUNCTION '/SCWM/TWORKST_READ_SINGLE'
        EXPORTING
          iv_lgnum       = ls_create-EWMWarehouse
          iv_workstation = ls_create-WarehouseProcessType
        IMPORTING
          es_workst      = gs_workstation
*          es_wrktyp      = gs_worksttyp
        EXCEPTIONS
          OTHERS         = 3.

        CALL METHOD lo_wm_packing->init_by_workstation
          EXPORTING
            is_workstation   = gs_workstation
            ir_bin           = VALUE #( sign = 'I' option = 'EQ'
                                        ( low = ls_create-SourceStorageBin
                                          high = ' ' ) )
          EXCEPTIONS
            error            = 1
            others           = 2
                .
        IF sy-subrc <> 0.
*         Implement suitable error handling here
        ENDIF.

      IF ls_create-ProductName IS NOT INITIAL.
        SELECT SINGLE scm_matid_guid16 FROM mara INTO @DATA(lv_packing_material_uuid) WHERE matnr = @ls_create-ProductName.
        CALL METHOD lo_wm_packing->/scwm/if_pack_bas~create_hu
          EXPORTING
            iv_pmat      = lv_packing_material_uuid
            i_location   = ls_create-SourceStorageBin
          receiving
            es_huhdr     = ls_huhdr
          EXCEPTIONS
            error        = 1
            others       = 2
                .
        IF sy-subrc <> 0.
*         Implement suitable error handling here
        ENDIF.
      ENDIF.
    SELECT guid_hu, huident FROM /scwm/huhdr INTO TABLE @DATA(lt_hu)
                            WHERE ( huident = @ls_create-SourceHandlingUnit
                            OR      huident = @ls_create-DestinationHandlingUnit ).
    IF lt_hu IS NOT INITIAL.
      DATA(lv_guid_source) = lt_hu[ huident = ls_create-SourceHandlingUnit ]-guid_hu.
    ENDIF.
    IF ls_create-DestinationHandlingUnit IS NOT INITIAL.
      DATA(lv_guid_destination) = lt_hu[ huident = ls_create-DestinationHandlingUnit ]-guid_hu.
    ELSE.
      lv_guid_destination = ls_huhdr-guid_hu.
    ENDIF.

    SELECT SINGLE GUID_STOCK FROM /scwm/aqua INTO @DATA(lv_guid_stock_source)
                             WHERE guid_parent = @lv_guid_source.

    ls_quantity-unit = ls_create-BaseUnit.
    ls_quantity-quan = ls_create-TargetQuantityInBaseUnit.
    CALL METHOD lo_wm_packing->/SCWM/IF_PACK_BAS~REPACK_STOCK
      EXPORTING
        iv_dest_hu    = lv_guid_destination
        iv_source_hu  = lv_guid_source
        iv_stock_guid = lv_guid_stock_source
        is_quantity   = ls_quantity
      EXCEPTIONS
        error         = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
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
    endif.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
