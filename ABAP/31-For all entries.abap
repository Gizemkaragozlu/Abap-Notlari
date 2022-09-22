"For All Entries, JOIN yapamıyacağımız tablolar için kullanılır. Örneğin BSEG(FI Belge Kalemi Tablosu) bir cluster tablo yapısına sahip olduğundan dolayı bu tabloya JOIN işlemi gerçekleştirilemez. Bundan dolayı bu tablo ile ilgili bir işlem yapılacağında bu tabloya For All Entries kuralı ile bağlanılır.

"For All Entries, kuralı uygulanırken, okunacak verilerden bir anahtar tablo oluşturulur. Daha sonra bu anahtar tablodaki tüm kayıtlar için SELECT komutu tek adımda çalıştırılır.

"For All Entries kullanımında dikkat edilmesi gereken nokta ise, eğer anahtar tablonuz boş ise tüm kayıtlar okunur. Bu nedenle For All Entries yazmadan önce mutlaka anahtar tablonun boş olup olmadığını kontrol etmemiz gerekir.

"Şimdi örnek bir uygulama yaparak, ilgili For All Entries kuralını nasıl uygulayacağımızı gösterelim.

"Örneğimizde; Satınalma siparişine istinaden yaratılmış olan mal girişleri ve faturaları okuyacak bir sorgu oluşturalım.

"Kullanacağımız tablolar aşağıdakilerdir;

EKBE : Satınalma Belge Akışı tablosu
MKPF : Malzeme Belgesi Başlık Tablosu
MSEG : Malzeme Belgesi Kalem Tablosu
RBKP : MM Fatura Belgeleri Başlık Tablosu
RSEG : MM Fatura Belgeleri Kalem Tablosu
EKBE tablosunda yer alan bir kaydın mal giriş belgesi mi yoksa fatura giriş belgesi mi olduğunu VGABE(İşlem Türü) alanında yer alan değere göre anlaşılır. EKBE-VGABE alanında 1 değeri var ise bu kayıt bir mal girişi kaydıdır. EKBE-VGABE alanında 2 değeri var ise bu kayıt bir fatura girişi kaydıdır. 

Mal Girişi (EKBE-VGABE = 1) ise detaylar MKPF ve MSEG tablolarından okunur.

Fatura Girişi (EKBE-VGABE = 2) ise detaylar RBKP ve RSEG tablolarından okunur.

Yukarıda detaylarını verdiğim gibi aslında gideceğimiz tabloları EKBE-VGABE alan değerine göre farklılık göstermektedir. Bu gibi durumlarda önce EKBE tablosu okunur ve internal bir tabloya dataları alınır. Daha sonra bu tablo döngüye sokularak her satırdaki VGABE alanının değerine göre iki farklı SELECT yazılır. Bu durumda her satır için database bağlantısı yapıp veri okumaya çalıştığımızdan dolayı işlem çok üzün sürebilir ve performans sorunu çıkarabilir.

Şimdi yukarıdaki durumun algoritmasını yazacak olur isek, kullanıcıdan  aldığımız tarih bilgisini (S_BUDAT) EKBE_BUDAT alanına eşitleyerek algoritmamızı oluşturalım.


*&---------------------------------------------------------------------*
*& Report ZFC_EXAMPLE_8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zfc_example_8.

"for all entries için tablolar
data: gv_budat type ekbe-budat,
      gt_ekbe type TABLE OF ekbe WITH HEADER LINE,
      gt_mseg type TABLE OF mseg WITH HEADER LINE,
      gt_rseg type TABLE OF rseg WITH HEADER LINE.
DATA : BEGIN OF S_KEY,
  GJAHR LIKE  EKBE-GJAHR,
  BELNR LIKE  EKBE-BELNR,
  BUZEI LIKE  RSEG-BUZEI,
       END OF S_KEY,
       GT_KEY1  LIKE TABLE OF S_KEY WITH HEADER LINE,
       GT_KEY2  LIKE TABLE OF S_KEY WITH HEADER LINE.

SELECT-OPTIONS S_BUDAT FOR gv_budat.

SELECT * FROM EKBE INTO TABLE GT_EKBE
    WHERE BUDAT IN S_BUDAT.



*Anahtar Tablolar Dolduruluyor
LOOP AT GT_EKBE.
  IF GT_EKBE-VGABE EQ '1'. "Mal Girişi"
    MOVE-CORRESPONDING GT_EKBE TO GT_KEY1.
    COLLECT GT_KEY1.
  ELSEIF GT_EKBE-VGABE EQ '2'. "Fatura Girişi"
    MOVE-CORRESPONDING GT_EKBE TO GT_KEY2.
    COLLECT GT_KEY2.
  ENDIF.
ENDLOOP.

*Anahtar Tablo Boş mu diye kontrol ediyoruz.
IF GT_KEY1[] IS NOT INITIAL.

*Tüm Mal Girişleri tek bir seferde okunur
SELECT * INTO TABLE GT_MSEG FROM MSEG
  FOR ALL ENTRIES IN GT_KEY1
  WHERE GJAHR EQ GT_KEY1-GJAHR AND
  MBLNR EQ GT_KEY1-BELNR AND
  ZEILE EQ GT_KEY1-BUZEI(4).
ENDIF.


*Anahtar Tablo Boş mu diye kontrol ediyoruz.
IF GT_KEY2[] IS NOT INITIAL.

*Tüm Fatura Girişleri tek bir seferde okunur
SELECT * INTO TABLE GT_RSEG FROM RSEG
  FOR ALL ENTRIES IN GT_KEY2
  WHERE GJAHR EQ GT_KEY2-GJAHR AND
  BELNR EQ GT_KEY2-BELNR AND
  BUZEI EQ GT_KEY2-BUZEI.
ENDIF.