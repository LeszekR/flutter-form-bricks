import 'package:flutter_form_builder/src/form_builder_field.dart';

import '../form_manager/form_manager.dart';
import '../form_manager/form_state.dart';

class StandaloneFormManagerOLD extends FormManagerOLD {
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
    return formKey.currentState?.fields[keyString];
  }

  @override
  FormStatus checkState() {
    return getFormPartState(formKey);
  }

  @override
  void resetForm() {
    formKey.currentState?.reset();
    formKey.currentState?.validate();
  }

  @override
  Map<String, dynamic> collectInputs() {
    return formKey.currentState!.value;
  }
}
