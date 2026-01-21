import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';
import '../../../../test_implementations/test_form_manager.dart';
import '../../../tools/date_time_test_data.dart';
import 'utils/dateTime_test_utils.dart';

void main() {
  const dateFieldKeyString = 'date_input_test';

  final today = DateTime.now();
  final todayAsString = Date.dateFormat.format(today);
  final mockCurrentDate = MockCurrentDate();
  when(mockCurrentDate.getDateNow()).thenReturn(today);

  var dateTimeLimits = DateTimeLimits(minDateTime: DateTime(2014), maxDateTime: DateTime(2026));

  testWidgets('DATE - refuses to parse with invalid characters', (WidgetTester tester) async {
    final List<DateTimeTestCase> testCases = [
      DateTimeTestCase("01 01", "${today.year}-01-01", true, ''),
      DateTimeTestCase("20/20", "${today.year}-20-20", true, ''),
      DateTimeTestCase("20-20", "${today.year}-20-20", true, ''),
      DateTimeTestCase("20", "20", true, ''),
      DateTimeTestCase("20ABCD", "20ABCD", true, ''),
      DateTimeTestCase("20-a", "20-a", true, ''),
      DateTimeTestCase("20-@", "20-@", true, ''),
      // -----------------------
      DateTimeTestCase(todayAsString.replaceAll("-", " "), todayAsString, true, ''),
      DateTimeTestCase(todayAsString, todayAsString, true, ''),
      // -----------------------
      DateTimeTestCase("20ABCD", "20", false, ''),
      DateTimeTestCase("20-a", "20-", false, ''),
      DateTimeTestCase("20-@", "20-", false, ''),
    ];
    final formManager = TestFormManager.testDefault();
    testAction<String>(String text) => (formManager.getFieldValue(dateFieldKeyString) as TextEditingValue).text;
    // testAction<String>(String text) => formManager.formKey.currentState!.fields[dateFieldKeyString]?.valueParsed;
    makeWidgetFunction(context, formManager) =>
        makeTextFieldDate(context, formManager, dateFieldKeyString, mockCurrentDate, dateTimeLimits);
    await testAllCasesInTextField(tester, makeWidgetFunction, formManager, testCases, testAction);
  });

  testWidgets('DATE - Should validate dates', (WidgetTester tester) async {
    final List<DateTimeTestCase> testCases = [
      DateTimeTestCase("01 01", "${today.year}-01-01", true, ''),
      DateTimeTestCase("20/20", "${today.year}-20-20", false, ''),
      DateTimeTestCase("20-20", "${today.year}-20-20", false, ''),
      DateTimeTestCase("20", "20", false, ''),
      DateTimeTestCase("20ABCD", "20ABCD", false, ''),
      DateTimeTestCase("20-a", "20-a", false, ''),
      DateTimeTestCase("20-@", "20-@", false, ''),
    ];
    final formManager = TestFormManager.testDefault();
    // var formManager = SingleFormManager();
    testAction<String>(String text) => (formManager.getFieldValue(dateFieldKeyString) as TextEditingValue).text;
    // testAction<String>(String text) => formManager.formKey.currentState!.fields[dateFieldKeyString]?.valueParsed;
    makeWidgetFunction(context, formManager) =>
        makeTextFieldDate(context, formManager, dateFieldKeyString, mockCurrentDate, dateTimeLimits);
    await testAllCasesInTextField(tester, makeWidgetFunction, formManager, testCases, testAction);
  });

  testWidgets('DATE - Should perform quick date formatting', (WidgetTester tester) async {
    final List<DateTimeTestCase> testCases = [
      DateTimeTestCase("01 01", "${today.year}-01-01", true, ''),
      DateTimeTestCase("1 1", "${today.year}-01-01", true, ''),
      DateTimeTestCase("1/15", "${today.year}-01-15", true, ''),
      DateTimeTestCase("${today.year} 01 01", "${today.year}-01-01", true, ''),
      DateTimeTestCase("${today.year}-5-05", "${today.year}-05-05", true, ''),
      DateTimeTestCase("30/12-4", "2030-12-04", true, ''),
      DateTimeTestCase("0101", "${today.year}-01-01", true, ''),
    ];
    final formManager = TestFormManager.testDefault();
    testAction<String>(String text) => (formManager.getFieldValue(dateFieldKeyString) as TextEditingValue).text;
    makeWidgetFunction(context, formManager) =>
        makeTextFieldDate(context, formManager, dateFieldKeyString, mockCurrentDate, dateTimeLimits);
    await testAllCasesInTextField(tester, makeWidgetFunction, formManager, testCases, testAction);
  });
}

Widget makeTextFieldDate(
  BuildContext context,
  FormManager formManager,
  String dateName,
  CurrentDate currentDate,
  DateTimeLimits dateTimeLimits,
) {
  // return DateTimeInputs.date(
  //   localizations: BricksLocalizations.of(context),
  //   context: context,
  //   keyString: dateName,
  //   label: dateName,
  //   labelPosition: LabelPosition.topLeft,
  //   formManager: formManager,
  //   currentDate: currentDate,
  //   dateLimits: dateTimeLimits,
  // );
  return DateField(keyString: dateName, formManager: formManager);
}

String verifyDate(String text) {
  try {
    return DateTime.parse(text).toString().split(' ')[0];
  } catch (e) {
    return "invalid date";
  }
}
