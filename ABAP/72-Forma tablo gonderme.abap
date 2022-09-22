data gt_table type table of scarr with header line."Tablo oluşturduk scarr tipinde


perform get_table using gt_tabl[]. "Tablo gonderme ve formu cagırma 

form get_table using p_table type zfc_scarr_tt. "form içinden tablo isteme
"Forma bi tablo gondercek bunu table type olarak istemeliyiz

endform.


data gt_table type TABLE OF scarr.

PERFORM get_table TABLES gt_table.

form get_table TABLES t_scarr TYPE scarr_tab.
  "... t1 [{TYPE itab_type}|{LIKE itab}|{STRUCTURE struc}]
   " t2 [{TYPE itab_type}|{LIKE itab}|{STRUCTURE struc}]

  LOOP AT t_scarr.

  ENDLOOP.
ENDFORM.