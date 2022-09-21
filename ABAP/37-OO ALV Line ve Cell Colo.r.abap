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
TYPES: BEGIN OF gty_scarr,
  CARRID type S_CARR_ID,
  CARRNAME type S_CARRNAME,
  CURRCODE type S_CURRCODE,
  URL type S_CARRURL,
  linecolor type char4, "satır renklendirme
  cell_color type LVC_T_SCOL,"hucre renklendirme tablosu
  END OF gty_scarr.

data gs_cell_color type LVC_S_SCOL. "Cell color structure

data: gt_scarr TYPE TABLE OF gty_scarr.

FIELD-SYMBOLS <gfs_scarr> type gty_scarr."linecolor vermek için

/////////GET_DATA///////////


FORM GET_DATA .

SELECT * from scarr into CORRESPONDING FIELDS OF TABLE gt_scarr .

"Dongu kurduk gelen datanın uzerinde bu datayı fieldsymbolumuze ekledik
LOOP AT gt_scarr ASSIGNING <GFS_SCARR>.
  CASE <GFS_SCARR>-CURRCODE.
    WHEN 'USD'.
      <GFS_SCARR>-LINECOLOR = 'C610'. "field-symbol içindekilerinin satır rengini kırmzıı yaptık
    WHEN 'JPY'.
      <GFS_SCARR>-LINECOLOR = 'C710'.
    WHEN 'EUR'.
       clear: gs_cell_color.
       GS_CELL_COLOR-FNAME = 'CURRCODE'.
       GS_CELL_COLOR-COLOR-COL = '3'.
       GS_CELL_COLOR-COLOR-int = '1'.
       GS_CELL_COLOR-COLOR-inv = '0'.
       APPEND GS_CELL_COLOR to <GFS_SCARR>-CELL_COLOR.
  ENDCASE.
endloop.


ENDFORM.

///////////SET_LAYOUT///////////

FORM SET_LAYOUT .

CLEAR GS_LAYOUT.
GS_LAYOUT-CWIDTH_OPT = 'X'. "tum kolonların colon genişligi optimizsayonu yapılır
"GS_LAYOUT-EDIT        ABAP_TRUE. "butun kolonların ediatble ollmasını saglar
"GS_LAYOUT-NO_TOOLBAR = 'X'. "toolbarı gizler
GS_LAYOUT-ZEBRA      = 'X'. "satırları zebra desenine çevirir.
GS_LAYOUT-INFO_FNAME = 'LINECOLOR'. "kolonun bir veri tutmayacagını soyleriz
GS_LAYOUT-CTAB_FNAME = 'CELL_COLOR'. "cell color

ENDFORM.