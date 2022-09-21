*&---------------------------------------------------------------------*
*& Report ZFC_EXAMPLE_8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zfc_example_8.
"Bu örnek, dahili tabloların satır içeriğinin nasıl ve nerede okunacağını gösterir.
CLASS demo DEFINITION."Class oluştruldu
  PUBLIC SECTION."Public
    CLASS-METHODS main."Bitane methodum bulunuyor
ENDCLASS.

CLASS demo IMPLEMENTATION."İmplement kısmı
  METHOD main."Main methodumunda

    DATA: BEGIN OF line,"line adında structreım bulunuypor
            col1 TYPE i,
            col2 TYPE i,
          END OF line.

    DATA itab LIKE SORTED TABLE OF line WITH UNIQUE KEY col1."Col1 key alanı dedik
    "Itab adanda tablo oluşturduk bu bir sort table

    DATA subrc TYPE sy-subrc."Subrc tipinde degisken oluşturduk
    DATA tabix TYPE sy-tabix."Tablo index tipinde degisken oluştrudk

    FIELD-SYMBOLS <fs> LIKE LINE OF itab."Fieldsymbol oluşturduk itab satırları tipinde bi bir structre

    DATA(out) = cl_demo_output=>new( )."cl_demo_output sınıfı ile yeni bir sayfa(screen) oluştrulur

    itab = VALUE #( FOR j = 1 UNTIL j > 4"For dongusu j = 1 j 4ten buyuk olana kadar
            ( col1 = j col2 = j ** 2 ) ).

    out->write_data( itab )->line( )."Sayfa uzerine satır satır tablo basılır

"/////////////////////////////////////////////////////////////////////////////////////////////////////////"
"/////////////////////////////////////////////////////////////////////////////////////////////////////////"
"/////////////////////////////////////////////////////////////////////////////////////////////////////////"
* INTO line COMPARING işlemi

    line-col1 = 2."Col1 degeri 2
    line-col2 = 3."col2 degeri 3


    READ TABLE itab FROM line INTO line COMPARING col2."Tablo okunur
    subrc = sy-subrc.
"READ deyimini kullanarak, sütun1 anahtar alanının çalışma alanıyla aynı içeriğe sahip olduğu tablo satırları bulunur
"ve bunlar daha sonra kopyalanır.
"sy-subrc ikidir, çünkü col2 alanının karşılaştırılması sırasında farklı sayılar bulunmuştur.

    out->write( |sy-subrc: { subrc }| ).
    out->write_data( line )->line( ).

"/////////////////////////////////////////////////////////////////////////////////////////////////////////"
"/////////////////////////////////////////////////////////////////////////////////////////////////////////"
"/////////////////////////////////////////////////////////////////////////////////////////////////////////"
* INTO line TRANSPORTING

    CLEAR line.
"READ ifadesi, sütun1 anahtar alanının 3 değerine sahip olduğu satırları okumak için kullanılır.
    READ TABLE itab WITH TABLE KEY col1 = 3"Read işlemi yapılırken sadece col1 degeri 3 olanın col2 degeri alınır
                    INTO line TRANSPORTING col2.
"Çalışma alanı satırına yalnızca col2 içeriği kopyalanır.
" sy-subrc sıfır değerine sahiptir ve sy-tabix üçtür çünkü itab bir dizin tablosudur.

    subrc = sy-subrc.
    tabix = sy-tabix.

    out->write( |sy-subrc: { subrc }|
      )->write( |sy-tabix: { tabix }|
      )->write_data( line
      )->line( ).

"/////////////////////////////////////////////////////////////////////////////////////////////////////////"
"/////////////////////////////////////////////////////////////////////////////////////////////////////////"
"/////////////////////////////////////////////////////////////////////////////////////////////////////////"
* TRANSPORTING NO FIELDS
" READ ifadesi, col2'nin 16 olduğu tablonun satırlarını bulmak için kullanılır.
    READ TABLE itab WITH KEY col2 = 16  TRANSPORTING NO FIELDS.
"Birincil tablo anahtarı kullanılmaz. Çalışma alanına hiçbir alan kopyalanmaz ve hiçbir satıra alan sembolü atanmaz.
"Yalnızca sistem alanları ayarlanır. sy-subrc sıfırdır çünkü bir satır bulunur ve sy-tabix dörttür.
    subrc = sy-subrc.
    tabix = sy-tabix.
    out->write( |sy-subrc: { subrc }|
      )->write( |sy-tabix: { tabix }|
      )->line( ).

"/////////////////////////////////////////////////////////////////////////////////////////////////////////"
"/////////////////////////////////////////////////////////////////////////////////////////////////////////"
"/////////////////////////////////////////////////////////////////////////////////////////////////////////"
* ASSIGNING
"Son alternatifin READ ifadesinde, sütun1 anahtar alanının 2 değerine sahip olduğu
" ve ardından <fs> alan sembolüne atandığı tablonun satırları okunur
    READ TABLE itab WITH TABLE KEY col1 = 2 ASSIGNING <fs>.

    <fs>-col2 = 100.

    out->write_data( itab ).

    out->display( )."Oluştrulan sayfa(ekran) yazdırılır.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo=>main( )."sınfıın içindeki main methodu çalışır