import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import '../../../../test_implementations/test_form_manager.dart';
import '../../../tools/date_time_test_data.dart';
import 'utils/dateTime_test_utils.dart';

void main() {
  const timeFieldKeyString = 'time_input_test';

  DateTimeLimits dateTimeLimits = DateTimeLimits(minDateTime: DateTime(2014), maxDateTime: DateTime(2026));

  testWidgets('TIME - should refuse to parse when bad character', (WidgetTester tester) async {
    final List<DateTimeTestCase> testCases = [
      DateTimeTestCase("01*01", "01*01", false, ''),
      DateTimeTestCase("20+", "20+", false, ''),
      DateTimeTestCase("20ABCD", "20ABCD", false, ''),
      DateTimeTestCase("20>20", "20>20", false, ''),
      DateTimeTestCase("20_20", "20_20", false, ''),
      DateTimeTestCase("20-a", "20-a", false, ''),
      DateTimeTestCase("20-@", "20-@", false, ''),
    ];
    final formManager = TestFormManager.testDefault();
    testAction<String>(String text) => (formManager.getFieldValue(timeFieldKeyString) as TextEditingValue).text;
    makeWidgetFunction(context, formManager) => makeTextFieldTime(context, timeFieldKeyString, formManager);
    await testAllCasesInTextField(tester, makeWidgetFunction, formManager, testCases, testAction);
  });

  testWidgets('TIME - Should refuse to parse when bad string', (WidgetTester tester) async {
    final List<DateTimeTestCase> testCases = [
      DateTimeTestCase("25:14", "25:14", false, ''),
      DateTimeTestCase("00:70", "00:70", false, ''),
      DateTimeTestCase("23:539", "23:539", false, ''),
      DateTimeTestCase("225:14", "25:14 ", false, ''),
      DateTimeTestCase(" 03330:70", "00:70", false, ''),
      DateTimeTestCase("2315 :539", "23:539", false, ''),
    ];
    final formManager = TestFormManager.testDefault();
    testAction<String>(String text) => (formManager.getFieldValue(timeFieldKeyString) as TextEditingValue).text;
    makeWidgetFunction(context, formManager) => makeTextFieldTime(context, timeFieldKeyString, formManager);
    await testAllCasesInTextField(tester, makeWidgetFunction, formManager, testCases, testAction);
  });

  testWidgets('TIME - Should validate time', (WidgetTester tester) async {
    final List<DateTimeTestCase> testCases = [
      DateTimeTestCase("01 01", "01:01", true, ''),
      DateTimeTestCase("21:14", "21:14", true, ''),
      DateTimeTestCase("00:00", "00:00", true, ''),
      DateTimeTestCase("23:59", "23:59", true, ''),
      // --------------------------------------------
      DateTimeTestCase("1:14", "01:14", true, ''),
      DateTimeTestCase("0/0", "00:00", true, ''),
      DateTimeTestCase("2359", "23:59", true, ''),
    ];
    final formManager = TestFormManager.testDefault();
    testAction<String>(String text) => (formManager.getFieldValue(timeFieldKeyString) as TextEditingValue).text;
    makeWidgetFunction(context, formManager) => makeTextFieldTime(context, timeFieldKeyString, formManager);
    await testAllCasesInTextField(tester, makeWidgetFunction, formManager, testCases, testAction);
  });
}

Widget makeTextFieldTime(
  BuildContext context,
  String timeName,
  FormManager formManager,
) {
  return DateTimeInputs.time(
    localizations: BricksLocalizations.of(context),
    context: context,
    keyString: timeName,
    label: timeName,
    labelPosition: LabelPosition.topLeft,
    formManager: formManager,
  );
}

String verifyTime(String text) {
  try {
    var dateTime = DateTime.parse('2024-01-01 $text');
    return DateFormat.Hm().format(dateTime);
  } catch (e) {
    return "invalid time";
  }
}
