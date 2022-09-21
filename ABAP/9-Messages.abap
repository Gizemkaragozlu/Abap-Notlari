//Message 

Messages 'bu bir mesaj' type 's'. //success sol altta gosterir
Messages 'bu bir mesaj' type 'ı'. //info popup ile gosterir
Messages 'bu bir mesaj' type 'w' //warning sol altta uyarı verir program akışını durdurur
Messages 'bu bir mesaj' type 'e' //error sol altta hata verir program akışını durdurur
Messages 'bu bir mesaj' type 'a' //abent popup ile hata tarzında program akışını durdurur ve ana ekrana gonderir
Messages 'bu bir mesaj' type 'x' //exit dump ekranı verir program akışını durdurur ve ana ekrana gonderir



// Message view 

Messages 'bu bir mesaj' type 's' display like 'ı'. //message aynı şekilde verilir sadece ikon değişir



//TextSembol ekleme

Go->text-symbol //kısmından eklenir

symbol kısmından id verilir ve metin ifadesi eklenir

//Kullanımı

Message text-id type 'ı'. //verilen id ye ait metin info olarak verilir


//Message class oluşturma ve kullanma
SE91 ile message class oluşturulabilir

//Kullanımı
Message messageType MessageClassId(messageClassName).
message i000(msg).


//MessgeClassName vermeden kullanmak istersek

uygulama başındaki
Report uygAdı message-id MsgClassName. //şeklinde eklenmelidir

//Kullanımı
message i000. //sadece id verip kullanabilirz


//Message class dinamik yapma istenilen veri ile doldurma

Message class kısmında message text oluşturulrken & işareti koyarsak bu kısma bizden gelen deger yazılcak anlamına gelir

//kullanımı

message i000 with 'parametre'.//artık parametre degerimiz direk olarak message text içine yazılcak


//Birden cok dinamik deger alan message class kullanmak

1-Class texti oluşturulrken istenn kısımlara & işareti konulur

//kullanımı
message i000 with 'ilk' 'ikinci'. //sırasıyla degerler text içine girilir. 


