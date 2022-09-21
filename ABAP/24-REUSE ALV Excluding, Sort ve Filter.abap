//////////TOP////////////

"Excluding
DATA: gt_exclude type SLIS_T_EXTAB,
      gs_exclude type slis_extab.

"Sort işlemler
DATA: gt_sort TYPE SLIS_T_SORTINFO_ALV,
      gs_sort type slis_sortinfo_alv.

"Filtreleme işlemleri
DATA: gt_filter type SLIS_T_FILTER_ALV,
      gs_filter TYPE SLIS_FILTER_ALV.


//////////FRM/////////////


"Excluding / statusbardaki işlemlerden istenildeni kaldırma
GS_EXCLUDE-FCODE = '&ABC' ."Buraya statusbardaki işlemlerden bir func code verildiginde otomatik olarak silini statusbardan
append GS_EXCLUDE to GT_EXCLUDE.

"Sort işlemler
GS_SORT-SPOS = 1 ." işlem sırası çoklu sortlama yapılırsa bu numaraya gore yapılır
GS_SORT-TABNAME = 'GT_LIST'. "Tablo adımız
GS_SORT-FIELDNAME = 'MENGE'. "Kolon adımız
GS_SORT-up = 'X'. "kucukten buyuge dogru
"GS_SORT-down = abap_true. "buyugten kucugue  dogru
APPEND gs_sort to gt_sort.

"filtreleme işlemleri
*gs_filter-TABNAME = 'GT_LIST' ."tablo adı
*gs_filter-FIELDNAME = 'MEINS' ."kolon adı
*gs_filter-SIGN0 = 'I' ."o degere dahil mi dahil degilmi / include * exclude /
*GS_FILTER-OPTIO = 'EQ'. "iki deger arası mı yoksa eşit mi / between * eq
*GS_FILTER-valuf = 'KG'. "deger
*APPEND GS_FILTER to gt_filter.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
   I_CALLBACK_PROGRAM                = sy-repid "bu alan aşağıdaki callback ve function alanlarını bulundugu fonksşonların konumunu ister
*   I_CALLBACK_PF_STATUS_SET          = 'PF_STATUS_SET' "Status bar eklemek için ya bir yerden kopyalıcaz yada kendimiz oluştutup fonksiyon içerisine verecegiz
*   I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
*   I_CALLBACK_TOP_OF_PAGE            = 'TOP_OF_PAGE' "Başlık ve açıklama alanı denilebilir
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
   IS_LAYOUT                         = GS_LAYOUT "layout işlemleri
   IT_FIELDCAT                       = GT_FIELDCALATOG "tablo doldurma
   IT_EXCLUDING                      = gt_exclude "statusbardan istenen işlemi kaldırma,
*   IT_SPECIAL_GROUPS                 =
   IT_SORT                           = gt_sort "Sıralama işlemleri
   IT_FILTER                         = gt_filter "filtreleme işlemleri
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
*   I_SAVE                            = ' '
*   IS_VARIANT                        =
   IT_EVENTS                         =  gt_events "event yapısı
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
    T_OUTTAB                          = gt_list "tablo
* EXCEPTIONS
*   PROGRAM_ERROR                     = 1
*   OTHERS                            = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.
