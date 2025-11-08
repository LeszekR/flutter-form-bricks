import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_implementations/test_color_maker.dart';
import '../../../../test_implementations/test_form_field_brick.dart';
import '../../../../test_implementations/test_form_manager.dart';
import '../../../../test_implementations/test_form_schema.dart';
import '../../../../test_implementations/test_formatter_validator_chain.dart';
import '../../../../ui/test_constants.dart';

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
  var keyString = keyString1;

  final formatterValidatorChain = TestFormatterValidatorChain(testCase.error);
  List<FormFieldDescriptor> descriptors = [
    FormFieldDescriptor<String>(
      keyString,
      testCase.initialValue,
      formatterValidatorChain,
    )
  ];

  final schema = TestFormSchema.of(
    keyString: keyString,
    descriptors: descriptors,
  );
  final formManager = TestFormManager(schema: schema);
  final globalKey = GlobalKey<TestFormFieldBrickState>();

  await tester.pumpWidget(
    UiParams(
      data: UiParamsData(),
      child: MaterialApp(
        home: Scaffold(
          body: TestFormFieldBrick(
            key: globalKey,
            keyString: keyString,
            formManager: formManager,
            colorMaker: TestColorMaker(),
          ),
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
  expect(formManager.getFieldValue(keyString), testCase.initialValue);
  expect(formManager.isFieldDirty(keyString), false);
  expect(formManager.isFieldValidating(keyString), false);
  expect(formManager.isFieldValid(keyString), true);
  expect(formManager.getFieldError(keyString), null);

  // --- Simulate user input change ---
  // await tester.enterText(fieldFinder, testCase.newValue);
  // await tester.pumpAndSettle();
  state.changeValue(testCase.newValue);

  // TODO can I assume that validation error ALWAYS shows errorText? Then FormFieldData.isValid is redundant
  // --- Verify final FormManager state ---
  expect(formManager.getFieldValue(keyString), testCase.newValue);
  expect(formManager.isFieldDirty(keyString), true);
  expect(formManager.isFieldValidating(keyString), false);
  expect(formManager.isFieldValid(keyString), testCase.error == null);
  expect(formManager.getFieldError(keyString), testCase.error);

  // --- Verify TextField controller sync ---
  expect(state.value, testCase.newValue);

  // --- Verify error notifier propagation ---
  expect(formManager.errorMessageNotifier.value, testCase.error);
}

final List<ValueChangeTestCase> _cases = [
  ValueChangeTestCase(
    description: 'initial empty → new → validator error',
    initialValue: null,
    newValue: newStringValue1,
    error: mockError1,
  ),
  ValueChangeTestCase(
    description: 'initial empty → new → validator ok',
    initialValue: null,
    newValue: newStringValue1,
    error: null,
  ),
  ValueChangeTestCase(
    description: 'initial filled → empty → validator error',
    initialValue: initialStringValue1,
    newValue: '',
    error: mockError1,
  ),
  ValueChangeTestCase(
    description: 'initial filled → empty → validator ok',
    initialValue: initialStringValue1,
    newValue: '',
    error: null,
  ),
  ValueChangeTestCase(
      description: 'initial filled → new → validator error',
      initialValue: initialStringValue1,
      newValue: newStringValue1,
      error: mockError1),
  ValueChangeTestCase(
    description: 'initial filled → new → validator ok',
    initialValue: initialStringValue1,
    newValue: newStringValue1,
    error: null,
  ),
];

class ValueChangeTestCase {
  final String description;
  final String? initialValue;
  final String newValue;
  final String? error;

  const ValueChangeTestCase({
    required this.description,
    required this.initialValue,
    required this.newValue,
    required this.error,
  });
}
