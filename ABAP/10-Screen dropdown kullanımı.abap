*&---------------------------------------------------------------------*
*& Report ZFC_SCREEN_EXAMPLE_APP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_SCREEN_EXAMPLE_APP.

DATA: gv_name type char30,
      gv_surname type char30,
      gv_gender_M type char1,
      gv_gender_F type char1, "Char yerine xfeld de kullanılabilir"
      gv_chkBox type xfeld,
      gv_salary type i.

*Dropdown data
Data: gv_id type vrm_id, "Veri tablo id si"
      gt_values type vrm_values,"veri tablosu"
      gs_value type vrm_value, "veri tablosunda verileri tutcak yapı"
      gv_index type i. "do içerisinde ki indeximiz"


START-OF-SELECTION.

  "DropDown"
  gv_index = 18."indexe 18 de başlatılır"
  DO 40 TIMES. "40 kez doner"
    gs_value-key = gv_index. "verileri tutan yapının içindeki key degeri doldurulur"
    gs_value-text = gv_index."veileri tutan yapının içindeki metin degerleri doldurulur"
    APPEND gs_value to gt_values. "verileri tutan yapımız ile veri tablomuzu doldururz"
    gv_index = gv_index + 1. "sonsuz donguye girmesin diye de index 1 artar"
  ENDDO.

  gv_chkBox = abap_true. "ekran gelmeden once deger ataması yapabiliriz
  call SCREEN 0100. "butun işlemleri ekran gelmeden once yapmak gereklidir aksi halde verilere erişemeyiz"


*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT. "Pbo yapımz ekran gelmeden onceki"
  SET PF-STATUS '0100_STATUS'.
*  SET TITLEBAR 'xxx'.

  "Dropdown data function"
  gv_id = 'GV_SALARY'. "vrm set values yapısı dropdown degerlerini doldurmamız için kullandık"

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = gv_id "Buradaki id biizm neyi doldurcagımızı ifade ediyor hangi dropdown şeklinde duşunebilriiz"
      VALUES = gt_values."buradaki yapı ise neyle doldurmamız gerektigitidir hangi veriyle şeklinde duşunebliriz"

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT. "Pai yapımız ekran geldikten sonra ki yapı"


CASE sy-ucomm.
  WHEN '&BCK'.
    IF gv_gender_M eq abap_true.  "Abap_true yerine eq 'X' de diyebilriiz"
        MESSAGE 'Cinsiyetiniz erkek' type 'I'.
    ELSE.
        Message 'Cinsiyetiniz kadin' type 'I'.
    ENDIF.

    IF gv_chkBox eq 'X'.
       MESSAGE 'Sözleşme kabul edildi' type 'I'.
        LEAVE TO SCREEN 0.
    ELSE.
      MESSAGE 'Sozleşme kabul edilmek zorundadır' type 'I'.
    ENDIF.
ENDCASE.
ENDMODULE.