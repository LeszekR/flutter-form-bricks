import '../../../shelf.dart';
import 'field_and_validator.dart';

abstract class TabbedFormState {
  final String formKeyString;
  final List<SingleFormState> tabsList;
  final List<FieldAndValidator>? fieldList;

  const TabbedFormState({required this.formKeyString, required this.tabsList, this.fieldList});
}
