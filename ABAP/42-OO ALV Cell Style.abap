///////TOP/////////

*&---------------------------------------------------------------------*
*&  Include           ZFC_ALV_OO_ALV_KULLANIM_TOP
*&---------------------------------------------------------------------*

"Alv
DATA: go_alv TYPE REF TO CL_GUI_ALV_GRID,
      go_container type REF TO CL_GUI_CUSTOM_CONTAINER.


data: gt_fcat type lvc_t_fcat,
      gs_fcat type lvc_s_fcat,
      gs_layout TYPE LVC_S_LAYO.


TYPES: BEGIN OF gty_scarr,
  CARRID   type S_CARR_ID,
  CARRNAME type S_CARRNAME,
  CURRCODE type S_CURRCODE,
  URL      type S_CARRURL,
  STYLE    type LVC_T_STYL,"Cell style için table " sadece bu kadar ile kalmaz layouta da bunu bildirmek gereklidir
  styleC type char8,
  END OF gty_scarr.

  data gs_style TYPE LVC_S_STYL. "Cell style structure

data: gt_scarr TYPE TABLE OF gty_scarr,
      gs_scarr TYPE gty_scarr.

FIELD-SYMBOLS: <gfs_scarr> type gty_scarr."linecolor vermek için


//////////FRM///////////

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

IF GO_ALV is INITIAL.
*
*CREATE OBJECT GO_CONTAINER "bu kısımda da alv ye vercegimiz containırı oluşturuyoruz
*  exporting
*    CONTAINER_NAME                 =        'CC_ALV'."layout uzernde oluşturdugumuz custom container id si          " Name of the Container to Which this Container is Linked



CREATE OBJECT GO_ALV "Alvyi kullanmak için oluşturmamı gerekir
  exporting
    I_PARENT          =            CL_GUI_CONTAINER=>SCREEN0.    ."container id si verilcek ama once oluşturulack
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
    IT_OUTTAB                    =       gt_scarr   "Veri bascagımız tablo.
    IT_FIELDCATALOG               =       GT_FCAT           " Kolon bazında duzenleme yapmamızı saglar
*    IT_SORT                       =
*    IT_FILTER                     =
*  exceptions
*    INVALID_PARAMETER_COMBINATION = 1
*    PROGRAM_ERROR                 = 2
*    TOO_MANY_LINES                = 3
*    OTHERS                        = 4
.

"editable modda deger yakalamakj istersek event eklememiz gerekir
call METHOD GO_ALV->REGISTER_EDIT_EVENT
  exporting
    I_EVENT_ID =                CL_GUI_ALV_GRID=>MC_EVT_MODIFIED. "bir satırdan çıkılınca event tetiklensin yani degerler yakalabilir olsun


call METHOD GO_ALV->REGISTER_EDIT_EVENT
  exporting
    I_EVENT_ID =                CL_GUI_ALV_GRID=>MC_EVT_ENTER. "bir satırda enter yapınca işlemler yakalanbilir olsun


else.

call METHOD GO_ALV->REFRESH_TABLE_DISPLAY."bu fonksion ekranın yenilenmesini saglar egerk if bloguna alınmazsa alv daha once oluşturuldumu diye
"bize hata verir ve her seferide alvyi yeniden oluşturur biz de ğişiklikleri yakalayamaz ikon ekleyemeyeiz

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

SELECT * from scarr into CORRESPONDING FIELDS OF TABLE gt_scarr .

*LOOP AT gt_scarr ASSIGNING <GFS_SCARR>. "tabloda don ve assign et field symbole
*
*IF <GFS_SCARR>-CURRCODE <> 'EUR'. "eger currcode euro degil ise
*CLEAR GS_STYLE.
*GS_STYLE-FIELDNAME = 'URL'. "url kolonun
*GS_STYLE-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED. "editablını kapat
*APPEND GS_STYLE to <GFS_SCARR>-STYLE. "ve tabloyu etkile
*ENDIF.
*
*ENDLOOP.

DATA: lv_style type n LENGTH 8,
      lv_style_c type char8.

DATA(gt_scarr_tmp) = gt_scarr. "tabloyu kopyalar tablo oluşturur

DO 30 TIMES.
APPEND LINES OF gt_scarr_tmp to gt_scarr. "tablonun satırlarını ekler
ENDDO.




LOOP AT GT_scarr ASSIGNING <GFS_SCARR>. "tabloda don assign et

LV_STYLE = LV_STYLE + 1. "her dongude 1 don
LV_STYLE_C = LV_STYLE. "her dongude degeri char tipine cevir
<GFS_SCARR>-STYLEC =  LV_STYLE_C. "her dongude degeri kolona yaz

clear gs_style. "structe temizle
GS_STYLE-FIELDNAME = 'URL'. "secilen kolonon
GS_STYLE-STYLE = LV_STYLE_C. "secilen sitilini ver 8 karekterli bi deger alıyor biz random veriyorz

APPEND GS_STYLE to <GFS_SCARR>-STYLE. "tabloyu etkliemek için assign edilen field symbole ekle

ENDLOOP.


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
*
PERFORM CREATE_FCAT USING 'CARRID' 'Air c.' 'Airline c.' 'Airline code' '' .
PERFORM CREATE_FCAT USING 'CARRNAME' 'A. Name' 'Air Name' 'Airline Name' ''.
PERFORM CREATE_FCAT USING 'CURRCODE' 'Curr' 'Local Curr' 'Local currency of airline' ''.
PERFORM CREATE_FCAT USING 'URL' 'A. Url' 'Air Url' 'Airline Url' 'X'.
PERFORM CREATE_FCAT USING 'STYLEC' 'S. C.' 'Style c' 'Style code' ''.



ENDFORM.

"Manuel field catalog oluşturma
FORM CREATE_FCAT USING p_fieldname
                       P_scrtext_s
                       p_scrtext_m
                       p_scrtext_l
                       p_edit.

CLEAR GS_FCAT.
GS_FCAT-FIELDNAME  = P_fieldname. "Kolon adı eger verilmezse o kolon alv de gozukmez
GS_FCAT-SCRTEXT_S  = P_scrtext_s. "Kolon adı kısa
GS_FCAT-SCRTEXT_M  = p_scrtext_m. "kolon adı orta
GS_FCAT-SCRTEXT_L  = p_scrtext_l. "kolon adı uzun
GS_FCAT-EDIT       = p_edit.      "Editlenebilir olsun mu olmasın mi
APPEND GS_FCAT to GT_FCAT.

  ENDFORM.




FORM SET_LAYOUT .

CLEAR GS_LAYOUT.
GS_LAYOUT-CWIDTH_OPT = 'X'. "tum kolonların colon genişligi optimizsayonu yapılır
GS_LAYOUT-ZEBRA      = 'X'. "satırları zebra desenine çevirir.
GS_LAYOUT-STYLEFNAME = 'STYLE'. "cell style için layoutada bu işlem tanımlanır
ENDFORM.