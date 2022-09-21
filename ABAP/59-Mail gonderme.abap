


FORM set_receiver using p_receiver_mail.

gs_alicibilgileri-receiver = p_receiver_mail.
gs_alicibilgileri-rec_type = 'U'.
append gs_alicibilgileri to gt_alicibilgileri.

ENDFORM.

form set_subject USING p_subjectname.

gs_mailozellikleri-obj_langu = 'T'.
gs_mailozellikleri-obj_name = p_subjectname.
gs_mailozellikleri-obj_descr = p_subjectname.

ENDFORM.

form set_body USING p_text.

gs_mailicerigi-line = p_text.

append gs_mailicerigi to gt_mailicerigi.

ENDFORM.

form send_mail.


GS_ICERIKBILGILERI-TRANSF_BIN = SPACE.
GS_ICERIKBILGILERI-HEAD_START = 1.
Gs_ICERIKBILGILERI-HEAD_NUM   = 0.
GS_ICERIKBILGILERI-body_start = 1.
DESCRIBE TABLE GT_MAILICERIGI LINES Gs_ICERIKBiLGILERI-BODY_NUM.
GS_ICERIKBILGILERI-DOC_TYPE = 'HTM'.
APPEND GS_ICERIKBILGILERI TO GT_ICERIKBILGILERI.

call function 'SO_DOCUMENT_SEND_API1'
  exporting
    document_data                    = gs_mailozellikleri
   SENDER_ADDRESS                   = gv_gonderen
   SENDER_ADDRESS_TYPE              = 'INT'
   COMMIT_WORK                      = 'X'
  tables
    packing_list                     = gt_icerikbilgileri
   CONTENTS_TXT                     = gt_mailicerigi
    receivers                        = gt_alicibilgileri
 EXCEPTIONS
   TOO_MANY_RECEIVERS               = 1
   DOCUMENT_NOT_SENT                = 2
   DOCUMENT_TYPE_NOT_EXIST          = 3
   OPERATION_NO_AUTHORIZATION       = 4
   PARAMETER_ERROR                  = 5
   X_ERROR                          = 6
   ENQUEUE_ERROR                    = 7
   OTHERS                           = 8.

IF sy-subrc eq 0.
  write 'Başarılı'.
else.
  write 'Başarısız'.
ENDIF.

ENDFORM.