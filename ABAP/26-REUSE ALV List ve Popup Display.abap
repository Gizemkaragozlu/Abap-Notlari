
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'  "REUSE_ALV_LIST_DISPLAY de kullanılabilir
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
*   I_DEFAULT                         = 'X' "vasayılan variantlardan etklensinm etkilenmesinmi
   I_SAVE                            = 'A' "SAVE işlemleri x->Genel değişimi u->kullanıcıya ozgu degisimi a->hem kullanıcıya hem genel secilebilen değişimi kayıt eder
   IS_VARIANT                        = gs_variant "save işlemi yapılınca variant oluşur varsaıylan ekran ayalamak için kullanılır
   IT_EVENTS                         =  gt_events "event yapısı
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
"bu kısmı değiştirerek popup gorunumu verebiliriz alv yapımıza
   I_SCREEN_START_COLUMN             = 20
   I_SCREEN_START_LINE               = 2
   I_SCREEN_END_COLUMN               = 100
   I_SCREEN_END_LINE                 = 20
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

