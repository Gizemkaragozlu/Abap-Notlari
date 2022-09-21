//////////////TOP//////////////////

*&---------------------------------------------------------------------*
*&  Include           ZFC_EXAMPLE_HIERARCHICAL_TOP
*&---------------------------------------------------------------------*

"Tables
tables: vbak,vbap.

"Structures
data: gs_vbak   type zprg_s_src1,
      gs_vbap   type zprg_s_src2,
      gs_itab   type zprg_s_src3,
      gs_header type zprg_s_src4.


"Tables
data: gt_vbak type zprg_tt_src1,
      gt_vbap type zprg_tt_src2,
      gt_itab type zprg_tt_src3.

"Field catalogs
data: gt_fieldcatalog2 type slis_t_fieldcat_alv,
      gs_fieldcatalog2 type slis_fieldcat_alv.


"Layouts
data: gs_layout  type slis_layout_alv,
      gs_layout2 type slis_layout_alv,
      gs_keyinfo type slis_keyinfo_alv.

"Cell colors
data: gs_cellcolor type lvc_s_scol.


//////////SSC///////////////

*&---------------------------------------------------------------------*
*&  Include           ZFC_EXAMPLE_HIERARCHICAL_SSC
*&---------------------------------------------------------------------*


  select-options  s_vbeln for vbak-vbeln. "Select options

  "selection-screen begin of line .
  "selection-screen comment 1(45) text-024.
  "selection-screen end of line.

 " parameters : p_radio1 radiobutton group a1 user-command radio,
 "           p_radio2 radiobutton group a1.
  select-options: s_erdat for vbak-erdat modif id erd.

  "parameters: p_radio3 radiobutton group a2 user-command radio,
   "           p_radio4 radiobutton group a2.

*  at selection-screen output.
*    loop at screen.
*
*      clear s_erdat.
*      if screen-group1 eq 'ERD'.
*        screen-input = 0.
*        screen-output = 0.
*        refresh s_erdat.
*        modify screen.
*
*        if p_radio2 = 'X'.
*          screen-input = 1.
*
*        endif.
*      endif.
*      modify screen.
*    endloop.


/////////////////////FRM////////////////////////



form item_get_data . "item moduna gore kolon doldurma

  select vbeln erdat erzet ernam kunnr "Gt_vbak tablosu doldurulur
    from vbak
    into corresponding fields of table gt_vbak
      where vbeln in s_vbeln
      and erdat in s_erdat.


  select vbeln posnr matnr arktx netwr waerk"gt_vbap tablosu doldurulur
    from vbap
    into corresponding fields of table  gt_vbap
    for all entries in gt_vbak
    where vbeln eq gt_vbak-vbeln.


  loop at gt_vbak assigning field-symbol(<gfs_vbak>). "gt_vbak tablosunda dön

    "Bu alanda kolonun key degerinin ve genel alanlarını dolduruyoruz
    gs_itab-vbeln = <gfs_vbak>-vbeln.
    gs_itab-kunnr = <gfs_vbak>-kunnr.
    gs_itab-erdat = <gfs_vbak>-erdat.
    gs_itab-erzet = <gfs_vbak>-erzet.
    gs_itab-ernam = <gfs_vbak>-ernam.


    if gs_itab-erzet ne 000000. "oluşturma saati parçalama
      gs_itab-zztime = gs_itab-erzet.

      concatenate <gfs_vbak>-erzet+0(2) <gfs_vbak>-erzet+2(2) <gfs_vbak>-erzet+4(2) into gs_itab-zztime
      separated by ':'.
    endif.
    "clear gs_itab-netwr. "net satış degeri temizlenir
    append gs_itab to gt_itab."genel alanları tabloya eklyourz
    clear gs_itab. "Strcutre temizlenir


    loop at gt_vbap into gs_vbap where vbeln eq <gfs_vbak>-vbeln."bu alanda ise tablonun genel alanını dışındaki ksıımlar urun adıdır fiyattır vs.

      gs_itab-posnr = gs_vbap-posnr.
      gs_itab-matnr = gs_vbap-matnr.
      gs_itab-arktx = gs_vbap-arktx.
      gs_itab-netwr = gs_vbap-netwr.
      gs_itab-waerk = gs_vbap-waerk.
      append gs_itab to gt_itab.
      clear gs_itab.

    endloop.

  endloop.



"Bu alan ise satırların renklendirme kısmı
  loop at gt_itab into gs_itab.
    if gs_itab-vbeln <> 0. "Satış dokumanı 0 degilse
      gs_itab-zzcolor = 'C511'.
      modify gt_itab from gs_itab.
    else. "0 ise
      gs_itab-zzcolor = 'C500'.
      modify gt_itab from gs_itab.
    endif.
  endloop.

"satis dokuman hucresindeki degerler 0 ise hucre temizlenir
  loop at gt_itab assigning field-symbol(<fs_itab>). "gt_itab içindeki
    shift <fs_itab>-posnr left deleting leading '0'. "Sales document item kolonundaki 0 degerleri silinir
  endloop.

endform.


form item_create_fcat . "item moduna gore field catalog oluşturma

 "fieldcatalog merge
  call function 'REUSE_ALV_FIELDCATALOG_MERGE'
    exporting
      i_program_name         = sy-repid
      i_structure_name       = 'ZPRG_S_SRC3'
      i_inclname             = sy-repid
    changing
      ct_fieldcat            = gt_fieldcatalog2[].



  loop at gt_fieldcatalog2 assigning field-symbol(<fs_fcat>).

    if <fs_fcat>-fieldname = 'ERZET'. "Erzet kolonu gizlenir
     <fs_fcat>-no_out = 'X'."saat alanını başka kolona parçaladıgımız için bu alanı gostermeyeecgiz


    elseif <fs_fcat>-fieldname = 'ZZTIME'. "ztime kolonu gosterilir ve kolon adları verilir
      <fs_fcat>-seltext_s = 'Time'.
      <fs_fcat>-seltext_m = 'Time'.
      <fs_fcat>-seltext_l = 'Time'.
    endif.

  endloop.



endform.


form item_set_layout . "Genel layout

  gs_layout2-info_fieldname = 'ZZCOLOR'. "Layouta satir rengi tanımlama
  "gs_layout2-coltab_fieldname = 'CELLCOLOR'. "layouta hucre rengi tanımlanr
  gs_layout2-zebra = 'X'. "zebra desen aktif edilir
  gs_layout2-colwidth_optimize = 'X'. "Colon optimizasyonu yapılır

endform.



form item_display_alv . "Alv yi ekrana basmak

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      is_layout                = gs_layout2
      it_fieldcat              = gt_fieldcatalog2[]
    tables
      t_outtab                 = gt_itab[].

endform.


form item_pf_status_set using p_extab type slis_t_extab. "Alv ye status bar tanımlama
  set pf-status 'STANDARD'.
endform.


//////////MAIN/////////////

*&---------------------------------------------------------------------*
*& Report ZFC_EXAMPLE_HIERARCHICAL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zfc_example_hierarchical.

include zfc_example_hierarchical_top.
include zfc_example_hierarchical_ssc.
include zfc_example_hierarchical_frm.

start-of-selection.


    perform item_get_data.
    perform item_create_fcat.
    perform item_set_layout.
    perform item_display_alv.