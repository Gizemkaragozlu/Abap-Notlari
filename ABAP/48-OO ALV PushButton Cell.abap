/////////TOP//////////

*&---------------------------------------------------------------------*
*&  Include           ZFC_ALV_OO_ALV_DENEME_TOP
*&---------------------------------------------------------------------*


data: go_alv TYPE REF TO CL_GUI_ALV_GRID, "Alv yi tanımladık
      go_container type REF TO CL_GUI_CUSTOM_CONTAINER. "alvyi tutcak container

TYPES: BEGIN OF gty_scarr, "scarr tablosuna benzeyen bir tip oluşturduk
  delete type char10,
  mandt type S_mandt,
  carrid type S_CARR_ID,
  carrname type S_CARRNAME,
  currcode type S_CURRCODE,
  url type S_CARRURL,
  END OF gty_scarr.

data: gt_scarr type TABLE OF gty_scarr,
      gs_scarr type gty_scarr.

DATA: gt_fcat type LVC_T_FCAT, "field caalotg tablo
      gs_fcat TYPE LVC_S_FCAT. "structure

data gs_layout TYPE LVC_S_LAYO. "layout

CLASS CL_EVENT_RECEIVER DEFINITION DEFERRED. "bu işlem ise eger ki class tanımlamamız kullancagımız objeden sonra geliyorsa hataları engeller

  "Eventlara erişmek istersek classın turunde bi objeye ihtiyacımız vardır
data go_event_receiver TYPE REF TO CL_EVENT_RECEIVER.

"Top of page kullanımı
  DATA: go_split_container TYPE REF TO CL_GUI_SPLITTER_CONTAINER, "Elimizdeki containeri parçalamak için
        go_sub1 TYPE REF TO CL_GUI_CONTAINER, "Bir parçası için
        go_sub2 TYPE REF TO CL_GUI_CONTAINER. "Diğer parçası için

    "Top of page e yazı yazmak için o sınıfa ait objeye ihtiyacımız vardir
  DATA go_docu TYPE REF TO cl_dd_document.

FIELD-SYMBOLS: <gfs_fcatt> type LVC_S_FCAT. "Field cataloga ait fieldsymbol oluşturulur
FIELD-SYMBOLS: <gfs_scarr> type gty_scarr. "tabloya  ait fieldsymbol oluşturulur

////////CLS///////////

*&---------------------------------------------------------------------*
*&  Include           ZFC_ALV_OO_ALV_DENEME_CLS
*&---------------------------------------------------------------------*
class cl_event_receiver DEFINITION. "Class açılır
  "İçerisine eventlar yazılcak
  PUBLIC SECTION. "encapsullation
    METHODS handle_top_of_page "method ismimiz      "alv nin uzerine başlık tarzında alan oluşturur
            "Hangi event of nerde tetiklenecek
      FOR EVENT top_of_page of CL_GUI_ALV_GRID
    IMPORTING "import parametreleri
      E_DYNDOC_ID
      TABLE_INDEX.


    METHODS handle_hotspot_click  "hotspot click olayı
      FOR EVENT hotspot_click of CL_GUI_ALV_GRID
    IMPORTING
      E_ROW_ID
      E_COLUMN_ID.

    METHODS handle_double_click           "Hucreye çift tıklamak
      FOR EVENT double_click of CL_GUI_ALV_GRID
      IMPORTING
        E_ROW
        E_COLUMN
        ES_ROW_NO.

    METHODS handle_data_changed "Hucre veri dğişimi
      FOR EVENT data_changed of CL_GUI_ALV_GRID
      IMPORTING
        ER_DATA_CHANGED
        E_ONF4
        E_ONF4_BEFORE
        E_ONF4_AFTER
        E_UCOMM.

    METHODS handle_button_click
      FOR EVENT button_click of CL_GUI_ALV_GRID
        IMPORTING
          ES_COL_ID
          ES_ROW_NO.


    ENDCLASS.

