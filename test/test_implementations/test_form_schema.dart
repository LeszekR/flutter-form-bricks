import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/utils/string_extension.dart';

import '../src/form_fields/text/date_time/tools/test_constants.dart';
import 'test_text_field_brick.dart';

class TestFormSchema extends FormSchema {
  TestFormSchema.testDefault()
      : super(
          formKey: testFormGlobalKey,
          initiallyFocusedKeyString: fieldKeyString1,
          fieldDescriptors: [
            TestTextFieldDescriptor(
              keyString: fieldKeyString1,
              initialInput: stringInput1.toTextEditingValue(),
            )
          ],
        );

  TestFormSchema.fromDescriptors({
    required super.initiallyFocusedKeyString,
    required super.fieldDescriptors,
  }) : super(formKey: testFormGlobalKey);

  TestFormSchema.withSingleTextField({
    required String fieldKeyString,
    required String? initialInput,
    FormatterValidatorListMaker<TextEditingValue, String>? formatterValidatorListMaker,
  }) : super(
          formKey: testFormGlobalKey,
          initiallyFocusedKeyString: fieldKeyString,
          fieldDescriptors: [
            TestTextFieldDescriptor(
              keyString: fieldKeyString,
              initialInput: initialInput == null ? null : initialInput.toTextEditingValue(),
            )
          ],
        );
}
