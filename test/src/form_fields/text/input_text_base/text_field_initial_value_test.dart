import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params_data.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_implementations/test_form_manager.dart';
import '../../../../test_implementations/test_form_schema.dart';
import '../../../../test_implementations/test_text_field_brick.dart';
import '../../../tools/test_constants.dart';

// TODO test all FormFieldBrick implementations for showing initial value: double, integer, checkbox, radio, ...
void main() {
  group('TextFieldBrick initial value cases', () {
    _testControllerInitialValue(
      description: 'controller provided, initialValue null → empty text_formatter_validators',
      controller: TextEditingController(),
      initialInput: null,
      expectedValueText: '',
    );

    _testControllerInitialValue(
      description: 'controller provided, initialValue not null → shows value',
      controller: TextEditingController(),
      initialInput: stringInput1,
      expectedValueText: stringInput1,
    );

    _testControllerInitialValue(
      description: 'controller internal, initialValue null → empty text_formatter_validators',
      controller: null,
      initialInput: null,
      expectedValueText: '',
    );

    _testControllerInitialValue(
      description: 'controller internal, initialValue not null → shows value',
      controller: null,
      initialInput: stringInput1,
      expectedValueText: stringInput1,
    );
  });
}

/// Runs a complete widget test for a given configuration.
void _testControllerInitialValue({
  required String description,
  required TextEditingController? controller,
  required String? initialInput,
  required String expectedValueText,
}) {
  testWidgets(description, (tester) async {
    final schema = TestFormSchema.withSingleTextField(
      fieldKeyString: fieldKeyString1,
      initialInput: initialInput,
    );

    await tester.pumpWidget(
      UiParams(
        data: UiParamsData(), // Required by bricks for styling/context.
        child: MaterialApp(
          home: Scaffold(
            body: TestTextField(
              keyString: fieldKeyString1,
              formManager: TestFormManager(schema: schema),
              controller: controller,
            ),
          ),
        ),
      ),
    );

    final field = find.byType(TextField);
    final textField = tester.widget<TextField>(field);
    expect(textField.controller!.text, expectedValueText);
  });
}
