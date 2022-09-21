TCOD Işlem kodları//

SE38 Program oluşturma kodu

yeni programların adı y veya z ile başlamalı sistemde hali hazırda bi çok uygulama oldugu için karışmaması adına y veya z ile başlar

VERİ tipi tanımlama

data gv_degis type p decimals 3.//decimals
data gv_degis1 type int4 / int2 / int1 .//integer
data gv_gegis2 type n.  //numeric
data gv_degis3 type c. //char
data gv_degis4 type string.  //string

//degiskenlere deger atama
gv_degis = '12.12'. //virgulden sonra 3 karakter şeklinde kaydettilk //decimals

gv_degis1 = 123.  //integer
gv_degis2 = 654.  //numeric type integer gibi numerik ifade alır tanımlamalarda lenght uzunlguu verirsek uzunlguu kadar başına 0 degeri koyar int boş bırakır

gv_degis3 = 'A'. //char 
gv_degis4= 'selam furkan'. //String 



data gv_gegis5 type i.  //int4 anlamına gelir 10 basamaklı bir sayı tutar

data gv_degis6 type n length 10. //sadece n yazıp bıraksak bu 1 karakterli sayıya tekabul eder length 10 diyerek 10 basamaklı bir sayı tutcagımı soluyoruz

//data yazıp iki nokta koymamzı durumunda biz birden cok data tamılayacgımız anlamına gelir
data: gv_degis type i,
	gv_degis1 type n,
	gv_degis2 type string.
	
	
//Yorum satırı
"selam" 
*selam*

write degis ad şeklinde çıktı alınır
write: ile birden cok yazdırma işlemi yapılır

//if kullanımı

if koşul.

endif.

ornek

if gv_degis2 > 5.
    write: 'degisken 5 ten buyuktur',gv_degis2.
endif.
****Bu farklı
data:gv_degis2 type i value 10.       


if gv_degis2 < 10.
    write 'degisken 10 dan kucuktur'.
elseif gv_degis2 > 10.
    write 'degisken 10 dan buyuktur'. 
else.
    write 'degisken 10'.
endif.

data: gv_s1 type i value 2 , gv_s2 type i value 2.
if gv_s1 = 1.//eşittir
    write 'senin sayın 1'.
elseif gv_s1 = gv_s2.
    write 'senin sayın 2'.
else.
    write 'senin sayın 2 veya 1 degil'. 
endif.



//CASE WHEN yapısı

data gv_s1 type i value 1.

case gv_s1.
    when 1.
        write 'Rakam 1'.
    when 2.
        write 'Rakam 2'.
    when 3.
        write 'Rakam 3'.
    when others.
        write 'Ralam ne 1 ne 2 ne 3'.
endcase.    
    
	
//DO DONGUSU

data gv_s1 type i value 0.

do 10 times. //Dongu 10 defa doner
    write 'SJ'.
enddo.
////////////////
data: gv_adim type string value 'Furkan' , gv_adUzunluk type i.
gv_adUzunluk = STRLEN(gv_adim).

do gv_adUzunluk times.
    write 'furkan'.
enddo.

///////////
data gv_degs type i value 0.

do 20 times.
write: / 'Sayı şuan: ',gv_degs.  //baştaki / altsatıra indirir
gv_degs = gv_degs + 1 .

enddo.

/////////////
WHILE DONGUSU

data gv_degs type i value 1.

while gv_degs > 0. "şart uydugu surece çalısır"
    write 'SJ'.
endwhile.
***************/////***************
data gv_degs type i value 10.

while gv_degs > 0. "şart uydugu surece çalısır"
    write: / 'SAYI: ',gv_degs.
    gv_degs = gv_degs - 1.
endwhile.


< LT. 
> GT. 
<= LE.
>= GE.
= EQ.

//Şeklinde de kullanılır