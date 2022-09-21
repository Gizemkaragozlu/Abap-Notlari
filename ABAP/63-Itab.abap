read table : İnternal tablonun bir satırını okur. Tablo anahtarı kullanılarak arama yapmak için kullanılır.
READ TABLE itab table_key| free_key|index.

loop at :Dahili tablolarda döngüsel işlemler yapmak için LOOP AT ifadesi kullanılır. İnternal tablodaki her kayıt için bir döngü bloğu çalıştırılır.
LOOP ifadesi ile WHERE anahtar kelimesi kullanılarak döngü sayısı sınırlandırılabilir. Koşula uyan her kayıt sayısı kadar döngü oluşur.
LOOP AT itab [cond].

insert :Dahili tablolara satır eklemek için INSERT ifadesi kullanılır. INSERT ifadesi
başarısızlıkla sonuçlanırsa sistem değişkeni sy-subrc 4 değerini, başarılı ise 0 değerini
alır.
INSERT itab_position [result].

append : İlgili tabloya veri eklemek için kullanılmaktadır. İnternal tabloya bir veya birden fazla kayıt ekler. Birincil tablo indeksine
bağlı olarak son kayıttan sonra yeni bir kayıt eklenir. INSERT komutuyla aynıdır.
APPEND TO itab [SORTED BY comp] [result].

collect : COLLECT ifadesi anahtar olarak belirtilmiş alanlarda kayıt eklenirken arama
işlemi yapar ve uyuşan bir kayıt bulur ise yeni kayıt olarak ekleme işlemi yapmaz.
Bulduğu kayıt üzerinde anahtar dışındaki sayısal alan üzerinde toplama işlemi yaparak
sadece değişiklik yapar.
COLLECT itab [result].

modify : İlgili tablodaki veriyi değiştirmek için kullanılmaktadır. İnternal tablodaki bir veya daha fazla kaydı değiştirmek için kullanılır.
Kayıtlara indeks numarası veya anahtar alanları ile ulaşılır.
MODIFY table_key|index [TRANSPORTING comp1 comp2 …] [result].

delete: İnternal tablodan bir veya daha fazla sayıda kayıt silmek için veya birbiri ardına sıralanmış çift satırları silmek kullanılır.
DELETE TABLE itab.

SORT : İnternal tabloyu sıralamak için kullanılır.
SORT <itab> [ASCENDING|DESCENDING] [AS TEXT] [STABLE].
--------------------------------------------------------
TYPES: BEGIN OF tab,
num TYPE i,
name(30) TYPE c,
END OF tab.

**** Table isminde bir tip bu dedik
TYPES: mytab TYPE STANDARD TABLE OF tab.

**** İnternal table ile work areamızı oluşturduk
DATA: wa TYPE tab,
itab TYPE mytab.

DO 10 TIMES.
wa-num = 11 – sy-index.
wa-name = ‘VOLKAN’.
APPEND wa to itab.
ENDDO.

LOOP AT itab into wa .
WRITE : / wa-num, wa-name.
ENDLOOP.

WRITE / ‘**********************************************’.

**** İtab Sıralanıyor
SORT itab BY num ASCENDING.

LOOP AT itab into wa .
WRITE : / wa-num, wa-name.
ENDLOOP.

Header Line
Header Line internal table’a konulan başlık satırıdır. Work area tek satır bir alandır. Bu alanın internal table eklenmesi olarak düşünebilirsiniz.

Yukarda yazdığım aynı kodu wa olmadan header line ile birlikte şöyle yazacaktık. İnternal table’ı oluştururken sadece DATA itab TYPE mytab WITH HEADER LINE. demiş olduk.

REPORT zvolkan_itabs.

**** Bir type oluşturduk  ****
TYPES: BEGIN OF tab,
num TYPE i,
name(30) TYPE c,
END OF tab.

**** Table isminde bir tip bu dedik
TYPES: mytab TYPE STANDARD TABLE OF tab.

**** İnternal table ile work areamızı oluşturduk
DATA itab TYPE mytab WITH HEADER LINE.

DO 10 TIMES.
itab-num = 11 – sy-index.
itab-name = ‘VOLKAN’.
APPEND itab.
ENDDO.

LOOP AT itab.
WRITE : / itab-num, itab-name.
ENDLOOP.

WRITE / ‘**********************************************’.

**** İtab Sıralanıyor
SORT itab BY num ASCENDING.

LOOP AT itab.
WRITE : / itab-num, itab-name.
ENDLOOP.
-----------------------------------------------------------
               DATA: BEGIN OF struc,
  col1 TYPE i,
  col2 TYPE i,
END OF struc,
itab LIKE STANDARD TABLE OF struc.

DO 10 TIMES.
  struc-col1 = sy-index.
  struc-col2 = sy-index ** 2.
  INSERT struc INTO TABLE itab.
ENDDO.

LOOP AT itab INTO struc.
  WRITE: / struc-col1, struc-col2.
ENDLOOP.

READ TABLE itab INDEX 5 ASSIGNING FIELD-SYMBOL(<line>).
WRITE: / <line>-col1, <line>-col2.