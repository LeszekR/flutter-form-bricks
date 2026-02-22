import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/dateTime_formatter_validator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../mocks.mocks.dart';
import '../../../../tools/date_time_test_data.dart';
import '../utils/dateTime_formatter_test_utils.dart';
import '../utils/dateTime_test_utils.dart';

void main() {
  final dateTimeUtils = DateTimeUtils();
  final mockCurrentDate = MockCurrentDate();
  when(mockCurrentDate.getDateNow()).thenReturn(DateTime.parse('2024-02-01 22:11'));

  var dateTimeLimits = DateTimeLimits(
    fixedReferenceDateTime: mockCurrentDate.getDateNow(),
    maxMinutesBack: 5303520, // 2014-01-01
    maxMinutesForward: 1008000, // 2026-01-01
  );
  final String dateMaxBack = dateTimeUtils.formatDate(dateTimeLimits.minDateTime!, 'yyyy-MM-dd');

  final String dateMaxForward = dateTimeUtils.formatDate(dateTimeLimits.maxDateTime!, 'yyyy-MM-dd');

  TestDateTimeFormatter dateTimeFormatter = TestDateTimeFormatter(
    DateTimeFormatterValidator(dateTimeUtils, mockCurrentDate, dateTimeLimits),
  );

  testWidgets('refuses to format excel-style invalid input', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestCase("2405011630", "2405011630", false, local.datetimeStringErrorNoSpace),
      DateTimeTestCase("5121200", "5121200", false, local.datetimeStringErrorNoSpace),
      DateTimeTestCase('22-03-03-15-33', '22-03-03-15-33', false, local.datetimeStringErrorNoSpace),
      DateTimeTestCase('22 03 03 15/30', '22 03 03 15/30', false, local.datetimeStringErrorTooManySpaces),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('invalid date', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestCase('25-16x8 1530', '25-16x8 15:30', false, local.dateStringErrorBadChars),
      DateTimeTestCase('9  125', '9 01:25', false, local.dateStringErrorTooFewDigits),
      DateTimeTestCase('222225566  2222', '222225566 22:22', false, local.dateStringErrorTooManyDigits),
      DateTimeTestCase('2-5/66-8 1533', '2-5/66-8 15:33', false, local.dateStringErrorTooManyDelimiters),
      DateTimeTestCase('5/667 233', '5/667 02:33', false, local.dateStringErrorTooManyDigitsDay),
      DateTimeTestCase('333/66 12:12', '333/66 12:12', false, local.dateStringErrorTooManyDigitsMonth),
      DateTimeTestCase('56688-1-66 0-0', '56688-1-66 00:00', false, local.dateStringErrorTooManyDigitsYear),
      DateTimeTestCase('500  1-1', '2024-05-00 01:01', false, local.dateErrorDay0),
      DateTimeTestCase(
          '050 2:::15', '2024-00-50 02:15', false, local.dateErrorMonth0 + '\n' + local.dateErrorTooManyDaysInMonth),
      DateTimeTestCase('4--31 1515', '2024-04-31 15:15', false, local.dateErrorTooManyDaysInMonth),
      DateTimeTestCase('5-15-2 8,8', '2025-15-02 08:08', false, local.dateErrorMonthOver12),
      DateTimeTestCase('00;2;5 8;8', '2000-02-05 08:08', false, local.dateErrorTooFarBack(dateMaxBack)),
      DateTimeTestCase('50-11-5 6;15', '2050-11-05 06:15', false, local.dateErrorTooFarForward(dateMaxForward)),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('invalid time', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestCase('622 15x30', '2024-06-22 15x30', false, local.timeStringErrorBadChars),
      DateTimeTestCase('50808 3-', '2025-08-08 3-', false, local.timeStringErrorTooFewDigits),
      DateTimeTestCase('50808 32', '2025-08-08 32', false, local.timeStringErrorTooFewDigits),
      DateTimeTestCase('50808 22551', '2025-08-08 22551', false, local.timeStringErrorTooManyDigits),
      DateTimeTestCase(' 1215 8:30-5', '2024-12-15 8:30-5', false, local.timeStringErrorTooManyDelimiters),
      DateTimeTestCase('1215  8:333', '2024-12-15 8:333', false, local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestCase('1215  182:4', '2024-12-15 182:4', false, local.timeStringErrorTooManyDigitsHours),
      DateTimeTestCase('22-3-3 18:66', '2022-03-03 18:66', false, local.timeErrorTooBigMinute),
      DateTimeTestCase('22-3-3 25-15', '2022-03-03 25:15', false, local.timeErrorTooBigHour),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateStringErrorBadChars', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestCase(
          '5x-6 18)10', '5x-6 18)10', false, local.dateStringErrorBadChars + '\n' + local.timeStringErrorBadChars),
      DateTimeTestCase(
          '5x-6 11', '5x-6 11', false, local.dateStringErrorBadChars + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestCase(
          '5x-6 12335', '5x-6 12335', false, local.dateStringErrorBadChars + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestCase('5x-6 15:13:1', '5x-6 15:13:1', false,
          local.dateStringErrorBadChars + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestCase('5x-6 15-309', '5x-6 15-309', false,
          local.dateStringErrorBadChars + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestCase('5x-6 122:9', '5x-6 122:9', false,
          local.dateStringErrorBadChars + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestCase(
          '5x-6 9-81', '5x-6 09:81', false, local.dateStringErrorBadChars + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestCase(
          '5x-6 30/5', '5x-6 30:05', false, local.dateStringErrorBadChars + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateStringErrorTooFewDigits', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestCase(
          '18 9x8', '18 9x8', false, local.dateStringErrorTooFewDigits + '\n' + local.timeStringErrorBadChars),
      DateTimeTestCase(
          '18 -9', '18 -9', false, local.dateStringErrorTooFewDigits + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestCase(
          '18 12330', '18 12330', false, local.dateStringErrorTooFewDigits + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestCase('18 09-12-04', '18 09-12-04', false,
          local.dateStringErrorTooFewDigits + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestCase('18 24;111', '18 24;111', false,
          local.dateStringErrorTooFewDigits + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestCase('18 180:19', '18 180:19', false,
          local.dateStringErrorTooFewDigits + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestCase(
          '18 23:70', '18 23:70', false, local.dateStringErrorTooFewDigits + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestCase(
          '18 25-13', '18 25:13', false, local.dateStringErrorTooFewDigits + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateStringErrorTooManyDigits', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestCase('222233555 9x8', '222233555 9x8', false,
          local.dateStringErrorTooManyDigits + '\n' + local.timeStringErrorBadChars),
      DateTimeTestCase('222233555 8', '222233555 8', false,
          local.dateStringErrorTooManyDigits + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestCase('222233555 55580', '222233555 55580', false,
          local.dateStringErrorTooManyDigits + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestCase('222233555 5-5-5', '222233555 5-5-5', false,
          local.dateStringErrorTooManyDigits + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestCase('222233555 5-120', '222233555 5-120', false,
          local.dateStringErrorTooManyDigits + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestCase('222233555 1220;08', '222233555 1220;08', false,
          local.dateStringErrorTooManyDigits + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestCase('222233555 22:81', '222233555 22:81', false,
          local.dateStringErrorTooManyDigits + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestCase('222233555 29:08', '222233555 29:08', false,
          local.dateStringErrorTooManyDigits + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateStringErrorTooManyDelimiters', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestCase('24-12-3-05 9x8', '24-12-3-05 9x8', false,
          local.dateStringErrorTooManyDelimiters + '\n' + local.timeStringErrorBadChars),
      DateTimeTestCase('24-12-3-05 8', '24-12-3-05 8', false,
          local.dateStringErrorTooManyDelimiters + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestCase('24-12-3-05 55580', '24-12-3-05 55580', false,
          local.dateStringErrorTooManyDelimiters + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestCase('24-12-3-05 5-5-5', '24-12-3-05 5-5-5', false,
          local.dateStringErrorTooManyDelimiters + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestCase('24-12-3-05 5-120', '24-12-3-05 5-120', false,
          local.dateStringErrorTooManyDelimiters + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestCase('24-12-3-05 1220;08', '24-12-3-05 1220;08', false,
          local.dateStringErrorTooManyDelimiters + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestCase('24-12-3-05 22:81', '24-12-3-05 22:81', false,
          local.dateStringErrorTooManyDelimiters + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestCase('24-12-3-05 29:08', '24-12-3-05 29:08', false,
          local.dateStringErrorTooManyDelimiters + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateStringErrorTooManyDigitsDay', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestCase('2/5;233 9x8', '2/5;233 9x8', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.timeStringErrorBadChars),
      DateTimeTestCase('2/5;233 8', '2/5;233 8', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestCase('2/5;233 55580', '2/5;233 55580', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestCase('2/5;233 5-5-5', '2/5;233 5-5-5', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestCase('2/5;233 5-120', '2/5;233 5-120', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestCase('2/5;233 1220;08', '2/5;233 1220;08', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestCase('2/5;233 22:81', '2/5;233 22:81', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestCase('2/5;233 29:08', '2/5;233 29:08', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateStringErrorTooManyDigitsMonth', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestCase('2025-120-9 9x8', '2025-120-9 9x8', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.timeStringErrorBadChars),
      DateTimeTestCase('2025-120-9 8', '2025-120-9 8', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestCase('2025-120-9 55580', '2025-120-9 55580', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestCase('2025-120-9 5-5-5', '2025-120-9 5-5-5', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestCase('2025-120-9 5-120', '2025-120-9 5-120', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestCase('2025-120-9 1220;08', '2025-120-9 1220;08', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestCase('2025-120-9 22:81', '2025-120-9 22:81', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestCase('2025-120-9 29:08', '2025-120-9 29:08', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateStringErrorTooManyDigitsYear', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestCase('21025-2-9 9x8', '21025-2-9 9x8', false,
          local.dateStringErrorTooManyDigitsYear + '\n' + local.timeStringErrorBadChars),
      DateTimeTestCase('21025-2-9 8', '21025-2-9 8', false,
          local.dateStringErrorTooManyDigitsYear + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestCase('21025-2-9 55580', '21025-2-9 55580', false,
          local.dateStringErrorTooManyDigitsYear + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestCase('21025-2-9 5-5-5', '21025-2-9 5-5-5', false,
          local.dateStringErrorTooManyDigitsYear + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestCase('21025-2-9 5-120', '21025-2-9 5-120', false,
          local.dateStringErrorTooManyDigitsYear + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestCase('21025-2-9 1220;08', '21025-2-9 1220;08', false,
          local.dateStringErrorTooManyDigitsYear + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestCase('21025-2-9 22:81', '21025-2-9 22:81', false,
          local.dateStringErrorTooManyDigitsYear + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestCase('21025-2-9 29:08', '21025-2-9 29:08', false,
          local.dateStringErrorTooManyDigitsYear + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateErrorDay0', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestCase('5/00 9x8', '2024-05-00 9x8', false, local.dateErrorDay0 + '\n' + local.timeStringErrorBadChars),
      DateTimeTestCase('5/00 8', '2024-05-00 8', false, local.dateErrorDay0 + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestCase(
          '5/00 55580', '2024-05-00 55580', false, local.dateErrorDay0 + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestCase(
          '5/00 5-5-5', '2024-05-00 5-5-5', false, local.dateErrorDay0 + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestCase('5/00 5-120', '2024-05-00 5-120', false,
          local.dateErrorDay0 + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestCase('5/00 1220;08', '2024-05-00 1220;08', false,
          local.dateErrorDay0 + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestCase(
          '5/00 22:81', '2024-05-00 22:81', false, local.dateErrorDay0 + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestCase('5/00 29:08', '2024-05-00 29:08', false, local.dateErrorDay0 + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateErrorMonth0', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestCase(
          '022/0/08 9x8', '2022-00-08 9x8', false, local.dateErrorMonth0 + '\n' + local.timeStringErrorBadChars),
      DateTimeTestCase(
          '022/0/08 8', '2022-00-08 8', false, local.dateErrorMonth0 + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestCase('022/0/08 55580', '2022-00-08 55580', false,
          local.dateErrorMonth0 + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestCase('022/0/08 5-5-5', '2022-00-08 5-5-5', false,
          local.dateErrorMonth0 + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestCase('022/0/08 5-120', '2022-00-08 5-120', false,
          local.dateErrorMonth0 + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestCase('022/0/08 1220;08', '2022-00-08 1220;08', false,
          local.dateErrorMonth0 + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestCase(
          '022/0/08 22:81', '2022-00-08 22:81', false, local.dateErrorMonth0 + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestCase(
          '022/0/08 29:08', '2022-00-08 29:08', false, local.dateErrorMonth0 + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateErrorTooManyDaysInMonth', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestCase('5-9-61 9x8', '2025-09-61 9x8', false,
          local.dateErrorTooManyDaysInMonth + '\n' + local.timeStringErrorBadChars),
      DateTimeTestCase('5-9-61 8', '2025-09-61 8', false,
          local.dateErrorTooManyDaysInMonth + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestCase('5-9-61 55580', '2025-09-61 55580', false,
          local.dateErrorTooManyDaysInMonth + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestCase('5-9-61 5-5-5', '2025-09-61 5-5-5', false,
          local.dateErrorTooManyDaysInMonth + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestCase('5-9-61 5-120', '2025-09-61 5-120', false,
          local.dateErrorTooManyDaysInMonth + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestCase('5-9-61 1220;08', '2025-09-61 1220;08', false,
          local.dateErrorTooManyDaysInMonth + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestCase('5-9-61 22:81', '2025-09-61 22:81', false,
          local.dateErrorTooManyDaysInMonth + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestCase('5-9-61 29:08', '2025-09-61 29:08', false,
          local.dateErrorTooManyDaysInMonth + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateErrorMonthOver12', (WidgetTester tester) async {
    final local = await getLocalizations();

    var testCases = [
      DateTimeTestCase(
          '1519 9x8', '2024-15-19 9x8', false, local.dateErrorMonthOver12 + '\n' + local.timeStringErrorBadChars),
      DateTimeTestCase(
          '1519 8', '2024-15-19 8', false, local.dateErrorMonthOver12 + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestCase('1519 55580', '2024-15-19 55580', false,
          local.dateErrorMonthOver12 + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestCase('1519 5-5-5', '2024-15-19 5-5-5', false,
          local.dateErrorMonthOver12 + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestCase('1519 5-120', '2024-15-19 5-120', false,
          local.dateErrorMonthOver12 + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestCase('1519 1220;08', '2024-15-19 1220;08', false,
          local.dateErrorMonthOver12 + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestCase(
          '1519 22:81', '2024-15-19 22:81', false, local.dateErrorMonthOver12 + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestCase(
          '1519 29:08', '2024-15-19 29:08', false, local.dateErrorMonthOver12 + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateErrorTooFarBack (dateErrorTooFarBack)', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestCase('006/10/13 9x8', '2006-10-13 9x8', false,
          local.dateErrorTooFarBack(dateMaxBack) + '\n' + local.timeStringErrorBadChars),
      DateTimeTestCase('006/10/13 8', '2006-10-13 8', false,
          local.dateErrorTooFarBack(dateMaxBack) + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestCase('006/10/13 55580', '2006-10-13 55580', false,
          local.dateErrorTooFarBack(dateMaxBack) + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestCase('006/10/13 5-5-5', '2006-10-13 5-5-5', false,
          local.dateErrorTooFarBack(dateMaxBack) + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestCase('006/10/13 5-120', '2006-10-13 5-120', false,
          local.dateErrorTooFarBack(dateMaxBack) + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestCase('006/10/13 1220;08', '2006-10-13 1220;08', false,
          local.dateErrorTooFarBack(dateMaxBack) + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestCase('006/10/13 22:81', '2006-10-13 22:81', false,
          local.dateErrorTooFarBack(dateMaxBack) + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestCase('006/10/13 29:08', '2006-10-13 29:08', false,
          local.dateErrorTooFarBack(dateMaxBack) + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('dateErrorTooFarForward (dateErrorTooFarForward)', (WidgetTester tester) async {
    final local = await getLocalizations();

    var testCases = [
      DateTimeTestCase('36/10/13 9x8', '2036-10-13 9x8', false,
          local.dateErrorTooFarForward(dateMaxForward) + '\n' + local.timeStringErrorBadChars),
      DateTimeTestCase('36/10/13 8', '2036-10-13 8', false,
          local.dateErrorTooFarForward(dateMaxForward) + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestCase('36/10/13 55580', '2036-10-13 55580', false,
          local.dateErrorTooFarForward(dateMaxForward) + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestCase('36/10/13 5-5-5', '2036-10-13 5-5-5', false,
          local.dateErrorTooFarForward(dateMaxForward) + '\n' + local.timeStringErrorTooManyDelimiters),
      DateTimeTestCase('36/10/13 5-120', '2036-10-13 5-120', false,
          local.dateErrorTooFarForward(dateMaxForward) + '\n' + local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestCase('36/10/13 1220;08', '2036-10-13 1220;08', false,
          local.dateErrorTooFarForward(dateMaxForward) + '\n' + local.timeStringErrorTooManyDigitsHours),
      DateTimeTestCase('36/10/13 22:81', '2036-10-13 22:81', false,
          local.dateErrorTooFarForward(dateMaxForward) + '\n' + local.timeErrorTooBigMinute),
      DateTimeTestCase('36/10/13 29:08', '2036-10-13 29:08', false,
          local.dateErrorTooFarForward(dateMaxForward) + '\n' + local.timeErrorTooBigHour),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('multiple errors date and time', (WidgetTester tester) async {
    final local = await getLocalizations();

    var testCases = [
      DateTimeTestCase(
        "39/18/00 000-111",
        "2039-18-00 000-111",
        false,
        local.dateErrorMonthOver12 +
            '\n' +
            local.dateErrorDay0 +
            '\n' +
            local.timeStringErrorTooManyDigitsHours +
            '\n' +
            local.timeStringErrorTooManyDigitsMinutes,
      ),
      DateTimeTestCase("01-0-80 5x60", "2001-00-80 5x60", false,
          local.dateErrorMonth0 + '\n' + local.dateErrorTooManyDaysInMonth + '\n' + local.timeStringErrorBadChars),
      DateTimeTestCase("  01-0-00 12561", "2001-00-00 12561", false,
          local.dateErrorMonth0 + '\n' + local.dateErrorDay0 + '\n' + local.timeStringErrorTooManyDigits),
      DateTimeTestCase(
          "01-0-31 5  ", "2001-00-31 5", false, local.dateErrorMonth0 + '\n' + local.timeStringErrorTooFewDigits),
      DateTimeTestCase(
          "268855   05;06-09",
          "2026-88-55 05;06-09",
          false,
          local.dateErrorMonthOver12 +
              '\n' +
              local.dateErrorTooManyDaysInMonth +
              '\n' +
              local.timeStringErrorTooManyDelimiters),
      DateTimeTestCase(
          "0000/0/0   156;5699 ",
          "0000-00-00 156;5699",
          false,
          local.dateErrorMonth0 +
              '\n' +
              local.dateErrorDay0 +
              '\n' +
              local.timeStringErrorTooManyDigitsHours +
              '\n' +
              local.timeStringErrorTooManyDigitsMinutes),
      DateTimeTestCase("5588 55  15615", "5588 55 15615", false, local.datetimeStringErrorTooManySpaces),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });

  testWidgets('makes date-time from valid string', (WidgetTester tester) async {
    final local = await getLocalizations();
    var testCases = [
      DateTimeTestCase('615 000', '2024-06-15 00:00', true, null),
      DateTimeTestCase('0615 0-0', '2024-06-15 00:00', true, null),
      DateTimeTestCase('3;12;18   6-30', '2023-12-18 06:30', true, null),
      DateTimeTestCase('20150530 0615', '2015-05-30 06:15', true, null),
      DateTimeTestCase('  18///11;18  6-3 ', '2018-11-18 06:03', true, null),
      // DateTimeTestCase(dateTimeLimits,'..', '..', true, null),
      // DateTimeTestCase(dateTimeLimits,'..', '..', true, null),
      // DateTimeTestCase(dateTimeLimits,'..', '..', true, null),
      // DateTimeTestCase(dateTimeLimits,'..', '..', true, null),
      // DateTimeTestCase(dateTimeLimits,'..', '..', true, null),
    ];
    var passedOk = runDateTimeFormatterTest(local, testCases, dateTimeFormatter);
    expect(passedOk, true);
  });
}
