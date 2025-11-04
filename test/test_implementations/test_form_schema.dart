import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';

import '../ui/test_constants.dart';

class TestFormSchema extends FormSchema {
  TestFormSchema({required String keyString})
      : super(
          [
            FormFieldDescriptor<String>(
              keyString,
              initialStringValue1,
            )
          ],
          keyString1,
        );

  TestFormSchema.forText({
    required String keyString,
    required TextEditingValue? initialValue,
    FormatterValidatorChain? formatterValidatorChain,
  }) : super(
          [
            FormFieldDescriptor<TextEditingValue>(
              keyString,
              initialValue ?? TextEditingValue(text: initialStringValue1),
              formatterValidatorChain,
            )
          ],
          keyString1,
        );

  TestFormSchema.of({
    required String keyString,
    required List<FormFieldDescriptor> descriptors,
  }) : super(descriptors, keyString);
}
