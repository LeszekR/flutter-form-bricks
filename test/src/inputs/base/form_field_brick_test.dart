import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params_data.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_implementations/test_color_maker.dart';
import '../../../test_implementations/test_constants.dart';
import '../../../test_implementations/test_form_field_brick.dart';
import '../../../test_implementations/test_form_manager.dart';
import '../../../test_implementations/test_form_schema.dart';

void main() {
  group('FormFieldBrick basic build behavior', () {
    _testKeyStringInTheSchema(
      description: 'builds quietly when keyString matches schema',
      schemaKeyString: keyString1,
      fieldKeyString: keyString1,
      expectThrows: false,
    );

    _testKeyStringInTheSchema(
      description: 'detects mismatch when keyString not in schema (no test failure)',
      schemaKeyString: keyString1,
      fieldKeyString: keyString2,
      expectThrows: true,
    );
  });
}

void _testKeyStringInTheSchema({
  required String description,
  required String schemaKeyString,
  required String fieldKeyString,
  required bool expectThrows,
}) {
  testWidgets(description, (tester) async {
    final schema = TestFormSchema.forText(
      keyString: schemaKeyString,
      initialValue: null,
    );

    bool didThrow = false;

    try {
      await tester.pumpWidget(
        UiParams(
          data: UiParamsData(),
          child: MaterialApp(
            home: TestFormFieldBrick(
              key: GlobalKey(),
              keyString: fieldKeyString,
              formManager: TestFormManager(schema: schema),
              colorMaker: TestColorMaker(),
            ),
          ),
        ),
      );
    } on AssertionError catch (_) {
      didThrow = true;
    } on Error catch (_) {
      didThrow = true;
    }

    if (expectThrows) {
      expect(didThrow, isTrue, reason: 'Expected widget to throw assertion');
    } else {
      expect(didThrow, isFalse, reason: 'Widget unexpectedly threw');
      expect(find.byType(TestFormFieldBrick), findsOneWidget);
    }
  });
}
