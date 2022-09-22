FORM set_receiver using p_receiver_mail."Alıcı mail adresi isteyen form 

gs_alicibilgileri-receiver = p_receiver_mail.
gs_alicibilgileri-rec_type = 'U'.
append gs_alicibilgileri to gt_alicibilgileri.

ENDFORM.

form set_subject USING p_subjectname."Konu adı isteyen form

gs_mailozellikleri-obj_langu = 'T'.
gs_mailozellikleri-obj_name = p_subjectname.
gs_mailozellikleri-obj_descr = p_subjectname.

ENDFORM.

form set_body USING p_text."Ne iletmek istedigmizi yazcagımzıı form 

gs_mailicerigi-line = p_text.

append gs_mailicerigi to gt_mailicerigi.

ENDFORM.

form send_mail. "Mail gonderme işlemini tetikleyen form

GS_ICERIKBILGILERI-TRANSF_BIN = SPACE."Binary formatına cevrilmesini istermisiniz? 
GS_ICERIKBILGILERI-HEAD_START = 1."Başlık satırı
Gs_ICERIKBILGILERI-HEAD_NUM   = 0."Başlık numarası
GS_ICERIKBILGILERI-body_start = 1."text alanı  satır numarası

DESCRIBE TABLE GT_MAILICERIGI LINES Gs_ICERIKBiLGILERI-BODY_NUM."Mail içerigi satır sayısını describe table kullanrak alırız

GS_ICERIKBILGILERI-DOC_TYPE = 'HTM'."Gonderme formatı html "İstersek html kodu yazarak gonderebilirz

APPEND GS_ICERIKBILGILERI TO GT_ICERIKBILGILERI."Girilen mesajları tabloya tabloya ekleriz

call function 'SO_DOCUMENT_SEND_API1'"Send api1 fonksyonunu kullanrak mailimizi gonderebiliriz
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