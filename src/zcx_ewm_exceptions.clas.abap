CLASS zcx_ewm_exceptions DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message .
    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .

    CONSTANTS:
      BEGIN OF handlingunit_unknown,
        msgid TYPE symsgid VALUE 'ZEWM_S4',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE 'HANDLINGUNITEXTERNALID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF handlingunit_unknown ,

      BEGIN OF warehouse_unknown,
        msgid TYPE symsgid VALUE 'ZEWM_S4',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'WAREHOUSE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF warehouse_unknown .

    METHODS constructor
      IMPORTING
        severity  TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL
        handlingunitexternalid TYPE /SCWM/DE_HUIDENT OPTIONAL
        warehouse TYPE /SCWM/LGNUM OPTIONAL .

    DATA: handlingunitexternalid TYPE string READ-ONLY,
          warehouse              TYPE string READ-ONLY.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_ewm_exceptions IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    me->handlingunitexternalid = |{ handlingunitexternalid ALPHA = OUT }|.
    me->warehouse = |{ warehouse ALPHA = OUT }|.
  ENDMETHOD.
ENDCLASS.
