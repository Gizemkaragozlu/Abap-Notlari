//////////Main//////////

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

//////////TOP//////////

*&---------------------------------------------------------------------*
*&  Include           ZFC_ALV_OO_ALV_KULLANIM_TOP
*&---------------------------------------------------------------------*

"Alv
DATA: go_alv TYPE REF TO CL_GUI_ALV_GRID, "oo_alv yi tanımladık
      go_container type REF TO CL_GUI_CUSTOM_CONTAINER. "alvyi tutcak bir de koneynıra ihtiyaç var onu da tanımladık

"Table data
"DATA gt_scarr TYPE TABLE OF scarr.

"Field catalog
data: gt_fcat type lvc_t_fcat, "Field catalog intern table oluşturuldu
      gs_fcat type lvc_s_fcat. "Field catalog structure

"Layout işlemleri
data gs_layout TYPE LVC_S_LAYO. "structure

"Field symbol ile oluşturulmuş gorunum uzerinde değişiklik yapma
FIELD-SYMBOLS: <gfs_fcat> type lvc_s_fcat."Kolon uzerinde degisiklik yapmak için


"Tablo oluşturma renk değişimi için
"buraya eklenn butun dataların eklenmesi için field catalog içine de eklenmesi gerekir
TYPES: BEGIN OF gty_scarr,
  icon type icon_d, "icon kolonu için domain
  CARRID type S_CARR_ID,
  CARRNAME type S_CARRNAME,
  CURRCODE type S_CURRCODE,
  URL type S_CARRURL,
  COST type i,
  LOCATION type char10, "dropdown için
  SINIF type char10, "dinamik dropdown için
  DD_SINIF type char1, "dinamik dropdown için
  END OF gty_scarr.

data gs_cell_color type LVC_S_SCOL. "Cell color structure

data: gt_scarr TYPE TABLE OF gty_scarr,
      gs_scarr TYPE gty_scarr.

FIELD-SYMBOLS <gfs_scarr> type gty_scarr."linecolor vermek için


///////PBO/////////


*&---------------------------------------------------------------------*
*&  Include           ZFC_ALV_OO_ALV_KULLANIM_TOP
*&---------------------------------------------------------------------*

"Alv
DATA: go_alv TYPE REF TO CL_GUI_ALV_GRID, "oo_alv yi tanımladık
      go_container type REF TO CL_GUI_CUSTOM_CONTAINER. "alvyi tutcak bir de koneynıra ihtiyaç var onu da tanımladık

"Table data
"DATA gt_scarr TYPE TABLE OF scarr.

"Field catalog
data: gt_fcat type lvc_t_fcat, "Field catalog intern table oluşturuldu
      gs_fcat type lvc_s_fcat. "Field catalog structure

"Layout işlemleri
data gs_layout TYPE LVC_S_LAYO. "structure

"Field symbol ile oluşturulmuş gorunum uzerinde değişiklik yapma
FIELD-SYMBOLS: <gfs_fcat> type lvc_s_fcat."Kolon uzerinde degisiklik yapmak için


"Tablo oluşturma renk değişimi için
"buraya eklenn butun dataların eklenmesi için field catalog içine de eklenmesi gerekir
TYPES: BEGIN OF gty_scarr,
  icon type icon_d, "icon kolonu için domain
  CARRID type S_CARR_ID,
  CARRNAME type S_CARRNAME,
  CURRCODE type S_CURRCODE,
  URL type S_CARRURL,
  COST type i,
  LOCATION type char10, "dropdown için
  SINIF type char10, "dinamik dropdown için
  DD_SINIF type char1, "dinamik dropdown için
  END OF gty_scarr.

data gs_cell_color type LVC_S_SCOL. "Cell color structure

data: gt_scarr TYPE TABLE OF gty_scarr,
      gs_scarr TYPE gty_scarr.

FIELD-SYMBOLS <gfs_scarr> type gty_scarr."linecolor vermek için


///////PAI/////////


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
  WHEN '&SAVE'.
    PERFORM get_sum.
ENDCASE.
ENDMODULE.


////////////FRM/////////////


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


