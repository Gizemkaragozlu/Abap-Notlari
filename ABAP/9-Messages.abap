"Message "Program içinde belirli veya istege baglı durumlarda bildirim vermesine olanak saglar

Messages 'bu bir mesaj' type 's'. "success sol altta gosterir ve başarıyı temsil eder
Messages 'bu bir mesaj' type 'ı'. "info popup ile gosterilir ve bilgiyi temsil eder
Messages 'bu bir mesaj' type 'w' "warning sol altta gosterilir ve uyarıyı temsil eder, program akışını durdurur 
Messages 'bu bir mesaj' type 'e' "error sol altta gosterilir ve hatayı temsil eder program akışını durdurur
Messages 'bu bir mesaj' type 'a' "abent popup ile hata tarzında program akışını durdurur ve ana ekrana gonderir
Messages 'bu bir mesaj' type 'x' "exit dump ekranı verir program akışını durdurur ve ana ekrana gonderir



" Message view Gorunumu aynı işlevi farklı messaj

Messages 'bu bir mesaj' type 's' display like 'ı'. 
"sol altta mesaj verir ama bilgiyi temsil eder



"TextSembol ekleme

Go->text-symbol "kısmından eklenir

symbol kısmından id verilir ve metin ifadesi eklenir

"Kullanımı

Message text-id type 'ı'. "verilen id ye ait metin info olarak verilir


"Message class oluşturma ve kullanma
SE91 ile message class oluşturulabilir

"Kullanımı
Message messageType MessageClassId(messageClassName).
message i000(msg).


"MessgeClassName vermeden kullanmak istersek

Report uygAdı message-id MsgClassName. //şeklinde eklenmelidir

"Kullanımı
message i000. //sadece id verip kullanabilirz


"Message class dinamik yapma istenilen veri ile doldurma

Message class kısmında message text oluşturulrken & işareti koyarsak bu kısma bizden gelen deger yazılcak anlamına gelir

"kullanımı

message i000 with 'parametre'."artık parametre degerimiz direk olarak message text içine yazılcak


"Birden cok dinamik deger alan message class kullanmak

1-Class texti oluşturulrken istenn kısımlara & işareti konulur

"kullanımı
message i000 with 'ilk' 'ikinci'. //sırasıyla degerler text içine girilir. 