class CL_EVENT_RECEIVER IMPLEMENTATION.

  METHOD HANDLE_TOP_OF_PAGE. "Top of page
    data: lv_text TYPE SDYDO_TEXT_ELEMENT. "Başlık degerimizi tutması için variable

    LV_TEXT = 'Flight Details'.

  call METHOD GO_DOCU->add_text "Text ekleme metodu cagrılır
    EXPORTING
      text    = LV_TEXT "metnimiz veirlir
      sap_style = CL_DD_DOCUMENT=>HEADING. "metin sitli verilir

  call METHOD GO_DOCU->new_line. "araya boşluk verilir

  clear LV_TEXT.

  CONCATENATE 'USER: ' sy-UNAME INTO LV_TEXT SEPARATED BY space.

    call METHOD GO_DOCU->add_text "Text ekleme metodu cagrılır
    EXPORTING
      text    = LV_TEXT "metnimiz veirlir
      sap_color = CL_DD_DOCUMENT=>LIST_POSITIVE. "metin rengi
      "sap_fontsize = CL_DD_DOCUMENT=>MEDIUM. "metin font buyuklugu


    call  METHOD GO_DOCU->display_document "Displayi goruntulume
      EXPORTING
        parent    =   go_sub1. "ve goruntu basılcak alan



  ENDMETHOD.

  METHOD HANDLE_HOTSPOT_CLICK. "Hotspot alan tetiklenince ne olcak

    data lv_mess type char200. "mesaj değişkjeni oluşturulur

    read TABLE GT_SCARR INTO GS_SCARR INDEX E_ROW_ID-INDEX. "Veri tablomuz okunur ve index ile şartlanır
    IF sy-SUBRC eq 0. "Eğer sorgu başarılı ise
       CASE E_COLUMN_ID. "Case yapısı kurulur ve tıklanan kolonun id degeri alınır
         WHEN 'CARRID'. "Carrid ye eşitse
          CONCATENATE 'Tıklanan kolon' "String birleştirme işlemi yapılır
                      E_COLUMN_ID "kolon adı verir
                      'Değeri'
                      GS_SCARR-CARRID "kolon adının içideki degeri verir
                      INTO LV_MESS
                      SEPARATED BY space.
          MESSAGE LV_MESS type 'I'. "Ekrana mesaj basılır
         WHEN 'CARRNAME'.
            CONCATENATE 'Tıklanan kolon' "String birleştirme işlemi yapılır
                      E_COLUMN_ID-FIELDNAME
                      'Değeri'
                      GS_SCARR-CARRNAME
                      INTO LV_MESS
                      SEPARATED BY space.
          MESSAGE LV_MESS type 'I'. "Ekrana mesaj basılır
       ENDCASE.
    ENDIF.
  ENDMETHOD.

  METHOD HANDLE_DOUBLE_CLICK. "Çift tıklama eventi

    data lv_mess type char200. "mesaj değişkjeni oluşturulur

    read TABLE GT_SCARR INTO GS_SCARR INDEX ES_ROW_NO-ROW_ID. "Veri tablomuz okunur ve index ile şartlanır
    IF sy-SUBRC eq 0. "Eğer sorgu başarılı ise
    "  CASE E_COLUMN-FIELDNAME. "Colon adına karşılık gelen deger
       " WHEN 'URL'. "url ise
          CONCATENATE 'Tıklanan kolon' "String birleştirme işlemi yapılır
                      E_COLUMN-FIELDNAME "kolon adı verir
                      'Değeri'
                      GS_SCARR "tıklanan kolonun structure degeri yazılır
                      INTO LV_MESS
                      SEPARATED BY space.
          MESSAGE LV_MESS type 'I'. "Ekrana mesaj basılır
      "ENDCASE.
    ENDIF.

  ENDMETHOD.

  METHOD HANDLE_DATA_CHANGED.
    data: lv_mess type char200, "Mesaj değişkeni
          ls_modi type LVC_S_MODI. "Değişiklikleri tutan degişken

    LOOP AT ER_DATA_CHANGED->MT_GOOD_CELLS INTO ls_modi. "Erdata classındna hangi değişikler oldugunu oluşturdugum tutucuya ekledim
      READ TABLE gt_scarr INTO GS_SCARR index Ls_MODI-ROW_ID. "Tabloyu okudum indexe gore şartladım
      IF sy-SUBRC eq 0. "sorguda herhangi bir hata yoksa
          CONCATENATE  GS_SCARR-CARRNAME "kolon adı
                       'Kolonunun,'
                      'Eski değeri =>'
                      Ls_MODI-FIELDNAME "Eski degeri
                      'Yeni değeri =>'
                      LS_MODI-VALUE "Yeni degeri
                      INTO lv_mess
                      SEPARATED by space.
          MESSAGE LV_MESS type 'I'.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD handle_button_click.

    data lv_mess type char200. "Mesaj değişkeni oluştur

    READ TABLE GT_SCARR INTO GS_SCARR INDEX ES_ROW_NO-ROW_ID.
    "Alv tablosunu oku gs_scarr içine seçili indextekini at
    IF sy-subrc eq 0. "işlemde herhangi bir hata yok ise
      CASE ES_COL_ID-FIELDNAME. "Kolon adı eşitse
        WHEN 'DELETE'. "Delete
          CONCATENATE ES_COL_ID-FIELDNAME "kolon adı
                      'Buttonuna bastın Bu indexteki =>'
                      GS_SCARR "Tablodan gelen seçili sıradaki structerı
                      INTO lv_mess "mesaj içine at
                      SEPARATED BY space.
          MESSAGE LV_MESS TYPE 'I'.
      ENDCASE.
    ENDIF.
  ENDMETHOD.



