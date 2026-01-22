import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_field_base/string_extension.dart';

import '../src/tools/test_constants.dart';
import 'mock_formatter_validator.dart';
import 'test_form_field_brick.dart';

class TestFormSchema extends FormSchema {
  TestFormSchema.testDefault()
      : super([
          TestPlainTextFieldDescriptor(
            keyString: fieldKeyString1,
            initialInput: stringInput1.txtEditVal(),
          )
        ]);

  TestFormSchema.fromDescriptors(super.descriptors);

  TestFormSchema.withSingleTextField({
    required String fieldKeyString,
    required String? initialInput,
    FormatterValidatorListMaker<TextEditingValue, String>? formatterValidatorListMaker,
  }) : super(
          [
            TestPlainTextFieldDescriptor(
              keyString: fieldKeyString,
              initialInput: (initialInput ?? stringInput1).txtEditVal(),
              defaultFormatterValidatorsMaker: formatterValidatorListMaker ?? () => [MockTextFormatterValidator()],
            )
          ],
        );
}
