///Top////
*&---------------------------------------------------------------------*
*&  Include           ZFC_ALV_REUSE_KULLANIM_TOP
*&---------------------------------------------------------------------*

"Reuse merge kullanımı internal table ile kullanım bu degiskenler tabloyu dolduruken kullanılır
*DATA: BEGIN OF gt_list occurs 0,
*       ebeln like ekko-ebeln,
*       ebelp like ekpo-ebelp,
*       bstyp like ekko-bstyp,
*       bsart like ekko-bsart,
*       matnr like ekpo-matnr,
*       menge like ekpo-menge,
*       meins like ekpo-meins,
*       statu like ekpo-statu,
*  END OF gt_list.



TYPES: BEGIN OF gty_list,"global type list"
       EBELN type EBELN, "ebeln 2 tablodada olan colonumuzdur 2 tabloyu bu şekilde birletircez "Satın alma belge no (ekko)
       ebelp type ebelp,  "kalem no (ekpo)
       bstyp type ebstyp, "Belge tipi (Ekko)
       bsart type esart,   "Belge turu (Ekko)
       matnr type matnr,  "Malzeme numarası (Ekpo)
       menge type bstmg,  "Malzeme miktarı (Ekpo)
       meins type meins,  "miktar turu (Ekpo)
       statu type statu,  "siparis durumu (Ekpo)
  END OF gty_list.

"Tabloyu oluşturma
DATA: gt_list TYPE TABLE OF gty_list, "tablo oluşturma
      gs_list type gty_list. "structure

"Tablo oluşturulduktan sonra boş olur bizim bunu doldurmamz gerekir


"Field catalog oluşturma
DATA: gt_fieldcalatog TYPE SLIS_T_FIELDCAT_ALV,"field catalog tablomuz
      gs_fieldcalatog TYPE slis_fieldcat_alv. "filed catalog structutre


"Laoyut degiştirirek genel alv nin yapısını degiştirmek

"Layout oluşturmak layouty ozelleştirmek için alv yapsıının structureı kullanılır
DATA gs_layout TYPE SLIS_LAYOUT_ALV.

"Evenets yapısı
data: gt_events type SLIS_T_EVENT, "intern table
      gs_event type slis_alv_event. "structure

/////////FRM////////////
FORM GET_DATA .
"Tabloyu doldurma
"Query
"      Tire değil sinus işareti konur   ~        "
  select "kolonları al
    ekko~ebeln
    ekpo~ebelp
    ekko~bstyp
    ekko~bsart
    ekpo~matnr
    ekpo~menge
    ekpo~meins
  from ekko
  INNER JOIN ekpo on ekpo~EBELN eq ekko~EBELN   "iki tabloyu birleştiremk için iki tablodada olan kolonları kuullanırız
  INTO TABLE gt_list. "into table diyerekde gelen degerler ile tablomuzu dolduruyoruz



ENDFORM.



FORM SET_FIELDCATALOG .

"Bu fonksiyon tabloyu doldurmaya yaramaktadır
CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
 EXPORTING
   I_PROGRAM_NAME               = sy-REPID
*   I_INTERNAL_TABNAME           = 'GT_LIST' internal tablo ile
   I_STRUCTURE_NAME             = 'ZFC_EGT_ALV_S' "olşuturulmuş structure structure degerleri top klasorunde yazmaktadır
   I_INCLNAME                   = SY-REPID
  CHANGING
    CT_FIELDCAT                  = GT_FIELDCALATOG.

ENDFORM.


FORM SET_LAYOUT .

"Layout uzerinde değişiklik yapmak
GS_LAYOUT-WINDOW_TITLEBAR = 'Reuse alv kullanımı'."Başlık metni değiştirme
GS_LAYOUT-ZEBRA  = 'X'. "tabloya zebra deseni verme
GS_LAYOUT-COLWIDTH_OPTIMIZE = abap_true. "layoutun sutun genişlklerini optimize eder
"GS_LAYOUT-EDIT = 'X'. "daha onceki edit mode ile aynı fakat bu tablonun geneline editable ozellik katar


