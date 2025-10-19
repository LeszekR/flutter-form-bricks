//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shipping_ui/ui/forms/form_manager/standalone_form_manager.dart';
// import 'package:shipping_ui/ui/inputs/date_time/date_formatter_validator.dart';
// import 'package:shipping_ui/ui/inputs/date_time/time_formatter_validator.dart';
// import 'package:shipping_ui/ui/inputs/date_time/dateTime_formatter_validator.dart';
// import 'package:shipping_ui/ui/inputs/date_time/string_parse_result.dart';
//
// import '../../../../date_time_test_data.dart';
// import '../../../../test_utils.dart';
// import 'a_test_date_time_formatter.dart';
//
// class UtilTestDateTime {
//   static Future<bool> testDateTimeExcelStyleInput(
//     List<DateTimeTestData> testCases,
//     tester,
//     formKey,
//     dynamic Function<String>(String text) testAction,
//   ) async {
//     bool passedOk = true;
//
//     for (final testCase in testCases) {
//       //when
//       var textInput = testCase.input;
//       await tester.enterText(find.byType(FormBuilderTextField), textInput);
//       await tester.testTextInput.receiveAction(TextInputAction.done);
//       formKey.currentState!.save();
//       await tester.pump();
//
//       //then
//       final dynamic actual = testAction.call(textInput);
//
//       passedOk &= (actual == testCase.expected) == (testCase.isValid);
//       if (!passedOk) debugPrint(makerrorString(testCase.input, testCase.input, actual, testCase.expected));
//     }
//     return Future.value(passedOk);
//   }
//
//   static Future<void> testAllCasesInTextField(
//       WidgetTester tester,
//       Widget Function() makeTextField,
//       StandaloneFormManagerOLD formManager,
//       List<DateTimeTestData> testCases,
//       Function<String>(String text) testAction) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     Widget textField = makeTextField();
//     await TestUtils.prepareSimpleForm(tester, formManager, textField);
//     await UtilTestDateTime.testDateTimeExcelStyleInput(testCases, tester, formManager.formKey, testAction)
//         .then((value) => expect(value, true));
//   }
//
//   // DATE-TIME-FORMATTER
//   // ============================================================================================
//   static bool testDateTimeFormatter(
//     List<DateTimeTestData> testCases,
//     ATestDateTimeFormatter testDateTimeFormatter, {
//     String? delimitersPattern,
//     String? placeholder,
//   }) {
//     assert((delimitersPattern == null) == (placeholder == null),
//         "Both must be either null or not-null: delimitersList and placeholder");
//
//     bool passedOk = true;
//
//     if (delimitersPattern == null) {
//       for (final testCase in testCases) {
//         passedOk &= assertSingleCaseDateTimeFormatter(testCase, testDateTimeFormatter);
//       }
//     } else {
//       for (final testCase in testCases) {
//         for (String delimiter in extractDelimitersList(delimitersPattern)) {
//           passedOk &= assertSingleCaseDateTimeFormatter(testCase, testDateTimeFormatter,
//               delimiter: delimiter, placeholder: placeholder);
//         }
//       }
//     }
//     return passedOk;
//   }
//
//   static bool assertSingleCaseDateTimeFormatter(
//     DateTimeTestData testCase,
//     ATestDateTimeFormatter testDateTimeFormatter, {
//     String? delimiter,
//     String? placeholder,
//   }) {
//     assert((delimiter == null) == (placeholder == null),
//         "Both must be either null or not-null: delimitersList and placeholder");
//
//     String input = (placeholder == null) ? testCase.input : (testCase.input.replaceAll(RegExp(placeholder), delimiter));
//     StringParseResult result = testDateTimeFormatter.makeDateTime(input);
//     String? errors;
//
//     var actual =
//         (placeholder == null) ? testCase.expected : (testCase.expected.replaceAll(RegExp(placeholder), delimiter));
//     errors = tryExpect(input, result.parsedString, actual, errors, 'parsedString');
//     errors = tryExpect(input, result.errorMessage, testCase.errorMessage, errors, 'errorMessage');
//     errors = tryExpect(input, result.isStringValid, testCase.isValid, errors, 'isStringValid');
//
//     if (errors != null) debugPrint("test failed: input $input $errors");
//     return errors == null;
//   }
//
//   static String? tryExpect(
//       final String input,dynamic actual,dynamic expected, String? errors,String testCaseTitle) {
//     try {
//       expect(actual, expected);
//     } catch (e) {
//       errors = (errors ?? '') + makerrorString(testCaseTitle, input, actual, expected);
//     }
//     return errors;
//   }
//
//   static String makerrorString(String testCaseTitle, String input, dynamic actual, dynamic expected) {
//     return ""
//         "\n\t$testCaseTitle  \n\t\t  "
//         "actual: ${addEndLines(actual.toString())} \n\t\t"
//         "expected: ${addEndLines(expected.toString())} \n\t\t.";
//   }
//
//   static List<String> extractDelimitersList(String delimitersPattern) {
//     String delimitersString = delimitersPattern;
//     delimitersString = delimitersString.substring(1);
//     delimitersString = delimitersString.substring(0, delimitersString.length - 1);
//     delimitersString = delimitersString.replaceAll('\\', '');
//     List<String> delimitersList = delimitersString.split('|');
//     return delimitersList;
//   }
//
//   static String addEndLines(String errorMessage) {
//     return errorMessage.replaceAll(RegExp('\n'), '\n\t\t\t\t  ');
//   }
// }
//
// ====================================================================================
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/dateTime_formatter_validator.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/time_formatter_validator.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/string_parse_result.dart';

import 'a_test_date_time_formatter.dart';

class TestDateFormatter implements ATestDateTimeFormatter {
  final DateFormatterValidator dateFormatter;

  TestDateFormatter(this.dateFormatter);

  @override
  StringParseResult makeDateTime(String text) {
    return dateFormatter.makeDateFromString(text);
  }
}

class TestTimeFormatter implements ATestDateTimeFormatter {
  final TimeFormatterValidator timeFormatter;

  TestTimeFormatter(this.timeFormatter);

  @override
  StringParseResult makeDateTime(String text) {
    return timeFormatter.makeTimeFromString(text);
  }
}

class TestDateTimeFormatter implements ATestDateTimeFormatter {
  final DateTimeFormatterValidator dateTimeFormatter;

  TestDateTimeFormatter(this.dateTimeFormatter);

  @override
  StringParseResult makeDateTime(String text) {
    return dateTimeFormatter.makeDateTimeFromString(text);
  }
}
