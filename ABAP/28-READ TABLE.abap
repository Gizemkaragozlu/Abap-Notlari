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

SELECT * from scarr INTO TABLE GT_TABLE.

  "READ TABLE gt_table into gs_table WITH KEY carrid = 'AZ'. "tablodan gelen veri içinden readtable ile şart koyma  bu durumda sadece carrid AZ olanı alcaktır "egerki sy-subrc ile şartalamak istersek aynı şarta ait birden cok kayıt varsa subrc 1 donmektedir
*  READ TABLE gt_table into gs_table WITH KEY carrname = 'Air Canada'. "tablodan gelen veri içinden readtable ile şart koyma carrname alanı sadece 
	"Aır canada olan gelcektir
*
*
*
*"Birden cok şart ekleme araya herhangi bir and yapsıı konulmaz otomatik olarak and denilmiş olur
*  READ TABLE gt_table into gs_table WITH KEY carrname = 'Air Canada'. "tablodan gelen veri içinden readtable ile şart koyma
*                                             currcode = 'EUR'. "tablodan gelen veri içinden readtable ile şart koyma
*
"Radtable larda sadece eq mantıgı vardır kucuktut buyuktu yoktur

"parabirimi euro olanların içinde gezinme
  LOOP AT gt_table INTO gs_table WHERE currcode = 'EUR' .
 write gs_table.
  ENDLOOP.