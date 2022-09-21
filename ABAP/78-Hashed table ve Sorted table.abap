*&---------------------------------------------------------------------*
*& Report ZFC_EXAMPLE_15
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zfc_example_15.

"SORTED TABLE
"Doldurduğunuzda sıralanan bir tabloya ihtiyacınız varsa, bu en uygun türdür.
* INSERT deyimini kullanarak sıralanmış tabloları doldurursunuz. Girişler,
*  tablo tuşu aracılığıyla tanımlanan sıralama sırasına göre eklenir.
*   Herhangi bir geçersiz giriş, siz onları tabloya eklemeye çalıştığınız anda tanınır.
*    Anahtar erişimi için yanıt süresi, sistem her zaman ikili arama kullandığından,
*     tablo girişlerinin sayısıyla logaritmik olarak orantılıdır.
*    WHERE koşulunda tablo anahtarının başlangıcını belirtirseniz,
*    sıralı tablolar özellikle bir LOOP'ta kısmen sıralı işleme için kullanışlıdır.

data: begin of line,
        col1 type i,
        col2 type i,
      end of line.

"Sorted tablo oluşturulur unique(benzersiz alan) col1 dir
data itab like sorted table of line with unique key col1.

do 4 times."4 Kez dongu kurar
  line-col1 = sy-index."O anki dongu sayisi
  line-col2 = sy-index ** 2."Dongunun 2.kuvvetir-
  insert line into table itab.
enddo.

clear line.

read table itab with table key col1 = 3 "Col1 degeri 3 olanın
                into line transporting col2."Col 2 degerini line içine atar

write:   'SY-SUBRC =', sy-subrc,"Subrc degeri
       / 'SY-TABIX =', sy-tabix."Col1 degeri 3 olanın satır numarasını verir
skip.
write: / line-col1, line-col2."Col1 ve col2 degerini yazdır
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Tabloyu oku col2 degeri 16 olanı sec herhangi bir taşıma yapma
READ TABLE ITAB WITH KEY COL2 = 16  TRANSPORTING NO FIELDS.

WRITE:   'SY-SUBRC =', SY-SUBRC,"Subrc degeri
       / 'SY-TABIX =', SY-TABIX."col2 degeri 16 olanın satır sayısını yazdır

"Ekran arasına boşluk
DO 10 TIMES.
skip.
ENDDO.
"HASHED TABLE
"Bu, ana işlemin anahtar erişimi olduğu herhangi bir tablo için en uygun türdür.
"Dizini kullanarak karma bir tabloya erişemezsiniz. Anahtar erişimi için yanıt süresi,
"tablo girişlerinin sayısından bağımsız olarak sabit kalır. Veritabanı tabloları gibi,
"karma tabloların da her zaman benzersiz bir anahtarı vardır. Karma tablolar,
"bir veritabanı tablosuna benzeyen bir iç tablo oluşturmak ve kullanmak istiyorsanız veya
"büyük miktarda veriyi işlemek için kullanışlıdır.

DATA ITAB2 LIKE HASHED TABLE OF LINE WITH UNIQUE KEY COL1.
"Hashed tablo oluştur unique degeri olarak col1 secilir ve line degeri structre olarak kabul edeilir

DO 4 TIMES."4 kez donen dongu kurulur
  LINE-COL1 = SY-INDEX."o anki satir index deger alınır
  LINE-COL2 = SY-INDEX ** 2."Satir indeex degerinin 2.katı yazdırılır
INSERT LINE INTO TABLE ITAB2."Tabloya eklenir
ENDDO.

LINE-COL1 = 2. LINE-COL2 = 3."Col 1=2 col2 = 3 degerleri verilir

"Tablo okunur line structrina col2 degeri eklenir.
READ TABLE ITAB2 FROM LINE INTO LINE COMPARING COL2.

WRITE : 'SY-SUBRC =', SY-SUBRC."Subrc yazdılır
SKIP.
WRITE: / LINE-COL1, LINE-COL2."Col1 ve col2 yazdılır

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Ekran arasına boşluk
DO 10 TIMES.
skip.
ENDDO.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
DATA ITAb3 LIKE HASHED TABLE OF LINE WITH UNIQUE KEY COL1.
FIELD-SYMBOLS <FS> LIKE LINE OF ITAB."Field symbol oluştrulur itabın satırları tipinde
"Bir nevi structre işlemi yapar

DO 4 TIMES."4 kez donen bir dongu kurulur
  LINE-COL1 = SY-INDEX."Index degeri
  LINE-COL2 = SY-INDEX ** 2."Index degerinin 2 katı
INSERT line INTO TABLE ITAB3."Satırlar tabloya eklenir
ENDDO.

READ TABLE ITAB3 WITH TABLE KEY COL1 = 2 ASSIGNING <FS>."Tablo okunur col1 = 2 olan fieldsymbol içine atılır

<FS>-COL2 = 100."Field symbol içinden col2 degeri = 100 yapılır

LOOP AT ITAB3 INTO LINE."Tablonun içinde dongu kurulur ve line içine atılır
  WRITE: / line-COL1, line-COL2."line col1 degeri ve col2 degeir yazdırlır
  "2. dongude filedsymobl uzerinden col2 degerine 100 verdigmiz için direkt olarak tablo içinden de degisim olur
ENDLOOP.