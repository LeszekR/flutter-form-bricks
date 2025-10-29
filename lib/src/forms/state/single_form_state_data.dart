import 'package:flutter_form_bricks/shelf.dart';

import 'field_and_validator.dart';

abstract class SingleFormStateData extends FormStateData{
  final String formKeyString;
  final List<FieldAndValidator> fieldAndValidatorList;

  const SingleFormStateData(this.formKeyString, this.fieldAndValidatorList);
}
