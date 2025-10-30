import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_status.dart';

class EmptyFormStateData extends FormStateData {}

class EmptyFormSchema extends FormSchema {
  EmptyFormSchema() : super([], '');
}

class EmptyFormManager extends FormManager {
  EmptyFormManager() : super(stateData: EmptyFormStateData(), schema: EmptyFormSchema());

  @override
  void afterFieldChanged() {}

  @override
  FormStatus checkStatus() {
    return FormStatus.valid;
  }

  @override
  Map<String, dynamic> collectInputs() {
    return {};
  }

  @override
  void fillInitialInputValuesMap() {}

  @override
  FormFieldStateBrick<FormFieldBrick>? findField(String keyString) {
    return null;
  }

  @override
  void resetForm() {}
}
