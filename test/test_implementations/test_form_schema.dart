import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';

import 'test_constants.dart';

class TestFormSchema extends FormSchema {
  TestFormSchema()
      : super(
          [
            FormFieldDescriptor<String, TextEditingValue>(
              keyString: keyString1,
              initialInput: initialStringValue1,
            )
          ],
        );

  TestFormSchema.forText({
    required String keyString,
    required String? initialValue,
    FormatterValidatorChain? formatterValidatorChain,
  }) : super(
          [
            FormFieldDescriptor<String, TextEditingValue>(
              keyString: keyString,
              initialInput: initialValue ?? initialStringValue1,
              formatterValidatorChainBuilder: formatterValidatorChain == null ? null : () =>  formatterValidatorChain,
            )
          ],
        );

  TestFormSchema.of({
    required String keyString,
    required List<FormFieldDescriptor> descriptors,
  }) : super(descriptors);
}
