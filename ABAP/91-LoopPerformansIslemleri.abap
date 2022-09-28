*&---------------------------------------------------------------------*
*& Report ZFC_EXAMPLE_8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zfc_example_8.
TABLES: scarr, sbook.

DATA: t_sbook  TYPE TABLE OF sbook,
      t_scarr TYPE TABLE OF scarr.

START-OF-SELECTION.

"Tablo Dolum işlemleri
  SELECT *
    FROM sbook
    INTO TABLE t_sbook.

  SELECT *
    FROM scarr
    INTO TABLE t_scarr.

"Indexleme
DATA: w_runtime1 TYPE i,
      w_runtime2 TYPE i,
      w_index LIKE sy-index.

  GET RUN TIME FIELD w_runtime1.  "Programın başından beri gecen sureyi alır

  "Sortlama işlemi
  SORT t_sbook BY carrid.
  SORT t_scarr BY carrid.


" içinde don
  LOOP AT t_scarr INTO scarr.
    LOOP AT t_sbook INTO sbook FROM w_index."O anki indexe gore al yani sorttaki key degerleri eşleşcek cinsten
      IF sbook-carrid NE scarr-carrid. "Eger eşit degilse
        w_index = sy-tabix. "Guncel indexi al
        EXIT."looptan çık
      ENDIF.

    ENDLOOP.
  ENDLOOP.
  write: 'Donulen Satır sayısı:', w_index ,'/'.

  GET RUN TIME FIELD w_runtime2."uygulamanın başından itibarenki zamanı alır

  w_runtime2 = w_runtime2 - w_runtime1. "2. degere ilk looptan onceki zamanı cıkarırız

  WRITE : 'Loopta gecen sure:', w_runtime2."Ve elimize loopta gecen sure gecer