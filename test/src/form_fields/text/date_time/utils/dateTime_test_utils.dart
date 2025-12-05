import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/dateTime_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/time_formatter_validator.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../test_implementations/test_form_manager.dart';
import '../../../../tools/date_time_test_data.dart';
import '../../../../tools/test_utils.dart';
import 'a_test_dateTime_formatter.dart';

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
    if (!passedOk) debugPrint(makErrorString(testCase.input, testCase.input, actual, testCase.expectedValueText));
  }
  return Future.value(passedOk);
}

typedef MakeWidgetFunction = Widget Function(BuildContext context);

Future<void> testAllCasesInTextField(
  WidgetTester tester,
  MakeWidgetFunction makeTextField,
  TestFormManager formManager,
  List<DateTimeTestCase> testCases,
  Function<String>(String text) testAction,
) async {
  final BuildContext context = await pumpAppGetContext(tester);
  Widget textField = makeTextField(context);
  await prepareSimpleForm(tester, textField);
  await testDateTimeExcelStyleInput(testCases, tester, formManager.formKey, testAction)
      .then((value) => expect(value, true));
}

String? tryExpect(String input, dynamic actual, dynamic expected, String? errors, String testCaseTitle) {
  try {
    expect(actual, expected);
  } catch (e) {
    errors = (errors ?? '') + makErrorString(testCaseTitle, input, actual, expected);
  }
  return errors;
}

String makErrorString(String testCaseTitle, String input, dynamic actual, dynamic expected) {
  return ""
      "\n\t$testCaseTitle  \n\t\t  "
      "actual: ${addEndLines(actual.toString())} \n\t\t"
      "expected: ${addEndLines(expected.toString())} \n\t\t.";
}

String addEndLines(String errorMessage) {
  return errorMessage.replaceAll(RegExp('\n'), '\n\t\t\t\t  ');
}

