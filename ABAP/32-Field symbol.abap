field symbol structe veya herhangi bi veri uzerinde değiştiridimiz veriyi anında assign etmemizi saglar

ornek bi tablo içinden bi veri değiştircez
bunu loopa alıyoruz. 

loop at gt_table into gs_table.

gs_tablın istenen degerine if ile geldigimizde 
structreın herhangi bi veirisni degiştigimizde tabloyu modify etmeden de direk tablomuzun etkilenmesin saglar

endloop.



ornk2:


merhaba size şu an anlatacağım konuyu tam olarak anlayabilirseniz standart programlardaki değişken değerlerini bile repair yapmadan değiştirebilirsiniz. şimdi zdeneme diye bir rapor oluşturalım. bu raporda lv_name adında local bir değişken tanımlayalım ve bu değişkeni bir fonksiyona export edip, fonksiyondan dönen değer ile birlikte ekrana yazdıralım. normal şartlarda export ettiğimiz değişkenin değerinin değişmemesi gerekiyor. ama bunu field symbol kullanarak değiştirebiliriz. aşağıdaki fonksiyonda fonksiyonu çağıran programın içindeki değişkene bellekten erişip değerini değiştiriyoruz.

sonuç olarak lv_name = ‘Serkan’ yazması gerekirken bu değişkenin değerini fonksiyon içerisinde değiştirdiğimiz için lv_name = ‘Ozcan’ olmuştur. lv_name2 = ‘test Serkan’ olarak belirlenmiştir.

*&---------------------------------------------------------------------*
*& Report zdeneme
*&
*&---------------------------------------------------------------------*
 
REPORT zdeneme.
 
DATA: lv_name TYPE text255,
lv_name2 TYPE text255.
 
lv_name = 'Serkan'.
 
CALL FUNCTION 'ZDENEMEFONKSIYON'
EXPORTING
ip_name = lv_name
IMPORTING
EP_NAME = lv_name2.
 
WRITE / lv_name.
WRITE / lv_name2.
FUNCTION zdenemefonksiyon.
*"----------------------------------------------------------------------
*"*"Local Interface:
*" IMPORTING
*" REFERENCE(IP_NAME) TYPE TEXT255
*" EXPORTING
*" REFERENCE(EP_NAME) TYPE TEXT255
*"----------------------------------------------------------------------
 
CONCATENATE 'test' ip_name INTO ep_name
SEPARATED BY SPACE.
 
FIELD-SYMBOLS: <fs> TYPE text255.
DATA: lv_field(30).
 
lv_field = '(ZDENEME)LV_NAME'.
ASSIGN (lv_field) TO <fs>.
IF <fs> İS ASSIGNED.
<fs> = 'Ozcan'.
ENDIF.
 
ENDFUNCTION.