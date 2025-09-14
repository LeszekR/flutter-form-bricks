import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/e_form_status.dart';

class EmptyFormStateData extends BrickFormStateData {}
class EmptyFormSchema extends FormSchema {
  EmptyFormSchema() : super([]);
}

class EmptyFormManager extends FormManager {
  EmptyFormManager() : super(EmptyFormStateData(), EmptyFormSchema());

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
  BrickFieldState<BrickField>? findField(String keyString) {
    return null;
  }

  @override
  void resetForm() {
  }

}