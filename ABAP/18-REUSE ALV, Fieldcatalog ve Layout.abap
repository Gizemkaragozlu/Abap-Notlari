*&---------------------------------------------------------------------*
*& Report ZFC_ALV_REUSE_KULLANIM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_ALV_REUSE_KULLANIM.




"Reuse yapısı cagırmak için pattern -> call functon (REUSE_ALV_GRID_DISPLAY)) dememiz yeterlidir

"Reuse alv yapsıı kullanmak iin intern tabloya ihityacımız vardır biz de malzeme yonetim tablolarını kullanarak (EKKO , EKPO) oluşturacagız

"Tablolardan kullanacagımız kolonlar
TYPES: BEGIN OF gty_list,"global type list"
       EBELN type EBELN, "ebeln 2 tablodada olan colonumuzdur 2 tabloyu bu şekilde birletircez "Satın alma belge no (ekko)
       ebelp type ebelp,  "kalem no (ekpo)
       bstyp type ebstyp, "Belge tipi (Ekko)
       bsart type esart,   "Belge turu (Ekko)
       matnr type matnr,  "Malzeme numarası (Ekpo)
       menge type bstmg,  "Malzeme miktarı (Ekpo)
  END OF gty_list.

"Tabloyu oluşturma
DATA: gt_list TYPE TABLE OF gty_list, "tablo oluşturma
      gs_list type gty_list. "structure

"Tablo oluşturulduktan sonra boş olur bizim bunu doldurmamz gerekir


"Field catalog oluşturma
DATA: gt_fieldcalatog TYPE SLIS_T_FIELDCAT_ALV,"field catalog tablomuz
      gs_fieldcalatog TYPE slis_fieldcat_alv. "filed catalog structutre



"Fonksiyon ile denemek için eklenmiştir
form addFiledCalatog using p_fieldname p_SELTEXT_S p_SELTEXT_m p_SELTEXT_l.

  CLEAR: GS_FIELDCALATOG.
  GS_FIELDCALATOG-FIELDNAME = P_FIELDNAME.
  GS_FIELDCALATOG-SELTEXT_S = P_SELTEXT_S.
  GS_FIELDCALATOG-SELTEXT_m = P_SELTEXT_M.
  GS_FIELDCALATOG-SELTEXT_l = P_SELTEXT_L.
  APPEND GS_FIELDCALATOG to GT_FIELDCALATOG.

ENDFORM.


"Laoyut degiştirirek genel alv nin yapısını degiştirmek

"Layout oluşturmak layouty ozelleştirmek için alv yapsıının structureı kullanılır
DATA gs_layout TYPE SLIS_LAYOUT_ALV.

START-OF-SELECTION.

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
  from ekko
  INNER JOIN ekpo on ekpo~EBELN eq ekko~EBELN   "iki tabloyu birleştiremk için iki tablodada olan kolonları kuullanırız
  INTO TABLE gt_list. "into table diyerekde gelen degerler ile tablomuzu dolduruyoruz


"Tablodan gelen degerlie ekrana basmak için fieldCatalog oluşturmamız gerekir
"oluşturduktan sonra structurin filedname yani kolon adlarını doldurmamız gerekir ki ekranda gozuksun

