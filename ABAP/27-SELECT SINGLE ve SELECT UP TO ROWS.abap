*&---------------------------------------------------------------------*
*& Report ZFC_SQL_YAPILARI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_SQL_YAPILARI.

"işlemlerde scarr tablosu kullanılmaktadı

DATA: gt_table type TABLE OF scarr, "o tabloya ait veri tutaagımız bir intern table oluşturulur
      gs_table type scarr,
      gv_currcode type S_CURRCODE. "tablodaki 1 satırı tutabilcek structure

START-OF-SELECTION.

**select * from scarr into table gt_table WHERE CARRID eq 'AC'.
**  "sec hepsini scarr dan gt_table tablosu içine nerdeki carrid eşit 'AC' olanlari
**
**READ TABLE gt_table INTO GS_TABLE index 1.
**  "oku gt_table tablosunu gs_table içine 1.indexteki(ilk satıır)
**
**  WRITE gs_table.

*"UP TO ROWS YAPSI"
*select * UP TO 5 rows from scarr INTO TABLE gt_table.
*
*  READ TABLE gt_table INTO gs_table INDEX 1.

"SELECT SINGLE" Bir tabloya deger donmezde bir structura deger doner
"where yapısı herzaman into işleminden sonra yapılır
  "SELECT SINGLE * from scarr INTO gs_table .

  select SINGLE currcode from scarr INTO GV_CURRCODE. "where currcode eq 'EUR'. gibi gibi

 write GV_CURRCODE.