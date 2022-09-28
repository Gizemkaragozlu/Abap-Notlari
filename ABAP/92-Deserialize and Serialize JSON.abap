*&---------------------------------------------------------------------*
*& Report ZFC_EXAMPLE_8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zfc_example_8.

"Json to Itab
data(lv_string) = '[{"kurlar":[{'&&
   '"doviz" : "usd",'&&
   '"alis": "18,4901",'&&
   '"satis": "18,4946",'&&
   '"degisim": "%0,25"},'&&
   '{"doviz" : "eur",'&&
   '"alis": "17,6813",'&&
   '"satis": "17,6991",'&&
   '"degisim": "%0,42"}]}]'.


types :BEGIN OF json,
  doviz type string,
  alis TYPE string,
  satis TYPE string,
  degisim type string,
  END OF json.

types: BEGIN OF ls_json,
  kurlar type STANDARD TABLE OF json WITH EMPTY KEY,
  END OF ls_json.

 data gt_json TYPE TABLE OF ls_json WITH EMPTY KEY.


  /ui2/cl_json=>deserialize(
    exporting
      json             =  lv_string                " JSON string
      pretty_name      =  /ui2/cl_json=>pretty_mode-camel_case                 " Pretty Print property names
    changing
      data             =  gt_json                 " Data to serialize
  ).

cl_demo_output=>write_json( json = lv_string ).
READ TABLE gt_json INTO data(gs_json) INDEX 1.
cl_demo_output=>write( gs_json-kurlar ).


"Itab to json

SELECT *
  FROM scarr
  INTO TABLE @DATA(it_scarr)
  UP TO 3 ROWS.
**Now we convert data geted to a json
data(gv_json_output) = /ui2/cl_json=>serialize( data = it_scarr compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
*We print this information:
cl_demo_output=>display( gv_json_output ).