
      CALL FUNCTION 'POPUP_WITH_2_BUTTONS_TO_CHOOSE'"2 Butonlu popup
        EXPORTING
          diagnosetext1 = 'Lütfen İstenilen Form Türünü Seçiniz...'
          textline1     = space
          textline2     = space
          text_option1  = 'SMART FORM'
          text_option2  = 'ADOBE FORM'
          titel         = 'check'
        IMPORTING
          answer        = lv_answer.

-----------------------------------------------

           CALL FUNCTION 'K_KKB_POPUP_RADIO2'"2 radio butonlu popup
        EXPORTING
          i_title   = 'TITLE1'
          i_text1   = 'SMARTFORM'
          i_text2   = 'ADOBE FORM'
          i_default = 'DEFAULT'
        IMPORTING
          i_result  = lv_result
        EXCEPTIONS
          cancel    = 1
          OTHERS    = 2.
      IF sy-subrc <> 0.
*      Implement suitable error handling here
      ENDIF.


--------------------------------------------

CALL FUNCTION 'POPUP_TO_CONFIRM'"Onay popupı
          EXPORTING
            text_question         = 'Seçilen kayıtlar silinecek'
            text_button_1         = 'Evet'
            icon_button_1         = 'ICON_OKAY '
            text_button_2         = 'Hayır'
            icon_button_2         = 'ICON_CANCEL'
            display_cancel_button = ' '
            popup_type            = 'ICON_MESSAGE_QUESTION'
          IMPORTING
            answer                = lv_mind
          EXCEPTIONS
            text_not_found        = 1
            OTHERS                = 2.
----------------------------------------------
Sonuçlar int deger olarak doner

------------------------------------------------
 call function 'CC_POPUP_STRING_INPUT'"String deger isteyen popup
        exporting
          property_name = 'Müşteri adres bilgisi'
        changing
          string_value  = gv_text. "girilen deger string doner