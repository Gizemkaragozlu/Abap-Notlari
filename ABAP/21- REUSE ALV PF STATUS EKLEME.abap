///CALLBACK İLE KULLANM////


CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
   I_CALLBACK_PROGRAM                = sy-repid 
   I_CALLBACK_PF_STATUS_SET          = 'PF_STATUS_SET' "Status bar eklemek için ya bir yerden kopyalıcaz yada kendimiz oluştutup fonksiyon içerisine verecegiz " Bu fonk bize parametere gondercek
   IS_LAYOUT                         = GS_LAYOUT
   IT_FIELDCAT                       = GT_FIELDCALATOG
   IT_EVENTS                         =  gt_events "event yapısı
  TABLES
    T_OUTTAB                          = gt_list
ENDFORM.

"Status bar ekleme "fonksiyon parametre gondercegi için bizim parametre alan fonkiyon yazmamız gerklidir
FORM PF_STATUS_SET USING p_extab type SLIS_T_EXTAB.
  set PF-STATUS 'STANDARD'.
ENDFORM.	



//////EVENTS ILE KULLLANIM ////////

gs_event-NAME = SLIS_EV_PF_STATUS_SET. "Event id
gs_event-FORM = 'PF_STATUS_SET'. "eventin form adı
APPEND gs_event to gt_events. "Structure yukarıda dolduruludu ve daha sonra intern table içerisine eklendi

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
   I_CALLBACK_PROGRAM                = sy-repid 
   IS_LAYOUT                         = GS_LAYOUT
   IT_FIELDCAT                       = GT_FIELDCALATOG
   IT_EVENTS                         =  gt_events "event yapısı
  TABLES
    T_OUTTAB                          = gt_list
ENDFORM.



"Status bar ekleme
FORM PF_STATUS_SET USING p_extab type SLIS_T_EXTAB.
  set PF-STATUS 'STANDARD'.
ENDFORM.	

