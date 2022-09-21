report ZFC_BATCH_DENEME
       no standard page heading line-size 255.
include bdcrecx1_s.

parameters: dataset(132) lower case.
data: begin of record,
* data element:
        P_ID_001(003),
* data element:
        P_NAME_002(020),
* data element:
        P_CODE_003(005),
* data element:
        P_URL_004(255),
      end of record.


start-of-selection.

perform open_dataset using dataset.
perform open_group.

do.

read dataset dataset into record.
if sy-subrc <> 0. exit. endif.

perform bdc_dynpro      using 'ZFC_BATCH_INPUT' '1000'.
perform bdc_field       using 'BDC_CURSOR'
                              'P_URL'.
perform bdc_field       using 'BDC_OKCODE'
                              '=PB1'.
perform bdc_field       using 'P_ID'
                              record-P_ID_001.
perform bdc_field       using 'P_NAME'
                              record-P_NAME_002.
perform bdc_field       using 'P_CODE'
                              record-P_CODE_003.
perform bdc_field       using 'P_URL'
                              record-P_URL_004.
perform bdc_transaction using 'ZFCB'.

enddo.

perform close_group.
perform close_dataset using dataset.