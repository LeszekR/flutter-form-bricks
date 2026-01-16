import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks_example/forms/example_form/example_form.dart';
import 'package:flutter_form_bricks_example/forms/example_form/example_form_data.dart';

class ExampleFormManager extends FormManager {
  ExampleFormManager() : super(formData: ExampleFormData(), formSchema: ExampleFormSchema());

  @override
  FormStatus checkStatus() {
    return FormStatus.valid;
  }

  @override
  Map<String, dynamic> collectInputs() {
    return {};
  }
}
