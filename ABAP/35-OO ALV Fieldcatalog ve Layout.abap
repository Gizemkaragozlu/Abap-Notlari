///////////top//////////
"Alv
DATA: go_alv TYPE REF TO CL_GUI_ALV_GRID, "oo_alv yi tanımladık
      go_container type REF TO CL_GUI_CUSTOM_CONTAINER. "alvyi tutcak bir de koneynıra ihtiyaç var onu da tanımladık

"Table data
DATA gt_scarr TYPE TABLE OF scarr.

"Field catalog
data: gt_fcat type lvc_t_fcat, "Field catalog intern table oluşturuldu
      gs_fcat type lvc_s_fcat. "Field catalog structure

"Layout işlemleri
data gs_layout TYPE LVC_S_LAYO. "structure

///////////PBO////////
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.

  PERFORM dispaly_alv. "Alvyi ekrana basma

ENDMODULE.

///////////////PAI////////////
MODULE USER_COMMAND_0100 INPUT.


CASE sy-ucomm.
  WHEN '&BACK'.
    SET SCREEN 0.
ENDCASE.
ENDMODULE.

///////////////////////////FRM//////////////////////////ü

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



call METHOD GO_ALV->SET_TABLE_FOR_FIRST_DISPLAY " "ekrana basmak için methodu çağırmamız gereklidir
  exporting
*    I_BUFFER_ACTIVE               =
*    I_BYPASSING_BUFFER            =
*    I_CONSISTENCY_CHECK           =
 "I_STRUCTURE_NAME              =          'SCARR'        " Ekrana basılcak tablo tipi / Diğer adıyla fieldcatalogg
*    IS_VARIANT                    =
*    I_SAVE                        =
*    I_DEFAULT                     = 'X'
    IS_LAYOUT                     = gs_layout
*    IS_PRINT                      =
*    IT_SPECIAL_GROUPS             =
*    IT_TOOLBAR_EXCLUDING          =
*    IT_HYPERLINK                  =
*    IT_ALV_GRAPHICS               =
*    IT_EXCEPT_QINFO               =
*    IR_SALV_ADAPTER               =
  changing
    IT_OUTTAB                    =        gt_scarr   "Veri bascagımız tablo.
    IT_FIELDCATALOG               =       GT_FCAT           " Kolon bazında duzenleme yapmamızı saglar
*    IT_SORT                       =
*    IT_FILTER                     =
*  exceptions
*    INVALID_PARAMETER_COMBINATION = 1
*    PROGRAM_ERROR                 = 2
*    TOO_MANY_LINES                = 3
*    OTHERS                        = 4
.



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

SELECT * from scarr into TABLE gt_scarr .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SET_FCAT .

PERFORM CREATE_FCAT USING 'CARRID' 'Air c.' 'Airline c.' 'Airline code' 1 '' 'X'.
PERFORM CREATE_FCAT USING 'CARRNAME' 'A. Name' 'Air Name' 'Airline Name' 2 '' ''.
PERFORM CREATE_FCAT USING 'CURRCODE' 'Curr' 'Local Curr' 'Local currency of airline' 3 '' ''.
PERFORM CREATE_FCAT USING 'URL' 'A. Url' 'Air Url' 'Airline Url' 4 'X' ''.

ENDFORM.

FORM CREATE_FCAT USING p_fieldname
                       P_scrtext_s
                       p_scrtext_m
                       p_scrtext_l
                       p_col_pos
                       p_col_opt
                       p_key.

CLEAR GS_FCAT.
GS_FCAT-FIELDNAME = P_fieldname. "Kolon adı eger verilmezse o kolon alv de gozukmez
GS_FCAT-SCRTEXT_S = P_scrtext_s. "Kolon adı kısa
GS_FCAT-SCRTEXT_M = p_scrtext_m. "kolon adı orta
GS_FCAT-SCRTEXT_L = p_scrtext_l. "kolon adı uzun
GS_FCAT-COL_POS   = P_col_pos.   "kolon sırası
GS_FCAT-COL_OPT   = p_col_opt.   "kolon optimizasyonu en uzun metne kadar kolon genişligini ayarlar
GS_FCAT-KEY       = p_key.       "Key alanı ise kolon rengi digerlerinden daha farkı olur
"GS_FCAT-HOTSPOT   = 'x'.      "kolona tıklanabilme ozelligi saglar
"GS_FCAT-NO_OUT    = 'X'.       "Ekranda gozunme ozellgini kapatır
"GS_FCAT-OUTPUTLEN = 100.      "Kolonun genişliğni istenen karakter sayısına gore ayarlar
"GS_FCAT-REF_TABLE = 'SCARR'. "bu tabloyu referans al
"GS_FCAT-REF_FIELD = 'sutunad'. "referans aldıgın tablodaki bu kolon ile sutunu ozelleştir yani tablodaki sutun yapısı ile burdaki sutun yapsını ozelleştircektir
                              "orn kısa ad uzun ad key olaylarnı otomatik olarak yapcaktır

APPEND GS_FCAT to GT_FCAT.

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

CLEAR GS_LAYOUT.
GS_LAYOUT-CWIDTH_OPT = 'X'. "tum kolonların colon genişligi optimizsayonu yapılır
"GS_LAYOUT-EDIT        ABAP_TRUE. "butun kolonların ediatble ollmasını saglar
"GS_LAYOUT-NO_TOOLBAR = 'X'. "toolbarı gizler
GS_LAYOUT-ZEBRA      = 'X'. "satırları zebra desenine çevirir.
ENDFORM.

/////////////////////MAIN////////////////

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



PERFORM get_data . "Tabloya veir çekme

PERFORM set_fcat. "Field catalog dodlurma

PERFORM set_layout. "Alv layout ozelleştirme

  CAll SCREEN 0100.