@EndUserText.label: 'Approver Comsumption Travel'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZCD_C_R_ORDEN_YC_A 
as projection on ZCD_I_R_ORDEN_YC
{
    key Id,
    Email,
    Firstname,
    Lastname,
    Country,
    Createon,
    Deliverydate,
    Orderstatus,
    Imageurl,
    /* Associations */
    _Items : redirected to composition child ZCD_C_V_ITEMS_YC_A
}
