PROCESS BEFORE OUTPUT. "PBO
 MODULE STATUS_0100.

"Açıklama:
   "call subscreen subScreenComponentId including (uygulama adı) subScreenId "

"Örnek:
   call SUBSCREEN SUB1 INCLUDING sy-repid '0101'.
"Örnek2:
   call SUBSCREEN SUB2 INCLUDING 'ZFC_SUBSCREEN_KULLANIM' '0102'.

PROCESS AFTER INPUT. //PAI
 MODULE USER_COMMAND_0100.
	call SUBSCREEN SUB1. //subscreen paisi aktifleşir