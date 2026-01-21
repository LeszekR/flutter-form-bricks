import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_field_base/string_extension.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_implementations/mock_formatter_validator.dart';
import '../../../../test_implementations/mock_formatter_validator_chain.dart';
import '../../../../test_implementations/test_color_maker.dart';
import '../../../../test_implementations/test_form_field_brick.dart';
import '../../../../test_implementations/test_form_manager.dart';
import '../../../../test_implementations/test_form_schema.dart';
import '../../../tools/test_constants.dart';

void main() {
  group('FormFieldBrick value change → validation flow', () {
    for (final testCase in _cases) {
      testWidgets(testCase.description, (tester) async {
        await _runValueChangeTest(tester, testCase);
      });
    }
  });
}

final List<ValueChangeTestCase> _cases = [
  ValueChangeTestCase(
    description: 'initial empty → new → validator error',
    initialInput: null,
    newInput: newStringInput1,
    error: mockError1,
  ),
  ValueChangeTestCase(
    description: 'initial empty → new → validator ok',
    initialInput: null,
    newInput: newStringInput1,
    error: '',
  ),
  ValueChangeTestCase(
    description: 'initial filled → empty → validator error',
    initialInput: stringInput1,
    newInput: '',
    error: mockError1,
  ),
  ValueChangeTestCase(
    description: 'initial filled → empty → validator ok',
    initialInput: stringInput1,
    newInput: '',
    error: '',
  ),
  ValueChangeTestCase(
    description: 'initial filled → new → validator error',
    initialInput: stringInput1,
    newInput: newStringInput1,
    error: mockError1,
  ),
  ValueChangeTestCase(
    description: 'initial filled → new → validator ok',
    initialInput: stringInput1,
    newInput: newStringInput1,
    error: '',
  ),
];

Future<void> _runValueChangeTest(
  WidgetTester tester,
  ValueChangeTestCase testCase,
) async {
  final fieldKeyString = fieldKeyString1;

  final FormatterValidatorListMaker<TextEditingValue, String> mockTextFormatValidListMaker = () => [
        MockTextFormatterValidator(
          returnInputTEV: testCase.newInput.txtEditVal(),
          mockError: testCase.error,
        )
      ];

  final formManager = TestFormManager(
    schema: TestFormSchema.fromDescriptors([
      FieldDescriptor<TextEditingValue, String>(
        keyString: fieldKeyString,
        initialInput: testCase.initialInput?.txtEditVal(),
        // TU PRZERWAŁEM - finish correcting refactoring
        defaultFormatterValidatorsMaker: mockTextFormatValidListMaker,
      )
    ]),
  );

  final globalKey = GlobalKey<TestFormFieldBrickState>();
  BricksLocalizations? localizations;

  await tester.pumpWidget(
    UiParams(
      data: UiParamsData(),
      child: MaterialApp(
        localizationsDelegates: BricksLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) {
            localizations = BricksLocalizations.of(context);
            return TestPlainTextFormFieldBrick(
              key: globalKey,
              keyString: fieldKeyString,
              formManager: formManager,
              colorMaker: TestColorMaker(),
              defaultFormatterValidatorListMaker: mockTextFormatValidListMaker,
            );
          },
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final fieldFinder = find.byKey(globalKey);
  expect(fieldFinder, findsOneWidget);
  final state = globalKey.currentState!;

  // --- Verify initial FormManager state ---
  expect(formManager.getFieldValue(fieldKeyString), null);
  expect(formManager.isFieldDirty(fieldKeyString), false);
  expect(formManager.isFieldValidating(fieldKeyString), false);
  expect(formManager.isFieldValid(fieldKeyString), false);
  expect(formManager.getFieldError(fieldKeyString), null);

  // --- Simulate user input change ---
  state.onInputChanged(testCase.newInput.txtEditVal());

  // --- Verify final FormManager state ---
  expect(formManager.getFieldValue(fieldKeyString), TextEditingValue(text: testCase.newInput));
  expect(formManager.isFieldDirty(fieldKeyString), true);
  expect(formManager.isFieldValidating(fieldKeyString), false);
  expect(formManager.isFieldValid(fieldKeyString), testCase.error == null);
  expect(formManager.getFieldError(fieldKeyString), testCase.error);

  // --- Verify TextField controller sync ---
  expect(state.controller.value, TextEditingValue(text: testCase.newInput));

  // --- Verify error notifier propagation ---
  expect(formManager.errorMessageNotifier.value, testCase.error);
}

class ValueChangeTestCase {
  final String description;
  final String? initialInput;
  final String newInput;
  final String? error;

  const ValueChangeTestCase({
    required this.description,
    required this.initialInput,
    required this.newInput,
    required this.error,
  });
}
