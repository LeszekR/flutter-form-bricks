import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_status.dart';

class ExampleFormStateData extends FormData {
  ExampleFormStateData({required super.focusedKeyString});
}

class ExampleFormSchema extends FormSchema {
  ExampleFormSchema(super.descriptors, super.initialFocusKeyString);
}

class EmptyFormStateData extends FormData {
  EmptyFormStateData({required super.focusedKeyString});
}

class EmptyFormSchema extends FormSchema {
  EmptyFormSchema() : super([], '');
}

class EmptyFormManager extends FormManager {
  EmptyFormManager({required super.formData, required super.schema});

  @override
  FormStatus checkStatus() {
    return FormStatus.valid;
  }

  @override
  Map<String, dynamic> collectInputs() {
    return {};
  }
}
