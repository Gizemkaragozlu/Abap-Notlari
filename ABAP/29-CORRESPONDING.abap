*&---------------------------------------------------------------------*
*& Report ZFC_SQL_YAPILARI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_SQL_YAPILARI.


*"işlemlerde scarr tablosu kullanılmaktadı
*
*DATA: gt_table type TABLE OF scarr, "o tabloya ait veri tutaagımız bir intern table oluşturulur
*      gs_table type scarr.
*
*"Kendi oluşturcagımız tip uzerinde deneyeleim kolonlar ve tipler scarr tablosundnan alınmıştır
*TYPES: BEGIN OF gty_table,
*    currcode type s_currcode,
*    url type S_CARRURL,
*  END OF gty_table.
*
*data gt_table2 type table of gty_table. "oluturudugum tip ten bir tablo oluşturuyorym
*START-OF-SELECTION.

"SELECT * from scarr into table gt_table.  "veri çekme işlelemlerinde tum kolonları çekerken aynı tipte tablo oldugunda bi sorun yaşamayız

"Ama egerki biz ayni tipteki bir tablodan veri çekerken eger istedigimiz satırları ister ve bu tablodaki kolon sırasına uymazsa hatab ile karşılaşırız
*
*select currcode url from scarr INTO table gt_table.
*  BREAK-POINT. "bizboyle bişey yaptıgımızda mandt kolonuna currcode alanı dolduruluyor currid kolonuna ise url bilgiisi dolduruluyor

"Bu yapısı duzletmek için corresponding kullanmamız gerekir

"select currcode url from scarr INTO CORRESPONDING FIELDS OF TABLE gt_table. "şeklinde kullanmamız gerekir bu sefer name degerlerinin uydugu kolonlara gelen veriler doldurulur

" select * from scarr into table gty_table.  "bu sefer sefer uzunluk degeri bile aynı olmadıgı  için aktıf bile edemedik

"SELECT currcode url from scarr INTO CORRESPONDING FIELDS OF TABLE gt_table2.
 " BREAK-POINT.


"STRUCTURELARDA KULLANIM


"2 adet yeni tip oluşturuyorum
TYPES: BEGIN OF gty_type1,
      col1 type char10,
      col2 type char10,
      col3 type char10,
      col4 type char10,
  END OF gty_type1.


TYPES: BEGIN OF gty_type2,
      col2 type char10,
      col3 type char10,
  END OF gty_type2.

"Oluşturudugum tiplerdende 2 adet structe oluşturyyoruym
DATA: gs_typ1 type gty_type1,
      gs_typ2 type gty_type2.

GS_TYP1-COL1 = 'aaaa'.
GS_TYP1-COL2 = 'bbbb'.
GS_TYP1-COL3 = 'cccc'.
GS_TYP1-COL4 = 'dddd'.

"gs_typ2 im boş 1 deki degerlimi ona aktarcagım fakat aynı tipte degiller

*gs_typ2 = GS_TYP1. "benim typ2 de col2 ve col3 kolonum olmasına ragmen  typedeki duzene gore atıldı col2 koonuma aaaa col3 kolonuma bbbb geldi bu yanlış bir duzen
*BREAK-POINT.

"move-corresponding kullanımı

MOVE-CORRESPONDING GS_TYP1 to GS_TYP2. "bu işlem bize kolon adlarına karşılık gelen degere gore doldurum yapar sıraya gore degil 
BREAK-POINT.