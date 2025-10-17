import 'package:flutter_form_bricks/imported_classes_from_tms/state/single_form_state.dart';

import 'field_and_validator.dart';

abstract class TabbedFormState {
  final String formKeyString;
  final List<SingleFormState> tabsList;
  final List<FieldAndValidator>? fieldList;

  const TabbedFormState({required this.formKeyString, required this.tabsList, this.fieldList});
}
