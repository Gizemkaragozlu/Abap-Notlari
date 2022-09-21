/////////TOP///////////



data: go_alv TYPE REF TO CL_GUI_ALV_GRID, "Alv yi tanımladık
      go_container type REF TO CL_GUI_CUSTOM_CONTAINER. "alvyi tutcak container

data: gt_scarr type TABLE OF scarr,
      gs_scarr type scarr. "Veri tablomuz

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

FIELD-SYMBOLS: <gfs_fcatt> type LVC_S_FCAT. "Field cataloga a

//////////FRM//////////


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


"Double click eventi tetikleme
set HANDLER GO_EVENT_RECEIVER->HANDLE_DOUBLE_CLICK for GO_ALV.

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

 select * from scarr INTO TABLE GT_SCARR.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SET_FCAT USING p_fieldname.

CLEAR GS_FCAT.
GS_FCAT-FIELDNAME = P_FIELDNAME."kolon adı

"geriye kalan ayarlamalı tablodan alsın diye referans işlemi uyguladık
GS_FCAT-REF_TABLE = 'SCARR'.
GS_FCAT-REF_FIELD = P_FIELDNAME.

APPEND GS_FCAT to GT_FCAT.

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


*LOOP AT GT_FCAT ASSIGNING <GFS_FCATT>." tablo içinde don ve hepsin field symbole at
*
*IF <GFS_FCATT>-FIELDNAME eq 'CARRID' or <GFS_FCATT>-FIELDNAME eq 'CARRNAME'. "Eger feld symbol içindeki dataların fieldname degeri carrıd ye eşitse
*  <GFS_FCATT>-HOTSPOT = abap_true. "field catalog degerindeki hotspotu aktif et
*ENDIF.
*
*ENDLOOP.

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

/////////////CLS//////////////


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

    METHODS handle_data_changed
      FOR EVENT data_changed of CL_GUI_ALV_GRID
      IMPORTING
        ER_DATA_CHANGED
        E_ONF4
        E_ONF4_BEFORE
        E_ONF4_AFTER
        E_UCOMM.

    METHODS handle_onf4
      FOR EVENT onf4 of CL_GUI_ALV_GRID
        IMPORTING
          E_FIELDNAME
          E_FIELDVALUE
          ES_ROW_NO
          ER_EVENT_DATA
          ET_BAD_CELLS
          E_DISPLAY.

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
    BREAK-POINT.
  ENDMETHOD.


  METHOD HANDLE_ONF4.
    BREAK-POINT.
  ENDMETHOD.



ENDCLASS.