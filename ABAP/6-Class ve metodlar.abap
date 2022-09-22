"SE24 : class ya da interface olu�turma t-kodu

"class i�inde methods k�sm� bize funcmodul anlam�na gelir
"methods k�sm�ndan methodlar olu�turulur parametreleri vs her�eyi ayn� panel uzerinden verip degistirebilriiz

"Olu�turulan class kullanma

Data: gv_class type ref to className.//class� referans alan degisken 


start-of-selection.
	create object gv_class. "Degiskeni class�n tipine referans veridigmiz i�in create object diyerek 
				"obje olu�trulur ve i�lemler bunun i�inden yap�l�r
	
	gv_class->class_i�indeki_fonksiyonlar( ) ."ctrl + space yap�l�nca kod tamamlan�r


"Eger metodumuz static ise class� olu�turmadan ve create etmeden sadece className=>static_fonk �eklinde eri�ebiliriz

"types alan� ile de classlar i�in de�i�ken tipi olu�turudugumuz alan
"attributes: class i�in de�i�ken olu�turma alan�d�r
"friends alan�:ba�ka bi alan�n fonksiynunu kullanabilcegimiz alan
"hangi class�n fonksiynunu ba�ka classta kullancaksak o class�n ad�n� friends alan�na yazmam�z gerekir
"tekrardan fonk olu�turur ve parametrelerini verirz ama source code k�sm�nda diger class�n kodunu cag�rarak kendi parametrelerimiiz vereririz

"events:parametreler tan�mlay�p source code yazmadan methods k�sm�nda kullanmam�z� saglar
"eventsi kullanamk i�in methods k�sm�nda tekrardan method olu�turup goto_properties k�sm�ndan event handler for k�sm�ndan hangi class�n hangi eventi "kullancaksa o yaz�l�r

"aliases: interfacein fonksiyon adlar�n� k�saltarak programda kullanmama�z� saglayan yap�

