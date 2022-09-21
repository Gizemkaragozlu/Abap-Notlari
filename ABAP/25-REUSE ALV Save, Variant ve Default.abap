/////////TOP/////////

"Variant işlemleri
DATA: gs_variant type DISVARIANT,
     gs_exit type char1.

"Oluşturulan save işlemlerindeki variantı uygulama açılıken listeleme ve seçme
PARAMETERS p_vari type DISVARIANT-VARIANT.

//////////MAIN//////////

*&---------------------------------------------------------------------*
*& Report ZFC_ALV_REUSE_KULLANIM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_ALV_REUSE_KULLANIM.

INCLUDE ZFC_ALV_REUSE_KULLANIM_TOP. "Tanımlamalar
INCLUDE ZFC_ALV_REUSE_KULLANIM_FRM. "form yapıları

INITIALIZATION.


gs_variant-REPORT = sy-REPID. "variantın hangi uygulamada çalışcagını vermek

"Varsayılan kaydedilen variant getirme
CALL FUNCTION 'REUSE_ALV_VARIANT_DEFAULT_GET'
  CHANGING
    CS_VARIANT          = GS_VARIANT
 EXCEPTIONS
   WRONG_INPUT         = 1
   NOT_FOUND           = 2
   PROGRAM_ERROR       = 3
   OTHERS              = 4.
IF SY-SUBRC eq 0.
  P_VARI = GS_VARIANT-VARIANT.
ENDIF.


"Uygulamda kaydedilen variantları bulma ve listeleme
at SELECTION-SCREEN on VALUE-REQUEST FOR p_vari.
  gs_variant-REPORT = sy-repid.
  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      IS_VARIANT                = gs_variant
   IMPORTING
     E_EXIT                    = gs_exit
     ES_VARIANT                = GS_VARIANT
   EXCEPTIONS
     NOT_FOUND                 = 1
     PROGRAM_ERROR             = 2
     OTHERS                    = 3.
  IF SY-SUBRC is INITIAL.
    p_vari = GS_VARIANT-VARIANT.
  ENDIF.



START-OF-SELECTION.

PERFORM get_data.
PERFORM set_fieldcatalog.
PERFORM set_layout.
PERFORM display_alv.



//////////////FRM///////////////////

"Variant işlemleri
gs_variant-VARIANT = p_vari ."save işlemi yapılırken ki id yi vermemiz uygulama başlatılnca o form duzeininden başlayacı anlamna gelir


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
*   I_DEFAULT                         = 'X' "vasayılan variantlardan etklensinm etkilenmesinmi
   I_SAVE                            = 'A' "SAVE işlemleri x->Genel değişimi u->kullanıcıya ozgu degisimi a->hem kullanıcıya hem genel secilebilen değişimi kayıt eder
   IS_VARIANT                        = gs_variant "save işlemi yapılınca variant oluşur varsaıylan ekran ayalamak için kullanılır
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
*   OTHERS                            = 2          .