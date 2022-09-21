*&---------------------------------------------------------------------*
*& Report ZFC_EXAMPLE_8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zfc_example_8.


"INTO eklenmesi, bulunan satırın içeriğini bir çalışma alanına atar.
" Bu ekleme, itab'ın hangi şekilde belirtildiğinden bağımsız olarak kullanılabilir.

"ASSIGNING eki, bulunan satırı <fs> alan sembolüne atar.
" Bu ekleme, yalnızca itab için mevcut bir dahili tablo belirtilmişse mümkündür.

"REFERENCE INTO eklenmesi, bir referans tablosunda bulunan satıra bir referans oluşturur.
" Bu ekleme, yalnızca itab için mevcut bir dahili tablo belirtilmişse mümkündür.

"TRANSPORTİNG NO FİELDS eki, yalnızca ilgili sistem alanlarının doldurulduğunu belirtir.
" Bu ekleme, itab'ın hangi şekilde belirtildiğinden bağımsız olarak kullanılabilir.

"INTO EXAMPLE
"sflight_tab dahili tablosundaki belirli bir satırı okur ve onu sflight_wa (satır içi olarak bildirilen) çalışma alanına atar.
"Referans başarıyla atandıktan sonra, satırın bir bileşeninin içeriği dahili tabloda değiştirilir.
PARAMETERS: p_carrid TYPE sflight-carrid,
            p_connid TYPE sflight-connid,
            p_fldate TYPE sflight-fldate.

DATA sflight_tab TYPE SORTED TABLE OF sflight
                 WITH UNIQUE KEY carrid connid fldate.

SELECT *
       FROM sflight
       WHERE carrid = @p_carrid AND
             connid = @p_connid
       INTO TABLE @sflight_tab.

IF sy-subrc = 0.
  READ TABLE sflight_tab
       WITH TABLE KEY carrid = p_carrid
                      connid = p_connid
                      fldate = p_fldate
       INTO DATA(sflight_wa).
  IF sy-subrc = 0.
    sflight_wa-price = sflight_wa-price * '0.9'.
    MODIFY sflight_tab FROM sflight_wa INDEX sy-tabix.
  ENDIF.
ENDIF.



"ASSIGNING EXAMPLE
"sflight_tab dahili tablosunda belirli bir satırı seçer ve onu <sflight> (satır içi olarak bildirilen) alan sembolüne atar.
"Referans başarıyla atandıktan sonra, satırın bir bileşeninin içeriği dahili tabloda değiştirilir.

SELECT *
       FROM sflight
       WHERE carrid = @p_carrid AND
             connid = @p_connid
       INTO TABLE @sflight_tab.

IF sy-subrc = 0.
  READ TABLE sflight_tab
       WITH TABLE KEY carrid = p_carrid
                      connid = p_connid
                      fldate = p_fldate
       ASSIGNING FIELD-SYMBOL(<sflight>).
  IF sy-subrc = 0.
     <sflight>-price = <sflight>-price * '0.9'.
  ENDIF.
ENDIF.

"REFERANCE EXAMPLE
"sflight_tab dahili tablosunun belirli bir satırını seçer ve bulunan satıra sflight_ref
" (satır içi bildirilen) veri referans değişkenine bir referans atar.
SELECT *
       FROM sflight
       WHERE carrid = @p_carrid AND
             connid = @p_connid
       INTO TABLE @sflight_tab.

IF sy-subrc = 0.
  READ TABLE sflight_tab
       WITH TABLE KEY carrid = p_carrid
                      connid = p_connid
                      fldate = p_fldate
            REFERENCE INTO DATA(sflight_ref).

  IF sy-subrc = 0.
    sflight_ref->price = sflight_ref->price * '0.9'.
  ENDIF.
ENDIF.


"TRANSPORTING NO FİELDS
"sflight_carr dahili tablosunda belirli bir satırın olup olmadığını kontrol eder
"ve sy-tabix'te bulunan satırın birincil tablo dizinindeki satır numarasını idx'e atar.
DATA: scarr_tab TYPE SORTED TABLE OF scarr
                WITH UNIQUE KEY carrid,
                 idx  TYPE i.
SELECT *
       FROM scarr
       INTO TABLE @scarr_tab.

READ TABLE scarr_tab
     WITH TABLE KEY carrid = p_carrid
     TRANSPORTING NO FIELDS.
IF sy-subrc = 0.
  idx = sy-tabix.
ENDIF.