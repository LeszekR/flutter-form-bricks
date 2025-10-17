import 'field_and_validator.dart';

abstract class SingleFormState {
  final String formKeyString;
  final List<FieldAndValidator> fieldList;

  const SingleFormState(this.formKeyString, this.fieldList);
}
