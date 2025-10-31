@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for EMP H'
@Metadata.ignorePropagatedAnnotations: true
define root view entity Zcds_I_Emp as select from ztab_emp
//composition of target_data_source_name as _association_name
{
    key emp_id as EmpId,
    emp_name as EmpName
  //  _association_name // Make association public
}
