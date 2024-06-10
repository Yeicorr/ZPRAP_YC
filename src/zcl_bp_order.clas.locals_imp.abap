CLASS lhc_Order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Order RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Order RESULT result.

    METHODS acceptOrder FOR MODIFY
      IMPORTING keys FOR ACTION Order~acceptOrder RESULT result.

    METHODS createOrder FOR MODIFY
      IMPORTING keys FOR ACTION Order~createOrder RESULT result.

    METHODS refuseOrder FOR MODIFY
      IMPORTING keys FOR ACTION Order~refuseOrder RESULT result.

    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Order~validateStatus.

ENDCLASS.

CLASS lhc_Order IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITY zcd_i_r_orden_yc
  FROM VALUE #( FOR keyval IN keys ( %key = keyval-%key ) )
  RESULT DATA(lt_Order_result).
    result = VALUE #( FOR ls_Order IN lt_Order_result (
    %key = ls_Order-%key
    %field-Id = if_abap_behv=>fc-f-read_only
    %features-%action-refuseOrder = COND #( WHEN ls_Order-Orderstatus = 3
    THEN if_abap_behv=>fc-o-disabled
    ELSE if_abap_behv=>fc-o-enabled )
    %features-%action-acceptOrder = COND #( WHEN ls_Order-Orderstatus = 2
    THEN if_abap_behv=>fc-o-disabled
    ELSE if_abap_behv=>fc-o-enabled ) ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD acceptOrder.
    MODIFY ENTITIES OF zcd_i_r_orden_yc IN LOCAL MODE
    ENTITY Order
    UPDATE FIELDS ( Orderstatus )
    WITH VALUE #( FOR key IN keys ( id = key-Id
    Orderstatus = 2 ) ) " Accepted
    FAILED failed
    REPORTED reported.
    READ ENTITIES OF zcd_i_r_orden_yc IN LOCAL MODE
 ENTITY Order
 FIELDS ( Country
          Createon
          Deliverydate
          Email
          Firstname
          Lastname
          Imageurl
          Orderstatus )
  WITH VALUE #( FOR key IN keys ( Id = key-Id ) )
  RESULT DATA(lt_order).
    result = VALUE #( FOR Order IN lt_order ( Id = Order-Id
    %param = Order ) ).
  ENDMETHOD.

  METHOD createOrder.
    READ ENTITY zcd_i_r_orden_yc
  FIELDS ( Id
           email
           firstname
           lastname
           country
           deliverydate
          )
  WITH VALUE #( FOR Order IN keys ( %key = order-%key ) )
  RESULT DATA(lt_read_result)
  FAILED failed
  REPORTED reported.

    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).
    DATA lt_create TYPE TABLE FOR CREATE zcd_i_r_orden_yc\\Order.
    lt_create = VALUE #( FOR row IN lt_read_result INDEX INTO idx
    ( id = row-id
      email = row-email
      firstname = row-firstname
      lastname = row-Lastname
      country = row-Country
      deliverydate = row-deliverydate
      Createon = lv_today
      Orderstatus = 1 ) ).

    MODIFY ENTITIES OF zcd_i_r_orden_yc
    IN LOCAL MODE ENTITY Order
    CREATE FIELDS ( id
          email
          firstname
          lastname
          country
          deliverydate
          Createon
          Orderstatus )
    WITH lt_create
    MAPPED mapped
    FAILED failed
    REPORTED reported.
    result = VALUE #( FOR create IN lt_create INDEX INTO idx
    ( %cid_ref = keys[ idx ]-%cid_ref
      %key = keys[ idx ]-Id
      %param = CORRESPONDING #( create ) ) ).
  ENDMETHOD.

  METHOD refuseOrder.
    MODIFY ENTITIES OF zcd_i_r_orden_yc IN LOCAL MODE
   ENTITY Order
   UPDATE FROM VALUE #( FOR key IN keys ( Id = key-Id
   Orderstatus = 3 " Canceled
   %control-Orderstatus = if_abap_behv=>mk-on ) )
   FAILED failed
   REPORTED reported.
    READ ENTITIES OF zcd_i_r_orden_yc IN LOCAL MODE
    ENTITY Order
    FIELDS (  Country
              Createon
              Deliverydate
              Email
              Firstname
              Lastname
              Imageurl
              Orderstatus )
    WITH VALUE #( FOR key IN keys ( Id = key-Id ) )
    RESULT DATA(lt_Order).
    result = VALUE #( FOR Order IN lt_Order ( Id = Order-Id
    %param = Order ) ).
  ENDMETHOD.

  METHOD validateStatus.
  ENDMETHOD.

ENDCLASS.
