import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params_data.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../test_implementations/test_color_maker.dart';
import '../../../../../test_implementations/test_form_manager.dart';
import '../../../../../test_implementations/test_form_schema.dart';
import '../../../../../test_implementations/test_text_field_brick.dart';
import '../../../../../test_implementations/test_constants.dart';

// TODO test all FormFieldBrick implementations for showing initial value: double, integer, checkbox, radio, ...
void main() {
  group('TextFieldBrick initial value cases', () {
    _testControllerIniitalValue(
      description: 'controller provided, initialValue null → empty text',
      controller: TextEditingController(),
      initialValue: null,
      expectedText: '',
    );

    _testControllerIniitalValue(
      description: 'controller provided, initialValue not null → shows value',
      controller: TextEditingController(),
      initialValue: TextEditingValue(text: initialStringValue1),
      expectedText: initialStringValue1,
    );

    _testControllerIniitalValue(
      description: 'controller internal, initialValue null → empty text',
      controller: null,
      initialValue: null,
      expectedText: '',
    );

    _testControllerIniitalValue(
      description: 'controller internal, initialValue not null → shows value',
      controller: null,
      initialValue: TextEditingValue(text: initialStringValue1),
      expectedText: initialStringValue1,
    );
  });
}

/// Runs a complete widget test for a given configuration.
void _testControllerIniitalValue({
  required String description,
  required TextEditingController? controller,
  required TextEditingValue? initialValue,
  required String expectedText,
}) {
  testWidgets(description, (tester) async {
    final schema = TestFormSchema(
      keyString: keyString1,
    );

    await tester.pumpWidget(
      UiParams(
        data: UiParamsData(), // Required by bricks for styling/context.
        child: MaterialApp(
          home: TestTextFieldBrick(
            keyString: keyString1,
            controller: controller,
            formManager: TestFormManager(schema: schema),
            colorMaker: TestColorMaker(),
          ),
        ),
      ),
    );

    final field = find.byType(TextField);
    final textField = tester.widget<TextField>(field);
    expect(textField.controller!.text, expectedText);
  });
}