CREATE OBJECT GO_CONTAINER "bu kısımda da alv ye vercegimiz containırı oluşturuyoruz
  exporting
    CONTAINER_NAME                 =        'CC_ALV'."layout uzernde oluşturdugumuz custom container id si          " Name of the Container to Which this Container is Linked

CREATE OBJECT GO_ALV "Alvyi kullanmak için oluşturmamı gerekir
  exporting
    I_PARENT          =            go_container    ."container id si verilcek ama once oluşturulack
                                    "CL_GUI_CONTAINER=>SCREEN0 / da yazabilirdim hehrnagi bir contiane roluşturmadan da kullanabilirim

"Dropdown içini doldurma
PERFORM set_dropdown.



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

LOOP AT gt_scarr ASSIGNING <GFS_SCARR>.

  CASE <GFS_SCARR>-CURRCODE.
    WHEN 'EUR'.
      <GFS_SCARR>-DD_SINIF = '2'.
    WHEN 'USD'.
      <GFS_SCARR>-DD_SINIF = '3'.
    WHEN OTHERS.
      <GFS_SCARR>-DD_SINIF = '4'.
  ENDCASE.

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
PERFORM CREATE_FCAT USING 'ICON' 'icon' 'icon' 'icon' 0 '' '' '' 0 ''. "icon kolonu için
PERFORM CREATE_FCAT USING 'CARRID' 'Air c.' 'Airline c.' 'Airline code' 1 '' 'X' '' 0 ''.
PERFORM CREATE_FCAT USING 'CARRNAME' 'A. Name' 'Air Name' 'Airline Name' 2 '' '' '' 0 ''.
PERFORM CREATE_FCAT USING 'CURRCODE' 'Curr' 'Local Curr' 'Local currency of airline' 3 '' '' '' 0 ''.
PERFORM CREATE_FCAT USING 'URL' 'A. Url' 'Air Url' 'Airline Url' 4 'X' '' '' 0 ''.
PERFORM CREATE_FCAT USING 'COST' 'Cost' 'Cost' 'Cost' 5 'X' '' 'X' 0 ''.
PERFORM CREATE_FCAT USING 'LOCATION' 'Lokasyon' 'Lokasyon' 'Lokasyon' 6 'X' '' 'X' 1 ''.
PERFORM CREATE_FCAT USING 'SINIF' 'Ucus s.' 'Ucus s' 'Ucus sınfıı' 7 'X' '' 'X' 0 'DD_SINIF'. "dd sınıf bizm drop down alanımız olcak



ENDFORM.

"Manuel field catalog oluşturma
FORM CREATE_FCAT USING p_fieldname
                       P_scrtext_s
                       p_scrtext_m
                       p_scrtext_l
                       p_col_pos
                       p_col_opt
                       p_key
                       p_edit
                       p_drdn
                       p_drdn_f.

CLEAR GS_FCAT.
GS_FCAT-FIELDNAME  = P_fieldname. "Kolon adı eger verilmezse o kolon alv de gozukmez
GS_FCAT-SCRTEXT_S  = P_scrtext_s. "Kolon adı kısa
GS_FCAT-SCRTEXT_M  = p_scrtext_m. "kolon adı orta
GS_FCAT-SCRTEXT_L  = p_scrtext_l. "kolon adı uzun
GS_FCAT-COL_POS    = P_col_pos.   "kolon sırası
GS_FCAT-COL_OPT    = p_col_opt.   "kolon optimizasyonu en uzun metne kadar kolon genişligini ayarlar
GS_FCAT-KEY        = p_key.       "Key alanı ise kolon rengi digerlerinden daha farkı olur
GS_FCAT-Edit       = p_edit.      "Editlenebilir olsun mu olmasın mi
GS_FCAT-DRDN_HNDL  = p_drdn.       "dropdown handle id birden fazla dropdown olabilir bu yuzden id veriypruz "dropdown ekleme
GS_FCAT-DRDN_FIELD = p_drdn_f.       "dropdown handle id birden fazla dropdown olabilir bu yuzden id veriypruz "dropdown ekleme

APPEND GS_FCAT to GT_FCAT.

  ENDFORM.




