import 'field_and_validator.dart';

abstract class SingleFormStateData {
  final String formKeyString;
  final List<FieldAndValidator> fieldList;

  const SingleFormStateData(this.formKeyString, this.fieldList);
}
