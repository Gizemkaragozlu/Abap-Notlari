Top klasoru
////////////////////////////////
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



/////////////////////////////////////////////////////
FRM klasoru
////////////////////////////////////////////////
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

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
*   I_CALLBACK_PROGRAM                = ' '
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
*   I_CALLBACK_TOP_OF_PAGE            = ' '
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
*   IT_EVENTS                         =
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

//////////////////////////////////
Main
////////////////////////////////
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
