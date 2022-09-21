---------------------------------------SPLIT
DATA: x1(10), y2(10), z3(10),"10 karakterlik 3 değişken oluşturulur
source(20) VALUE 'abc-def-ghi'. "20 karakterlik içinde deger olan değişken

SPLIT source AT '-' INTO x1 y2 z3."Split fonksiyonu ile source içindeki '-' olan kısımlardan keser 3 değişkenin içine atar

WRITE:/ 'X1 — ', x1.
WRITE:/ 'Y2 — ', y2.
WRITE:/ 'Z3 — ', z3.

---------------------------------------SEARCH
DATA: string(30) VALUE ‘SAP ABAP Developers’,"30 karakterlik bir değiken içinde deger olan
str(10) VALUE ‘ABAP’."10 karakterlik içinde deger olan değişken 

SEARCH string FOR str."Search fonk ile string değişkeni içinde str değişkenini arar
IF sy-subrc = 0."Eğer varsa
WRITE:/ ‘Found’.
ELSE."Yoksa
WRITE:/ ‘Not found’.
ENDIF.
---------------------------------------CONDANSE
CONDENSE string. "Stringin başındaki ve sonunda boşlukları temizlker
---------------------------------------REPLACE
DATA: gv_exp1 TYPE string VALUE ‘SAP ABAP & Developers’, "içinde deger olan bir string değişken
gv_exp2 TYPE string VALUE ‘World’. "içinde deger olan ikinci değişken
 
REPLACE ‘Developers’ WITH gv_exp2 INTO gv_exp1.
"replace func ile developers alanını degişken ikiyle degiştirir degişken bir içindeki

WRITE:/ gv_exp1.
----------------------------------------