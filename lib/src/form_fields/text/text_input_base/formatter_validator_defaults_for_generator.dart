String? defaultFormValidListMakerForFieldClassName(String? fieldClassName) {
  switch (fieldClassName) {
    case 'DateField':
      return 'formatterValidatorDefaults.date';
    case 'LowerCaseTextField':
      return 'formatterValidatorDefaults.lowerCase';
  }
  return null;
}
