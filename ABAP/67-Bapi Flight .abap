*&---------------------------------------------------------------------*
*& Report ZFC_BAPI_FLIGHT_GET_DETAIL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_BAPI_FLIGHT_GET_DETAIL.

class flight DEFINITION. "Class Tanımlama
  PUBLIC SECTION. "Public alan
    METHODS get_data IMPORTING air_id type BAPISFLKEY-AIRLINEID "Birtane methodumuz var ve 3 tane parametre alıyor
                               air_conn type BAPISFLKEY-CONNECTID
                               air_date type BAPISFLKEY-FLIGHTDATE.

  PRIVATE SECTION. "Private alan
    data: lt_fldata type BAPISFLDAT ,"Gelen verileri tutan tablo
          lt_return type STANDARD TABLE OF BAPIRET2. "Donen deger hakkında bilgi işlem başarılımı vs mesajları tutar

ENDCLASS.



CLASS flight IMPLEMENTATION. "Classin içi methodaları doldurmak diyebiliriz
  METHOD: get_data. "Get data methodumuzu dolduruyoruz
   call function 'BAPI_FLIGHT_GETDETAIL' "Bapi fonksiyonunu cagirirz
      exporting
        airlineid             = air_id "Bu method çağırılıdıgında bize 3 parametre gelcek diye 
        connectionid          = air_conn"tanımlama yapmıştık o parametreleri buraya tanımlıyoruz
        flightdate            = air_date
     IMPORTING
       FLIGHT_DATA           = lt_fldata "İşlemin sonucunda bize donen veriyi tutan tablomuzu çıkış olarak belirledik
     TABLES
       RETURN                = lt_return "İşlemin hatalarını mesajlarını tanımmladıgımız tabloda buraya
              .
   "işlemlerden sonra ekrana basma işlemi yapıyoruz
write: / 'Airline id:' , lt_fldata-airlineid , ' Connection id:' , lt_fldata-connectid , ' Flight Date', lt_fldata-flightdate.
ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001. "Parametreleri istiyoruz
PARAMETERS :p_id type BAPISFLKEY-AIRLINEID,
            p_conn type BAPISFLKEY-CONNECTID,
            p_date type BAPISFLKEY-FLIGHTDATE.
SELECTION-SCREEN END OF BLOCK b1.

data lo_flight TYPE REF TO flight. "Oluşturdugumuz class tipindeki objemiz
CREATE OBJECT lo_flight. "Objeyi yaratırız  / başlatırız

lo_flight->get_data(  "Obje içindeki methodu çalıştırırz
  exporting
    air_id   =  p_id "Ve istenen parametreleri methoda veririz
    air_conn = p_conn
    air_date =  p_date
).