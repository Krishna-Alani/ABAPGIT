class ZCL_ZAPI_BIN_LABEL_PRI_MPC definition
  public
  inheriting from /IWBEP/CL_V4_ABS_MODEL_PROV
  create public .

public section.

  types:
     begin of TS_BIN_LABEL,
         LGNUM type C length 3,
     end of TS_BIN_LABEL .
  types:
     TT_BIN_LABEL type standard table of TS_BIN_LABEL .

  methods /IWBEP/IF_V4_MP_BASIC~DEFINE
    redefinition .
protected section.
private section.

  methods DEFINE_BIN_LABEL
    importing
      !IO_MODEL type ref to /IWBEP/IF_V4_MED_MODEL
    raising
      /IWBEP/CX_GATEWAY .
ENDCLASS.



CLASS ZCL_ZAPI_BIN_LABEL_PRI_MPC IMPLEMENTATION.


  method /IWBEP/IF_V4_MP_BASIC~DEFINE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 25.01.2023 06:02:32 in client 220
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the MPC implementation, use the
*&*   generated methods inside MPC subclass - ZCL_ZAPI_BIN_LABEL_PRI_MPC_EXT
*&-----------------------------------------------------------------------------------------------*
  define_bin_label( io_model ).
  endmethod.


  method DEFINE_BIN_LABEL.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 25.01.2023 06:02:32 in client 220
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the MPC implementation, use the
*&*   generated methods inside MPC subclass - ZCL_ZAPI_BIN_LABEL_PRI_MPC_EXT
*&-----------------------------------------------------------------------------------------------*

 DATA lo_entity_type    TYPE REF TO /iwbep/if_v4_med_entity_type.
 DATA lo_property       TYPE REF TO /iwbep/if_v4_med_prim_prop.
 DATA lo_entity_set     TYPE REF TO /iwbep/if_v4_med_entity_set.
***********************************************************************************************************************************
*   ENTITY - bin_label
***********************************************************************************************************************************
 lo_entity_type = io_model->create_entity_type( iv_entity_type_name = 'BIN_LABEL' ). "#EC NOTEXT

 lo_entity_type->set_edm_name( 'bin_label' ).               "#EC NOTEXT

***********************************************************************************************************************************
*   Properties
***********************************************************************************************************************************
 lo_property = lo_entity_type->create_prim_property( iv_property_name = 'LGNUM' ). "#EC NOTEXT
 lo_property->set_edm_name( 'LGNUM' ).                      "#EC NOTEXT
 lo_property->set_edm_type( iv_edm_type = 'String' ).       "#EC NOTEXT
 lo_property->set_is_key( ).
 lo_property->set_max_length( iv_max_length = '3' ).        "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
 lo_entity_set = lo_entity_type->create_entity_set( 'BIN_LABELSET' ). "#EC NOTEXT
 lo_entity_set->set_edm_name( 'bin_labelSet' ).             "#EC NOTEXT
  endmethod.
ENDCLASS.
