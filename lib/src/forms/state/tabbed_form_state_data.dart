import 'field_and_validator.dart';
import 'single_form_state_data.dart';

abstract class TabbedFormStateData {
  final String formKeyString;
  final List<StandaloneFormStateData> tabsList;
  final List<FieldAndValidator>? fieldList;

  const TabbedFormStateData({required this.formKeyString, required this.tabsList, this.fieldList});
}
