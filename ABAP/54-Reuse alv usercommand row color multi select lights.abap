//////////////TOP///////////////
*&---------------------------------------------------------------------*
*&  Include           ZFX_EXAMPLE_3_TOP
*&---------------------------------------------------------------------*
"Alv
data go_grid type REF TO cl_gui_alv_grid.

"Tables
TABLES: ekko,ekpo.

data: gt_ekko type TABLE OF ekko WITH HEADER LINE,
      gt_ekpo type TABLE OF ekpo WITH HEADER LINE.

"Total table
types: begin of gty_table,
         light,
         select,
         COLOR type char4,
         ebeln type ekko-ebeln,
         bsart type ekko-bsart,
         aedat type ekko-aedat,
         ernam type ekko-ernam,
         txz01 type ekpo-txz01,
       end of gty_table.

"Total table
data gt_table type TABLE OF gty_table  WITH HEADER LINE.

"Fieldcatalog
data:gt_fcat type SLIS_T_FIELDCAT_ALV,
     gs_fcat type slis_fieldcat_alv.

"Layout
  DATA gs_layout TYPE SLIS_LAYOUT_ALV.

/////////////FRM///////////////

*&---------------------------------------------------------------------*
*&  Include           ZFX_EXAMPLE_3_FRM
*&---------------------------------------------------------------------*
form get_data.

  select ebeln bsart aedat ernam from ekko into corresponding fields of table gt_ekko.

  select ebeln aedat txz01 from ekpo
    into corresponding fields of table gt_ekpo
    for all entries in gt_ekko where ebeln eq gt_ekko-ebeln.

  loop at gt_ekko.


    gt_table-ebeln = gt_ekko-ebeln.
    gt_table-bsart = gt_ekko-bsart.
    gt_table-aedat = gt_ekko-aedat.
    gt_table-ernam = gt_ekko-ernam.

    append gt_table to gt_table[].

    clear gt_table.

    loop at gt_ekpo where ebeln eq gt_ekko-ebeln.

      gt_table-aedat = gt_ekpo-aedat.
      gt_table-txz01 = gt_ekpo-txz01.

      append gt_table to gt_table[].

      clear gt_table.

    endloop.

  endloop.

LOOP AT gt_table ASSIGNING FIELD-SYMBOL(<gfs_table>).

IF <gfs_table>-ebeln eq 0. "Row color
<gfs_table>-COLOR = 'C411'.
<gfs_table>-light = 1. "Lights 1 red 2 orange 3 red
ELSE.
<gfs_table>-COLOR = 'C310'.
ENDIF.


ENDLOOP.

endform.


form display_alv.

call function 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
   I_CALLBACK_PROGRAM                = sy-repid
   I_CALLBACK_PF_STATUS_SET          = 'PF_STATUS_SET'
   I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
   IS_LAYOUT                         = gs_layout
   IT_FIELDCAT                       =  gt_fcat
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
*   I_SAVE                            = ' '
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  tables
    t_outtab                          = gt_table.


endform.

"Field catalgo
form set_fcat.

   perform create_fcat using 'EBELN' 'EKKO'.
   perform create_fcat using 'BSART' 'EKKO'.
   perform create_fcat using 'AEDAT' 'EKKO'.
   perform create_fcat using 'ERNAM' 'EKKO'.
   perform create_fcat using 'AEDAT' 'EKPO'.
   perform create_fcat using 'TXZ01' 'EKPO'.

endform.

"Field catalgo
form create_fcat using p_field_name
                       p_ref_table.

  clear gs_fcat.
  gs_fcat-fieldname = p_field_name.
  gs_fcat-ref_fieldname = p_field_name.
  gs_fcat-ref_tabname = p_ref_table.
  APPEND gs_fcat to gt_fcat.

endform.


"Layotu işlemleri
FORM set_layout.
gs_layout-zebra = 'X'.
gs_layout-colwidth_optimize = 'X'.
gs_layout-info_fieldname = 'COLOR'. "Row color
gs_layout-box_fieldname  = 'SELECT'. "Multi select
gs_layout-lights_fieldname = 'LIGHT'. "Light
ENDFORM.


"User command
FORM USER_COMMAND USING p_ucomm      type sy-ucomm
                        ps_selfield TYPE SLIS_SELFIELD.

DATA: lv_index type i,
      lv_text type string,
      lv_index_c type char2.


    CASE P_ucomm."Multi select totatl rows
     WHEN '&MSG'.
       LOOP at gt_table WHERE select eq 'X'.
         lv_index = lv_index + 1.
         lv_index_c = lv_index.
         CONCATENATE
                  lv_text
                  lv_index_c
                  '-'
                  gt_table-aedat
                  INTO lv_text
                  SEPARATED BY space.
         ENDLOOP.

      MESSAGE lv_text TYPE 'I'.

      ENDCASE.

ENDFORM.

"Status bar ekleme
FORM PF_STATUS_SET USING p_extab type SLIS_T_EXTAB.
  set PF-STATUS 'STANDARD'.
ENDFORM.