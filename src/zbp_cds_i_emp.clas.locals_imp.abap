CLASS lhc_Zcds_I_Emp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Zcds_I_Emp RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Zcds_I_Emp RESULT result.
    METHODS ExcelUpload FOR MODIFY
      IMPORTING keys FOR ACTION Zcds_I_Emp~ExcelUpload.
*    METHODS ExcelUpload FOR MODIFY
*      IMPORTING keys FOR ACTION Zcds_I_Emp~ExcelUpload.

ENDCLASS.

CLASS lhc_Zcds_I_Emp IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD ExcelUpload.
    TYPES : BEGIN OF ty_sheet_data,
              id                  TYPE ztab_emp-emp_id,
              title               TYPE ztab_emp-emp_name,

            END OF ty_sheet_data.

    DATA lv_file_content   TYPE xstring.
    DATA lt_sheet_data     TYPE STANDARD TABLE OF ty_sheet_data.
    DATA lt_listing_create TYPE TABLE FOR CREATE ZCDS_I_EMP.

    lv_file_content = VALUE #( keys[ 1 ]-%param-_streamproperties-StreamProperty OPTIONAL ).

    " Error handling in case file content is initial

    DATA(lo_document) = xco_cp_xlsx=>document->for_file_content( lv_file_content )->read_access( ).

    DATA(lo_worksheet) = lo_document->get_workbook( )->worksheet->at_position( 1 ).

    DATA(o_sel_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to(
      )->from_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )  " Start reading from Column A
      )->to_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'B' )   " End reading at Column N
      )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 2 )    " *** Start reading from ROW 2 to skip the header ***
      )->get_pattern( ).

    lo_worksheet->select( o_sel_pattern
                                     )->row_stream(
                                     )->operation->write_to( REF #( lt_sheet_data )
                                     )->set_value_transformation(
                                         xco_cp_xlsx_read_access=>value_transformation->string_value
                                     )->execute( ).

*    lt_listing_create = CORRESPONDING #( lt_sheet_data  ).
lt_listing_create = CORRESPONDING #(
  lt_sheet_data
  MAPPING EmpId   = id
          EmpName = title
).
    MODIFY ENTITIES OF ZCDS_I_EMP IN LOCAL MODE
           ENTITY Zcds_I_Emp
           CREATE AUTO FILL CID FIELDS ( EmpId EmpName )
           WITH lt_listing_create
           " TODO: variable is assigned but never used (ABAP cleaner)
           MAPPED DATA(lt_mapped)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(lt_reported)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED DATA(lt_failed).


    " Communicate the messages to UI - not in scope of this demo
    IF lt_failed IS INITIAL.
      APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                    text     = 'Listings have been uploaded - please refresh the list!!' ) )
             TO reported-zcds_i_emp.
    ENDIF.
***** Change Standard Behaviour Definition -> i_salesordertp

*    MODIFY ENTITIES OF i_salesordertp "IN LOCAL MODE
*  ENTITY salesorder
*    CREATE
*      FIELDS ( salesordertype
*               salesorganization
*               distributionchannel
*               organizationdivision
*               soldtoparty  )
*      WITH VALUE #( ( %cid     = 'H001'
*                      %data    = VALUE #( salesordertype          = 'TA'
*                                          salesorganization       = '1810'
*                                          distributionchannel     = '10'
*                                          organizationdivision    = '00'
*                                          soldtoparty             = '0018100001' ) ) )
*   MAPPED   DATA(ls_mapped)
*   FAILED   DATA(ls_failed)
*   REPORTED DATA(ls_reported_modify).
*
*   DATA: ls_so_temp_key TYPE STRUCTURE FOR KEY OF i_salesordertp.
*
**COMMIT ENTITIES BEGIN
**  RESPONSE OF i_salesordertp
**    FAILED   DATA(ls_save_failed)
**    REPORTED DATA(ls_save_reported).
**
**CONVERT KEY OF i_salesordertp FROM ls_so_temp_key TO DATA(ls_so_final_key).
**
**COMMIT ENTITIES END.

  ENDMETHOD.

ENDCLASS.
