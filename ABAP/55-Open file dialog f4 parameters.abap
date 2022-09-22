PARAMETERS: P_FILE LIKE RLGRAP-FILENAME DEFAULT 'C:\'. "Varsayılan dosya yolu 'C diski dedik

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE."Selection screen search helpine basılırsa

CALL FUNCTION 'WS_FILENAME_GET'"Open file dialog işlevi gormektedir
EXPORTING
DEF_PATH = P_FILE
MASK = ',..'
MODE = '0 '
TITLE = 'Choose File'
IMPORTING
FILENAME = P_FILE"Dosya adını bize doner
EXCEPTIONS
INV_WINSYS = 1
NO_BATCH = 2
SELECTION_CANCEL = 3
SELECTION_ERROR = 4
OTHERS = 5.