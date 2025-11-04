import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';

class FormFieldData<T> {
  T? initialValue;
  T? value;
  bool validating = false; // if async validator running
  String? errorMessage;

  FormFieldData([T? initialValue]) : value = initialValue;

  bool get valid => errorMessage == null; // result of last validation
  bool get touched => value != initialValue;
}
