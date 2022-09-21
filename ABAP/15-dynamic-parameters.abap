*&---------------------------------------------------------------------*
*& Report ZFC_DYNAMIC_SELECTION_SCREEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_DYNAMIC_SELECTION_SCREEN.

*PARAMETERS: p_num TYPE int4.
*
*INITIALIZATION. 1
*
*AT SELECTION-SCREEN OUTPUT. 2
*
*START-OF-SELECTION. 3
"Başlama sırasıyla

*DATA: gv_num TYPE i.
*
*PARAMETERS: P_num TYPE int4 MODIF ID qr1.
*
*SELECT-OPTIONS: s_mum FOR gv_num MODIF ID gr1.
*
*INITIALIZATION.
*  LOOP AT SCREEN .
*    IF screen-group1 eq 'GR1'.
*      Screen-display_3d = 1 .
*      screen-input = 0.
*    MODIFY SCREEN.
*    ENDIF.
*
*  ENDLOOP.


"ORNEK UYGULAMA"

"2 radio button tanımlanır satici ve musteri için
PARAMETERS: p_rad1 RADIOBUTTON GROUP rgr1 DEFAULT 'X' USER-COMMAND clicked, "default varsaıylan olarak tikli gelmesi user command ise ekranın yenilenmesi için func code
            p_rad2 RADIOBUTTON GROUP rgr1.

PARAMETERS: p_lifnr type lifnr MODIF ID gr1, "Hazır tabloları kullanarak parametreler oluşturulur ve gruplanır
            p_lifnrn type name1_gp MODIF ID gr1,
            P_kunnr type kunnr MODIF ID gr2,
            p_kunnrn type name1_gp  MODIF ID gr2.

at SELECTION-SCREEN OUTPUT. "Her bir framede çalışır
  LOOP AT SCREEN. "ekran objelerinde gezinir
    IF p_rad1 eq abap_true. "eger radio 1 secildiye
      IF screen-GROUP1 eq 'GR1'. "grup 1 i aktif edilir
        screen-active = 1.
        MODIFY SCREEN.
      endif.
      IF screen-group1 eq 'GR2'.
         screen-active = 0.
         MODIFY SCREEN.
      ENDIF.
    ENDIF.
     IF p_rad2 eq abap_true.
      IF screen-GROUP1 eq 'GR2'.
        screen-active = 1.
        MODIFY SCREEN.
      endif.
      IF screen-group1 eq 'GR1'.
         screen-active = 0.
         MODIFY SCREEN.
      ENDIF.
    ENDIF.
  ENDLOOP.