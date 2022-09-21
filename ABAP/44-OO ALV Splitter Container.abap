///////////TOP///////////

DATA: go_alv TYPE REF TO CL_GUI_ALV_GRID, "Alvler
      go_alv2 TYPE REF TO CL_GUI_ALV_GRID,
      go_alv3 TYPE REF TO CL_GUI_ALV_GRID,
      go_alv4 TYPE REF TO CL_GUI_ALV_GRID.


data: gt_fcat type lvc_t_fcat,
      gt_fcat2 type lvc_t_fcat,
      gt_fcat3 type lvc_t_fcat,
      gt_fcat4 type lvc_t_fcat,
      gs_layout TYPE LVC_S_LAYO.

data: gt_scarr TYPE TABLE OF scarr,
      gt_sflight TYPE TABLE OF sflight,
      gt_ekko TYPE TABLE OF ekko,
      gt_ekpo TYPE TABLE OF ekpo.


"Ekran bolme işlemleri
data: go_splitter TYPE REF TO CL_GUI_SPLITTER_CONTAINER,
      go_sub1 TYPE REF TO CL_GUI_CONTAINER,
      go_sub2 TYPE REF TO CL_GUI_CONTAINER,
      go_sub3 TYPE REF TO CL_GUI_CONTAINER,
      go_sub4 TYPE REF TO CL_GUI_CONTAINER.


///////////FRM//////////////


FORM DISPALY_ALV .



CREATE OBJECT GO_SPLITTER
  exporting
    PARENT                  =          CL_GUI_CONTAINER=>SCREEN0
    ROWS                    =            2
    COLUMNS                 =            2.        " Number of Columns to be Displayed

call METHOD GO_SPLITTER->GET_CONTAINER
  exporting
    ROW       =                 1 " Row
    COLUMN    =                 1 " Column
  receiving
    CONTAINER =              GO_SUB1.

call METHOD GO_SPLITTER->GET_CONTAINER
  exporting
    ROW       =                 2 " Row
    COLUMN    =                 1 " Column
  receiving
    CONTAINER =              GO_SUB2.

call METHOD GO_SPLITTER->GET_CONTAINER
  exporting
    ROW       =                 1 " Row
    COLUMN    =                 2 " Column
  receiving
    CONTAINER =              GO_SUB3.

call METHOD GO_SPLITTER->GET_CONTAINER
  exporting
    ROW       =                 2 " Row
    COLUMN    =                 2 " Column
  receiving
    CONTAINER =              GO_SUB4.

CREATE OBJECT GO_ALV "Alvyi kullanmak için oluşturmamı gerekir
  exporting
    I_PARENT          =           GO_SUB1.



CREATE OBJECT GO_ALV3
  exporting
    I_PARENT          =           go_sub2.  " Parent Container


CREATE OBJECT GO_ALV4
  exporting
    I_PARENT          =           go_sub3.  " Parent Container

CREATE OBJECT GO_ALV2
  exporting
    I_PARENT          =           go_sub4.  " Parent Container

                                    "CL_GUI_CONTAINER=>SCREEN0 / da yazabilirdim hehrnagi bir contiane roluşturmadan da kullanabilirim
call METHOD GO_ALV->SET_TABLE_FOR_FIRST_DISPLAY
  exporting
 "I_STRUCTURE_NAME              =          'SCARR'        " Ekrana basılcak tablo tipi / Diğer adıyla fieldcatalogg
    IS_LAYOUT                     = gs_layout
  changing
    IT_OUTTAB                    =       gt_scarr   "Veri bascagımız tablo.
    IT_FIELDCATALOG               =       GT_FCAT  .          " Kolon bazında duzenleme yapmamızı saglar

call METHOD GO_ALV2->SET_TABLE_FOR_FIRST_DISPLAY
  exporting
    "I_STRUCTURE_NAME              =          'SFLIGHT'
    IS_LAYOUT                     =          GS_LAYOUT        " Layout
  changing
    IT_OUTTAB                     =          GT_SFLIGHT        " Output Table
    IT_FIELDCATALOG               =          GT_FCAT2.        " Field Catalog

call METHOD GO_ALV3->SET_TABLE_FOR_FIRST_DISPLAY
  exporting
    "I_STRUCTURE_NAME              =          'SFLIGHT'
    IS_LAYOUT                     =          GS_LAYOUT        " Layout
  changing
    IT_OUTTAB                     =          gt_ekko        " Output Table
    IT_FIELDCATALOG               =          GT_FCAT3.        " Field Catalog

call METHOD GO_ALV4->SET_TABLE_FOR_FIRST_DISPLAY
  exporting
    "I_STRUCTURE_NAME              =          'SFLIGHT'
    IS_LAYOUT                     =          GS_LAYOUT        " Layout
  changing
    IT_OUTTAB                     =          gt_ekpo        " Output Table
    IT_FIELDCATALOG               =          GT_FCAT4.        " Field Catalog

ENDFORM.



FORM GET_DATA .

SELECT * from scarr into CORRESPONDING FIELDS OF TABLE gt_scarr .

SELECT * from sflight UP TO 20 ROWS into CORRESPONDING FIELDS OF TABLE GT_SFLIGHT .

SELECT * from ekko UP TO 20 ROWS into CORRESPONDING FIELDS OF TABLE GT_EKKO .

SELECT * from ekpo UP TO 20 ROWS into CORRESPONDING FIELDS OF TABLE GT_EKPO .

ENDFORM.

FORM SET_FCAT .

CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
 EXPORTING
   I_STRUCTURE_NAME             =  'SCARR'
  CHANGING
    CT_FIELDCAT                  =  GT_FCAT.


CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
 EXPORTING
   I_STRUCTURE_NAME             =  'SFLIGHT'
  CHANGING
    CT_FIELDCAT                  =  GT_FCAT2.



CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
 EXPORTING
   I_STRUCTURE_NAME             =  'EKKO'
  CHANGING
    CT_FIELDCAT                  =  GT_FCAT3.


CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
 EXPORTING
   I_STRUCTURE_NAME             =  'EKPO'
  CHANGING
    CT_FIELDCAT                  =  GT_FCAT4.

ENDFORM.




FORM SET_LAYOUT .

CLEAR GS_LAYOUT.

GS_LAYOUT-CWIDTH_OPT = 'X'. "tum kolonların colon genişligi optimizsayonu yapılır
GS_LAYOUT-ZEBRA      = 'X'. "satırları zebra desenine çevirir.

ENDFORM.