import 'package:flutter_form_bricks/shelf.dart';

class ExampleFormManager extends FormManager {
  ExampleFormManager({required super.formData, required super.formSchema});

  @override
  FormStatus checkStatus() {
    return FormStatus.valid;
  }

  @override
  Map<String, dynamic> collectInputs() {
    return {};
  }
}
