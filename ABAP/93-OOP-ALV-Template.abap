*&---------------------------------------------------------------------*
*&  Include           ZFC_EXAMPLE_TOP
*&---------------------------------------------------------------------*

CLASS cls_local DEFINITION DEFERRED.

DATA: go_local             TYPE REF TO cls_local,
      gs_formoutput        TYPE fpformoutput,
      go_container         TYPE REF TO cl_gui_custom_container.
"///////////////////////////////////////////////////////////////////////
*&---------------------------------------------------------------------*
*&  Include           ZFC_EXAMPLE_SLC
*&---------------------------------------------------------------------*
"Selection Screen
"F4
"///////////////////////////////////////////////////////////////////////
*&---------------------------------------------------------------------*
*&  Include           ZFC_EXAMPLE_CLS
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*       CLASS CLS_LOCAL DEFINITION
*----------------------------------------------------------------------*
class cls_local definition.
  public section.
    methods: display_alv, prepare_display, get_data, print.

    data: alv_grid    type ref to cl_gui_alv_grid,
          layout      type lvc_s_layo,
          "Main Table
          gt_outtab   type table of scarr,
          fieldcat    type lvc_t_fcat,
          toolbar_exc type ui_functions,
          gt_rows     type lvc_t_row.

    methods  handle_top_of_page
        for event top_of_page of cl_gui_alv_grid
      importing "import parametreleri
        e_dyndoc_id
        table_index.


    methods handle_hotspot_click
        for event hotspot_click of cl_gui_alv_grid
      importing
        e_row_id
        e_column_id.

    methods handle_double_click
        for event double_click of cl_gui_alv_grid
      importing
        e_row
        e_column
        es_row_no.

    methods handle_data_changed
        for event data_changed of cl_gui_alv_grid
      importing
        er_data_changed
        e_onf4
        e_onf4_before
        e_onf4_after
        e_ucomm.

    methods handle_button_click
        for event button_click of cl_gui_alv_grid
      importing
        es_col_id
        es_row_no.

    methods handle_onf4
        for event onf4 of cl_gui_alv_grid
      importing
        e_fieldname
        e_fieldvalue
        es_row_no
        er_event_data
        et_bad_cells
        e_display.

    methods handle_toolbar
        for event toolbar of cl_gui_alv_grid
      importing
        e_object
        e_interactive.

    methods handle_user_command "Toolbar
        for event user_command of cl_gui_alv_grid
      importing
        e_ucomm.

endclass.

*----------------------------------------------------------------------*
*       CLASS CLS_LOCAL IMPLEMENTATION
*----------------------------------------------------------------------*
class cls_local implementation.
  method get_data.
    select * from scarr into table gt_outtab.
  endmethod.

  method prepare_display.
    field-symbols <lfs_fcat> type lvc_s_fcat.

    create object alv_grid
      exporting
        i_parent = cl_gui_custom_container=>screen0
      exceptions
        others   = 0.

    clear layout.
    layout-zebra      = abap_true.
*    layout-sel_mode   = 'A'.
    layout-no_toolbar = 'X'.
    layout-col_opt    = 'X'.
    layout-cwidth_opt = 'X'.

    clear fieldcat[].
    call function 'LVC_FIELDCATALOG_MERGE'
      exporting
        i_structure_name = 'SCARR'
      changing
        ct_fieldcat      = fieldcat
      exceptions
        others           = 0.

    " loop at fieldcat assigning <lfs_fcat>.
    " endloop.
  endmethod.

  method display_alv.

    "set handler go_local->handle_double_click for alv_grid.

    call method alv_grid->set_table_for_first_display
      exporting
        is_layout                     = layout
        i_save                        = 'A'
        i_default                     = 'X'
        it_toolbar_excluding          = toolbar_exc
      changing
        it_outtab                     = gt_outtab
        it_fieldcatalog               = fieldcat
      exceptions
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        others                        = 4.
    if sy-subrc is initial.
      call method alv_grid->register_edit_event
        exporting
          i_event_id = cl_gui_alv_grid=>mc_evt_modified
        exceptions
          error      = 1
          others     = 2.

      call method alv_grid->register_edit_event
        exporting
          i_event_id = cl_gui_alv_grid=>mc_evt_enter
        exceptions
          error      = 1
          others     = 2.
    endif.
  endmethod.

  method print.
    data: ls_outputparams type sfpoutputparams,
          ls_docparams    type sfpdocparams,
          lv_fm_name      type rs38l_fnam,
          "Print datas.
          lt_data         type table of scarr,
          ls_data         type scarr.

    ls_outputparams-getpdf   = 'X'.
    ls_outputparams-nodialog = 'X'.

    call method alv_grid->get_selected_rows "Selected row
      importing
        et_index_rows = gt_rows[]. "in gt_rows table

    sort gt_rows ascending.
    loop at gt_rows into data(ls_row).
      data(ls_outtab) = gt_outtab[ ls_row-index ].
      move-corresponding ls_outtab to ls_data.
      append ls_data to lt_data.
    endloop.



    call function 'FP_JOB_OPEN'
      changing
        ie_outputparams = ls_outputparams
      exceptions
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        others          = 5.

    call function 'FP_FUNCTION_MODULE_NAME'
      exporting
        i_name     = 'FORMNAME'
      importing
        e_funcname = lv_fm_name.

    call function lv_fm_name
      exporting
        /1bcdwb/docparams  = ls_docparams
        gt_data            = lt_data
      importing
        /1bcdwb/formoutput = gs_formoutput
      exceptions
        usage_error        = 1
        system_error       = 2
        internal_error     = 3
        others             = 4.

    call function 'FP_JOB_CLOSE'
      exceptions
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        others         = 4.


  endmethod.

  method handle_top_of_page.

    data: lv_text type sdydo_text_element,
          go_docu type ref to cl_dd_document..

    lv_text = 'EXAMPLE'.

    call method go_docu->add_text
      exporting
        text      = lv_text
        sap_style = cl_dd_document=>heading.

    call method go_docu->new_line.


    concatenate 'USER: ' sy-uname into lv_text separated by space.

    call method go_docu->add_text
      exporting
        text      = lv_text
        sap_color = cl_dd_document=>list_positive.


