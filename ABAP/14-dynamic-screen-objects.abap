*&---------------------------------------------------------------------*
*& Report ZFC_DYNAMIC_SCREEN_OBJECTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_DYNAMIC_SCREEN_OBJECTS.

"Screen objeleri"
DATA: gv_name type char20,
      gv_surname type char20,
      gv_age type num4.

"True false button için"
DATA gv_isVisible type xfeld VALUE abap_true.

"Girdiye gore işlem yapmak"
DATA gv_size type num1.

START-OF-SELECTION.
  call SCREEN 0100.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT. "PBO her PAI den sonra tekrar çalışır"
  SET PF-STATUS '0100'.
  "  START OLMASIYLA KULLANIM   "
*  LOOP AT SCREEN. "dongu her donmesinde layout objesi alır"
*    IF SCREEN-NAME eq 'GV_NAME'. "alınan name degerine eşitse"
*      SCREEN-ACTIVE = 1. "o objenin aktfligini kapatır"
*      MODIFY SCREEN. "ve ekranı yeniler / Bu işlem olmazsa ekranda bir değişiklik olmaz"
*    ENDIF.
*
*    IF SCREEN-NAME eq 'GV_SURNAME'.
*      SCREEN-INVISIBLE = 1.
*      MODIFY SCREEN.
*    ENDIF.
*  ENDLOOP.

"   BUTTON İLE KULLANIM   "
*  LOOP AT SCREEN.
*    IF gv_isVisible eq abap_true.
*       IF SCREEN-GROUP1 eq 'X'.
*         SCREEN-INVISIBLE = 0.
*       ENDIF.
*    Else.
*       IF SCREEN-GROUP1 eq 'X'.
*         SCREEN-INVISIBLE = 1.
*       ENDIF.
*    ENDIF.
*    MODIFY SCREEN.
*  ENDLOOP.

"Girdiye gore işlem yapmak"
LOOP AT SCREEN.
  CASE gv_size.
    WHEN 1.
      IF screen-GROUP3 eq 'X'.
          screen-INVISIBLE = 1.
      ENDIF.
    WHEN 2.
       IF screen-GROUP2 eq 'X'.
          screen-INVISIBLE = 1.
      ENDIF.
    WHEN 3.
       IF screen-GROUP1 eq 'X'.
          screen-INVISIBLE = 1.
      ENDIF.
  ENDCASE.
  MODIFY SCREEN.
  endloop.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
CASE sy-ucomm.
  WHEN '&BACK'.
    SET SCREEN 0.
*  When '&ENABLED'.
*    Gv_isVisible = abap_true.
*  When '&DISABLED'.
*    Gv_isVisible = abap_false.
ENDCASE.
ENDMODULE.