*&---------------------------------------------------------------------*
*& Report ZFC_EXAMPLE_8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zfc_example_8.

CLASS lcl_abap_class DEFINITION."Class oluştrulur
  PUBLIC SECTION."Public tipte methodumuz var
    METHODS method1 IMPORTING iv_string TYPE string"İçeri aktarılacak parametre
                     EXPORTING ev_string TYPE string"İçeriden donecek parametre
                     CHANGING cv_string TYPE string."İçeride degisecek parametre
ENDCLASS.

CLASS lcl_abap_class IMPLEMENTATION."Classın degerleri tanımlanır işlemeler yapılmaya başlanır
    METHOD method1."Method1
        cv_string = iv_string."Changing parametreye import parametre atannır
        ev_string = 'example'."Export parametre içeride degisir method otomatik olarak çıktıları yapar
    ENDMETHOD.
ENDCLASS.

data :go_cls type REF TO lcl_abap_class,"Class objeye atanır
      lv_string type string VALUE 'QWE',"Stringler oluşur ve varsayılan degerleri atanır
      lv_string2 type string VALUE 'ASD',
      lv_string3 type string VALUE 'ZXC'.

START-OF-SELECTION."Start edilince
CREATE OBJECT go_cls."Class objesi oluştrulur

go_cls->method1("Classın methoduna obje ile erişilerek methoda parametreler verilir
  EXPORTING iv_string = lv_string"İçeri aktarılacak olan parametre
  IMPORTING ev_string = lv_string2"Donen deger parametresi
   CHANGING cv_string = lv_string3"Degisen deger parametresi
).
WRITE: lv_string,lv_string2,lv_string3."Hangi degerlerin degistigine Bakarız