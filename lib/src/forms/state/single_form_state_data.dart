import 'field_and_validator.dart';

abstract class StandaloneFormStateData {
  final String formKeyString;
  final List<FieldAndValidator> fieldList;

  const StandaloneFormStateData(this.formKeyString, this.fieldList);
}
