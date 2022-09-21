///////////TOP//////

TYPES: BEGIN OF gty_list,"global type list"
       chkbox type char1, "Satır seçmini aktif etmek için eklendi
       EBELN type EBELN, "ebeln 2 tablodada olan colonumuzdur 2 tabloyu bu şekilde birletircez "Satın alma belge no (ekko)
       ebelp type ebelp,  "kalem no (ekpo)
       bstyp type ebstyp, "Belge tipi (Ekko)
       bsart type esart,   "Belge turu (Ekko)
       matnr type matnr,  "Malzeme numarası (Ekpo)
       menge type bstmg,  "Malzeme miktarı (Ekpo)
       meins type meins,  "miktar turu (Ekpo)
       statu type statu,  "siparis durumu (Ekpo)
  END OF gty_list.




//////////Frm////////////////
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
   I_CALLBACK_PROGRAM                = sy-repid "bu alan aşağıdaki callback ve function alanlarını bulundugu fonksşonların konumunu ister
   I_CALLBACK_USER_COMMAND           = 'USER_COMMAND' "user command fonksiyon adı eklenir
   IS_LAYOUT                         = GS_LAYOUT
   IT_FIELDCAT                       = GT_FIELDCALATOG
   IT_EVENTS                         =  gt_events "event yapısı

  TABLES
    T_OUTTAB                          = gt_list


ENDFORM.

///////////////////userCommand///////////////////

"user command function 2 parametre alır birisi fun code tutucu digeri row col tutan yapı
FORM USER_COMMAND USING p_ucomm      type sy-ucomm
                        ps_selfield TYPE SLIS_SELFIELD.
DATA: lv_mes TYPE char200,
      lv_index type numc2."99 a kadar

  CASE P_ucomm.
     WHEN '&MSG'.
       "dongu kur gt_list içinde gs_listten chkbox seçili olanların uzerinde gezin
       LOOP at GT_LIST INTO GS_LIST WHERE chkbox eq 'X'.
         lv_index = lv_index + 1.
         ENDLOOP.
        CONCATENATE lv_index
                  'Adet Satır Sçildi'
                  INTO lv_mes
                  SEPARATED BY space.
      MESSAGE lv_mes TYPE 'I'.
     WHEN '&IC1'.
  CASE ps_selfield-fieldname.
    WHEN 'EBELN'.
      CONCATENATE PS_SELFIELD-value
                  'numaralı SAS tıklanmıştır'
                  INTO lv_mes
                  SEPARATED BY space.
      MESSAGE lv_mes TYPE 'I'.
    WHEN 'MATNR'.
      CONCATENATE PS_SELFIELD-value
                  'numaralı malzemeye tıklanmıştır'
                  INTO lv_mes
                  SEPARATED BY space.
      MESSAGE lv_mes TYPE 'I'.
    ENDCASE.
ENDCASE.
ENDFORM.