ENDCLASS.


//////////////FRM//////////

*&---------------------------------------------------------------------*
*&  Include           ZFC_ALV_OO_ALV_DENEME_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY_ALV .


IF GO_ALV is INITIAL.


CREATE OBJECT GO_EVENT_RECEIVER."Event yapısını once creat ederiz

CREATE OBJECT GO_CONTAINER "Container objemizi tutması için
  exporting
    CONTAINER_NAME              =          'CC_ALV'.



"Normalde alv yapımıza direk containır tutan yapımızı verirdik ama o yapıyı parçaladıgımız için artık onun bir parçası olan sub2 tutcak
CREATE OBJECT GO_ALV
  exporting
    I_PARENT          =        GO_CONTAINER. "         GO_CONTAINER. yapısı tutmicak o yapıyı bolduk onu parçaladıgımız yapı tutacak


"button eventi
set HANDLER GO_EVENT_RECEIVER->HANDLE_BUTTON_CLICK for GO_ALV.

GO_ALV->SET_TABLE_FOR_FIRST_DISPLAY(
  exporting
    IS_LAYOUT                     =       gs_layout          " Layout
  changing
    IT_OUTTAB                    =        GT_SCARR   "Veri bascagımız tablo.
    IT_FIELDCATALOG               =       GT_FCAT           " Kolon bazında duzenleme yapmamızı saglar
).

else.
call METHOD GO_ALV->REFRESH_TABLE_DISPLAY.
ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .

 select * from scarr INTO CORRESPONDING FIELDS OF TABLE GT_SCARR.

   LOOP AT GT_SCARR ASSIGNING <GFS_sCARR>."Tablo uzerinde doner ve butun degerleir field-symbole atar
     <GFS_SCARR>-DELETE = '@11@'. "Field symbol içindeki button satırlarına icon ataması yapılrı
   ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_FCAT .

CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
 EXPORTING
   I_STRUCTURE_NAME             = 'SCARR'
  CHANGING
    CT_FIELDCAT                  = GT_FCAT
       .

CLEAR GS_FCAT. "Tablo structure temizenir
GS_FCAT-FIELDNAME = 'DELETE'. "Tabloya ekledigimiz alanında ekreana basılması için fiedlnamei olası gerekir
GS_FCAT-SCRTEXT_s = 'SIL'.
GS_FCAT-SCRTEXT_M = 'SIL'.
GS_FCAT-SCRTEXT_L = 'SIL'.
GS_FCAT-STYLE     = CL_GUI_ALV_GRID=>MC_STYLE_BUTTON. "Ekledigimiz alana bir sitil vererek bunu butona donuşturuyoruz
GS_FCAT-ICON      = 'X'.  "Kolonun icon alabilme ozelligini aktif ederiz
APPEND GS_FCAT to GT_FCAT.





ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SET_LAYOUT .

GS_LAYOUT-CWIDTH_OPT = 'X'.
GS_LAYOUT-ZEBRA      = 'X'.


ENDFORM.