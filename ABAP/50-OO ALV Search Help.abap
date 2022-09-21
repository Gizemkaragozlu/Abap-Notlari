///////////TOP////////


data: go_alv TYPE REF TO CL_GUI_ALV_GRID, "Alv yi tanımladık
      go_container type REF TO CL_GUI_CUSTOM_CONTAINER. "alvyi tutcak container


data: gt_scarr type TABLE OF scarr,
      gs_scarr type scarr.

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

FIELD-SYMBOLS: <gfs_fcat> type LVC_S_FCAT. "Field cataloga ait fieldsymbol oluşturulur
FIELD-SYMBOLS: <gfs_scarr> type scarr.  " Tabloda değişiklik yapmak için

///////////CLS///////////

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

    METHODS HANDLE_ONF4 "search field
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










METHOD HANDLE_ONF4.

TYPES: BEGIN OF lty_value_tab,  "Value tab alanı için bir tek kolonlu tablo oluşturuyorz
      carrname TYPE s_carrname,
      carrdeff type char20,
  END OF LTY_VALUE_TAB.

data: lt_value_tab type TABLE OF LTY_VALUE_TAB, "Oluşturudugumuz tek kolonlu tabloyu referans alan bir internal table oluşturuuyoruz
      ls_value_tab type lty_value_tab. "Ve o alanı doldurmak içinde bir structre

"Search help alanına basıldıgınnda pop up ile birlikte ekrana gelcek alan
clear LS_VALUE_TAB.
LS_VALUE_TAB-CARRNAME = 'Uçuş 1'.
LS_VALUE_TAB-CARRDEFF = 'Birinci uçuş'.
APPEND LS_VALUE_TAB to LT_VALUE_TAB.

clear LS_VALUE_TAB.
LS_VALUE_TAB-CARRNAME = 'Uçuş 2'.
LS_VALUE_TAB-CARRDEFF = 'İkinci uçuş'.
APPEND LS_VALUE_TAB to LT_VALUE_TAB.

clear LS_VALUE_TAB.
LS_VALUE_TAB-CARRNAME = 'Uçuş 3'.
LS_VALUE_TAB-CARRDEFF = 'Üçüncü uçuş'.
APPEND LS_VALUE_TAB to LT_VALUE_TAB.


data: lt_return_tab type TABLE OF DDSHRETVAL, "return table tipinde bi tablo
      ls_return_tab type DDSHRETVAL."O tabloyu da doldurmak için structure


CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST' "Search help alanına bastıgımda ekrana cıkacak pop up alanı
  EXPORTING
    RETFIELD              =  'CARRNAME'  "oluşturulan tablodaki hangi kolonu referans(DEğerini) almamız gerkttiigin bu alana yazıyoruz
   WINDOW_TITLE           =   'carrname F4'    "Açılan search helpin başlıgı
   VALUE_ORG              = 'S'   "Default olarak S veriyourz
  TABLES
    VALUE_TAB             =  lt_value_tab "Ekranda gorunmesini istedigimiz internal table "Dinamik table olan "N kolonlu
   RETURN_TAB             =   lt_return_tab .  "Yaptıgı seçimi yakalamamız için kullancagım alan


"Sarch help alanına basıldıgında ekrana gelcek pop up tan seçilen alanı ls_return_tab içinde  tutyoruz
"F0001 seçilen kolon sırasıdır
READ TABLE LT_RETURN_TAB INTO LS_RETURN_TAB WITH KEY FIELDNAME = 'F0001'.
IF sy-SUBRC eq 0.

"Seçilen degeri direkt olarak tablonun alanına bascagımzı için field symbol kullanıoruz
READ TABLE GT_SCARR ASSIGNING <GFS_SCARR> index ES_ROW_NO-ROW_ID. "Search help içinde hangi satırda işlem yapıldıysa onunla şartıyorzu
IF sy-subrc eq 0.

"Tablomun seçil satırına search help uzerindn seçilen degeri yazdırıyoruz
<GFS_SCARR>-CARRNAME = LS_RETURN_TAB-FIELDVAL.

GO_ALV->REFRESH_TABLE_DISPLAY( ). "Yapılan degişikligin alv uzerine yansıması için alvyi refreshliyoruz
ENDIF.
ENDIF.

"Search help kısmının tamamlanmış olması için
ER_EVENT_DATA->M_EVENT_HANDLED = 'X'.

ENDMETHOD.








METHOD HANDLE_TOOLBAR.

data ls_toolbar type STB_BUTTON. "Toolbar objesi oluşturmak için structure

CLEAR LS_TOOLBAR. "structure temizle
LS_TOOLBAR-TEXT = 'Delete'. "objenin adi
LS_TOOLBAR-ICON = '@11@'. "iconu
LS_TOOLBAR-DISABLED = ''. "aktifligi
LS_TOOLBAR-FUNCTION = '&DEL'. "Fonksiuon kodu
LS_TOOLBAR-QUICKINFO = 'Delete '. "Kısa bilgisi

APPEND LS_TOOLBAR to E_OBJECT->MT_TOOLBAR.

  ENDMETHOD.





METHOD HANDLE_USER_COMMAND.

CASE E_UCOMM.
  WHEN '&DEL'.
    MESSAGE 'Silme butonuna tıklandı' type 'I'.
ENDCASE.

ENDMETHOD.


ENDCLASS.


//////////FRM////////////


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


set HANDLER GO_EVENT_RECEIVER->HANDLE_ONF4 for GO_ALV. "Seacrh help alanını alv ye assign ediyorum

PERFORM register_f4."Search help alanını kullanmak için

GO_ALV->SET_TABLE_FOR_FIRST_DISPLAY(
  exporting
    IS_LAYOUT                     =       gs_layout          " Layout
  changing
    IT_OUTTAB                    =        GT_SCARR   "Veri bascagımız tablo.
    IT_FIELDCATALOG               =       GT_FCAT           " Kolon bazında duzenleme yapmamızı saglar
).

call METHOD GO_ALV->REGISTER_EDIT_EVENT "Eğer kolonumda editable bi alan varsa kullancı bu alana manul deger girebilir bizimde bunu yakalamamız gerkir
  exporting
    I_EVENT_ID =    CL_GUI_ALV_GRID=>MC_EVT_MODIFIED        .      " Event ID

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
*&      Form  REGISTER_F4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM REGISTER_F4 .

data: lt_f4 type LVC_T_F4, "Birden cok alana search help ekleyebilriiz bu yuzden bu değişkenn bir intern table
      ls_f4 TYPE lvc_s_f4. "Tablomu doldurmakta kullanacagım structure

clear ls_f4.

LS_F4-FIELDNAME = 'CARRNAME'. "hangi kolona search help ekliceksem o alanı yazacgım
LS_F4-REGISTER = 'X'. "Register yanı search help alan olacagını belirtiyoruz
APPEND LS_F4 to LT_F4."sectigim kolonu tabloma eklyorm

call METHOD GO_ALV->REGISTER_F4_FOR_FIELDS "Search help alanının  hangi kolonda olacagını vermemiz gereklidir
  exporting
    IT_F4 =       lt_f4           "Search help alanalarının kaydedildigi alanlarını veriyoruz
  .

ENDFORM.