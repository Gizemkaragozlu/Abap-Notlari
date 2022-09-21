------------TOP--------------

TABLES: vbak,vbap.

TYPES: BEGIN OF gtx_list,
         check TYPE char1,
         vbeln TYPE vbeln_va,
         kunnr TYPE kunag,
         erdat TYPE erdat,
         erzet TYPE erzet,
         ernam TYPE ernam,
         waerk TYPE waerk,
         posnr TYPE posnr_va,
         matnr TYPE matnr,
         arktx TYPE arktx,
         netwr TYPE netwr_ap,
       END OF gtx_list.

DATA: gt_list TYPE TABLE OF gtx_list,
      gs_list TYPE gtx_list.

DATA: gt_fcatalog TYPE slis_t_fieldcat_alv,
      gs_fcatalog TYPE slis_fieldcat_alv.

DATA: gs_layout TYPE slis_layout_alv.

DATA: gv_vbeln TYPE vbeln_va,
      gv_erdat TYPE erdat.

DATA: gt_events TYPE slis_t_event,
      gs_event  TYPE slis_alv_event.


---------------SEL----------------
SELECTION-SCREEN BEGIN OF BLOCK can WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS:   s_vbeln FOR gv_vbeln,
                  s_erdat FOR gv_erdat.
SELECTION-SCREEN END OF BLOCK can.


-------------FRM-----------------

FORM get_data .
select
  vbak~vbeln
  vbak~kunnr
  vbak~erdat
  vbak~erzet
  vbak~ernam
  vbak~waerk
  vbap~posnr
  vbap~matnr
  vbap~arktx
  vbap~netwr
INTO CORRESPONDING FIELDS OF TABLE gt_list FROM vbak
INNER JOIN vbap ON vbak~vbeln = vbap~vbeln
WHERE vbak~vbeln IN s_vbeln AND vbak~erdat IN s_erdat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_FC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_fc .

  PERFORM: set_fc_sub USING 'VBELN'     'VBELN' 'Sales Document'      'Sales Document'                  abap_true ' ' 'X',
           set_fc_sub USING 'KUNNR'     'KUNNR' 'Sold-To Party'       'Sold-To Party'                   ' ' ' ' 'X',
           set_fc_sub USING 'ERDAT'     'ERDAT' 'Date'                'Date of Registration'            ' ' ' ' ' ',
           set_fc_sub USING 'ERZET'     'ERZET' 'Entry Time'          'Entry Time'                      ' ' ' ' ' ',
           set_fc_sub USING 'ERNAM'     'ERNAM' 'Name'                'Name of Person'                  ' ' ' ' ' ',
           set_fc_sub USING 'WAERK'     'WAERK' 'Document Currency'   'SD Document Currency'            ' ' ' ' ' ',
           set_fc_sub USING 'POSNR'     'POSNR' 'Sales Document Item' 'Sales Document Item'             ' ' ' ' ' ',
           set_fc_sub USING 'MATNR'     'MATNR' 'Material Number'     'Material Number'                 ' ' ' ' ' ',
           set_fc_sub USING 'ARKTX'     'ARKTX' 'Sales Order Item'    'Sales Order Item'                ' ' ' ' ' ',
           set_fc_sub USING 'NETWR'     'NETWR' 'Document Currency'   'Net Value in Document Currency'  ' ' ' ' ' '.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_layout .

  gs_layout-window_titlebar = 'REUSE ALV RAPOR'.
  gs_layout-zebra = abap_true.
  gs_layout-colwidth_optimize = abap_true.
  gs_layout-box_fieldname = 'CHECK'.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_alv .

  gs_event-name = slis_ev_top_of_page.
  gs_event-form = slis_ev_top_of_page.
  APPEND gs_event  TO gt_events.

  gs_event-name = slis_ev_pf_status_set.
  gs_event-form = slis_ev_pf_status_set. " 'PF_STATUS_SET '.
  APPEND gs_event  TO gt_events.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = 'PF_STATUS_SET '
      i_callback_user_command = 'USER_COMMAND'
