"SE24 : class ya da interface oluþturma t-kodu

"class içinde methods kýsmý bize funcmodul anlamýna gelir
"methods kýsmýndan methodlar oluþturulur parametreleri vs herþeyi ayný panel uzerinden verip degistirebilriiz

"Oluþturulan class kullanma

Data: gv_class type ref to className.//classý referans alan degisken 


start-of-selection.
	create object gv_class. "Degiskeni classýn tipine referans veridigmiz için create object diyerek 
				"obje oluþtrulur ve iþlemler bunun içinden yapýlýr
	
	gv_class->class_içindeki_fonksiyonlar( ) ."ctrl + space yapýlýnca kod tamamlanýr


"Eger metodumuz static ise classý oluþturmadan ve create etmeden sadece className=>static_fonk þeklinde eriþebiliriz

"types alaný ile de classlar için deðiþken tipi oluþturudugumuz alan
"attributes: class için deðiþken oluþturma alanýdýr
"friends alaný:baþka bi alanýn fonksiynunu kullanabilcegimiz alan
"hangi classýn fonksiynunu baþka classta kullancaksak o classýn adýný friends alanýna yazmamýz gerekir
"tekrardan fonk oluþturur ve parametrelerini verirz ama source code kýsmýnda diger classýn kodunu cagýrarak kendi parametrelerimiiz vereririz

"events:parametreler tanýmlayýp source code yazmadan methods kýsmýnda kullanmamýzý saglar
"eventsi kullanamk için methods kýsmýnda tekrardan method oluþturup goto_properties kýsmýndan event handler for kýsmýndan hangi classýn hangi eventi "kullancaksa o yazýlýr

"aliases: interfacein fonksiyon adlarýný kýsaltarak programda kullanmamaýzý saglayan yapý

