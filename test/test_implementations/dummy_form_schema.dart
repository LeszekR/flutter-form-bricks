import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/inputs/state/text_editing_value_brick.dart';

import '../ui/test_constants.dart';

class DummyFormSchema extends FormSchema {
  DummyFormSchema({required String keyString})
      : super(
          [FormFieldDescriptor<String>(keyString, initialStringValue1, null)],
          keyString1,
        );

  DummyFormSchema.forText({required String keyString, required TextEditingValue? initialValue})
      : super(
          [
            FormFieldDescriptor<TextEditingValue>(
                keyString,
                initialValue ?? TextEditingValue(text: initialStringValue1),
                null)
          ],
          keyString1,
        );
}
