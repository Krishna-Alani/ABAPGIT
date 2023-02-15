CLASS zcl_ce_printrequests DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ce_printrequests IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    DATA: lt_result TYPE STANDARD TABLE OF zcw_ewm_ce_printrequests,
          ls_result TYPE zcw_ewm_ce_printrequests.

    ls_result-EWMWarehouse = '1710'.
    APPEND ls_result TO lt_result.

    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records( lines( lt_result ) ).
      io_response->set_data( lt_result ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
