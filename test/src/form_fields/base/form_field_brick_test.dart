import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/components/base/validate_mode_brick.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params_data.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_implementations/test_form_manager.dart';
import '../../../test_implementations/test_form_schema.dart';
import '../../../test_implementations/test_text_field_brick.dart';
import '../text/date_time/utils/test_constants.dart';

void main() {
  group('FormFieldBrick basic build behavior', () {
    _testKeyStringInTheSchema(
      description: 'builds quietly when keyString matches schema',
      schemaKeyString: fieldKeyString1,
      fieldKeyString: fieldKeyString1,
      expectThrows: false,
    );

    _testKeyStringInTheSchema(
      description: 'detects mismatch when keyString not in schema (no test failure)',
      schemaKeyString: fieldKeyString1,
      fieldKeyString: fieldKeyString2,
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
  testWidgets(
    description,
    (tester) async {
      final schema = TestFormSchema.withSingleTextField(
        fieldKeyString: schemaKeyString,
        initialInput: null,
      );

      bool didThrow = false;

      await tester.pumpWidget(
        UiParams(
          data: UiParamsData(),
          child: MaterialApp(
            home: Scaffold(
              body: TestTextField(
                keyString: fieldKeyString,
                formManager: TestFormManager(schema: schema),
                validateMode: ValidateModeBrick.noValidator,
              ),
            ),
          ),
        ),
      );
      await tester.pump(); // allow post-frame errors

      final err = tester.takeException();
      if (expectThrows) {
        expect(err, isNotNull);
        expect(err, anyOf(isA<AssertionError>(), isA<FlutterError>()));
      } else {
        expect(err, isNull);
        expect(find.byType(TestTextField), findsOneWidget);
      }
    },
  );
}
