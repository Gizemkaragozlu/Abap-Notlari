*&---------------------------------------------------------------------*
*& Report ZFC_EXAMPLE_8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zfc_example_8.

DATA: it_sflight     TYPE TABLE OF sflight."slfight tipinde tablo oluştrulur
DATA: it_fieldcat  TYPE slis_t_fieldcat_alv,"Fielcatalog
      wa_fieldcat  TYPE slis_fieldcat_alv,"fieldcatalog structre
      it_sort      TYPE slis_t_sortinfo_alv,"Sıralama tablosu
      wa_sort      TYPE slis_sortinfo_alv.."Sıralama structreı
*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION."Çlaıştırılınca

*Fetch data from the database
  SELECT * FROM sflight INTO TABLE it_sflight."Select atılr tablo doldurulur

*Build field catalog
  wa_fieldcat-fieldname  = 'CARRID'.    " Tablo fieldname alanı
  wa_fieldcat-seltext_m  = 'Airline'.   " Colon açıklaması medium
  APPEND wa_fieldcat TO it_fieldcat.    "Fieldcatalog structrı tabloya eklenir

  wa_fieldcat-fieldname  = 'CONNID'.
  wa_fieldcat-seltext_m  = 'Con. No.'.
  APPEND wa_fieldcat TO it_fieldcat.

  wa_fieldcat-fieldname  = 'FLDATE'.
  wa_fieldcat-seltext_m  = 'Date'.
  APPEND wa_fieldcat TO it_fieldcat.

  wa_fieldcat-fieldname  = 'PAYMENTSUM'.
  wa_fieldcat-seltext_m  = 'PAYMEN SUM'.
   wa_fieldcat-do_sum     = 'X'."Hangi alanda toplam alıncaksa do_sum alanı x lenir
  APPEND wa_fieldcat TO it_fieldcat.

*Build sort catalog
*  wa_sort-spos      = 1.
  wa_sort-fieldname = 'CARRID'."Sıralama işlemi için fieldname alanı
  wa_sort-up        = 'X'.     "Kucukten buyuge dogru sıralama olcak
  wa_sort-subtot    = 'X'.     "Ara toplam işlemi yapılsınmı
  APPEND wa_sort TO it_sort.   "Sort strcutrı tabloya atılır

*Pass data and field catalog to ALV function module to display ALV list
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat   = it_fieldcat"Fieldcatalog
    it_sort       = it_sort      "Sort işlemi
    TABLES
      t_outtab      = it_sflight "Main table
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.