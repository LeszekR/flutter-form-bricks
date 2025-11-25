import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks_example/forms/example_form/example_form.dart';

class ExampleFormSchema extends FormSchema {
  ExampleFormSchema() : super([
    FormFieldDescriptor<String, TextEditingValue>(plainTextKeyString1, 'Ala' ),
    FormFieldDescriptor<String, TextEditingValue>(plainTextKeyString2, 'Gucio'),
  ]);
}
