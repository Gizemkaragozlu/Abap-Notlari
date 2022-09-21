SE11 Tcode
Tablo Domain oluşturma

Domain nedir: Teknik yapısal ozellikler bulunur
Data element nedir:Daha anımsal ozellikler bulunur veri tipi vs

SE16N Tabloları goruntulemeye ve editlemeye yarar

https://www.youtube.com/watch?v=ctNj0wZ2yMk&list=PLP6TjrWzAOA1WW9H35YiBQN2z4pVGK4wi&index=14

/////////////////////////
Variable oluşturma

data: gv_per_id type dataElementName,
	gv_per_ad type dataElementName,
	gv_per_soyad type dataElementName,
	gv_per_cins type dataElementName,
	gs_per_t type TableName, //Structure tanımlama(4 kolonu referans verir)
	gt_per_t type table of table_name.//Tablo tanımlama
	
//Select sorgusu
//Table verisi çekmek
select * from tableName into table gt_per_t //Table variable name

//Structure : Tabloların tek bir satırını tutan yapı
//Structure tutmak
select single * from tableName into gs_per_t.
//Tek bir sutunu almak
select single tableKOlon tableName into kolonaGelenGV
//Where yapısı
select single * from tableName into gs_per_t where kolonAd EQ deger.

//Structure Verisi doldurma
gs_per_t-kolonAd = 3.
gs_per_t-kolonAd = 'fyrkan'.

//Insert Komutu
insert tableName from gs_per_t

//Update ve delte komutu normal sql komutu ile aynıdır.

//Modify komutu o structure içindeki key e sahip bi deger varsa update yapar yoksa insert işlemi yapar
modify tableName from gs_per_t.
	