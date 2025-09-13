import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/ui/forms/form_manager/e_form_status.dart';
import 'package:flutter_form_builder/src/form_builder_field.dart';

class EmptyFormManager extends FormManager {
  @override
  void afterFieldChanged() {
  }

  @override
  EFormStatus checkState() {
    return EFormStatus.valid;
  }

  @override
  Map<String, dynamic> collectInputs() {
    return {};
  }

  @override
  void fillInitialInputValuesMap() {
  }

  @override
  FormBuilderFieldState<FormBuilderField, dynamic>? findField(String keyString) {
    return null;
  }

  @override
  void resetForm() {
  }

}