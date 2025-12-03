import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';

import 'test_constants.dart';

class TestFormSchema extends FormSchema {
  TestFormSchema.autoDefault()
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
