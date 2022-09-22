DATA: gs_scarr TYPE scarr. "scarr adında structure

START-Of-SELECTIOn. 

SELECT * from scarr into gs_scarr.  "normalde select single demeden bu işlem "yapılmazdı ama select end select arası bir loop gorevi gormektedir
 "   write gs_scarr. "her dolan structure ekrana basılır
ENDSELECT.

SELECT * FROM scarr WHERE currcode EQ 'EUR'. "where yapısıyla beraber de kullanabilirz

endselect