FORM SET_LAYOUT .

CLEAR GS_LAYOUT.
GS_LAYOUT-CWIDTH_OPT = 'X'. "tum kolonların colon genişligi optimizsayonu yapılır
GS_LAYOUT-ZEBRA      = 'X'. "satırları zebra desenine çevirir.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_SUM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_SUM ."editable modda girilen degerleri yakalama

Data: lv_sum type i,
      lv_avg type i,
      lv_lines type i.

LOOP AT GT_SCARR into GS_SCARR.
  lv_sum = lv_sum  + GS_SCARR-COST. "toplam değişkenime cost stununundak, degerleri atıyorum
ENDLOOP.

DESCRIBE TABLE GT_SCARR LINES lv_lines. "describe table bize satır sayısını veriri

lv_avg = lv_sum / LV_LINES. "toplam değişkenini topla satır sayısına bolunce ortlama çıkıyor

LOOP AT GT_SCARR ASSIGNING <GFS_SCARR>. "ortalamayı hesaplaynca icon eklemek için tekrar modify kullanammak için field symbol ile uzeriden gezip

  IF <GFS_SCARR>-COST > LV_AVG. "ortalamalara gore işlemler yapılıypr
      <GFS_SCARR>-ICON = '@0A@'. "Yeşil trafik lamp
  ELSEIF <GFS_SCARR>-COST < LV_AVG.
      <GFS_SCARR>-ICON = '@08@'. "Kırmızı trafik lamp
  else.
      <GFS_SCARR>-ICON = '@09@'. "tururncu trafik lamp
  ENDIF.
ENDLOOP.

  "bu kadar ile işlem bitmeyip alv ekranının yenilenmesi gerekir

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_DROPDOWN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SET_DROPDOWN . "Dropdown doldurma

DATA:lt_dropdown type LVC_T_DROP, "intern table
     ls_dropdown type LVC_S_DROP. "structe

CLEAR ls_dropdown.

LS_DROPDOWN-HANDLE = 1. "Dropdownn oluştururken ki id
LS_DROPDOWN-VALUE = 'Yurt içi'. "Dropdown verisi
APPEND LS_DROPDOWN to LT_DROPDOWN.

LS_DROPDOWN-HANDLE = 1. "Dropdownn oluştururken ki id
LS_DROPDOWN-VALUE = 'Yurt Dışı'. "Dropdown verisi
APPEND LS_DROPDOWN to LT_DROPDOWN.


LS_DROPDOWN-HANDLE = 2. "Dropdownn oluştururken ki id
LS_DROPDOWN-VALUE = 'Ekonomi'. "Dropdown verisi
APPEND LS_DROPDOWN to LT_DROPDOWN.

LS_DROPDOWN-HANDLE = 2. "Dropdownn oluştururken ki id
LS_DROPDOWN-VALUE = 'Bussines'. "Dropdown verisi
APPEND LS_DROPDOWN to LT_DROPDOWN.

LS_DROPDOWN-HANDLE = 2. "Dropdownn oluştururken ki id
LS_DROPDOWN-VALUE = 'Middle'. "Dropdown verisi
APPEND LS_DROPDOWN to LT_DROPDOWN.


LS_DROPDOWN-HANDLE = 3. "Dropdownn oluştururken ki id
LS_DROPDOWN-VALUE = 'Ekonomi'. "Dropdown verisi
APPEND LS_DROPDOWN to LT_DROPDOWN.


LS_DROPDOWN-HANDLE = 3. "Dropdownn oluştururken ki id
LS_DROPDOWN-VALUE = 'Bussines'. "Dropdown verisi
APPEND LS_DROPDOWN to LT_DROPDOWN.



LS_DROPDOWN-HANDLE = 4. "Dropdownn oluştururken ki id
LS_DROPDOWN-VALUE = 'Mıddle'. "Dropdown verisi
APPEND LS_DROPDOWN to LT_DROPDOWN.



GO_ALV->SET_DROP_DOWN_TABLE(
  exporting
    IT_DROP_DOWN       =        LT_DROPDOWN "Oluşturdugumuz dropdown tablosu
).

ENDFORM.