------------TOP---------------
*&---------------------------------------------------------------------*
*&  Include           ZFC_EXAMPLE_11_TOP
*&---------------------------------------------------------------------*

data: gv_text  type string,
      gt_table type table of zfc_satis with header line.


"Alv

  data: dockingbottom type ref to cl_gui_docking_container,
        alv_bottom    type ref to cl_gui_alv_grid.

"Layout
  data gs_layout TYPE LVC_S_LAYO .

----------FRM---------------

*&---------------------------------------------------------------------*
*&  Include           ZFC_EXAMPLE_11_FRM
*&---------------------------------------------------------------------*
form get_adobe using p_table type zfc_satis_tt
                     p_adres type string.
data :fm_name           TYPE rs38l_fnam,
      fp_docparams      TYPE sfpdocparams,
      fp_outputparams   TYPE sfpoutputparams.
* Sets the output parameters and opens the spool job
CALL FUNCTION 'FP_JOB_OPEN'                   "& Form Processing: Call Form
  CHANGING
    ie_outputparams = fp_outputparams
  EXCEPTIONS
    cancel          = 1
    usage_error     = 2
    system_error    = 3
    internal_error  = 4
    OTHERS          = 5.
IF sy-subrc <> 0.
*            <error handling>
ENDIF.


*&---- Get the name of the generated function module
CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'           "& Form Processing Generation
  EXPORTING
    i_name     = 'ZFC_EXAMPLE_EFATURA' "Adobe form adı yazılır
  IMPORTING
    e_funcname = fm_name.

call function fm_name
  exporting
*   /1BCDWB/DOCPARAMS        =
    it_satis                 = p_table
    iv_musteri_adres         = p_adres
*   /1BCDWB/FORMOUTPUT       =
 EXCEPTIONS
   USAGE_ERROR              = 1
   SYSTEM_ERROR             = 2
   INTERNAL_ERROR           = 3
   OTHERS                   = 4
          .
if sy-subrc <> 0.
* Implement suitable error handling here
endif.



*&---- Close the spool job
CALL FUNCTION 'FP_JOB_CLOSE' "Form işlemi bitnce
*    IMPORTING
*     E_RESULT             =
  EXCEPTIONS
    usage_error           = 1
    system_error          = 2
    internal_error        = 3
    OTHERS               = 4.
IF sy-subrc <> 0.
*            <error handling>
ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ADD_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ACKLMA  text
*      -->P_MIKTAR  text
*      -->P_BFIYAT  text
*----------------------------------------------------------------------*
form add_table  using    p_acklma
                         p_miktar
                         p_bfiyat.

      gt_table-aciklama = p_acklma.
      gt_table-miktar = p_miktar.
      gt_table-birim_fiyat = p_bfiyat.
      gt_table-toplam = p_bfiyat * p_miktar.
      append gt_table.
      MESSAGE 'Satis basariyla eklendi' type 'S'.
endform.

form display_alv.
 IF dockingbottom is INITIAL.
 create object dockingbottom
              exporting repid     = sy-repid
                        dynnr     = sy-dynnr
                        side      = dockingbottom->dock_at_bottom
                        extension = 170.

  create object alv_bottom
                exporting i_parent = dockingbottom.

       call method alv_bottom->set_table_for_first_display
      exporting
        is_layout                     =     gs_layout             " Layout
           i_structure_name       = 'ZFC_SATIS'
      changing
           it_outtab       = gt_table[].
  else.
  alv_bottom->refresh_table_display( ).
 ENDIF.
ENDFORM.

FORM set_layout.
  CLEAR gs_layout.
  gs_layout-zebra = 'X'.
  gs_layout-cwidth_opt = 'X'.
ENDFORM.

-------------SS--------------

selection-screen begin of block sel_screen_1 with frame title text-000.
parameters : acklma  type zfc_satis-aciklama,
             miktar  type zfc_satis-miktar,
             bfiyat  type zfc_satis-birim_fiyat.

selection-screen: pushbutton /1(20) btnadd user-command btnadd, "Margin verir
                  pushbutton 21(20) btnpdf user-command btnpdf.
selection-screen end of block sel_screen_1.

initialization.
PERFORM set_layout.
  btnadd = 'Add'.
  btnpdf = 'Print Pdf'.

at selection-screen.
* Check if buttons have beenü
  case sy-ucomm.
    when 'BTNADD'.

      perform add_table USING acklma miktar bfiyat .
      CLEAR:  acklma ,
              miktar ,
              bfiyat .



    when 'BTNPDF'.
      call function 'CC_POPUP_STRING_INPUT'
        exporting
          property_name = 'Müşteri adres bilgisi'
        changing
          string_value  = gv_text.
      perform get_adobe using gt_table[] gv_text.

  endcase.

PERFORM display_alv.