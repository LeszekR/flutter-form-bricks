import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_status.dart';

class EmptyFormStateData extends FormStateData {}

class EmptyFormSchema extends FormSchema {
  EmptyFormSchema() : super([], '');
}

class EmptyFormManager extends FormManager {
  EmptyFormManager({required super.stateData, required super.schema});

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

class ExampleFormStateData extends FormStateData {}

class ExampleFormSchema extends FormSchema {
  ExampleFormSchema(super.descriptors, super.initialFocusKeyString);
}
