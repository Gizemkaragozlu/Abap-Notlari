Fonksiyon modulu nedir: Belli bir amaca hizmet eden yapıyı bir alanda toplayip istenildigi zaman erişilen yapı

Fonksiyon grubu nedir: fonksiyonların grulanıp bir başlık altnda toplanması


se80: yapı oluşturma kodu

fonksiyon grubu oluşturmak için se80 kodu ile function gurp oluşturulup ad verilip active edilir


Fonksiyon modulu oluşturmak:
se37 : fonksiyon modulu oluşturma kodu
fonksiyon adı verilir
create ile oluşturulur
tanım ve fonksiyon grubu degerleri verilir

modulu tanımak
arrtibutes : ozellikler
import : fonksiyona verilcek parametreler
export : fonksiyonun bize return edecegi parametreler
changing: bir deger alıp o degeri değiştirip veren yapılar
tables:	changing ile aynı işe yapar 
exceptions: hata alınan veya ongorulen durumları 
source code: fonksiyon işinin yapcagı işleri gireriz

ORNEK Fonksiyon
iki input al int bir birine bol ve return et

1-import kısmından parametreler verilir 
iv_num1	type int4 defVal  -> import kısmına sırasıyla yapılır
iv_num2	type int4 defVal  -> import kısmına sırasıyla yapılır

2- Export kısmı
ev_result type int4 ->export kısmına aynı şekilde yapılır

3-changing
cv_mes type char20 -> mesaj eklmeek için ekledik changing kısmına sırayla eklenir

4-soruce code kısmına gelinir

Function func_name.

	ev_result = iv_num1 / iv_num2.

endfunction.

pass_by_value kapalıysa = fonksiyona gelen degeri fonk içinde degişmesine izin vermez 

optional = eklenmesi zorunlu olmayan parametre

//Eger exceprion kullanmak istersek
exception kısmına hata adı girilir ve açıklamasaı yazılır

soruce code kısmına gelinir tekrar
function func_name.

* if iv_num1 eq 0.//0  a eşitse *
if iv_num1 is initial.//eger herhangi bir deger ataması yapılmadıysa
	raise exception_ad. //exception çağırma
endif.

endfunction.


////////////////////////////
fonksiyon modulu kullanmak//
////////////////////////////

se38 ile yenı proje açılır



start_of_selection. //herzaman kullanılması taviye edilir oncesinde degisken atamaları sonrasında deger atamaları vs yapılabilir

REPORT reportName.

DATA: gV_num1 TYPE int4,
	gv_num2 TYPE int4,
	gV_sonuc TYPE int4,
	gv_mes TYPE char20.

START-OF-sELECTION.
gv numl= 20.
gv_num2=5.
gv_mes Mesaj1.

CALL functionName.//sap ekrandan ornek kısmından fonksiyon modulu eklenir
	EXPORTING
		iv_numl = gv_num1. 
		1v_num2 = gv_num2.
	IMPORTING
		ev_sonuc = gv_sonuc.
	CHANGING
		cv_mes = gv_mes.
	EXCEPTIONS
		divided by_zero = 1.
		OTHERS = 2.
	IF sY-subrc EQ 0. //Deger sıfıra eşitse hata yok demektir
		WRITE: / 'sonuç: ',gv_sonuc.
		WRITE: / 'Mesaj: ',gV_mes.
	ELSEIF Sy subre EQ 1
		WRITE: '0 a boulemezsiniz'.
	ENDIF.