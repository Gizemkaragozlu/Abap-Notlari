--------TOP-------

*&---------------------------------------------------------------------*
*&  Include           ZFC_TEXT_TO_TABLE_TOP
*&---------------------------------------------------------------------*


DATA : it_itab TYPE STANDARD TABLE OF zfc_table WITH HEADER LINE."Kendi oluşturdugum bir tablo için internal tablo açıyorum

data lv_file type string."Dosya adını tutcak degisken


-------FRM--------

*&---------------------------------------------------------------------*
*&  Include           ZFC_TEXT_TO_TABLE_FRM
*&---------------------------------------------------------------------*

form get_data USING p_file."Dosya adını form forma parametre olarak vercegim

CALL FUNCTION 'GUI_UPLOAD'
  EXPORTING
    filename                      = p_file"Dosya adını alır
*   FILETYPE                      = 'ASC'
   HAS_FIELD_SEPARATOR           = '#'"Elbetteki seperator aracları kullanırak bu işlem yapılır bir alv cıktıssı kullanılarak text işlemini parcalayabiliyoruz
*   HEADER_LENGTH                 = 0
*   READ_BY_LINE                  = 'X'
*   DAT_MODE                      = ' '
   CODEPAGE                      = '4110'
*   IGNORE_CERR                   = ABAP_TRUE
*   REPLACEMENT                   = '#'
*   CHECK_BOM                     = ' '
*   VIRUS_SCAN_PROFILE            =
*   NO_AUTH_CHECK                 = ' '
* IMPORTING
*   FILELENGTH                    =
*   HEADER                        =
  TABLES
    data_tab                      = it_itab[]."Text bize tablo olarak doner

LOOP AT it_itab[] ASSIGNING FIELD-SYMBOL(<ifs_itab>)."Loop içinde text içinden aldıgımız tabloyu doneriz fieldsymbol yardımı ile

  "EBELN  BSART AEDAT AEDAT2  ERNAM TXZ01"Kolon adlarımı

  IF <ifs_itab>-aedat eq 0 or <ifs_itab>-aedat2 eq 0."Eger kolonlar boşsa(0) yani

    SHIFT <ifs_itab>-aedat LEFT DELETING LEADING '0'."Kolon degerlerini sileriz ve temizleriz
    SHIFT <ifs_itab>-aedat2 LEFT DELETING LEADING '0'.

  ENDIF.
ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form display_alv ."Reuse alv kullarak ekrana basma işlemi yapacagız

call function 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
   I_CALLBACK_PROGRAM                = sy-repid"Rapor ismini sistem structrından alırız
   I_STRUCTURE_NAME                  = 'ZFC_TABLE'"Sistem içindeki tablo adını structre gibi kullanarak fieldcatalog kullanmadan ekrana basarız
  tables
    t_outtab                          = it_itab[]"Textten donen tabloyu yazdır deriz
 EXCEPTIONS
   PROGRAM_ERROR                     = 1
   OTHERS                            = 2
   .
endform.

--------Main--------

*&---------------------------------------------------------------------*
*& Report ZFC_TEXT_TO_TABLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_TEXT_TO_TABLE.
INCLUDE  ZFC_TEXT_TO_TABLE_TOP.
INCLUDE  ZFC_TEXT_TO_TABLE_FRM.

PARAMETERS: P_FILE LIKE RLGRAP-FILENAME DEFAULT 'C:\'."Varsayılan dosya adımız c diski

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE."Parametrenin searchhelpine basarak 

CALL FUNCTION 'WS_FILENAME_GET'"Open file dialog gibi calışan fonksyonumuzu tetikleriz
EXPORTING
DEF_PATH = P_FILE
MASK = ',..'
MODE = '0 '
TITLE = 'Choose File'
IMPORTING
FILENAME = P_FILE
EXCEPTIONS
INV_WINSYS = 1
NO_BATCH = 2
SELECTION_CANCEL = 3
SELECTION_ERROR = 4
OTHERS = 5.



START-OF-SELECTION."Ve rapor run edildiginde
lv_file = p_file."Parametreden donen degeri degiskene veirirz

  PERFORM get_data USING lv_file."Perform il eoluştrudugumuz formları tetikleriz
  PERFORM display_alv."Reuse alv yi goruntuleriz