*    call method go_docu->display_document
*      exporting
*        parent = go_sub1.



  endmethod.

  method handle_hotspot_click. "Hotspot alan tetiklenince ne olcak

    " e_row_id-index. "Selected row index
    " e_column_id     "Selected column name

  endmethod.

  method handle_double_click.

    "  es_row_no-row_id.  "Selected Row index
    "  E_COLUMN-FIELDNAME "Selected Column name

  endmethod.

  method handle_data_changed.
    data :ls_modi type lvc_s_modi.
    loop at er_data_changed->mt_good_cells into ls_modi.
      " ls_modi-row_id. "Edited Row index
      " ls_modi-fieldname "Row Old Value
      " ls_modi-value     "Row New Value
    endloop.
  endmethod.


  method handle_button_click.


    " es_row_no-row_id.    "Selected row index
    " es_col_id-fieldname. "Selected column name

  endmethod.

  method handle_onf4.


    types: begin of lty_value_tab,
             carrname type s_carrname,
             carrdeff type char20,
           end of lty_value_tab.


    data: lt_value_tab type table of lty_value_tab,
          ls_value_tab type lty_value_tab.


    clear ls_value_tab.
    ls_value_tab-carrname = 'Uçuş 1'.
    ls_value_tab-carrdeff = 'Birinci uçuş'.
    append ls_value_tab to lt_value_tab.


    data: lt_return_tab type table of ddshretval,
          ls_return_tab type ddshretval.


    call function 'F4IF_INT_TABLE_VALUE_REQUEST'
      exporting
        retfield     = 'CARRNAME'
        window_title = 'carrname F4'
        value_org    = 'S'
      tables
        value_tab    = lt_value_tab
        return_tab   = lt_return_tab. "Selected row in here



    "F0001 seçilen kolon adı
    read table lt_return_tab into ls_return_tab with key fieldname = 'F0001'.
    if sy-subrc eq 0.


      read table gt_outtab assigning field-symbol(<gfs_scarr>) index es_row_no-row_id. "Selected row index
      if sy-subrc eq 0.

        <gfs_scarr>-carrname = ls_return_tab-fieldval. "Selected row data

        alv_grid->refresh_table_display( ). "Yapılan degişikligin alv uzerine yansıması için alvyi refreshliyoruz
      endif.
    endif.

    "Search help kısmının tamamlanmış olması için
    er_event_data->m_event_handled = 'X'.

  endmethod.


  method handle_toolbar.

    data ls_toolbar type stb_button. "Toolbar objesi oluşturmak için structure

    clear ls_toolbar. "structure temizle
    ls_toolbar-text = 'Delete'. "objenin adi
    ls_toolbar-icon = '@11@'. "iconu
    ls_toolbar-disabled = ''. "inaktifligi
    ls_toolbar-function = '&DEL'. "Fonksiyon kodu
    ls_toolbar-quickinfo = 'Delete '. "Kısa bilgisi

    append ls_toolbar to e_object->mt_toolbar.

  endmethod.

  method handle_user_command.

    case e_ucomm.
      when '&DEL'.
        message 'Silme butonuna tıklandı' type 'I'.
    endcase.

  endmethod.
endclass.
"///////////////////////////////////////////////////////////////////////
*&---------------------------------------------------------------------*
*&  Include           ZFC_EXAMPLE_PBO
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100S'.
*  SET TITLEBAR 'ZTITLE'.
ENDMODULE.
"///////////////////////////////////////////////////////////////////////
*&---------------------------------------------------------------------*
*&  Include           ZFC_EXAMPLE_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_0100 input.
  CASE sy-ucomm.
    WHEN '&F03' or '&F12' or '&F15'.
      SET SCREEN 0.
  ENDCASE.

endmodule.
"///////////////////////////////////////////////////////////////////////
*&---------------------------------------------------------------------*
*& Report ZFC_EXAMPLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_EXAMPLE.
INCLUDE ZFC_EXAMPLE_top.
INCLUDE ZFC_EXAMPLE_slc.
INCLUDE ZFC_EXAMPLE_cls.
INCLUDE ZFC_EXAMPLE_pbo.
INCLUDE ZFC_EXAMPLE_pai.

INITIALIZATION.
  CREATE OBJECT go_local.

START-OF-SELECTION.
  go_local->get_data( ).
  go_local->prepare_display( ).
  go_local->display_alv( ).
  CALL SCREEN 0100.