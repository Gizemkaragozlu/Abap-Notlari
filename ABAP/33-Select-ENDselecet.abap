TABLES: scarr. "direk tables diye tanımlarsam bu bana sanki bie structure gibi davrancaktır
DATA: gs_scarr TYPE scarr. "scarr adında structure

START-Of-SELECTIOn. 

SELECT * from scarr into gs_scarr.  "normalde select single demeden bu işlem yapılmazdı ama select end select arası bir loop gorevi gormktedir
    write gs_scarr. "her dolan structure ekrana basılır
ENDSELECT.

SELECT * FROM scarr WHERE currcode EQ 'EUR'. "whre yapısıyla berbaer de kullanabilirz

endselect