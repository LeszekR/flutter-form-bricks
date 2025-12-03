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
            home: TestPlainTextFormFieldBrick(
              key: GlobalKey(),
              keyString: fieldKeyString,
              formManager: TestFormManager(schema: schema),
              colorMaker: TestColorMaker(),
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
        expect(find.byType(TestPlainTextFormFieldBrick), findsOneWidget);
      }
    },
  );
}
