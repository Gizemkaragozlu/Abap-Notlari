*&---------------------------------------------------------------------*
*& Report ZFC_BAPI_GET_USER_DETAIL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFC_BAPI_GET_USER_DETAIL.

"Bu rapor bapi fonksiyonu ile sistemdeki kullanıcıya ait bilgileri almamızı saglar 

data: lv_username type BAPIBNAME-BAPIBNAME, "Bapiye vercegimiz kullancıı adını bapinin istedigi tipte oluştururz
      "Bapiden doncek degerler
      ls_logon type BAPILOGOND ,"Logon detayları 
      ls_adres type BAPIADDR3 , "User adresi
      ls_comp type BAPIUSCOMP,  "User şirketi
      lt_return type BAPIRET2 occurs 0 WITH HEADER LINE."Ve işlemler sonucunda hta veya mesajları tutcak tablo

lv_username = 'FCOSGUN'. "Kullanıcı adını atama işlemi yaparız

call function 'BAPI_USER_GET_DETAIL' "Bapi fonksyonu cagrilir 
  exporting
    username             = lv_username "Kullanıcı  adı fonksiona verilir
*   CACHE_RESULTS        = 'X'
 IMPORTING"Donen degerleri istedigimizi alabilirz
   LOGONDATA            = ls_logon 
*   DEFAULTS             =
   ADDRESS              = ls_adres
   COMPANY              = ls_comp
*   SNC                  =
*   REF_USER             =
*   ALIAS                =
*   UCLASS               =
*   LASTMODIFIED         =
*   ISLOCKED             =
*   IDENTITY             =
*   ADMINDATA            =
*   DESCRIPTION          =
  tables
*   PARAMETER            =
*   PROFILES             =
*   ACTIVITYGROUPS       =
    return               = lt_return
*   ADDTEL               =
*   ADDFAX               =
*   ADDTTX               =
*   ADDTLX               =
*   ADDSMTP              =
*   ADDRML               =
*   ADDX400              =
*   ADDRFC               =
*   ADDPRT               =
*   ADDSSF               =
*   ADDURI               =
*   ADDPAG               =
*   ADDCOMREM            =
*   PARAMETER1           =
*   GROUPS               =
*   UCLASSSYS            =
*   EXTIDHEAD            =
*   EXTIDPART            =
*   SYSTEMS              =
          .

BREAK-POINT.