*&---------------------------------------------------------------------*
*& Report ZFC_EXAMPLE_8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zfc_example_8.
cl_demo_output=>new( ).


data(text) = 'Text'. "Direkt olakra data tanımlamadan deger ataması yapılabilir 7.40

types  t_itab type table of i with empty key. "Integer tablo tipi oluşturmak

data(itab) = value t_itab( ( 1 ) ( 2 ) ( 3 ) )."Integer tablo tipini direkt olarak degerlerini atayarak kullanmak

"//////////////////////////////////////////"
"//////////////////////////////////////////"
"//////////////////////////////////////////"

read table itab index 1 into data(wa)."Read table ile tablonun 1. indexini almak
cl_demo_output=>write( wa ).

wa = itab[ 3 ]."Tablonun 3.indexini almak

cl_demo_output=>write( wa ).

"//////////////////////////////////////////"
"//////////////////////////////////////////"
"//////////////////////////////////////////"
data :it_tab type table of scarr  , "datas
      is_tab type scarr.
"Select scarr into it_tab
select * from scarr into table it_tab.

read table it_tab into is_tab with key carrid = 'AA'."Read table kullanarak carrid 'AA' olanı aldık
cl_demo_output=>write( is_tab ).

is_tab = it_tab[ carrid = 'AC' ]."Tablonun içinden carrid 'AC' olanı aldık

cl_demo_output=>write( is_tab ).

is_tab = it_tab[ carrname = 'Alitalia' ] ."Read Table kullanamk yerine tablonun carrname alanına eşit olan structrı aldık

cl_demo_output=>write( it_tab[ currcode = 'JPY' ]-carrname )."Şeklinde tablonun[ degerine = eşit ]-kolonu alınabilir

cl_demo_output=>write( is_tab ).

"Egerki var olmayan bi degeri almaaya kalkarsak itab[ 5 ] şeklinde veya key ile eger ki o degerde yok ise dump alırız
"Bu gibi durumlarda readTable kullanrak sy subrc ile sorgulamak en mantıklısı olur
READ TABLE it_tab WITH KEY carrname = 'Alitali' INTO is_tab.
IF sy-subrc eq 0.
  cl_demo_output=>write( is_tab ).
ENDIF.

"Veya line_exists fonksyonu ile degerin var olup olmadıgı sorgulanır daha sonra ise deger ataması yapılabilir
IF line_exists( it_tab[ carrname = 'Alitali'] ).
 is_tab = it_tab[ carrname = 'Alitali'].
  cl_demo_output=>write( is_tab ).
ENDIF.

"line_index fonksyonu ile tablonun[ degerine = eşit] olan degerin kacıncı satırda bulundugunu alabilirz
"Bu işlem read_table no transporting fields degeri ile aynı işelvi yapmaktadır
data(idx) = line_index( it_tab[ currcode = 'JPY' ] ).

cl_demo_output=>write( idx ).

*DESCRIBE TABLE it_tab LINES data(indx)."itab içindeki toplam satır saysıı alınır
*DO indx TIMES."do ... times satır sayısı kadar do işlemi yapılır
*  "He do işleminde demoya yazar ( itabin[ o anki dongu sayısı ]-carrname ) alanı yazılır
*  cl_demo_output=>write( it_tab[ sy-index ]-carrname ).
*ENDDO.
*"Elbette ki loop işlemi daha kolaydır bunu yapmaktan
*LOOP AT it_tab INTO data(is_tab2).
*  cl_demo_output=>write( is_tab2-carrname ). "Bu şekilde :)
*ENDLOOP.

"Stringler ile dolu bi tablo yapmak için :D
TYPES sitab TYPE STANDARD TABLE OF string WITH EMPTY KEY."Boş key anahtarlı bir standarad tablo tipi oluştrulur sitab adında

DATA(sitab) = VALUE sitab("variable oluştrulur sitab adında = degerler atanır sitab tipinde ( (her kolon) ).
  ( `I’m going slightly mad` )
  ( `I’m going slightly mad` )
  ( `It finally happened – happened` )
  ( `It finally happened – ooh woh` ) ).

cl_demo_output=>write( sitab ).

"Demo sayfa ile html yazma
cl_demo_output=>display_html( '<table border=1><tr><td>asd</td><td>asd</td><td>asd</td><td>asd</td></tr></table>' ).

"Col1 degeri string ve col2 degeri integer olan type oluşturduk
types: BEGIN OF ltype ,
  col1 TYPE string,
  col2 TYPE i,
  END OF ltype.
data litab type TABLE OF ltype."Ltype tipinde bir tablo oluşturduk
"Ldata degiskeni = deger ltype structre tipinde ( col1 = dege col2 = deger ).
data(ldata) = VALUE ltype( col1 = 'Furkan'  col2 =  100 ).
APPEND ldata to litab."Tabloya strucrı ekledik
ldata = VALUE ltype( col1 = 'Furkan123'  col2 =  123 ).
APPEND ldata to litab.

"Tabloyu yazdırdık
cl_demo_output=>write( litab ).

cl_demo_output=>write( litab[ 2 ]  )."Tablonun 2. indexini yazdırdık

"String ifade içinde işlem yaparak concatenate ve char tipine donuşumune ihtiyac duymadık
data(lv_str) =  |'Furkan'{ 120 * 200 }|.

cl_demo_output=>write( lv_str ).

"Kısa if yazımı cond # (when var1 şart var2 then(True ise) else(Degilse))
data(var1) = COND #( WHEN 10 gt 20 THEN 'True ' ELSE 'False' ).
cl_demo_output=>write( var1 ).
cl_demo_output=>display( ).


DATA: lv_indicator LIKE scal-indicator.
CALL FUNCTION 'DATE_COMPUTE_DAY'
  EXPORTING
    date = sy-datum    " Date of weekday to be calculated
  IMPORTING
    day  = lv_indicator.   " Weekday

DATA(lv_day) = SWITCH char10( lv_indicator
                              WHEN 1 THEN 'Pazartesi'
                              WHEN 2 THEN 'Salı'
                              WHEN 3 THEN 'Çarşamba'
                              WHEN 4 THEN 'Perşembe'
                              WHEN 5 THEN 'Cuma'
                              WHEN 6 THEN 'Cumartesi' ).
WRITE lv_day.