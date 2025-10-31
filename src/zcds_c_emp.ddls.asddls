@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'C View for EMP H'
@Metadata.ignorePropagatedAnnotations: true

@UI.headerInfo: {
    typeName: 'Employee',
    typeNamePlural: 'Employees',
    title: { value: 'EmpName' },
    description: { value: 'EmpId' }
}



define root view entity ZCDS_C_EMP
  provider contract transactional_query
  as projection on Zcds_I_Emp
{
@UI.facet: [
    {
        id: 'Identification',
        purpose: #STANDARD,
        type: #IDENTIFICATION_REFERENCE,
        label: 'Employee Details',
        targetQualifier: 'EmpIdentification'
    }
]
    @EndUserText.label: 'ID'
       @UI.lineItem: [
  { position: 10, label: 'Idsss' },
  { type:#FOR_ACTION , dataAction: 'ExcelUpload' , label: 'Upload Excel' }]
  @UI.selectionField: [ {
    position: 10 
  } ]
    @UI.identification: [{ position: 10, qualifier: 'EmpIdentification' }]
    key EmpId,
    
    
    
   
    
    

    @EndUserText.label: 'Name'
    @UI.lineItem: [{ position: 20 }]
    @UI.identification: [{ position: 20, qualifier: 'EmpIdentification' }]
    EmpName
}
