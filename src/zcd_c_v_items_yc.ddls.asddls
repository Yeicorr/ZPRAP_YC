@EndUserText.label: 'Projection View Items'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZCD_C_V_ITEMS_YC 
as projection on ZCD_I_V_ITEMS_YC
{
    key Id,
    key Id_item,
    Name,
    Description,
    Releasedate,
    Discontinueddate,
    Price,
    Height,
    Width,
    Depth,
    Quantity,
    Unitofmeasure,
    /* Associations */
    _Orden : redirected to parent ZCD_C_R_ORDEN_YC
}
