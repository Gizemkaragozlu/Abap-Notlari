*&---------------------------------------------------------------------*
*& Report ZFC_EXAMPLE_9
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_EXAMPLE_9.

data lv_index type i."index numarasını tutmak  için degisken
data: BEGIN OF gt_table occurs 0,"Tablo oluştururz
  index type i."index degeri int
  include structure scarr."Scarr tablosunun kolonlarını kullanırız
data: end of gt_table.

START-OF-SELECTION."Start edilince
select * from scarr INTO CORRESPONDING FIELDS OF table gt_table."Scarr tablosuna gider ve butun satır ve kolonlarını alarak gt_table içine atarız

LOOP AT gt_table."Tablonun içinde dongu kurarız
  lv_index = lv_index + 1."İndex degerini her donuşte bir artırız
  gt_table-index = lv_index."O anki structrın index degerin elimizdeki index degerini atarız
  COLLECT gt_table."Ve collect yapısıla degerleri yakalar ve internal tablo içine kaydederiz
ENDLOOP.

LOOP AT gt_Table."Tekar dongu kurar ve kolon degerlerini yazdırırz
  write gt_table-index.
  write gt_table-carrid.
  write gt_table-carrname.
  write gt_table-currcode.
  write gt_table-url.
ENDLOOP.
BREAK-POINT.