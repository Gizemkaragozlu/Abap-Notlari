"table uzerinden gelcek satırları tutmak için structre oluşturulur
DATA: gs_sflight TYPE SFLIGHT. "Structure"

"Where yapısı için parametre istenir
PARAMETERS: p_CARRID  type S_CARR_ID, 
            p_CONNID  type S_CONN_ID,
            p_FLDATE  type S_DATE.


START-OF-SELECTION.
"Sorgu yazılır tek bir veri gelcegi için single ifadesi kullanılır
"intodan sonraki gelen degişkene sorgudan doncek degerler atanır where yapısı ile de işlem koşullandırılır
  select SINGLE * from SFLIGHT INTO GS_SFLIGHT WHERE CARRID eq p_CARRID
                                                 and CONNID eq p_CONNID
                                                 and FLDATE eq p_FLDATE.
