class ZCL_ZAPI_BIN_LABEL_PRI_DPC_EXT definition
  public
  inheriting from ZCL_ZAPI_BIN_LABEL_PRI_DPC
  create public .

public section.
protected section.

  methods BIN_LABELSET_CREATE
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZAPI_BIN_LABEL_PRI_DPC_EXT IMPLEMENTATION.


  method BIN_LABELSET_CREATE.

  DATA: lr_lgpla TYPE RANGE OF lgpla.
  APPEND VALUE #( sign = 'I' option = 'EQ' low = '011.01.02.04' high = ' ' ) TO lr_lgpla.
            SUBMIT /scwm/r_bin_print
*                    WITH p_autor ...
                    WITH p_bin EQ 'X'
                    WITH p_copis EQ '1'
                    WITH p_datas EQ 'BinPri'
                    WITH p_formu EQ '/SCWM/BIN_LABEL'
*                    WITH p_kind ...
                    WITH p_ldest EQ 'LP01'
*                    WITH p_lgber ...
                    WITH p_lgnum EQ '1710'
*                    WITH p_lgtyp ...
                    WITH p_tddel EQ 'X'
                    WITH p_tdimm EQ 'X'
                    WITH p_tdnew EQ 'X'
*                    WITH p_verif ...
                    WITH s1_lgpla IN lr_lgpla.

  endmethod.
ENDCLASS.
