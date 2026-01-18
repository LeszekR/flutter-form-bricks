bugdi
String? defaultFormValidListMakerForFieldClassName(String? fieldClassName) {
  switch (fieldClassName) {
    case 'DateField':
      return 'formatterValidatorDefaults.date';
    case 'LowerCaseTextField':
      return 'formatterValidatorDefaults.lowerCase';
  // Extend here:
  // case 'TimeField': return 'formatterValidatorDefaults.time';
  // case 'DateTimeField': return 'formatterValidatorDefaults.dateTime';
  }
  return null;
}
