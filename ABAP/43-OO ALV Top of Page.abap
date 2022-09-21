///////////TOP/////////

*&---------------------------------------------------------------------*
*&  Include           ZFC_ALV_OO_ALV_DENEME_TOP
*&---------------------------------------------------------------------*


data: go_alv TYPE REF TO CL_GUI_ALV_GRID, "Alv yi tanımladık
      go_container type REF TO CL_GUI_CUSTOM_CONTAINER. "alvyi tutcak container

data gt_scarr type TABLE OF scarr. "Veri tablomuz

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


//////////FRM//////////////

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

"Top of page yapısı
CREATE OBJECT GO_SPLIT_CONTAINER "elimizdeki containir bolmek istiyoruz
  exporting
    PARENT                  =    GO_CONTAINER                 " Bolcegimiz containeri
    ROWS                    =    2                            " 2 SAtır olcak bir ustte top of page altında alv
    COLUMNS                 =    1              .              " 1 colon olcak herhangi bir ek bolum yapmayacagız

"Top of page i yonetecegmiz yapıuı creat ediyouz "Sade frm alanında creat işlemleri yapılır geriisi class yapısının içinde devam edilir
CREATE OBJECT GO_DOCU
  exporting
    STYLE            =      'ALV_GRID'.            " Adjusting to the Style of a Particular GUI Environment


"Boldgumuz kontaineria tutcakları yapıyı vermek
call METHOD GO_SPLIT_CONTAINER->GET_CONTAINER
  exporting
    ROW       =   1               " 1.rowda en başta top of page yapısı olcak
    COLUMN    =   1              " Column
  receiving
    CONTAINER =   GO_SUB1   .            " oluşturdugumuz sub1 yapısını veriyorz içerdeki objemizi tutması için

"Boldgumuz kontaineria tutcakları yapıyı vermek
call METHOD GO_SPLIT_CONTAINER->GET_CONTAINER
  exporting
    ROW       =   2               " 2.rowda Alv yapımjz olcak
    COLUMN    =   1              " Column
  receiving
    CONTAINER =   GO_SUB2   .            " oluşturdugumuz sub1 yapısını veriyorz içerdeki objemizi tutması için

"1. satır yuksekligimiz kucultuyoruz id dedigimiz sub1 ve sub2 dedigmiz yapıyı temsil eder
CALL METHOD GO_SPLIT_CONTAINER->SET_ROW_HEIGHT
  exporting
    ID                =   1               " Row ID
    HEIGHT            =   15        .       " Height


"Normalde alv yapımıza direk containır tutan yapımızı verirdik ama o yapıyı parçaladıgımız için artık onun bir parçası olan sub2 tutcak
CREATE OBJECT GO_ALV
  exporting
    I_PARENT          =        GO_SUB2. "         GO_CONTAINER. yapısı tutmicak o yapıyı bolduk onu parçaladıgımız yapı tutacak


"Oluşturdugumuz event classını methodlarını kullanabilmek için alv ye de tanıtmamız gereklidir
set HANDLER GO_EVENT_RECEIVER->HANDLE_TOP_OF_PAGE for GO_ALV."set handler diyerek methodumuzu cagırı hangi alv uzerinde kullanılcaksa onu ekleriz



GO_ALV->SET_TABLE_FOR_FIRST_DISPLAY(
  exporting
    IS_LAYOUT                     =        gs_layout          " Layout
  changing
    IT_OUTTAB                    =        GT_SCARR   "Veri bascagımız tablo.
    IT_FIELDCATALOG               =       GT_FCAT           " Kolon bazında duzenleme yapmamızı saglar
).

"Top of page yapısın ekrana basmak
  GO_ALV->LIST_PROCESSING_EVENTS(
    exporting
      I_EVENT_NAME      =        'TOP_OF_PAGE'           " Event Name List Processing
      I_DYNDOC_ID       =        GO_DOCU          " Dynamic Document
*      IS_SUBTOTTXT_INFO =                  " Subtotal Text Information
*      IP_SUBTOT_LINE    =                  " Subtotal Line
*      I_TABLE_INDEX     =                  " Loops, Current Loop Pass
*    changing
*      C_SUBTOTTXT       =                  " Subtotal Text
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
PERFORM SET_FCAT using 'CARRID' .
PERFORM SET_FCAT using 'CARRNAME' .
PERFORM SET_FCAT using 'CURRCODE' .
PERFORM SET_FCAT using 'URL' .
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

////////////CLS///////////////

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
      e_column_id.

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

  METHOD HANDLE_DATA_CHANGED.
    BREAK-POINT.
  ENDMETHOD.

  METHOD HANDLE_DOUBLE_CLICK.
    BREAK-POINT.
  ENDMETHOD.

  METHOD HANDLE_ONF4.
    BREAK-POINT.
  ENDMETHOD.

  METHOD HANDLE_HOTSPOT_CLICK.
    BREAK-POINT.
  ENDMETHOD.

ENDCLASS.