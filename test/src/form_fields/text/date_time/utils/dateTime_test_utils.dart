import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../test_implementations/test_form_manager.dart';
import '../../../../../test_implementations/test_single_form.dart';
import '../../../../tools/date_time_test_data.dart';
import '../../../../tools/test_utils.dart';

Future<BricksLocalizations> getLocalizations() => BricksLocalizations.delegate.load(Locale('en'));

Future<bool> testDateTimeExcelStyleInput(
  List<DateTimeTestCase> testCases,
  tester,
  formKey,
  dynamic Function<String>(String text) testAction,
) async {
  bool passedOk = true;

  for (DateTimeTestCase testCase in testCases) {
    //when
    var textInput = testCase.input;
    await tester.enterText(find.byType(FormBuilderTextField), textInput);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    formKey.currentState!.save();
    await tester.pump();

    //then
    final dynamic actual = testAction.call(textInput);

    passedOk &= (actual == testCase.expectedValueText) == (testCase.expectedIsValid);
    if (!passedOk) debugPrint(makeErrorString(testCase.input, testCase.input, actual, testCase.expectedValueText));
  }
  return Future.value(passedOk);
}

Future<void> testAllCasesInTextField(
  WidgetTester tester,
  TestWidgetBuilder widgetBuilder,
  TestFormManager formManager,
  List<DateTimeTestCase> testCases,
  Function<String>(String text) testAction,
) async {
  await prepareTestSingleForm(tester, widgetBuilder);
  await testDateTimeExcelStyleInput(testCases, tester, formManager.formKey, testAction)
      .then((value) => expect(value, true));
}

String? tryExpect(String input, dynamic actual, dynamic expected, String? errors, String testCaseTitle) {
  try {
    expect(actual, expected);
  } catch (e) {
    errors = (errors ?? '') + makeErrorString(testCaseTitle, input, actual, expected);
  }
  return errors;
}

String makeErrorString(String testCaseTitle, String input, dynamic actual, dynamic expected) {
  return ""
      "\n\t$testCaseTitle  \n\t\t  "
      "actual: ${addEndLines(actual.toString())} \n\t\t"
      "expected: ${addEndLines(expected.toString())} \n\t\t.";
}

String addEndLines(String errorMessage) {
  return errorMessage.replaceAll(RegExp('\n'), '\n\t\t\t\t  ');
}
