import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/components/date_time_utils.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/dateTime_formatter_validator.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/time_formatter_validator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';
import '../../../date_time_test_data.dart';
import '../../../test_utils.dart';
import 'utils/a_test_dateTime_formatter.dart';
import 'utils/dateTime_test_utils.dart';

void main() {
  final dateTimeInputUtils = DateTimeUtils();
  final mockCurrentDate = MockCurrentDate();
  when(mockCurrentDate.getDateNow()).thenReturn(DateTime.parse('2024-02-01 22:11'));

  var dateFormatter = DateFormatterValidator(dateTimeInputUtils, mockCurrentDate);
  var timeFormatter = TimeFormatterValidator(dateTimeInputUtils);
  ATestDateTimeFormatter dateTimeFormatter =
      TestDateTimeFormatter(DateTimeFormatterValidator(dateFormatter, timeFormatter, dateTimeInputUtils));

  DateTimeLimits datTimLim = DateTimeLimits(minDateTime: DateTime(2014), maxDateTime: DateTime(2026));
  int yearMaxBack = datTimLim.minDateTime!.year;
  int yearMaxForward = datTimLim.maxDateTime!.year;

  testWidgets('refuses to format excel-style invalid input', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestData(datTimLim, "2405011630", "2405011630", false, local.datetimeStringErrorNoSpace),
      DateTimeTestData(datTimLim, "5121200", "5121200", false, local.datetimeStringErrorNoSpace),
      DateTimeTestData(datTimLim, '22-03-03-15-33', '22-03-03-15-33', false, local.datetimeStringErrorNoSpace),
      DateTimeTestData(datTimLim, '22 03 03 15/30', '22 03 03 15/30', false, local.datetimeStringErrorTooManySpaces),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('invalid date', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestData(datTimLim, '25-16x8 1530', '25-16x8 15:30', false, local.dateStringErrorBadChars),
      DateTimeTestData(datTimLim, '9  125', '9 01:25', false, local.dateStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, '222225566  2222', '222225566 22:22', false, local.dateStringErrorTooManyDigits),
      DateTimeTestData(datTimLim, '2-5/66-8 1533', '2-5/66-8 15:33', false, local.dateStringErrorTooManyDelimiters),
      DateTimeTestData(datTimLim, '5/667 233', '5/667 02:33', false, local.dateStringErrorTooManyDigitsDay),
      DateTimeTestData(datTimLim, '333/66 12:12', '333/66 12:12', false, local.dateStringErrorTooManyDigitsMonth),
      DateTimeTestData(datTimLim, '56688-1-66 0-0', '56688-1-66 00:00', false, local.dateStringErrorTooManyDigitsYear),
      DateTimeTestData(datTimLim, '500  1-1', '2024-05-00 01:01', false, local.dateErrorDay0),
      DateTimeTestData(datTimLim, '050 2:::15', '2024-00-50 02:15', false,
          local.dateErrorMonth0 + '\n' + local.dateErrorTooManyDaysInMonth),
      DateTimeTestData(datTimLim, '4--31 1515', '2024-04-31 15:15', false, local.dateErrorTooManyDaysInMonth),
      DateTimeTestData(datTimLim, '5-15-2 8,8', '2025-15-02 08:08', false, local.dateErrorMonthOver12),
      DateTimeTestData(datTimLim, '00;2;5 8;8', '2000-02-05 08:08', false, local.dateErrorTooFarBack(yearMaxBack)),
      DateTimeTestData(
          datTimLim, '50-11-5 6;15', '2050-11-05 06:15', false, local.dateErrorTooFarForward(yearMaxForward)),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('invalid time', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestData(datTimLim, '622 15x30', '2024-06-22 15x30', false, local.timeStringErrorBadChars),
      DateTimeTestData(datTimLim, '50808 3-', '2025-08-08 3-', false, local.timeStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, '50808 32', '2025-08-08 32', false, local.timeStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, '50808 22551', '2025-08-08 22551', false, local.timeStringErrorTooManyDigits),
      DateTimeTestData(datTimLim, ' 1215 8:30-5', '2024-12-15 8:30-5', false, local.timeStringErrorTooManyDelimiters),
      DateTimeTestData(datTimLim, '1215  8:333', '2024-12-15 8:333', false, local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestData(datTimLim, '1215  182:4', '2024-12-15 182:4', false, local.timeStringErrorTooManyDigitsHours),
      DateTimeTestData(datTimLim, '22-3-3 18:66', '2022-03-03 18:66', false, local.timeErrorTooBigMinute),
      DateTimeTestData(datTimLim, '22-3-3 25-15', '2022-03-03 25:15', false, local.timeErrorTooBigHour),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateStringErrorBadChars', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestData(datTimLim, '5x-6 18)10', '5x-6 18)10', false,
          local.dateStringErrorBadChars + '\n' + local.timeStringErrorBadChars),
      DateTimeTestData(datTimLim, '5x-6 11', '5x-6 11', false,
          local.dateStringErrorBadChars + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, '5x-6 12335', '5x-6 12335', false,
          local.dateStringErrorBadChars + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestData(datTimLim, '5x-6 15:13:1', '5x-6 15:13:1', false,
          local.dateStringErrorBadChars + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestData(datTimLim, '5x-6 15-309', '5x-6 15-309', false,
          local.dateStringErrorBadChars + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestData(datTimLim, '5x-6 122:9', '5x-6 122:9', false,
          local.dateStringErrorBadChars + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestData(datTimLim, '5x-6 9-81', '5x-6 09:81', false,
          local.dateStringErrorBadChars + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestData(datTimLim, '5x-6 30/5', '5x-6 30:05', false,
          local.dateStringErrorBadChars + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateStringErrorTooFewDigits', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestData(datTimLim, '18 9x8', '18 9x8', false,
          local.dateStringErrorTooFewDigits + '\n' + local.timeStringErrorBadChars),
      DateTimeTestData(datTimLim, '18 -9', '18 -9', false,
          local.dateStringErrorTooFewDigits + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, '18 12330', '18 12330', false,
          local.dateStringErrorTooFewDigits + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestData(datTimLim, '18 09-12-04', '18 09-12-04', false,
          local.dateStringErrorTooFewDigits + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestData(datTimLim, '18 24;111', '18 24;111', false,
          local.dateStringErrorTooFewDigits + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestData(datTimLim, '18 180:19', '18 180:19', false,
          local.dateStringErrorTooFewDigits + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestData(datTimLim, '18 23:70', '18 23:70', false,
          local.dateStringErrorTooFewDigits + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestData(datTimLim, '18 25-13', '18 25:13', false,
          local.dateStringErrorTooFewDigits + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateStringErrorTooManyDigits', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestData(datTimLim, '222233555 9x8', '222233555 9x8', false,
          local.dateStringErrorTooManyDigits + '\n' + local.timeStringErrorBadChars),
      DateTimeTestData(datTimLim, '222233555 8', '222233555 8', false,
          local.dateStringErrorTooManyDigits + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, '222233555 55580', '222233555 55580', false,
          local.dateStringErrorTooManyDigits + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestData(datTimLim, '222233555 5-5-5', '222233555 5-5-5', false,
          local.dateStringErrorTooManyDigits + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestData(datTimLim, '222233555 5-120', '222233555 5-120', false,
          local.dateStringErrorTooManyDigits + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestData(datTimLim, '222233555 1220;08', '222233555 1220;08', false,
          local.dateStringErrorTooManyDigits + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestData(datTimLim, '222233555 22:81', '222233555 22:81', false,
          local.dateStringErrorTooManyDigits + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestData(datTimLim, '222233555 29:08', '222233555 29:08', false,
          local.dateStringErrorTooManyDigits + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateStringErrorTooManyDelimiters', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestData(datTimLim, '24-12-3-05 9x8', '24-12-3-05 9x8', false,
          local.dateStringErrorTooManyDelimiters + '\n' + local.timeStringErrorBadChars),
      DateTimeTestData(datTimLim, '24-12-3-05 8', '24-12-3-05 8', false,
          local.dateStringErrorTooManyDelimiters + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, '24-12-3-05 55580', '24-12-3-05 55580', false,
          local.dateStringErrorTooManyDelimiters + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestData(datTimLim, '24-12-3-05 5-5-5', '24-12-3-05 5-5-5', false,
          local.dateStringErrorTooManyDelimiters + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestData(datTimLim, '24-12-3-05 5-120', '24-12-3-05 5-120', false,
          local.dateStringErrorTooManyDelimiters + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestData(datTimLim, '24-12-3-05 1220;08', '24-12-3-05 1220;08', false,
          local.dateStringErrorTooManyDelimiters + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestData(datTimLim, '24-12-3-05 22:81', '24-12-3-05 22:81', false,
          local.dateStringErrorTooManyDelimiters + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestData(datTimLim, '24-12-3-05 29:08', '24-12-3-05 29:08', false,
          local.dateStringErrorTooManyDelimiters + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateStringErrorTooManyDigitsDay', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestData(datTimLim, '2/5;233 9x8', '2/5;233 9x8', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.timeStringErrorBadChars),
      DateTimeTestData(datTimLim, '2/5;233 8', '2/5;233 8', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, '2/5;233 55580', '2/5;233 55580', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestData(datTimLim, '2/5;233 5-5-5', '2/5;233 5-5-5', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestData(datTimLim, '2/5;233 5-120', '2/5;233 5-120', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestData(datTimLim, '2/5;233 1220;08', '2/5;233 1220;08', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestData(datTimLim, '2/5;233 22:81', '2/5;233 22:81', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestData(datTimLim, '2/5;233 29:08', '2/5;233 29:08', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateStringErrorTooManyDigitsMonth', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestData(datTimLim, '2025-120-9 9x8', '2025-120-9 9x8', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.timeStringErrorBadChars),
      DateTimeTestData(datTimLim, '2025-120-9 8', '2025-120-9 8', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, '2025-120-9 55580', '2025-120-9 55580', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestData(datTimLim, '2025-120-9 5-5-5', '2025-120-9 5-5-5', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestData(datTimLim, '2025-120-9 5-120', '2025-120-9 5-120', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestData(datTimLim, '2025-120-9 1220;08', '2025-120-9 1220;08', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestData(datTimLim, '2025-120-9 22:81', '2025-120-9 22:81', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestData(datTimLim, '2025-120-9 29:08', '2025-120-9 29:08', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateStringErrorTooManyDigitsYear', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestData(datTimLim, '21025-2-9 9x8', '21025-2-9 9x8', false,
          local.dateStringErrorTooManyDigitsYear + '\n' + local.timeStringErrorBadChars),
      DateTimeTestData(datTimLim, '21025-2-9 8', '21025-2-9 8', false,
          local.dateStringErrorTooManyDigitsYear + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, '21025-2-9 55580', '21025-2-9 55580', false,
          local.dateStringErrorTooManyDigitsYear + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestData(datTimLim, '21025-2-9 5-5-5', '21025-2-9 5-5-5', false,
          local.dateStringErrorTooManyDigitsYear + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestData(datTimLim, '21025-2-9 5-120', '21025-2-9 5-120', false,
          local.dateStringErrorTooManyDigitsYear + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestData(datTimLim, '21025-2-9 1220;08', '21025-2-9 1220;08', false,
          local.dateStringErrorTooManyDigitsYear + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestData(datTimLim, '21025-2-9 22:81', '21025-2-9 22:81', false,
          local.dateStringErrorTooManyDigitsYear + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestData(datTimLim, '21025-2-9 29:08', '21025-2-9 29:08', false,
          local.dateStringErrorTooManyDigitsYear + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateErrorDay0', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestData(
          datTimLim, '5/00 9x8', '2024-05-00 9x8', false, local.dateErrorDay0 + '\n' + local.timeStringErrorBadChars),
      DateTimeTestData(
          datTimLim, '5/00 8', '2024-05-00 8', false, local.dateErrorDay0 + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, '5/00 55580', '2024-05-00 55580', false,
          local.dateErrorDay0 + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestData(datTimLim, '5/00 5-5-5', '2024-05-00 5-5-5', false,
          local.dateErrorDay0 + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestData(datTimLim, '5/00 5-120', '2024-05-00 5-120', false,
          local.dateErrorDay0 + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestData(datTimLim, '5/00 1220;08', '2024-05-00 1220;08', false,
          local.dateErrorDay0 + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestData(
          datTimLim, '5/00 22:81', '2024-05-00 22:81', false, local.dateErrorDay0 + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestData(
          datTimLim, '5/00 29:08', '2024-05-00 29:08', false, local.dateErrorDay0 + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateErrorMonth0', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestData(datTimLim, '022/0/08 9x8', '2022-00-08 9x8', false,
          local.dateErrorMonth0 + '\n' + local.timeStringErrorBadChars),
      DateTimeTestData(datTimLim, '022/0/08 8', '2022-00-08 8', false,
          local.dateErrorMonth0 + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, '022/0/08 55580', '2022-00-08 55580', false,
          local.dateErrorMonth0 + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestData(datTimLim, '022/0/08 5-5-5', '2022-00-08 5-5-5', false,
          local.dateErrorMonth0 + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestData(datTimLim, '022/0/08 5-120', '2022-00-08 5-120', false,
          local.dateErrorMonth0 + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestData(datTimLim, '022/0/08 1220;08', '2022-00-08 1220;08', false,
          local.dateErrorMonth0 + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestData(datTimLim, '022/0/08 22:81', '2022-00-08 22:81', false,
          local.dateErrorMonth0 + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestData(datTimLim, '022/0/08 29:08', '2022-00-08 29:08', false,
          local.dateErrorMonth0 + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateErrorTooManyDaysInMonth', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestData(datTimLim, '5-9-61 9x8', '2025-09-61 9x8', false,
          local.dateErrorTooManyDaysInMonth + '\n' + local.timeStringErrorBadChars),
      DateTimeTestData(datTimLim, '5-9-61 8', '2025-09-61 8', false,
          local.dateErrorTooManyDaysInMonth + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, '5-9-61 55580', '2025-09-61 55580', false,
          local.dateErrorTooManyDaysInMonth + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestData(datTimLim, '5-9-61 5-5-5', '2025-09-61 5-5-5', false,
          local.dateErrorTooManyDaysInMonth + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestData(datTimLim, '5-9-61 5-120', '2025-09-61 5-120', false,
          local.dateErrorTooManyDaysInMonth + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestData(datTimLim, '5-9-61 1220;08', '2025-09-61 1220;08', false,
          local.dateErrorTooManyDaysInMonth + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestData(datTimLim, '5-9-61 22:81', '2025-09-61 22:81', false,
          local.dateErrorTooManyDaysInMonth + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestData(datTimLim, '5-9-61 29:08', '2025-09-61 29:08', false,
          local.dateErrorTooManyDaysInMonth + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateErrorMonthOver12', (WidgetTester tester) async {
    final local = await getLocalizations();

    var testCases = [
      DateTimeTestData(datTimLim, '1519 9x8', '2024-15-19 9x8', false,
          local.dateErrorMonthOver12 + '\n' + local.timeStringErrorBadChars),
      DateTimeTestData(datTimLim, '1519 8', '2024-15-19 8', false,
          local.dateErrorMonthOver12 + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, '1519 55580', '2024-15-19 55580', false,
          local.dateErrorMonthOver12 + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestData(datTimLim, '1519 5-5-5', '2024-15-19 5-5-5', false,
          local.dateErrorMonthOver12 + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestData(datTimLim, '1519 5-120', '2024-15-19 5-120', false,
          local.dateErrorMonthOver12 + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestData(datTimLim, '1519 1220;08', '2024-15-19 1220;08', false,
          local.dateErrorMonthOver12 + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestData(datTimLim, '1519 22:81', '2024-15-19 22:81', false,
          local.dateErrorMonthOver12 + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestData(datTimLim, '1519 29:08', '2024-15-19 29:08', false,
          local.dateErrorMonthOver12 + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateErrorTooFarBack (dateErrorTooFarBack)', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestData(datTimLim, '006/10/13 9x8', '2006-10-13 9x8', false,
          local.dateErrorTooFarBack(yearMaxBack) + '\n' + local.timeStringErrorBadChars),
      DateTimeTestData(datTimLim, '006/10/13 8', '2006-10-13 8', false,
          local.dateErrorTooFarBack(yearMaxBack) + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, '006/10/13 55580', '2006-10-13 55580', false,
          local.dateErrorTooFarBack(yearMaxBack) + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestData(datTimLim, '006/10/13 5-5-5', '2006-10-13 5-5-5', false,
          local.dateErrorTooFarBack(yearMaxBack) + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestData(datTimLim, '006/10/13 5-120', '2006-10-13 5-120', false,
          local.dateErrorTooFarBack(yearMaxBack) + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestData(datTimLim, '006/10/13 1220;08', '2006-10-13 1220;08', false,
          local.dateErrorTooFarBack(yearMaxBack) + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestData(datTimLim, '006/10/13 22:81', '2006-10-13 22:81', false,
          local.dateErrorTooFarBack(yearMaxBack) + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestData(datTimLim, '006/10/13 29:08', '2006-10-13 29:08', false,
          local.dateErrorTooFarBack(yearMaxBack) + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateErrorTooFarForward (dateErrorTooFarForward)', (WidgetTester tester) async {
    final local = await getLocalizations();

    var testCases = [
      DateTimeTestData(datTimLim, '36/10/13 9x8', '2036-10-13 9x8', false,
          local.dateErrorTooFarForward(yearMaxForward) + '\n' + local.timeStringErrorBadChars),
      DateTimeTestData(datTimLim, '36/10/13 8', '2036-10-13 8', false,
          local.dateErrorTooFarForward(yearMaxForward) + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, '36/10/13 55580', '2036-10-13 55580', false,
          local.dateErrorTooFarForward(yearMaxForward) + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestData(datTimLim, '36/10/13 5-5-5', '2036-10-13 5-5-5', false,
          local.dateErrorTooFarForward(yearMaxForward) + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestData(datTimLim, '36/10/13 5-120', '2036-10-13 5-120', false,
          local.dateErrorTooFarForward(yearMaxForward) + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestData(datTimLim, '36/10/13 1220;08', '2036-10-13 1220;08', false,
          local.dateErrorTooFarForward(yearMaxForward) + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestData(datTimLim, '36/10/13 22:81', '2036-10-13 22:81', false,
          local.dateErrorTooFarForward(yearMaxForward) + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestData(datTimLim, '36/10/13 29:08', '2036-10-13 29:08', false,
          local.dateErrorTooFarForward(yearMaxForward) + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('multiple errors date and time', (WidgetTester tester) async {
    final local = await getLocalizations();

    var testCases = [
      DateTimeTestData(
        datTimLim,
        "39/18/00 000-111",
        "2039-18-00 000-111",
        false,
        local.dateErrorTooFarForward(yearMaxForward) +
            '\n' +
            local.dateErrorMonthOver12 +
            '\n' +
            local.dateErrorDay0 +
            '\n' +
            local.timeStringErrorTooManyDigitsHours +
            '\n' +
            local.timeStringErrorTooManyDigitsMinutes,
      ),
      DateTimeTestData(
          datTimLim,
          "01-0-80 5x60",
          "2001-00-80 5x60",
          false,
          local.dateErrorTooFarBack(yearMaxBack) +
              '\n' +
              local.dateErrorMonth0 +
              '\n' +
              local.dateErrorTooManyDaysInMonth +
              '\n' +
              local.timeStringErrorBadChars),
      DateTimeTestData(
          datTimLim,
          "  01-0-00 12561",
          "2001-00-00 12561",
          false,
          local.dateErrorTooFarBack(yearMaxBack) +
              '\n' +
              local.dateErrorMonth0 +
              '\n' +
              local.dateErrorDay0 +
              '\n' +
              local.timeStringErrorTooManyDigits),
      DateTimeTestData(
          datTimLim,
          "01-0-31 5  ",
          "2001-00-31 5",
          false,
          local.dateErrorTooFarBack(yearMaxBack) +
              '\n' +
              local.dateErrorMonth0 +
              '\n' +
              local.timeStringErrorTooFewDigits),
      DateTimeTestData(
          datTimLim,
          "268855   05;06-09",
          "2026-88-55 05;06-09",
          false,
          local.dateErrorMonthOver12 +
              '\n' +
              local.dateErrorTooManyDaysInMonth +
              '\n' +
              local.timeStringErrorTooManyDelimiters),
      DateTimeTestData(
          datTimLim,
          "0000/0/0   156;5699 ",
          "0000-00-00 156;5699",
          false,
          local.dateErrorTooFarBack(yearMaxBack) +
              '\n' +
              local.dateErrorMonth0 +
              '\n' +
              local.dateErrorDay0 +
              '\n' +
              local.timeStringErrorTooManyDigitsHours +
              '\n' +
              local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestData(datTimLim, "5588 55  15615", "5588 55 15615", false, local.datetimeStringErrorTooManySpaces),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('makes date-time from valid string', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestData(datTimLim, '615 000', '2024-06-15 00:00', true, ''),
      DateTimeTestData(datTimLim, '0615 0-0', '2024-06-15 00:00', true, ''),
      DateTimeTestData(datTimLim, '3;12;18   6-30', '2023-12-18 06:30', true, ''),
      DateTimeTestData(datTimLim, '20150530 0615', '2015-05-30 06:15', true, ''),
      DateTimeTestData(datTimLim, '  18///11;18  6-3 ', '2018-11-18 06:03', true, ''),
      // DateTimeTestData(datTimLim,'..', '..', true, ''),
      // DateTimeTestData(datTimLim,'..', '..', true, ''),
      // DateTimeTestData(datTimLim,'..', '..', true, ''),
      // DateTimeTestData(datTimLim,'..', '..', true, ''),
      // DateTimeTestData(datTimLim,'..', '..', true, ''),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });
}
