*&---------------------------------------------------------------------*
*& Report ZFC_EXAMPLE_8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zfc_example_8.

"Scarr tablosu için tablo ve strctre surekli db ye gitmemek için temp taablo içinde işlemler yapcagız
data: gt_list type sorted table of scarr with unique key carrid,
      gt_temp type table of scarr,
      gs_list type scarr.

select * from scarr into table gt_list."ana tablo doldurulur

data(out) = cl_demo_output=>new( )."Yeni sayfa açılır

"/////////////////////////////////////////////////////////////"
"/////////////////////////////////////////////////////////////"
"/////////////////////////////////////////////////////////////"
"Standard loop
loop at gt_list into gs_list.
  append gs_list to gt_temp.
endloop.

out->write( 'LOOP AT gt_list INTO gs_list.' ).
out->write( gt_temp )->line( ).



"/////////////////////////////////////////////////////////////"
"/////////////////////////////////////////////////////////////"
"/////////////////////////////////////////////////////////////"
"LOOP FROM X TO X
clear: gs_list,gt_temp."Temp tablo ve structre temizlenir
loop at gt_list into gs_list from 7 to 8."Tablo içine 7 ve 8. indexi atar sadece
  append gs_list to gt_temp."Temp tablosuna gelen kayıtlar atılır
endloop.
out->write( 'LOOP AT gt_list INTO gs_list FROM 7 TO 8.' ).
out->write( gt_temp )->line( ).


"/////////////////////////////////////////////////////////////"
"/////////////////////////////////////////////////////////////"
"/////////////////////////////////////////////////////////////"
"LOOP WHERE CLAUSE
clear: gs_list,gt_temp.
loop at gt_list into gs_list where currcode <> 'USD'.
  append gs_list to gt_temp.
endloop.
out->write( 'LOOP AT gt_list INTO gs_list WHERE currcode <> USD.' ).
out->write( gt_temp )->line( ).


"/////////////////////////////////////////////////////////////"
"/////////////////////////////////////////////////////////////"
"/////////////////////////////////////////////////////////////"
"LOOP TRANSPORTING NO FIELDS
clear: gs_list,gt_temp.
data: wa_index_set type sy-tabix,
      index_set type TABLE OF i.
loop at gt_list transporting no fields where currcode cs 'USD'.
  wa_index_set = sy-tabix.
  append wa_index_set to index_set.
endloop.
out->write( 'loop at gt_list transporting no fields where currcode cs USD.' ).
out->write( index_set )->line( ).
out->display( ).