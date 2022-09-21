*&---------------------------------------------------------------------*
*&  Include           ZFC_GENEL_TEKRAR_CLS
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
LS_TOOLBAR-TEXT = 'Add'. "objenin adi
LS_TOOLBAR-ICON = '@17@'. "iconu
LS_TOOLBAR-DISABLED = ''. "aktifligi
LS_TOOLBAR-FUNCTION = '&add'. "Fonksiuon kodu
LS_TOOLBAR-QUICKINFO = 'Add Row '. "Kısa bilgisi

APPEND LS_TOOLBAR to E_OBJECT->MT_TOOLBAR.

  ENDMETHOD.



ENDCLASS.