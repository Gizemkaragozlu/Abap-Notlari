*&---------------------------------------------------------------------*
*& Report ZFC_ALV_SALV_KULLANIM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_ALV_SALV_KULLANIM.


"oluşturma"
DATA: gt_sbook type TABLE OF sbook, "intern table"
      go_salv type REF TO cl_salv_table. "salv objesi"

START-OF-SELECTION.

select * UP TO 20 rows from sbook
  INTO TABLE gt_sbook. "query"

"baglama"

"SALV fonksionu oluşturma"
cl_salv_table=>FACTORY(
  importing
    R_SALV_TABLE   =    go_salv
  changing
    T_TABLE        =    gt_sbook
).
"Salv yapsıı kullanılmadan once oluşturulur baglanır ve goruntulenir

"gpruntuleme"
GO_SALV->DISPLAY( ).