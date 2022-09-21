----------------TOP------------------
*&---------------------------------------------------------------------*
*&  Include           ZFC_EXAMPLE_13_TOP
*&---------------------------------------------------------------------*

data: BEGIN OF gt_table occurs 0,"Data
      line type char4,"Line color
      sel."Selectable rows
      INCLUDE STRUCTURE zfc_scarr."Structe table columns adding
data: END OF  gt_table.


data: gs_layout TYPE SLIS_LAYOUT_ALV."Alv layout


------------------FRM-----------------------
*&---------------------------------------------------------------------*
*&  Include           ZFC_EXAMPLE_13_FRM
*&---------------------------------------------------------------------*
form get_data.
  select * from zfc_scarr into CORRESPONDING FIELDS OF table gt_table.
endform.

form display_alv.
  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
     I_CALLBACK_PROGRAM                = sy-repid
     I_CALLBACK_PF_STATUS_SET          = 'PF_STATUS_SET'
     I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
     I_STRUCTURE_NAME = 'ZFC_SCARR'
      is_layout   = gs_layout
    tables
      t_outtab    = gt_table
    .
endform.

form set_layout.
  gs_layout-zebra = 'X'."Zebra desen
  gs_layout-box_fieldname = 'SEL'. "Column select enable
  gs_layout-info_fieldname = 'LINE'."Line color
endform.


FORM PF_STATUS_SET USING p_extab type SLIS_T_EXTAB.
  set PF-STATUS 'STANDARD'.
ENDFORM.


FORM USER_COMMAND USING p_ucomm      type sy-ucomm
                        ps_selfield TYPE SLIS_SELFIELD.
CASE p_ucomm.
  WHEN '&INF'.
    data : lv_sel TYPE string,
          lv_ttl type i,
          lv_ttl_c type char2.
     LOOP AT gt_table WHERE sel eq 'X'.
       CONCATENATE lv_sel gt_table-carrid INTO lv_sel SEPARATED BY space.
       add 1 to lv_ttl."i = i + 1
     ENDLOOP.
     lv_ttl_c = lv_ttl.
     CONCATENATE lv_sel lv_ttl_c 'Selected Rows' INTO lv_sel SEPARATED BY space.
     MESSAGE lv_sel TYPE 'I'.

     clear gt_table."Clear structre
     gt_table-url = lv_sel."Url column add selected column carrid
     gt_table-line = 'C511'."line color change
     APPEND gt_table."Append table extra line

     ps_selfield-REFRESH = 'X'."Refresh reuse alv

ENDCASE.

ENDFORM.

--------------MAIN----------------
*&---------------------------------------------------------------------*
*& Report ZFC_EXAMPLE_13
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_EXAMPLE_13.
include ZFC_EXAMPLE_13_top.
include ZFC_EXAMPLE_13_frm.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM set_layout.
  PERFORM display_alv.