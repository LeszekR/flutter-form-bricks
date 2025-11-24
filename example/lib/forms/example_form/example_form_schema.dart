import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks_example/forms/example_form/example_form.dart';

class ExampleFormSchema extends FormSchema {
  ExampleFormSchema() : super([
    FormFieldDescriptor<String>(plainTextKeyString1, 'Ala' ),
    FormFieldDescriptor<String>(plainTextKeyString2, 'Gucio'),
  ]);
}
