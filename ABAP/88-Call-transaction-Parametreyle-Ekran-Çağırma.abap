
  METHOD handle_hotspot_click.

    READ TABLE gt_sas INTO DATA(ls_sas) INDEX es_row_no-row_id.
    IF sy-subrc = 0.
      IF e_column_id-fieldname = 'EBELN'.
        DATA(lv_sas) = ls_sas-ebeln(1).
        IF lv_sas = '6'.
          SET PARAMETER ID 'ANF' FIELD ls_sas-ebeln.
          CALL TRANSACTION 'ME43' AND SKIP FIRST SCREEN.
        ELSE.
          SET PARAMETER ID 'BES' FIELD ls_sas-ebeln.
          CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.                    "HANDLE_HOTSPOT_CLICK
