import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator_chain.dart';

import '../src/tools/test_constants.dart';

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
    FormatterValidatorChain? formatterValidatorChain,
  }) : super(
          [
            FormFieldDescriptor<String, TextEditingValue>(
              keyString: fieldKeyString,
              initialInput: initialInput ?? stringInput1,
              formatterValidatorChainBuilder: formatterValidatorChain == null ? null : () => formatterValidatorChain,
            )
          ],
        );
}
