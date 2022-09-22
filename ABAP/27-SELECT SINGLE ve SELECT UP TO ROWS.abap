*&---------------------------------------------------------------------*
*& Report ZFC_SQL_YAPILARI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_SQL_YAPILARI.

"işlemlerde scarr tablosu kullanılmaktadır

DATA: gt_table type TABLE OF scarr, "o tabloya ait veri tutacagımız bir internal table oluşturulur
      gs_table type scarr,
      gv_currcode type S_CURRCODE. "tablodaki tek bir satırı tutabilcek structure

START-OF-SELECTION.

**select * from scarr into table gt_table WHERE CARRID eq 'AC'.
**  "scarr tablosuna select atılarak sadece carrid si AC olanlari internal tablomuza atarız
**
**READ TABLE gt_table INTO GS_TABLE index 1.
**  "Internal tabloyu okuyarak tablo içindeki ilk satırı structre içine atarız
**
**  WRITE gs_table.

*"UP TO ROWS YAPSI"
*select * UP TO 5 rows from scarr INTO TABLE gt_table. "scarr tablosuna giderek ilk 5 satırı sadece internal tablo içine atarız
*
*  READ TABLE gt_table INTO gs_table INDEX 1."Internal tabloyu okuyarak sadece ilk satırı structre içine atar

"SELECT SINGLE" Bir tabloya deger donmezde bir structura deger doner
"where yapısı herzaman into işleminden sonra yapılır
  "SELECT SINGLE * from scarr INTO gs_table ."scarr tablosuna select single yani tek satır olarak gidilir ve strcutre içine deger atılır

  select SINGLE currcode from scarr INTO GV_CURRCODE. "select single diyerek tek satır alcagımız belirttik ama bu tek satırın sadce currcode kolonunu
"Alcagımızı da belirttik bunuda degisken içine attık

 write GV_CURRCODE.