*     i_callback_top_of_page  = 'TOP_OF_PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      is_layout               = gs_layout
      it_fieldcat             = gt_fcatalog
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*     IT_SORT                 =
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
*     I_SAVE                  = ' '
*     IS_VARIANT              =
      it_events               = gt_events
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      t_outtab                = gt_list
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SET_FC_SUB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_fc_sub USING p_fieldname
                      p_seltext_s
                      p_seltext_m
                      p_seltext_l
                      p_key
                      p_edit
                      p_hotspot.
  CLEAR:gs_fcatalog.
  gs_fcatalog-fieldname = p_fieldname.
  gs_fcatalog-seltext_s = p_seltext_s.
  gs_fcatalog-seltext_m = p_seltext_m.
  gs_fcatalog-seltext_l = p_seltext_l.
  gs_fcatalog-key       = p_key.
  gs_fcatalog-edit      = p_edit.
  gs_fcatalog-hotspot   = p_hotspot.
  APPEND gs_fcatalog TO gt_fcatalog.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM top_of_page.

  DATA: lt_header  TYPE slis_t_listheader,
        ls_header  TYPE slis_listheader,
        lv_date    TYPE char10,
        lv_lines   TYPE i,
        lv_lines_c TYPE char4.

  CLEAR ls_header.
  ls_header-typ = 'H'.
  ls_header-info = 'ALV Eğitim Raporu'.
  APPEND ls_header TO lt_header.

  CLEAR ls_header.
  ls_header-typ = 'S'.
  ls_header-key = 'Tarih: '.
  CONCATENATE sy-datum+6(2) '.' sy-datum+4(2) '.' sy-datum+0(4) "20220531 tarih formatında olan sy-datum için string dönüşüm.
  INTO lv_date.
  ls_header-info = lv_date.
  APPEND ls_header TO lt_header.

  CLEAR ls_header.

  DESCRIBE TABLE gt_list LINES lv_lines.
  lv_lines_c = lv_lines.

  ls_header-typ = 'A'.
  CONCATENATE 'Raporda ' lv_lines_c 'adet kalem vardır...'
  INTO ls_header-info SEPARATED BY space. "aralara boşluk koyma amaçlı.
  APPEND ls_header TO lt_header.


*
* ls_header-typ = 'S'.
*ls_header-info = 'User Name: '.
*  CONCATENATE ls_header-info v_name
*  INTO ls_header-info.
*  APPEND ls_header TO lt_header.
*  CLEAR ls_header.
*
*  ls_header-typ = 'S'.
*  ls_header-info = 'Date: '.
*  CONCATENATE ls_header-info v_date
*  INTO ls_header-info.
*  APPEND ls_header TO lt_header.
*  CLEAR ls_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_header.
*   I_LOGO                   =
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PF_STATUS_SET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pf_status_set USING p_extab TYPE slis_t_extab.
  SET PF-STATUS 'STANDARD'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM user_command USING p_ucomm TYPE sy-ucomm
                    ps_selfield TYPE slis_selfield .
  DATA: lv_message TYPE char200,
        lv_index   TYPE numc2.
  "DATA : gs_list   TYPE zhc_veri.
  CASE p_ucomm.
    WHEN '&HCA'.
*INSERT zhc_veri FROM gs_list.
      LOOP AT gt_list INTO gs_list WHERE check  EQ 'X'.
        lv_index = lv_index + 1.
        "APPEND gs_list TO zhc_veri.
        "INSERT zhc_veri FROM gs_list.
        "INSERT zhc_veri FROM gs_list.
*        MOVE-CORRESPONDING gs_list to gs_table.
*        INSERT zhc_veri FROM gs_table.
      ENDLOOP.
      CONCATENATE lv_index 'satır ilgili tabloya kaydedildi.'
INTO lv_message SEPARATED BY space.
      MESSAGE lv_message TYPE 'I'.

    WHEN '&IC1'.
      CASE ps_selfield-fieldname.
        WHEN 'MATNR'.
          CONCATENATE ps_selfield-value 'numaralı malzemeye tıklandı.'
          INTO lv_message SEPARATED BY space.
          MESSAGE lv_message TYPE 'I'.
      ENDCASE.
  ENDCASE.
ENDFORM.


-------------MAIN-------------

*&---------------------------------------------------------------------*
*& Report ZHC_ALV_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zhc_alv_22.

INCLUDE zhc_alv_22_top.
INCLUDE zhc_alv_22_sel.
INCLUDE zhc_alv_22_frm.

START-OF-SELECTION.

PERFORM get_data.
PERFORM set_fc.
PERFORM set_layout.
PERFORM display_alv.