"Domain nedir: Teknik yapısal ozellikler bulunur
"Data element nedir:Daha anımsal ozellikler bulunur veri tipi vs


"Variable oluşturma

data: gv_per_id type dataElementName,
	gv_per_ad type dataElementName,
	gv_per_soyad type dataElementName,
	gv_per_cins type dataElementName,
	gs_per_t type TableName,"Structure tanımlama(n kolonu referans alır)
	gt_per_t type table of table_name."Tablo tanımlama
	

select * from tableName into table gt_per_t .

"Structure : Tabloların tek bir satırını tutan yapı
"Structure tutmak

select single * from tableName into gs_per_t.


"Tek bir sutunu almak
select single tableKolonAd tableName into kolonGelenVeri.


"Where yapısı
select single * from tableName into gs_per_t where kolonAd EQ deger.

"Structra veri  eklemek
gs_per_t-kolonAd = 3.
gs_per_t-kolonAd = 'furkan'.

"
insert tableName from gs_per_t

"Update ve delte komutu normal sql komutu ile aynıdır.

"Modify komutu o structure içindeki key e sahip bi deger varsa update yapar yoksa insert işlemi yapar
modify tableName from gs_per_t.
	