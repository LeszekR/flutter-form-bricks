import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_status.dart';
import 'package:flutter_form_bricks/src/inputs/base/form_field_brick.dart';

class SingleFormManager extends FormManager {
  SingleFormManager(super.stateData, super.formSchema);

  @override
  void fillInitialInputValuesMap() {
    setInitialValues(formKey);
  }

  @override
  void afterFieldChanged() {
    // no op
  }

  @override
  FormFieldStateBrick<FormFieldBrick>? findField(String keyString) {
    // TODO refactor to FlutterFormBuilder pattern - ?
    // return formKey.currentState?.fields[keyString];
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
