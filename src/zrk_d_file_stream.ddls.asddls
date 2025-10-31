@EndUserText.label: 'Abs. Entity For Attachment'
define root abstract entity ZRK_D_FILE_STREAM
{
  @Semantics.largeObject.mimeType: 'MimeType'
  @Semantics.largeObject.fileName: 'FileName'
  @Semantics.largeObject.contentDispositionPreference: #INLINE
  @EndUserText.label: 'Select Excel file'
  StreamProperty : abap.rawstring(0);
  
  @UI.hidden: true
  MimeType : abap.char(128);
  
  @UI.hidden: true
  FileName : abap.char(128);   
}
