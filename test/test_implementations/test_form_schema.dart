import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_input_base/string_extension.dart';

import '../src/tools/test_constants.dart';
import 'mock_formatter_validator.dart';

class TestFormSchema extends FormSchema {
  TestFormSchema.testDefault()
      : super([
          FormFieldDescriptor<String, TextEditingValue>(
            keyString: fieldKeyString1,
            initialInput: stringInput1,
          )
        ]);

  TestFormSchema.fromDescriptors(super.descriptors);

  TestFormSchema.withSingleTextField({
    required String fieldKeyString,
    required String? initialInput,
    FormatterValidatorListMaker<TextEditingValue, String>? formatterValidatorListMaker,
  }) : super(
          [
            FormFieldDescriptor<TextEditingValue, String>(
              keyString: fieldKeyString,
              initialInput: (initialInput ?? stringInput1).txtEditVal(),
              defaultFormatterValidatorListMaker: formatterValidatorListMaker ?? () => [MockTextFormatterValidator()],
            )
          ],
        );
}
