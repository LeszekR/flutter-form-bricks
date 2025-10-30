import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/form_manager/form_manager_OLD.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_status.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SingleFormManager extends FormManagerOLD {
  @override
  void fillInitialInputValuesMap() {
    setInitialValues(formKey);
  }

  @override
  void afterFieldChanged() {
    // no op
  }

  @override
  FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>? findField(String keyString) {
    // TODO refactor to FlutterFormBuilder pattern - ?
    return formKey.currentState?.fields[keyString];
  }

  @override
  FormStatus checkStatus() {
    return getFormPartState(formKey);
  }

  @override
  void resetForm() {
    // TODO refactor to FlutterFormBuilder pattern - ?
    // formKey.currentState?.reset();
    // formKey.currentState?.validate();
  }

  @override
  Map<String, dynamic> collectInputs() {
    // TODO refactor to FlutterFormBuilder pattern - ?
    return {};
    // return formKey.currentState!.value;
  }
}
