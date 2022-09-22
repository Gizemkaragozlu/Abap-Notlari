------TOP-----

*&---------------------------------------------------------------------*
*&  Include           ZFC_EXCEL_TO_ALV_TOP
*&---------------------------------------------------------------------*
types:BEGIN OF gty_tab,"scarr tablosunu kullanrak istedigim kolonlar için tip oluşturalım
     carrid type scarr-carrid,
     carrname type scarr-carrname,
     currcode type scarr-currcode,
     url type scarr-url,
  END OF gty_tab.


data: gt_fcat type SLIS_T_FIELDCAT_ALV,"Fieldacatlog tablomuz
      gs_fcat type slis_fieldcat_alv."Fieldcatalogu doldurcagımız structre 
DATA: it_tab type TABLE OF gty_tab WITH HEADER LINE."Tip yardımı ile oluştrudugumuz structre ve tablomuz
DATA: it_raw TYPE truxs_t_text_data."Ham halde gelecek excel verisini tutcagımız tablo

--------FRM----------


*&---------------------------------------------------------------------*
*&  Include           ZFC_EXCEL_TO_ALV_FRM
*&---------------------------------------------------------------------*
form set_fcat using p_colid p_tabname."Fielcatalogu hızlıca oluşturmak için form yarattık

  clear gs_fcat.
  gs_fcat-fieldname = p_colid.
  gs_fcat-ref_fieldname = p_colid.
  gs_fcat-ref_tabname = p_tabname.
  append gs_fcat to gt_fcat.
endform.

form get_fcat."Fieldcatalog için kolon adlarımızı ve tablo adımızı gireriz

  perform set_fcat using 'CARRID'   'SCARR'.
  perform set_fcat using 'CARRNAME' 'SCARR'.
  perform set_fcat using 'CURRCODE' 'SCARR'.
  perform set_fcat using 'URL'      'SCARR'.

endform.

form display_alv."Gelen degerleri kullanarak alv yi goruntulemek için kolay olması amacıyla reuse alv tercih ettik

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      i_callback_program = sy-repid
      it_fieldcat        = gt_fcat
    tables
      t_outtab           = it_tab
    exceptions
      program_error      = 1
      others             = 2.
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.

endform.

form get_data using p_file."Get data formunu excelden gelen veriyi parcalamak için kullancagız

  call function 'TEXT_CONVERT_XLS_TO_SAP'
    exporting
      i_line_header        = 'X'"Excel içinde kolon adları var mı?
      i_tab_raw_data       = it_raw " WORK TABLE"Ham halde gelen degerleri tutcak tablo
      i_filename           = p_file"Dosya uzantısı gireriz
    tables
      i_tab_converted_data = it_tab[] "ACTUAL DATA"Ve ham halde gelen datayi cevirerek internal tablo içine atarız
    exceptions
      conversion_failed    = 1
      others               = 2.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
    with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.

endform.

---------MAIN-----------*&---------------------------------------------------------------------*
*& Report ZFC_EXCEL_TO_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_EXCEL_TO_ALV.
INCLUDE ZFC_EXCEL_TO_ALV_TOP.
INCLUDE ZFC_EXCEL_TO_ALV_FRM.




PARAMETERS: p_file TYPE rlgrap-filename.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file."Parametrenin search help alanına basılınca
CALL FUNCTION 'F4_FILENAME'"Dosya adını alma için fonksyon cagırırız direk pc uzerinden konumu scecebiliriz
EXPORTING
field_name = 'P_FILE'
IMPORTING
file_name = p_file.

***********************************************************************

*START-OF-SELECTION.

START-OF-SELECTION.

  PERFORM get_data using p_file."Dosya adını get data formuna veriirz
  PERFORM get_fcat.
  PERFORM display_alv.