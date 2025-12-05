import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/dateTime_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/time_formatter_validator.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

import '../../../../tools/date_time_test_data.dart';
import 'a_test_dateTime_formatter.dart';
import 'dateTime_test_utils.dart';

bool testDateTimeFormatter(
  BricksLocalizations localizations,
  List<DateTimeTestCase> testCases,
  ATestDateTimeFormatter testDateTimeFormatter, {
  String? delimitersPattern,
  String? placeholder,
}) {
  assert((delimitersPattern == null) == (placeholder == null),
      "Both delimitersList and placeholder must be either null or not-null");

  bool passedOk = true;

  if (delimitersPattern == null) {
    for (DateTimeTestCase testCase in testCases) {
      passedOk &= assertSingleCaseDateTimeFormatter(
        localizations,
        testCase,
        testDateTimeFormatter,
      );
    }
  } else {
    for (DateTimeTestCase testCase in testCases) {
      for (String delimiter in extractDelimitersList(delimitersPattern)) {
        passedOk &= assertSingleCaseDateTimeFormatter(
          localizations,
          testCase,
          testDateTimeFormatter,
          delimiter: delimiter,
          placeholder: placeholder,
        );
      }
    }
  }
  return passedOk;
}

bool assertSingleCaseDateTimeFormatter(
  BricksLocalizations localizations,
  DateTimeTestCase testCase,
  ATestDateTimeFormatter testDateTimeFormatter, {
  String? delimiter,
  String? placeholder,
}) {
  assert((delimiter == null) == (placeholder == null),
      "Both must be either null or not-null: delimitersList and placeholder");

  String? errors;
  String input = (placeholder == null) ? testCase.input : (testCase.input.replaceAll(RegExp(placeholder), delimiter!));

  DateTimeFieldContent result = testDateTimeFormatter.makeDateTime(localizations, input, testCase.input);

  var actual = (placeholder == null)
      ? testCase.expectedValueText
      : (testCase.expectedValueText.replaceAll(RegExp(placeholder), delimiter!));
  errors = tryExpect(input, result.input, actual, errors, 'parsedString');
  errors = tryExpect(input, result.error, testCase.expectedError, errors, 'errorMessage');
  errors = tryExpect(input, result.isValid, testCase.expectedIsValid, errors, 'isStringValid');

  if (errors != null) debugPrint("test failed: input $input $errors");
  return errors == null;
}

List<String> extractDelimitersList(String delimitersPattern) {
  String delimitersString = delimitersPattern;
  delimitersString = delimitersString.substring(1);
  delimitersString = delimitersString.substring(0, delimitersString.length - 1);
  delimitersString = delimitersString.replaceAll('\\', '');
  List<String> delimitersList = delimitersString.split('|');
  return delimitersList;
}

class TestDateFormatter implements ATestDateFormatter {
  final DateFormatterValidator dateFormatter;

  TestDateFormatter(this.dateFormatter);

  @override
  DateFieldContent makeDate(
    BricksLocalizations localizations,
    String fieldKeyString,
    String inputString,
  ) {
    return dateFormatter.run(localizations, fieldKeyString, DateFieldContent.transient(inputString));
  }
}

class TestTimeFormatter implements ATestTimeFormatter {
  final TimeFormatterValidator timeFormatter;

  TestTimeFormatter(this.timeFormatter);

  @override
  TimeFieldContent makeTime(
    BricksLocalizations localizations,
    String fieldKeyString,
    String inputString,
  ) {
    return timeFormatter.run(localizations, fieldKeyString, TimeFieldContent.transient(inputString));
  }
}

class TestDateTimeFormatter /*implements ATestDateTimeFormatter*/ {
  final DateTimeFormatterValidator dateTimeFormatter;

  TestDateTimeFormatter(this.dateTimeFormatter);

  /*@override*/
  DateTimeFieldContent makeDateTime(
    BricksLocalizations localizations,
    String fieldKeyString,
    String inputString,
  ) {
    return dateTimeFormatter.run(localizations, fieldKeyString, DateTimeFieldContent.transient(inputString));
  }
}
