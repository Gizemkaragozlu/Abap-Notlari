*&---------------------------------------------------------------------*
*& Report ZFC_EXAMPLE_8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zfc_example_8.

DATA :it_scarr type standard TABLE OF scarr,
      it_spfli            TYPE Standard TABLE OF spfli,
      lo_alv              TYPE REF TO cl_salv_hierseq_table,
      v_vbeln             TYPE vbeln_vf.
*SELECT-OPTIONS s_vbeln for v_vbeln.

START-OF-SELECTION.
  PERFORM get_data.

END-OF-SELECTION.
  PERFORM show_output.

*&-------------------------------------------------------------*
*& FormGET_DATA
*&-------------------------------------------------------------*
FORM get_data.
 select * from spfli INTO TABLE it_spfli.
 select * from  scarr INTO TABLE it_scarr.
ENDFORM.
*&-------------------------------------------------------------*
*& FormSHOW_OUTPUT
*&-------------------------------------------------------------*
FORM show_output.
  DATA: lt_key type salv_t_hierseq_binding,
        lw_key                           LIKE LINE OF lt_key,
        lcx_data_err                     TYPE REF TO cx_salv_data_error,
        lcx_not_found                    TYPE REF TO cx_salv_not_found.
  lw_key-master = 'CARRID'.
  lw_key-slave = 'CARRID'.
  APPEND lw_key to lt_key.
  TRY.
      CALL method cl_salv_hierseq_table=>factory
      EXPORTING
      t_binding_level1_level2 = lt_key
      IMPORTING
      r_hierseq = lo_alv
      CHANGING
      t_table_level1 = it_scarr
      t_table_level2 = it_spfli.
    CATCH cx_salv_data_error into lcx_data_err.
    CATCH cx_salv_not_found into lcx_not_found.
  ENDTRY.

  DATA: lo_functions TYPE REF TO cl_salv_functions_list.
  lo_functions = lo_alv->get_functions( ).
  lo_functions->set_all( abap_true ).

  lo_alv->display( ).
ENDFORM.