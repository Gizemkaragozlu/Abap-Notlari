/////////Top/////////
*&---------------------------------------------------------------------*
*&  Include           ZFC_ALV_OO_ALV_KULLANIM_TOP
*&---------------------------------------------------------------------*

"Alv
DATA: go_alv TYPE REF TO CL_GUI_ALV_GRID, "oo_alv yi tanımladık
      go_container type REF TO CL_GUI_CUSTOM_CONTAINER. "alvyi tutcak bir de koneynıra ihtiyaç var onu da tanımladık

"Table data
DATA gt_scarr TYPE TABLE OF scarr.


////////PBO////////
*&---------------------------------------------------------------------*
*&  Include           ZFC_ALV_OO_ALV_KULLANIM_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.

  PERFORM dispaly_alv. "Alvyi ekrana basma

ENDMODULE.

//////////PAI///////////
*&---------------------------------------------------------------------*
*&  Include           ZFC_ALV_OO_ALV_KULLANIM_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.


CASE sy-ucomm.
  WHEN '&BACK'.
    SET SCREEN 0.
ENDCASE.
ENDMODULE.

///////////FRM/////////////
*&---------------------------------------------------------------------*
*&  Include           ZFC_ALV_OO_ALV_KULLANIM_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  DISPALY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPALY_ALV .

CREATE OBJECT GO_CONTAINER "bu kısımda da alv ye vercegimiz containırı oluşturuyoruz
  exporting
    CONTAINER_NAME                 =        'CC_ALV'."layout uzernde oluşturdugumuz custom container id si          " Name of the Container to Which this Container is Linked


CREATE OBJECT GO_ALV "Alvyi kullanmak için oluşturmamı gerekir
  exporting
    I_PARENT          =            go_container    ."container id si verilcek ama once oluşturulack
                                    "CL_GUI_CONTAINER=>SCREEN0 / da yazabilirdim hehrnagi bir contiane roluşturmadan da kullanabilirim



call METHOD GO_ALV->SET_TABLE_FOR_FIRST_DISPLAY "ekrana basmak için methodu çağırmamız gereklidir
  exporting
    I_STRUCTURE_NAME              =          'SCARR'        " Ekrana basılcak tablo tipi
  changing
    IT_OUTTAB                     =        gt_scarr  . "Veri bascagımız tablo.


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

SELECT * from scarr into TABLE gt_scarr.

ENDFORM.


//////////MAIN////////
*&---------------------------------------------------------------------*
*& Report ZFC_ALV_OO_ALV_KULLANIM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_ALV_OO_ALV_KULLANIM.

INCLUDE ZFC_ALV_OO_ALV_KULLANIM_TOP.
INCLUDE ZFC_ALV_OO_ALV_KULLANIM_PBO.
INCLUDE ZFC_ALV_OO_ALV_KULLANIM_PAI.
INCLUDE ZFC_ALV_OO_ALV_KULLANIM_FRM.

START-OF-SELECTION.

PERFORM get_data. "Tabloya veir çekme

  CAll SCREEN 0100.

///////////////////////////////////////////////////////
OO alv genelde hem screen uzerinde hemde screensiz kullanıma sahiptir