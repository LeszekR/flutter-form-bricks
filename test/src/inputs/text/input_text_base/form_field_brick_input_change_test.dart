import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_implementations/mock_formatter_validator_chain.dart';
import '../../../../test_implementations/test_color_maker.dart';
import '../../../../test_implementations/test_constants.dart';
import '../../../../test_implementations/test_form_field_brick.dart';
import '../../../../test_implementations/test_form_manager.dart';
import '../../../../test_implementations/test_form_schema.dart';

void main() {
  group('FormFieldBrick value change → validation flow', () {
    for (final testCase in _cases) {
      testWidgets(testCase.description, (tester) async {
        await _runValueChangeTest(tester, testCase);
      });
    }
  });
}

Future<void> _runValueChangeTest(
  WidgetTester tester,
  ValueChangeTestCase testCase,
) async {
  var fieldKeyString = fieldKeyString1;

  final formManager = TestFormManager(
      schema: TestFormSchema.of(
    keyString: formKeyString1,
    descriptors: [
      FormFieldDescriptor<String, TextEditingValue>(
        keyString: fieldKeyString,
        initialInput: testCase.initialInput,
        formatterValidatorChainBuilder: () => MockFormatterValidatorChain(testCase.error),
      )
    ],
  ));

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
              formatterValidatorChainBuilder: () => MockFormatterValidatorChain(testCase.error),
            );
          },
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  // final fieldFinder = find.byType(TextField);
  // expect(fieldFinder, findsOneWidget);
  // final controller = tester.widget<TextField>(fieldFinder).controller!;
  final fieldFinder = find.byKey(globalKey);
  expect(fieldFinder, findsOneWidget);
  final state = globalKey.currentState!;

  // --- Verify initial FormManager state ---
  expect(formManager.getFieldValue(fieldKeyString), testCase.initialInput);
  expect(formManager.isFieldDirty(fieldKeyString), false);
  expect(formManager.isFieldValidating(fieldKeyString), false);
  expect(formManager.isFieldValid(fieldKeyString), false);
  expect(formManager.getFieldError(fieldKeyString), null);

  // --- Simulate user input change ---
  // await tester.enterText(fieldFinder, testCase.newValue);
  // await tester.pumpAndSettle();
  state.changeValue(localizations!, testCase.newValue);

  // TODO can I assume that validation error ALWAYS shows errorText? Then FormFieldData.isValid is redundant
  // --- Verify final FormManager state ---
  expect(formManager.getFieldValue(fieldKeyString), testCase.newValue);
  expect(formManager.isFieldDirty(fieldKeyString), true);
  expect(formManager.isFieldValidating(fieldKeyString), false);
  expect(formManager.isFieldValid(fieldKeyString), testCase.error == null);
  expect(formManager.getFieldError(fieldKeyString), testCase.error);

  // --- Verify TextField controller sync ---
  expect(state.value, testCase.newValue);

  // --- Verify error notifier propagation ---
  expect(formManager.errorMessageNotifier.value, testCase.error);
}

final List<ValueChangeTestCase> _cases = [
  ValueChangeTestCase(
    description: 'initial empty → new → validator error',
    initialInput: null,
    newValue: newStringInput1,
    error: mockError1,
  ),
  ValueChangeTestCase(
    description: 'initial empty → new → validator ok',
    initialInput: null,
    newValue: newStringInput1,
    error: null,
  ),
  ValueChangeTestCase(
    description: 'initial filled → empty → validator error',
    initialInput: initialStringInput1,
    newValue: '',
    error: mockError1,
  ),
  ValueChangeTestCase(
    description: 'initial filled → empty → validator ok',
    initialInput: initialStringInput1,
    newValue: '',
    error: null,
  ),
  ValueChangeTestCase(
      description: 'initial filled → new → validator error',
      initialInput: initialStringInput1,
      newValue: newStringInput1,
      error: mockError1),
  ValueChangeTestCase(
    description: 'initial filled → new → validator ok',
    initialInput: initialStringInput1,
    newValue: newStringInput1,
    error: null,
  ),
];

class ValueChangeTestCase {
  final String description;
  final String? initialInput;
  final String newValue;
  final String? error;

  const ValueChangeTestCase({
    required this.description,
    required this.initialInput,
    required this.newValue,
    required this.error,
  });
}
