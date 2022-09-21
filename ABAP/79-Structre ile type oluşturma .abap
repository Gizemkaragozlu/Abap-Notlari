*&---------------------------------------------------------------------*
report zfc_example_8.
data: begin of gs_tab.
        include structure scarr.
      data: end of gs_tab.

data:gt_fcat type slis_t_fieldcat_alv.

data: gt_tab  like sorted table of gs_tab with unique key carrid,
      gt_itab type table of scarr.