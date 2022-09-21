/////////TOP///////////
renk degistirmek için kolon tanımlanması yapılmalı aşağıdaki gibi cell color içinse ekstra structre tanımlanması gerekir


TYPES: BEGIN OF gty_list,"global type list"
       chkbox type char1, "Satır seçmini aktif etmek
       EBELN type EBELN, "ebeln 2 tablodada olan colonumuzdur 2 tabloyu bu şekilde birletircez "Satın alma belge no (ekko)
       ebelp type ebelp,  "kalem no (ekpo)
       bstyp type ebstyp, "Belge tipi (Ekko)
       bsart type esart,   "Belge turu (Ekko)
       matnr type matnr,  "Malzeme numarası (Ekpo)
       menge type bstmg,  "Malzeme miktarı (Ekpo)
       meins type meins,  "miktar turu (Ekpo)
       statu type statu,  "siparis durumu (Ekpo)
       line_color type char4,  "SAtir rengi
       cell_color type SLIS_T_SPECIALCOL_ALV,  "hucre rengi cok kapsamlı oldugu için tablo şeklinde tanımlanması gerekir
                                                "cunku bir hucre kolon ve sutunlarda oldugu için hepsini farkli renk yapmak isteyebiliris
  END OF gty_list.

data gs_cell_color TYPE slis_specialcol_alv. "hucre rengi için structre

"Tabloyu oluşturma
DATA: gt_list TYPE TABLE OF gty_list, "tablo oluşturma
      gs_list type gty_list. "structure

"Tablo oluşturulduktan sonra boş olur bizim bunu doldurmamz gerekir


"Field catalog oluşturma
DATA: gt_fieldcalatog TYPE SLIS_T_FIELDCAT_ALV,"field catalog tablomuz
      gs_fieldcalatog TYPE slis_fieldcat_alv. "filed catalog structutre


"Laoyut degiştirirek genel alv nin yapısını degiştirmek

"Layout oluşturmak layouty ozelleştirmek için alv yapsıının structureı kullanılır
DATA gs_layout TYPE SLIS_LAYOUT_ALV.

"Evenets yapısı
data: gt_events type SLIS_T_EVENT, "intern table
      gs_event type slis_alv_event. "structure


//////////////FRM/////////////////
REnklendirme işlemi veri çekme kısmında yapılır ama ilk once layout içinde tanımlama yapmak gereklidir


///Layout kısmı///

FORM SET_LAYOUT .

"Layout uzerinde değişiklik yapmak
GS_LAYOUT-WINDOW_TITLEBAR = 'Reuse alv kullanımı'."Başlık metni değiştirme
GS_LAYOUT-ZEBRA  = 'X'. "tabloya zebra deseni verme
GS_LAYOUT-COLWIDTH_OPTIMIZE = abap_true. "layoutun sutun genişlklerini optimize eder
GS_LAYOUT-BOX_FIELDNAME = 'chkbox'. "degerleri secmek için layout uzerinde belirtmek gerekir
GS_LAYOUT-INFO_FIELDNAME = 'LINE_COLOR'. "satir renklerini degistirmek için gereken layout içinde onuda tanımlamaktır
GS_LAYOUT-COLTAB_FIELDNAME = 'CELL_COLOR'. "hucre renklendirmesi için oluşturduumuz tabloyu ekleriz
"GS_LAYOUT-EDIT = 'X'. "daha onceki edit mode ile aynı fakat bu tablonun geneline editable ozellik katar


ENDFORM.






//VEri çekme kısmı//

FORM GET_DATA .
"Tabloyu doldurma
"Query
"      Tire değil sinus işareti konur   ~        "
  select "kolonları al
    ekko~ebeln
    ekpo~ebelp
    ekko~bstyp
    ekko~bsart
    ekpo~matnr
    ekpo~menge
    ekpo~meins
    ekpo~statu
  from ekko
  INNER JOIN ekpo on ekpo~EBELN eq ekko~EBELN   "iki tabloyu birleştiremk için iki tablodada olan kolonları kuullanırız
  INTO CORRESPONDING FIELDS OF TABLE gt_list. "into table diyerekde eşleşen kolonları doldurur

*"Line color
LOOP AT gt_list INTO GS_LIST. "butun satırların uzerinde gezinir

  IF GS_LIST-EBELP eq '10'. "ebelp satiri 10  aeşitse
    CLEAR gs_cell_color. "structe temizlenir
    GS_CELL_COLOR-FIELDNAME = 'MATNR'. "matnr kolonu renklendirilcek denir
    GS_CELL_COLOR-COLOR-COL = 4. "ana renk
    GS_CELL_COLOR-COLOR-int = 1. "koyuluk
    GS_CELL_COLOR-COLOR-inv = 0. "background mu foregroundmu
    APPEND GS_CELL_COLOR to GS_LIST-CELL_COLOR. "daha sonra ise structure alv structreımıın cell coloruna eklenir

    CLEAR gs_cell_color. "structe temizlenir
    GS_CELL_COLOR-FIELDNAME = 'BSART'. "matnr kolonu renklendirilcek denir
    GS_CELL_COLOR-COLOR-COL = 7. "ana renk
    GS_CELL_COLOR-COLOR-int = 1. "koyuluk
    GS_CELL_COLOR-COLOR-inv = 0. "background mu foregroundmu
    APPEND GS_CELL_COLOR to GS_LIST-CELL_COLOR. "daha sonra ise structure alv structreımıın cell coloruna eklenir
  ENDIF.
  MODIFY Gt_LIST FROM GS_LIST. "tabloyu öodogie et deriz


*  IF GS_LIST-EBELP eq '10'.
*       GS_LIST-LINE_COLOR = 'C410'. "renkelerine degerler atar
*  ELSEIF GS_LIST-EBELP eq '20'.
*        GS_LIST-LINE_COLOR = 'C510'.
*  ENDIF.
*
*  MODIFY Gt_LIST FROM GS_LIST. "modifiye et gt_list in gs list_lestlerini yani tablonun kolonlarını8
ENDLOOP.
"Color degerleri
  "Herzaman C ile başlar
  "0-beyaz 1-Mavi 2-gri 3-sari 4-turkuaz 5-yeşil 6-Kırmızı 7-turuncu / İkinci karakter renk secer
  "0 - 1 Koyuluk degeri / Üçüncü Karakter
  "0 - 1 Backgroun veya foreground renk ayarı 0 arkplan 1 yazı /4. karakter
  "ornek c500 acik yeşil
ENDFORM.
