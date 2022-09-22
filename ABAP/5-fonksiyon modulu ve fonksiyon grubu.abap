"Fonksiyon modulu nedir: Belli bir amaca hizmet eden yapıyı, bir alanda toplayip istenildigi zaman erişilen yapı

"Fonksiyon grubu nedir: fonksiyonların grulayıp bir başlık altnda toplanması

"fonksiyon grubu oluşturmak için se80 t-kodu ile function grup oluşturulup ad verilip active edilir

"Fonksiyon modulu oluşturmak:
"se37 : fonksiyon modulu oluşturma t-kodu
"fonksiyon adı verilir
"create ile oluşturulur
"tanım ve fonksiyon grubu degerleri verilir

"modulu tanımak
"arrtibutes : ozellikler
"import : fonksiyona verilcek parametreler
"export : fonksiyonun bize return edecegi parametreler
"changing: bir deger alıp o degeri değiştirip veren yapılar
"tables: fonksiona verilcek tablolar
"exceptions: hata alınan veya ongorulen durumları 
"source code: fonksiyonun ne yapcagını gircegimiz alan

"ORNEK Fonksiyon
"iki input al int bir birine bol ve return et

"1-import kısmından parametreler verilir 
"iv_num1	type int4   -> import kısmına sırasıyla yapılır
"iv_num2	type int4   -> import kısmına sırasıyla yapılır

"2- Export kısmı
ev_result type int4 ->export kısmına aynı şekilde yapılır

"3-changing
cv_mes type char20 -> mesaj eklemek için ekledik 

"4-soruce code kısmına gelinir

Function func_name.

	ev_result = iv_num1 / iv_num2.

endfunction.

"pass by value alanları kapalıysa fonksiyon parametrelerinin = gelen degeri fonk içinde degişmesine izin vermez 

"optional = eklenmesi zorunlu olmayan parametre

"Eger exception kullanmak istersek
"exception kısmına hata adı girilir ve açıklamasaı yazılır

"soruce code kısmına gelinir tekrar
function func_name.

* if iv_num1 eq 0."0 a eşitse *
if iv_num1 is initial."eger herhangi bir deger ataması yapılmadıysa
	raise exception_ad. "exception çağırma
endif.

endfunction.



"fonksiyon modulu kullanmak

"start_of_selection. "herzaman kullanılması taviye edilir oncesinde degisken atamaları sonrasında deger atamaları vs yapılabilir

REPORT reportName.

DATA: gv_num1 TYPE int4,
	gv_num2 TYPE int4,
	gv_sonuc TYPE int4,
	gv_mes TYPE char20.

START-OF-SELECTION.
gv numl= 20.
gv_num2=5.
gv_mes Mesaj1.

CALL functionName."sap ekrandan ornek(pattern) kısmından fonksiyon modulu adı eklenir ve 
		  "ok denir fonksiyon parametreleri ve exceptionlar otomatik doldurulması için gelir
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
	IF sY-subrc EQ 0. "Deger sıfıra eşitse hata yok demektir
		WRITE: / 'sonuç: ',gv_sonuc.
		WRITE: / 'Mesaj: ',gV_mes.
	ELSEIF Sy subre EQ 1
		WRITE: '0 a bolemezsiniz'.
	ENDIF.