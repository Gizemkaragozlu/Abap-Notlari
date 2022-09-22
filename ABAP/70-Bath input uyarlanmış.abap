*&---------------------------------------------------------------------*
*& Report ZFC_BATCH_INPUT_PROGRAM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zfc_batch_input_program.

"Batch input includu eklenir
include bdcrecx1_s.

"excel dosyasınnı okumak için
data :it_raw type truxs_t_text_data.

"Excelden gelen verileri tutcak tablo tipi
types: begin of gty_tab,
        carrid   type s_carr_id,
        carrname type s_carrname,
        currcode type s_currcode,
        url      type s_carrurl,
      end of gty_tab.

"Excel tablosunu ve batch işlemi için tablo
data gt_itab type table of gty_tab with header line.

"Excel dosya yolu isteme
parameters: p_file type ibipparms-path obligatory.

*----------------------------------------------------------------------*
*     AT SELECTION-SCREEN ON VALUE-REQUEST
*----------------------------------------------------------------------*
at selection-screen on value-request for p_file.

  call function 'F4_FILENAME'
    importing
      file_name = p_file.

  call function 'TEXT_CONVERT_XLS_TO_SAP'"Dosya yolundan excel içindeki veriyi tabloya atma
    exporting
*     I_FIELD_SEPERATOR    =
*     I_LINE_HEADER        =
      i_tab_raw_data       = it_raw
      i_filename           = p_file
    tables
      i_tab_converted_data = gt_itab[]
 EXCEPTIONS
     CONVERSION_FAILED    = 1
     OTHERS               = 2
    .
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.


start-of-selection."Run edilince

  loop at gt_itab."Dongu kurarız dolu tablonun içinde
    perform add_data using gt_itab. "Tablonun structreını veririz
  endloop.

form add_data using p_table type gty_tab."Form oluşturup butun işlemleri tek bi alanda yonetmek için oluşturduk

"bu alanı direkt olarak shdb uzerinden record kaydı yaptıktan sonra function group olarak ekleyince
"O function group içerisinden alabilriz daha sonra bununla dongu kurmamız  yeterli olur
  perform bdc_dynpro      using 'ZFC_BATCH_INPUT' '1000'.

  perform bdc_field       using 'BDC_CURSOR'
                                'P_URL'.
  perform bdc_field       using 'BDC_OKCODE'
                                '=PB1'.
  perform bdc_field       using 'P_ID'
                                p_table-carrid.
  perform bdc_field       using 'P_NAME'
                                p_table-carrname.
  perform bdc_field       using 'P_CODE'
                                p_table-currcode.
  perform bdc_field       using 'P_URL'
                                p_table-url.
  perform bdc_transaction using 'ZFCB'.


endform.