*&---------------------------------------------------------------------*
*& Report ZFC_SUBSTRIP_KULLANIMI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_SUBSTRIP_KULLANIMI.

"Tabstriple etkileşime gecemk icin tanımlaması yapılır"
CONTROLS TB_ID type TABSTRIP.

"substrip içindeki tabların her birine farklı func kodlar verirleir bunlar sy-ucomm ile yakalanabilir"
"substrip içindeki tabalarda subscreenler bulunur ve onlar ile çalışır
"daha sonra istenildigi gibi tabstrip id si ile istenen func kod tetiklendiginde  TB_ID-ACTIVETAB = 'tetiklenen fun kod'. yazarak
"o taba geçiş saglanır

START-OF-SELECTION.
  call SCREEN 0100.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
CASE sy-ucomm.
  WHEN '&BACK'.
    SET SCREEN 0.
  WHEN '&TAB1'.
    TB_ID-ACTIVETAB = '&TAB1'.
  WHEN '&TAB2'.
    TB_ID-ACTIVETAB = '&TAB2'.
ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS '0100'.
*  SET TITLEBAR 'xxx'.
ENDMODULE.