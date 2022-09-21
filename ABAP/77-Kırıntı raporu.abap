*&---------------------------------------------------------------------*
*& Include          ZPP_R_KIRINTI_RAPOR_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .


  SELECT
        mara~matnr
        makt~maktx
        marc~werks
        marc~dispo
        mseg~bwart
        mara~meins
        mseg~erfmg
        mseg~aufnr
        t024d~dsnam
        caufv~plnbez
        mseg~budat_mkpf
        mseg~menge
      FROM mseg
      INNER JOIN marc ON marc~matnr EQ mseg~matnr
      INNER JOIN caufv ON caufv~aufnr EQ mseg~aufnr
      INNER JOIN t024d ON t024d~dispo EQ marc~dispo
      INNER JOIN mara ON mara~matnr EQ mseg~matnr
      INNER JOIN makt ON makt~matnr EQ mseg~matnr
      INTO CORRESPONDING FIELDS OF TABLE gt_table
      WHERE marc~werks IN s_uretim
      AND mara~matnr IN s_mal_no
      AND marc~dispo IN s_mip
      AND caufv~aufnr IN s_sip
      AND mseg~budat_mkpf IN s_kyt
      AND ( mseg~bwart EQ '531' OR mseg~bwart EQ '532' ).

  SORT gt_table.
  DELETE ADJACENT DUPLICATES FROM gt_table.


  DATA :lv_sum   TYPE int4,
        lv_total TYPE int4,
        lv_sip   TYPE string.

  LOOP AT gt_table ASSIGNING FIELD-SYMBOL(<fs_tab>).
    SELECT SINGLE maktx FROM makt INTO <fs_tab>-maktx2 WHERE matnr EQ <fs_tab>-plnbez.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = gs_layout
      it_fieldcat        = gt_fcat
    TABLES
      t_outtab           = gt_table
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_fcat .

  PERFORM add_fcat USING 'CAUFV' 'PLNBEZ'.
  PERFORM add_fcat2 USING 'MAKTX2' 'MAKT' 'Malzeme Tanımı' 'Malzeme Tnm.' 'Malzm. Tnm.'.
  PERFORM add_fcat USING 'MSEG' 'MENGE'.
  PERFORM add_fcat USING 'MARC' 'WERKS'.
  PERFORM add_fcat USING 'MARC' 'DISPO'.
  PERFORM add_fcat USING 'T024D' 'DSNAM'.
  PERFORM add_fcat2 USING 'MATNR' 'MARA' 'Bileşen Malzeme' 'Bileşen M.' 'Bilş. Mal.'.
  PERFORM add_fcat USING 'MAKT' 'MAKTX'.
  PERFORM add_fcat USING 'MSEG' 'BWART'.
  PERFORM add_fcat USING 'MARA' 'MEINS'.
  PERFORM add_fcat USING 'MSEG' 'ERFMG'.
  PERFORM add_fcat USING 'MSEG' 'AUFNR'.
  PERFORM add_fcat USING 'MSEG' 'BUDAT_MKPF'.
ENDFORM.
*&--------------------------------------------------------------------*
*& Form add_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_fcat USING  p_tab p_field.
  CLEAR gs_fcat.
  gs_fcat-fieldname = p_field.
  gs_fcat-ref_fieldname = p_field.
  gs_fcat-ref_tabname = p_tab.
  APPEND gs_fcat TO gt_fcat.
ENDFORM.


FORM add_fcat2 USING  p_field p_tab p_text_l p_text_m p_text_s .
  CLEAR gs_fcat.
  gs_fcat-fieldname = p_field.
  gs_fcat-ref_tabname = p_tab.
  gs_fcat-seltext_l = p_text_l.
  gs_fcat-seltext_m = p_text_m.
  gs_fcat-seltext_s = p_text_s.
  APPEND gs_fcat TO gt_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .
  gs_layout-colwidth_optimize = 'X'.
  gs_layout-zebra = 'X'.
ENDFORM.