CLEAR: GS_FIELDCALATOG. "structeın içi temizlenir
GS_FIELDCALATOG-FIELDNAME = 'ebeln'. "field name degeri atanır
GS_FIELDCALATOG-SELTEXT_S = 'Sas no'. "colon adının kısa hali
GS_FIELDCALATOG-SELTEXT_m = 'Sas numarasi'."orta hali
GS_FIELDCALATOG-SELTEXT_l = 'Satın alma numarasi'."uzun hali
GS_FIELDCALATOG-KEY       = 'X'. "Tablonon key i olunca daha belirgin renkte olması saglanıyor / abap_true de yapılabilir
GS_FIELDCALATOG-COL_POS   = 0. "indexe gore soldan saga dogru hangi sırada olcagını belirler
GS_FIELDCALATOG-OUTPUTLEN = 30. "kolonun genişlgini ayarlar
"GS_FIELDCALATOG-edit      = abap_true. "kolonun editlenmesini saglar ama bu kadarla bitmez çeşitli ayarlar yapımaslı gerekjir
"GS_FIELDCALATOG-HOTSPOT   = abap_true. "kolonun altını çizer ve tıklanabilmesini saglar ama bu kadarla bitmez çeşitli ayarlar yapımaslı gerekjir
"GS_FIELDCALATOG-DO_SUM    = abap_true. "sayısal kolonlarda içindeki degerler' toplar ve en sona yazdirir/
APPEND GS_FIELDCALATOG to GT_FIELDCALATOG. "structın içi doluncada fieldcatalog tablosuna eklenir ve artık gozukebilr durumda olur
"istenen sutun kadar field name doldurulur

CLEAR: GS_FIELDCALATOG.
GS_FIELDCALATOG-FIELDNAME = 'ebelp'.
GS_FIELDCALATOG-SELTEXT_S = 'Kalem no'.
GS_FIELDCALATOG-SELTEXT_m = 'Kalem Numarasi'.
GS_FIELDCALATOG-SELTEXT_l = 'Kalem nuamarai'.
GS_FIELDCALATOG-key       = abap_true.
APPEND GS_FIELDCALATOG to GT_FIELDCALATOG.

CLEAR: GS_FIELDCALATOG.
GS_FIELDCALATOG-FIELDNAME = 'bstyp'.
GS_FIELDCALATOG-SELTEXT_S = 'Belge t.'.
GS_FIELDCALATOG-SELTEXT_m = 'Belge tip'.
GS_FIELDCALATOG-SELTEXT_l = 'Belge tipi'.
APPEND GS_FIELDCALATOG to GT_FIELDCALATOG.

CLEAR: GS_FIELDCALATOG.
GS_FIELDCALATOG-FIELDNAME = 'bsart'.
GS_FIELDCALATOG-SELTEXT_S = 'Belge tur.'.
GS_FIELDCALATOG-SELTEXT_m = 'Belge turu'.
GS_FIELDCALATOG-SELTEXT_l = 'Belge turu'.
APPEND GS_FIELDCALATOG to GT_FIELDCALATOG.

CLEAR: GS_FIELDCALATOG.
GS_FIELDCALATOG-FIELDNAME = 'matnr'.
GS_FIELDCALATOG-SELTEXT_S = 'Malzeme n'.
GS_FIELDCALATOG-SELTEXT_m = 'Malzeme num'.
GS_FIELDCALATOG-SELTEXT_l = 'Malzeme numarası'.
APPEND GS_FIELDCALATOG to GT_FIELDCALATOG.

*CLEAR: GS_FIELDCALATOG.
*GS_FIELDCALATOG-FIELDNAME = 'menge'.
*GS_FIELDCALATOG-SELTEXT_S = 'Mal mik'.
*GS_FIELDCALATOG-SELTEXT_m = 'Malzeme mik'.
*GS_FIELDCALATOG-SELTEXT_l = 'Malzeme miktari'.
*APPEND GS_FIELDCALATOG to GT_FIELDCALATOG.

"Fonksiyon yazarakta eklenebilir
PERFORM ADDFILEDCALATOG
  using
    'menge'
    'Mal mik'
    'Malzeme mik'
    'Malzeme miktari'
  .


"Layout uzerinde değişiklik yapmak
GS_LAYOUT-WINDOW_TITLEBAR = 'Reuse alv kullanımı'."Başlık metni değiştirme
GS_LAYOUT-ZEBRA  = 'X'. "tabloya zebra deseni verme
GS_LAYOUT-COLWIDTH_OPTIMIZE = abap_true. "layoutun sutun genişlklerini optimize eder
"GS_LAYOUT-EDIT = 'X'. "daha onceki edit mode ile aynı fakat bu tablonun geneline editable ozellik katar


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