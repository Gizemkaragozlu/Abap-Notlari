--------TOP-------

*&---------------------------------------------------------------------*
*&  Include           ZFC_TEXT_TO_TABLE_TOP
*&---------------------------------------------------------------------*


DATA : it_itab TYPE STANDARD TABLE OF zfc_table WITH HEADER LINE.

data lv_file type string.


-------FRM--------

*&---------------------------------------------------------------------*
*&  Include           ZFC_TEXT_TO_TABLE_FRM
*&---------------------------------------------------------------------*

form get_data USING p_file.

CALL FUNCTION 'GUI_UPLOAD'
  EXPORTING
    filename                      = p_file
*   FILETYPE                      = 'ASC'
   HAS_FIELD_SEPARATOR           = '#'
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
    data_tab                      = it_itab[].

LOOP AT it_itab[] ASSIGNING FIELD-SYMBOL(<ifs_itab>).
  "EBELN  BSART AEDAT AEDAT2  ERNAM TXZ01
  IF <ifs_itab>-aedat eq 0 or <ifs_itab>-aedat2 eq 0.

    SHIFT <ifs_itab>-aedat LEFT DELETING LEADING '0'.
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
form display_alv .

call function 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
   I_CALLBACK_PROGRAM                = sy-repid
   I_STRUCTURE_NAME                  = 'ZFC_TABLE'
  tables
    t_outtab                          = it_itab[]
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

PARAMETERS: P_FILE LIKE RLGRAP-FILENAME DEFAULT 'C:\'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.

CALL FUNCTION 'WS_FILENAME_GET'
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



START-OF-SELECTION.
lv_file = p_file.

  PERFORM get_data USING lv_file.
  PERFORM display_alv.