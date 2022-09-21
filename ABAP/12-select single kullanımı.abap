*&---------------------------------------------------------------------*
*& Report ZFC_SUBSCREEN_EXAMPLE_APP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_SUBSCREEN_EXAMPLE_APP.

"2" table uzerinden gelcek verileri tutmak için structre oluşturulur
DATA: gs_sflight TYPE SFLIGHT. "Structure"

"1" Where yapısı için parametre istenir
PARAMETERS: p_CARRID  type S_CARR_ID, "Tabloya atcagımız where şartı için alcagımız parametreler"
            p_CONNID  type S_CONN_ID,
            p_FLDATE  type S_DATE.

"3" Ekran tasarım işlemleri yapılır hangi verlier istenirse onlar structre yapısı uzerinden doldurulur
"Parametreler vs oluşturulduktan sonra subscreen ekranları oluşturulur structure içindeki istenendegerler istenen sub screen verilir"

START-OF-SELECTION.
"4" Sorgu yazılır tek bir veri gelcegi için single ifadesi kullanılır
"intodan sonraki gelen degişkene sorgudan doncek degerler atanır where yapısı ile de işlem koşullandırılır
  select SINGLE * from SFLIGHT INTO GS_SFLIGHT WHERE CARRID eq p_CARRID
                                                 and CONNID eq p_CONNID
                                                 and FLDATE eq p_FLDATE.

  call SCREEN 0100.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS '0100'.
*  SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CASE sy-UCOMM.
    WHEN '&BACK'.
       SET SCREEN 0.
       "leave to screen 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0101  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0101 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0101 INPUT.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0102  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0102 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0102  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0102 INPUT.

ENDMODULE.