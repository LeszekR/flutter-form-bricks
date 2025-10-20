import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/standalone_form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/dateTime_formatter_validator.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/time_formatter_validator.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/string_parse_result.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../date_time_test_data.dart';
import '../../../../test_utils.dart';
import 'a_test_dateTime_formatter.dart';

// late DateTimeLimits datTimLim;
// late final int yearMaxBack;
// late final int yearMaxForward;
//
// initDateTimeUtils(int minYear, int maxYear) {
//   datTimLim = DateTimeLimits(minDateTimeRequired: DateTime(minYear), maxDateTimeRequired: DateTime(maxYear));
//   // datTimLim = DateTimeLimits(minDateTimeRequired: DateTime(2014), maxDateTimeRequired: DateTime(2026));
//   yearMaxBack = datTimLim.minDateTimeRequired!.year;
//   yearMaxForward = datTimLim.maxDateTimeRequired!.year;
// }

Future<bool> testDateTimeExcelStyleInput(
  List<DateTimeTestData> testCases,
  tester,
  formKey,
  dynamic Function<String>(String text) testAction,
) async {
  bool passedOk = true;

  for (final testCase in testCases) {
    //when
    var textInput = testCase.input;
    await tester.enterText(find.byType(FormBuilderTextField), textInput);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    formKey.currentState!.save();
    await tester.pump();

    //then
    final dynamic actual = testAction.call(textInput);

    passedOk &= (actual == testCase.expected) == (testCase.isValid);
    if (!passedOk) debugPrint(makerrorString(testCase.input, testCase.input, actual, testCase.expected));
  }
  return Future.value(passedOk);
}

typedef MakeWidgetFunction = Widget Function(BuildContext context);

Future<void> testAllCasesInTextField(
    WidgetTester tester,
    MakeWidgetFunction makeTextField,
    StandaloneFormManagerOLD formManager,
    List<DateTimeTestData> testCases,
    Function<String>(String text) testAction) async {
  final BuildContext context = await TestUtils.pumpAppGetContext(tester);
  Widget textField = makeTextField(context);
  await TestUtils.prepareSimpleForm(tester, formManager, textField);
  await testDateTimeExcelStyleInput(testCases, tester, formManager.formKey, testAction)
      .then((value) => expect(value, true));
}

bool testDateTimeFormatter(
  BricksLocalizations localizations,
  List<DateTimeTestData> testCases,
  ATestDateTimeFormatter testDateTimeFormatter, {
  String? delimitersPattern,
  String? placeholder,
}) {
  assert((delimitersPattern == null) == (placeholder == null),
      "Both must be either null or not-null: delimitersList and placeholder");

  bool passedOk = true;

  if (delimitersPattern == null) {
    for (final testCase in testCases) {
      passedOk &= assertSingleCaseDateTimeFormatter(localizations, testCase, testDateTimeFormatter);
    }
  } else {
    for (final testCase in testCases) {
      for (String delimiter in extractDelimitersList(delimitersPattern)) {
        passedOk &= assertSingleCaseDateTimeFormatter(localizations, testCase, testDateTimeFormatter,
            delimiter: delimiter, placeholder: placeholder);
      }
    }
  }
  return passedOk;
}

bool assertSingleCaseDateTimeFormatter(
  BricksLocalizations localizations,
  DateTimeTestData testCase,
  ATestDateTimeFormatter testDateTimeFormatter, {
  String? delimiter,
  String? placeholder,
}) {
  assert((delimiter == null) == (placeholder == null),
      "Both must be either null or not-null: delimitersList and placeholder");

  String input = (placeholder == null) ? testCase.input : (testCase.input.replaceAll(RegExp(placeholder), delimiter));
  StringParseResult result = testDateTimeFormatter.makeDateTime(localizations, input, testCase.dateTimeLimits);
  String? errors;

  var actual =
      (placeholder == null) ? testCase.expected : (testCase.expected.replaceAll(RegExp(placeholder), delimiter));
  errors = tryExpect(input, result.parsedString, actual, errors, 'parsedString');
  errors = tryExpect(input, result.errorMessage, testCase.errorMessage, errors, 'errorMessage');
  errors = tryExpect(input, result.isStringValid, testCase.isValid, errors, 'isStringValid');

  if (errors != null) debugPrint("test failed: input $input $errors");
  return errors == null;
}

String? tryExpect(final String input, dynamic actual, dynamic expected, String? errors, String testCaseTitle) {
  try {
    expect(actual, expected);
  } catch (e) {
    errors = (errors ?? '') + makerrorString(testCaseTitle, input, actual, expected);
  }
  return errors;
}

String makerrorString(String testCaseTitle, String input, dynamic actual, dynamic expected) {
  return ""
      "\n\t$testCaseTitle  \n\t\t  "
      "actual: ${addEndLines(actual.toString())} \n\t\t"
      "expected: ${addEndLines(expected.toString())} \n\t\t.";
}

List<String> extractDelimitersList(String delimitersPattern) {
  String delimitersString = delimitersPattern;
  delimitersString = delimitersString.substring(1);
  delimitersString = delimitersString.substring(0, delimitersString.length - 1);
  delimitersString = delimitersString.replaceAll('\\', '');
  List<String> delimitersList = delimitersString.split('|');
  return delimitersList;
}

String addEndLines(String errorMessage) {
  return errorMessage.replaceAll(RegExp('\n'), '\n\t\t\t\t  ');
}

class TestDateFormatter implements ATestDateTimeFormatter {
  final DateFormatterValidator dateFormatter;

  TestDateFormatter(this.dateFormatter);

  @override
  StringParseResult makeDateTime(BricksLocalizations localizations, String inputString, DateTimeLimits dateLimits) {
    return dateFormatter.makeDateFromString(localizations, inputString, dateLimits);
  }
}

class TestTimeFormatter implements ATestDateTimeFormatter {
  final TimeFormatterValidator timeFormatter;

  TestTimeFormatter(this.timeFormatter);

  @override
  StringParseResult makeDateTime(BricksLocalizations localizations, String inputString, DateTimeLimits dateLimits) {
    return timeFormatter.makeTimeFromString(localizations, inputString);
  }
}

class TestDateTimeFormatter implements ATestDateTimeFormatter {
  final DateTimeFormatterValidator dateTimeFormatter;

  TestDateTimeFormatter(this.dateTimeFormatter);

  @override
  StringParseResult makeDateTime(BricksLocalizations localizations, String inputString, DateTimeLimits dateLimits) {
    return dateTimeFormatter.makeDateTimeFromString(localizations, inputString, dateLimits);
  }
}
