import 'package:flutter_form_bricks/src/form_fields/base/form_field_descriptor.dart';

import 'single_form_state_data.dart';

abstract class TabbedFormStateData {
  final String formKeyString;
  final List<SingleFormStateData> tabsList;
  final List<FormFieldDescriptor>? fieldList;

  const TabbedFormStateData({required this.formKeyString, required this.tabsList, this.fieldList});
}
