////////CLS///////

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

    METHODS handle_button_click "button tiklama
      FOR EVENT button_click of CL_GUI_ALV_GRID
        IMPORTING
          ES_COL_ID
          ES_ROW_NO.

    METHODS handle_onf4 "search field
      FOR EVENT onf4 of CL_GUI_ALV_GRID
        IMPORTING
          E_FIELDNAME
          E_FIELDVALUE
          ES_ROW_NO
          ER_EVENT_DATA
          ET_BAD_CELLS
          E_DISPLAY.

    methods handle_toolbar "Toolbar
      FOR EVENT toolbar of CL_GUI_ALV_GRID
      IMPORTING
        E_OBJECT
        E_INTERACTIVE.

    methods handle_user_command "Toolbar
      FOR EVENT user_command of CL_GUI_ALV_GRID
      IMPORTING
        E_UCOMM.


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


METHOD HANDLE_USER_COMMAND.

CASE E_UCOMM."methodun bize dondugu e_ucomm parametresini yakalayak istenen toolbar butonunun fonksiuon işlemini gerçekleşitrebiliriz
  WHEN '&DEL'.
    MESSAGE 'Silme butonuna tıklandı' type 'I'.
ENDCASE.

ENDMETHOD.


ENDCLASS.


/////////FRM///////

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

"PERFORM register_f4.

"Normalde alv yapımıza direk containır tutan yapımızı verirdik ama o yapıyı parçaladıgımız için artık onun bir parçası olan sub2 tutcak
CREATE OBJECT GO_ALV
  exporting
    I_PARENT          =        GO_CONTAINER. "         GO_CONTAINER. yapısı tutmicak o yapıyı bolduk onu parçaladıgımız yapı tutacak

"set HANDLER GO_EVENT_RECEIVER->HANDLE_ONF4.

set handler GO_EVENT_RECEIVER->HANDLE_TOOLBAR for GO_ALV. "Toolbar
set handler GO_EVENT_RECEIVER->HANDLE_USER_COMMAND for GO_ALV. "User command


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

LOOP AT GT_FCAT ASSIGNING <GFS_FCAT>. "Field catalog tablosu uzerinde donup field symbol structurına atıyoruz
IF <GFS_FCAT>-FIELDNAME eq 'CARRNAME'.
  <GFS_FCAT>-EDIT = 'X'. "Edit mode
  "<GFS_FCAT>-F4AVAILABL = 'X'. "Search help alanı aktif etme
  <GFS_FCAT>-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_F4. "Search help alanı aktif etme
ENDIF.
ENDLOOP.





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
*&---------------------------------------------------------------------*
*&      Form  register_F4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM register_F4 .

DATA: lt_f4 type LVC_T_F4, "Searchfield tablosu
      ls_f4 type LVC_s_F4. "Seacrhfield structure

CLEAR: LS_F4.

LS_F4-FIELDNAME = 'CARRNAME'."Searchfieldın olcagı kolon
LS_F4-REGISTER  = 'X'. "Searchfieldın aktifligi
APPEND LS_F4 to LT_F4.

call METHOD GO_ALV->REGISTER_F4_FOR_FIELDS "Alv ye Searchfield ekleme
  exporting
    IT_F4 =    LT_F4.              " F4 Fields

ENDFORM.