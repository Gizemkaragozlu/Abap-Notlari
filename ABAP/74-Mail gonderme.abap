*&---------------------------------------------------------------------*
*&  Include           ZFC_P_MAIL_GONDERME_1_FNC
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT h~vbeln i~posnr k~name1 AS customer arktx vkgrp
      INTO CORRESPONDING FIELDS OF TABLE gt_data
      FROM vbak AS h
      INNER JOIN vbap AS i
      ON h~vbeln EQ i~vbeln
      INNER JOIN kna1 AS k
      ON h~kunnr EQ k~kunnr
      WHERE vkorg EQ '7000'.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SEND_MAIL
*&---------------------------------------------------------------------*
FORM send_mail .

  LOOP AT gt_data INTO DATA(ls_data).

*    DATA(lv_ay) = ls_data-kalan_gun / 30.
    DATA(lv_ay) = '3'.

    gs_docdata-obj_descr = 'Deal (Opportunity) Hizmet Bitiş Bildirimi'.

    gs_objtxt-line = '<html> <body>'.
    APPEND gs_objtxt TO gt_objtxt.

    gs_objtxt-line = |<p> Aşağıda bulunan deal kalemlerine ait hizmet süresi bitimine istinaden son { lv_ay } aylık sürece girilmiş bulunmaktadır.| &&
                     | İlgili deal’ın yenilenmesi ile ilgili CRM’de gerekli aksiyonun alınması gerekmektedir. </p>|.
    APPEND gs_objtxt TO gt_objtxt.
*   table display
    gs_objtxt-line = '<table style="MARGIN: 10px" bordercolor="blue" '.
    APPEND gs_objtxt TO gt_objtxt.
    gs_objtxt-line = ' cellspacing="0″ cellpadding="5″ width="800″'.
    APPEND gs_objtxt TO gt_objtxt.
    gs_objtxt-line = ' border="1″><tbody><tr>'.
    APPEND gs_objtxt TO gt_objtxt.
*   table header
    gs_objtxt-line = '<th bgcolor="yellow" nowrap>Deal Numarası</th>'.
    APPEND gs_objtxt TO gt_objtxt.
    gs_objtxt-line = '<th bgcolor="yellow">Deal Kalemi</th>'.
    APPEND gs_objtxt TO gt_objtxt.
    gs_objtxt-line = '<th bgcolor="yellow" nowrap>Ürün Tanımı</th>'.
    APPEND gs_objtxt TO gt_objtxt.
    gs_objtxt-line = '<th bgcolor="yellow" nowrap>Customer</th>'.
    APPEND gs_objtxt TO gt_objtxt.

    CONCATENATE '<tr style="background-color:#eeeeee;"><td>' ls_data-vbeln '</td>'
    INTO gs_objtxt.
    APPEND gs_objtxt TO gt_objtxt.

    CONCATENATE '<td>' ls_data-posnr '</td>' INTO gs_objtxt-line.
    APPEND gs_objtxt TO gt_objtxt.

    CONCATENATE '<td>' ls_data-arktx '</td>' INTO gs_objtxt-line.
    APPEND gs_objtxt TO gt_objtxt.

    CONCATENATE '<td>' ls_data-customer '</td>' INTO gs_objtxt-line.
    APPEND gs_objtxt TO gt_objtxt.

    gs_objtxt-line = '</tbody> </table>'.
    APPEND gs_objtxt TO gt_objtxt.

    gs_objtxt-line = '<br><br>'.
    APPEND gs_objtxt TO gt_objtxt.
*   HTML close
    gs_objtxt-line = '</body> </html> '.
    APPEND gs_objtxt TO gt_objtxt.

    DESCRIBE TABLE gt_objtxt LINES gv_lines.
    READ TABLE gt_objtxt INTO gs_objtxt INDEX gv_lines.
    gs_docdata-doc_size = ( gv_lines - 1 ) * 255 + strlen( gs_objtxt ).

    CLEAR gs_objpack-transf_bin.
    gs_objpack-head_start = 1.
    gs_objpack-head_num   = 0.
    gs_objpack-body_start = 1.
    gs_objpack-body_num   = gv_lines.
    gs_objpack-doc_type   = 'HTML'.
    APPEND gs_objpack TO gt_objpack.

    gs_reclist-receiver = 'deneme@teampro.com.tr'.
    gs_reclist-rec_type = 'U'.
    APPEND gs_reclist TO gt_reclist.

    CALL FUNCTION 'SO_NEW_DOCUMENT_ATT_SEND_API1'
      EXPORTING
        document_data              = gs_docdata
        put_in_outbox              = 'X'
        commit_work                = 'X'
      TABLES
        packing_list               = gt_objpack
        object_header              = gt_objhead
        contents_txt               = gt_objtxt
        receivers                  = gt_reclist
      EXCEPTIONS
        too_many_receivers         = 1
        document_not_sent          = 2
        document_type_not_exist    = 3
        operation_no_authorization = 4
        parameter_error            = 5
        x_error                    = 6
        enqueue_error              = 7
        OTHERS                     = 8.

    CLEAR: gs_docdata, gt_objpack[], gt_objhead[], gt_objtxt[], gt_reclist[].
  ENDLOOP.

ENDFORM.