ENDFORM.

FORM DISPLAY_ALV .

"Events yapıları
gs_event-NAME = SLIS_EV_TOP_OF_PAGE. "Event id
gs_event-FORM = 'TOP_OF_PAGE'. "eventin form adı
APPEND gs_event to gt_events. "Structure yukarıda dolduruludu ve daha sonra intern table içerisine eklendi
clear gs_event.
gs_event-NAME = SLIS_EV_END_OF_LIST. "Event id
gs_event-FORM = 'END_OF_LIST'. "eventin form adı
APPEND gs_event to gt_events. "Structure yukarıda dolduruludu ve daha sonra intern table içerisine eklendi


CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
   I_CALLBACK_PROGRAM                = sy-repid "bu alan aşağıdaki callback ve function alanlarını bulundugu fonksşonların konumunu ister
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
*   I_CALLBACK_TOP_OF_PAGE            = 'TOP_OF_PAGE' "Başlık ve açıklama alanı denilebilir
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
   IS_LAYOUT                         = GS_LAYOUT
   IT_FIELDCAT                       = GT_FIELDCALATOG
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
*   I_SAVE                            = ' '
*   IS_VARIANT                        =
   IT_EVENTS                         =  gt_events "event yapısı
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
    T_OUTTAB                          = gt_list
* EXCEPTIONS
*   PROGRAM_ERROR                     = 1
*   OTHERS                            = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM TOP_OF_PAGE.
DATA: lt_header type slis_t_listheader,
      ls_header type slis_listheader.
data lv_date type char10.


" H = Header, S = Selection, A = Action

clear ls_header.
ls_header-TYP = 'H'.
ls_header-INFO = 'sas Tablosu'.
APPEND ls_header to lt_header.

CLEAR ls_header.
LS_HEADER-TYP = 'S'.
LS_HEADER-KEY = 'Tarih:'.
CONCATENATE sy-DATUM+6(2) "Substring yapar 6.karakterden sonra 2 karakter alır gelen tarih: 20220714.
            '.'
            sy-DATUM+4(2)
            '.'
            sy-DATUM+0(4)
            into lv_date.
LS_HEADER-INFO = lv_date.
APPEND LS_HEADER to LT_HEADER.


CLEAR ls_header.
ls_header-TYP = 'A'.
ls_header-INFO = 'Satin alma siparis raporu'.
APPEND ls_header to lt_header.



CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
  EXPORTING
    IT_LIST_COMMENTARY       = lt_header.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  END_OF_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM END_OF_LIST.
DATA: lt_header type slis_t_listheader,
      ls_header type slis_listheader.

data: lv_lines TYPE i,
      lv_lines_c type char5.


DESCRIBE TABLE GT_LIST LINES lv_lines."Herhangi bir intenral tablonun satır sayısını verir
LV_LINES_C = LV_LINES.
CLEAR ls_header.
LS_HEADER-TYP = 'A'.
CONCATENATE 'Bu raporda'
            lv_lines_c
            'adet kalem vardır'
            into LS_HEADER-INFO
            SEPARATED BY space.
APPEND LS_HEADER to LT_HEADER.


CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
  EXPORTING
    IT_LIST_COMMENTARY       = lt_header.

ENDFORM.
/////////////Main////////
*&---------------------------------------------------------------------*
*& Report ZFC_ALV_REUSE_KULLANIM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_ALV_REUSE_KULLANIM.

INCLUDE ZFC_ALV_REUSE_KULLANIM_TOP. "Tanımlamalar
INCLUDE ZFC_ALV_REUSE_KULLANIM_FRM. "form yapıları



START-OF-SELECTION.

PERFORM get_data.
PERFORM set_fieldcatalog.
PERFORM set_layout.
PERFORM display_alv.