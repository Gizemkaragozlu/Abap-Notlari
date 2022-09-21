*&---------------------------------------------------------------------*
*& Report ZFC_ALV_SALV_KULLANIM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_ALV_SALV_KULLANIM.

"En basit şekilde"
*
*oluşturma"
*DATA: gt_sbook type TABLE OF sbook, "intern table"
*      go_salv type REF TO cl_salv_table. "salv objesi"
*
*START-OF-SELECTION.
*
*select * UP TO 20 rows from sbook
*  INTO TABLE gt_sbook. "query"
*
*baglama"
*
*SALV fonksionu oluşturma"
*cl_salv_table=>FACTORY(
*  importing
*    R_SALV_TABLE   =    go_salv
*  changing
*    T_TABLE        =    gt_sbook
*).
*Salv yapsıı kullanılmadan once oluşturulur baglanır ve goruntulenir
*
*gpruntuleme"
*GO_SALV->DISPLAY( ).



"Geliştirilmiş"
"oluşturma"
DATA: gt_sbook type TABLE OF sbook, "intern table"
      go_salv type REF TO cl_salv_table. "salv objesi"

START-OF-SELECTION.

select * UP TO 20 rows from sbook
  INTO TABLE gt_sbook. "query"

"baglama"

"SALV fonksionu oluşturma"
cl_salv_table=>FACTORY(
  importing
    R_SALV_TABLE   =    go_salv
  changing
    T_TABLE        =    gt_sbook
).
"Salv yapsıı kullanılmadan once oluşturulur baglanır ve goruntulenir

"Ekran işlemleri
"lo_display adında salv objesinin ekran ayarlarını tutan değişken oluşturulur düzenlemeler yapabilmek için"
DATA:  lo_display TYPE REF TO CL_SALV_DISPLAY_SETTINGS.

"oluşturulan objeye kullandigimiz salv objesinin display ayarları atanır
lo_display = GO_SALV->GET_DISPLAY_SETTINGS( ).

"Ekran uzerindeki liste başlıgını değiştirme"
LO_DISPLAY->SET_LIST_HEADER( VALUE =  'SALV Kullanımı').

"Listenin satırlarının zebra desenli olmasını saglar
LO_DISPLAY->SET_STRIPED_PATTERN( VALUE =  'X').


"Genel Kolon işlemleri
"Kolona erişmek için salv sınfıını kullanarak obje uretilir
data lo_cols type REF TO cl_salv_columns.

"uretilen degiskene bizim salv objemizin colonlarını verirzz
lo_cols = GO_SALV->GET_COLUMNS( ).

"Kolonlar arası boşlugu optimize etmek
lo_cols->SET_OPTIMIZE( VALUE = 'X' ).


"Tekli kolon işlemleri
"kolona erişmek için salv kutuphanesinden kolon degiskeni uretilir
data lo_col TYPE REF TO CL_SALV_COLUMN.



"Kolonun kapladıgı alanı degistirme"
"degiskene colonlara eristigimiz degiskenin get column fonksionu ile bir colon atanir
lo_col = lo_cols->GET_COLUMN( COLUMNNAME = 'INVOICE' ).

LO_COL->SET_LONG_TEXT(' Changed colon ').
LO_COL->SET_MEDIUM_TEXT(' Changed cln ').
LO_COL->SET_SHORT_TEXT(' CHNGD CLN').

"istenilen kolonu kaldırma
lo_col = lo_cols->GET_COLUMN( COLUMNNAME = 'MANDT' ).
LO_COL->SET_VISIBLE( value = '' ).

"Olası kolon bulunamama hatalarını engellemek için try catch kullanılır
TRY .
lo_col = lo_cols->GET_COLUMN( COLUMNNAME = 'herhangi bir kolon' ). "Kolon adı dogru girilmezse dump ekrnaına duşer biz bunu try catch ile engelliypruz
LO_COL->SET_VISIBLE( value = '' ).
CATCH CX_SALV_NOT_FOUND.
 "message 'Column Not Found' type 'I'.
ENDTRY.


"Toolbar Eklemek / functions
"toolbara erişmek için degisken olusturulur
data lo_toolbar type REF TO CL_SALV_FUNCTIONS.

"degiskene bizim salv objesimzden gelen toolbar / functions degerlerini almak için fonksyon cagirirz
lo_toolbar = GO_SALV->GET_FUNCTIONS( ).

"Toolbar aktif edilir
LO_TOOLBAR->SET_ALL( abap_true ).
"LO_TOOLBAR->SET_ALL( VALUE = abap_true ). bu veya
" LO_TOOLBAR->SET_ALL( 'X' ). Bu şekilde de kullanilabilir



"Başlık ve açıklama ekleme
"Başlık ve açıklamaları birleştirmek için degiskenler oluşturulur
Data: lo_header TYPE REF TO CL_SALV_FORM_LAYOUT_GRID,
      lo_h_label TYPE REF TO CL_SALV_FORM_LABEL,
      lo_h_flow TYPE REF TO CL_SALV_FORM_LAYOUT_Flow.

CREATE OBJECT lo_header. "Başlık objesi oluşturulur

LO_H_LABEL = LO_HEADER->CREATE_LABEL( "Başlık oluşturmak için label konumu belirlenir
               ROW         = 1
               COLUMN      = 1
             ).
LO_H_LABEL->SET_TEXT( VALUE =  'Oluşturulmuş başlıka' ). "Başlık metni atanir

LO_H_FLOW = LO_HEADER->CREATE_FLOW( "Açıklama metnini konumu ayarlanır
              ROW     = 2
              COLUMN  = 1 ).

LO_H_FLOW->CREATE_TEXT( "Açıklama metni atanır
EXPORTING
    TEXT     =  'Bu bir açıklama'
).

go_salv->SET_TOP_OF_LIST( VALUE =  LO_HEADER ). "Oluşturdugumuz başlık objesi salv yapımıza eklenir



"Alv yapısını bir popup şekline çevirme
GO_SALV->SET_SCREEN_POPUP(
  exporting
    START_COLUMN = 1 "baş kolon
    END_COLUMN   = 80 "bit kolon
    START_LINE   = 1 "baş row
    END_LINE     = 20 "bit row
).

GO_SALV->DISPLAY( ).