*&---------------------------------------------------------------------*
*& Report ZFC_EXAMPLE_9
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_EXAMPLE_9.

data lv_index type i.
data: BEGIN OF gt_table occurs 0,
  index type i.
  include structure scarr.
data: end of gt_table.

START-OF-SELECTION.
select * from scarr INTO CORRESPONDING FIELDS OF table gt_table.

LOOP AT gt_table.
  lv_index = lv_index + 1.
  gt_table-index = lv_index.
  COLLECT gt_table.
ENDLOOP.

LOOP AT gt_Table.
  write gt_table-index.
  write gt_table-carrid.
  write gt_table-carrname.
  write gt_table-currcode.
  write gt_table-url.
ENDLOOP.
BREAK-POINT.