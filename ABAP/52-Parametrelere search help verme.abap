
start-of-selection.

  select-options  : s_matnum for  mara-matnr. "selecet options oluşturma

  parameters p_werks type mard-werks. "parameters oluşturma


  data: gt_list       type table of scarr, "Search helpi doldurma
        gs_list       type scarr,
        gt_return_tab type table of ddshretval,
        gs_return_tab type  dselc,
        gs_mapping    type dselc.


at selection-screen on value-request for p_werks. "p_werks alanındaki search helpe tıklanınca aşağı kısım çalışmaya başlar

  select * from scarr into table gt_list. "Tabloyu doldurma

  call function 'F4IF_INT_TABLE_VALUE_REQUEST' "Search help alanı oluşturmak için
    exporting
      retfield     = 'MANDT' "Tablodaki hangi alanı cekecegimi belirtcegimiz alan
      dynpprog     = sy-repid "Program ismi
      dynpnr       = sy-dynnr "Screen
      dynprofield  = 'P_WERKS' "Seçilen alanın ne oldugu nerde search help oluşacagı
      window_title = 'Search help'
      value_org    = 'S' "cell (C) mi yoksa structure (S) mantıgı mı
    tables
      value_tab    = gt_list "Search helpde goruncek kısım
      return_tab   = gt_return_tab "Yapılan seçimi goster ksıım
*     DYNPFLD_MAPPING        = gs_mapping"Coklu data ataması yoneten kısım
* EXCEPTIONS
*     PARAMETER_ERROR        = 1
*     NO_VALUES_FOUND        = 2
*     OTHERS       = 3
    .
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.
