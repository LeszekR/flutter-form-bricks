// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';
import '../../../date_time_test_data.dart';
import 'utils/dateTime_test_utils.dart';

void main() {
  const dateName = 'date_input_test';

  final today = DateTime.now();
  final todayAsString = Date.dateFormat.format(today);
  final mockCurrentDate = MockCurrentDate();
  when(mockCurrentDate.getDateNow()).thenReturn(today);

  var datTimLim = DateTimeLimits(minDateTimeRequired: DateTime(2014), maxDateTimeRequired: DateTime(2026));
  var yearMaxBack = datTimLim.minDateTimeRequired!.year;
  var yearMaxForward = datTimLim.maxDateTimeRequired!.year;

  testWidgets('DATE - refuses to parse with invalid characters', (WidgetTester tester) async {
    final List<DateTimeTestData> testCases = [
      DateTimeTestData(datTimLim, "01 01", "${today.year}-01-01", true, ''),
      DateTimeTestData(datTimLim, "20/20", "${today.year}-20-20", true, ''),
      DateTimeTestData(datTimLim, "20-20", "${today.year}-20-20", true, ''),
      DateTimeTestData(datTimLim, "20", "20", true, ''),
      DateTimeTestData(datTimLim, "20ABCD", "20ABCD", true, ''),
      DateTimeTestData(datTimLim, "20-a", "20-a", true, ''),
      DateTimeTestData(datTimLim, "20-@", "20-@", true, ''),
      // -----------------------
      DateTimeTestData(datTimLim, todayAsString.replaceAll("-", " "), todayAsString, true, ''),
      DateTimeTestData(datTimLim, todayAsString, todayAsString, true, ''),
      // -----------------------
      DateTimeTestData(datTimLim, "20ABCD", "20", false, ''),
      DateTimeTestData(datTimLim, "20-a", "20-", false, ''),
      DateTimeTestData(datTimLim, "20-@", "20-", false, ''),
    ];
    var formManager = SingleFormManager();
    testAction<String>(String text) => formManager.formKey.currentState!.fields[dateName]?.valueParsed;
    makeWidgetFunction(context) => makeTextFieldDate(context, dateName, formManager, mockCurrentDate, datTimLim);
    await testAllCasesInTextField(tester, makeWidgetFunction, formManager, testCases, testAction);
  });

  testWidgets('DATE - Should validate dates', (WidgetTester tester) async {
    final List<DateTimeTestData> testCases = [
      DateTimeTestData(datTimLim, "01 01", "${today.year}-01-01", true, ''),
      DateTimeTestData(datTimLim, "20/20", "${today.year}-20-20", false, ''),
      DateTimeTestData(datTimLim, "20-20", "${today.year}-20-20", false, ''),
      DateTimeTestData(datTimLim, "20", "20", false, ''),
      DateTimeTestData(datTimLim, "20ABCD", "20ABCD", false, ''),
      DateTimeTestData(datTimLim, "20-a", "20-a", false, ''),
      DateTimeTestData(datTimLim, "20-@", "20-@", false, ''),
    ];
    var formManager = SingleFormManager();
    testAction<String>(text) => verifyDate(formManager.formKey.currentState!.fields[dateName]?.valueParsed);
    makeWidgetFunction(context) => makeTextFieldDate(context, dateName, formManager, mockCurrentDate, datTimLim);
    await testAllCasesInTextField(tester, makeWidgetFunction, formManager, testCases, testAction);
  });

  testWidgets('DATE - Should perform quick date formatting', (WidgetTester tester) async {
    final List<DateTimeTestData> testCases = [
      DateTimeTestData(datTimLim, "01 01", "${today.year}-01-01", true, ''),
      DateTimeTestData(datTimLim, "1 1", "${today.year}-01-01", true, ''),
      DateTimeTestData(datTimLim, "1/15", "${today.year}-01-15", true, ''),
      DateTimeTestData(datTimLim, "${today.year} 01 01", "${today.year}-01-01", true, ''),
      DateTimeTestData(datTimLim, "${today.year}-5-05", "${today.year}-05-05", true, ''),
      DateTimeTestData(datTimLim, "30/12-4", "2030-12-04", true, ''),
      DateTimeTestData(datTimLim, "0101", "${today.year}-01-01", true, ''),
    ];
    var formManager = SingleFormManager();
    testAction<String>(String text) => formManager.formKey.currentState!.fields[dateName]?.valueParsed;
    makeWidgetFunction(context) => makeTextFieldDate(context, dateName, formManager, mockCurrentDate, datTimLim);
    // makeWidgetFunction() => makeTextFieldDate(dateName, formManager);
    await testAllCasesInTextField(tester, makeWidgetFunction, formManager, testCases, testAction);
  });
}

Widget makeTextFieldDate(
  BuildContext context,
  String dateName,
  FormManager formManager,
  CurrentDate currentDate,
  DateTimeLimits dateTimeLimits,
) {
  return DateTimeInputs.date(
    context: context,
    keyString: dateName,
    label: dateName,
    labelPosition: LabelPosition.topLeft,
    formManager: formManager,
    currentDate: currentDate,
    dateLimits: dateTimeLimits,
  );
}

String verifyDate(String text) {
  try {
    return DateTime.parse(text).toString().split(' ')[0];
  } catch (e) {
    return "invalid date";
  }
}
