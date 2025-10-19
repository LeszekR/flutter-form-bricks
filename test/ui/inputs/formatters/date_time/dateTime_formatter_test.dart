// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:shipping_ui/config/params/app_params.dart';
// import 'package:shipping_ui/config/string_assets/translation.dart';
// import 'package:mockito/mockito.dart';
// import 'package:shipping_ui/ui/inputs/date_time/current_date.dart';
// import 'package:shipping_ui/ui/inputs/date_time/date_formatter_validator.dart';
// import 'package:shipping_ui/ui/inputs/date_time/dateTime_formatter_validator.dart';
// import 'package:shipping_ui/ui/inputs/date_time/date_time_utils.dart';
// import 'package:shipping_ui/ui/inputs/date_time/time_formatter_validator.dart';
//
// import '../../../../date_time_test_data.dart';
// import 'a_test_date_time_formatter.dart';
// import '../../../../test_utils.dart';
// import 'date_formatter_test.mocks.dart';
// import 'util_test_date_time.dart';
//
// @GenerateMocks([CurrentDate])
// void main() {
//   final dateTimeInputUtils = DateTimeUtils();
//   final mockCurrentDate = MockCurrentDate();
//   when(mockCurrentDate.getCurrentDate()).thenReturn(DateTime.parse('2024-02-01 22:11'));
//
//   var dateFormatter = DateFormatterValidator(dateTimeInputUtils, mockCurrentDate);
//   var timeFormatter = TimeFormatterValidator(dateTimeInputUtils);
//   ATestDateTimeFormatter dateTimeFormatter = TestDateTimeFormatter(
//       DateTimeFormatterValidator(dateFormatter, timeFormatter, dateTimeInputUtils));
//
//   var yearMaxBack = (mockCurrentDate
//       .getCurrentDate()
//       .year - AppParams.maxYearsBackInDate);
//   var yearMaxForward = (mockCurrentDate
//       .getCurrentDate()
//       .year + AppParams.maxYearsForwardInDate);
//
//   testWidgets('refuses to format excel-style invalid input', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData("2405011630", "2405011630", false, BricksLocalizations.of(context).datetimeStringErrorNoSpace),
//       DateTimeTestData("5121200", "5121200", false, BricksLocalizations.of(context).datetimeStringErrorNoSpace),
//       DateTimeTestData('22-03-03-15-33', '22-03-03-15-33', false, BricksLocalizations.of(context).datetimeStringErrorNoSpace),
//       DateTimeTestData('22 03 03 15/30', '22 03 03 15/30', false, BricksLocalizations.of(context).datetimeStringErrorTooManySpaces),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('invalid date', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData('25-16x8 1530', '25-16x8 15:30', false, BricksLocalizations.of(context).dateStringErrorBadChars),
//       DateTimeTestData('9  125', '9 01:25', false, BricksLocalizations.of(context).dateStringErrorTooFewDigits),
//       DateTimeTestData('222225566  2222', '222225566 22:22', false, BricksLocalizations.of(context).dateStringErrorTooManyDigits),
//       DateTimeTestData('2-5/66-8 1533', '2-5/66-8 15:33', false, BricksLocalizations.of(context).dateStringErrorTooManyDelimiters),
//       DateTimeTestData('5/667 233', '5/667 02:33', false, BricksLocalizations.of(context).dateStringErrorTooManyDigitsDay),
//       DateTimeTestData('333/66 12:12', '333/66 12:12', false, BricksLocalizations.of(context).dateStringErrorTooManyDigitsMonth),
//       DateTimeTestData('56688-1-66 0-0', '56688-1-66 00:00', false, BricksLocalizations.of(context).dateStringErrorTooManyDigitsYear),
//       DateTimeTestData('500  1-1', '2024-05-00 01:01', false, BricksLocalizations.of(context).dateErrorDay0),
//       DateTimeTestData('050 2:::15', '2024-00-50 02:15', false, BricksLocalizations.of(context).dateErrorMonth0 + '\n' + BricksLocalizations.of(context).dateErrorTooManyDaysInMonth),
//       DateTimeTestData('4--31 1515', '2024-04-31 15:15', false, BricksLocalizations.of(context).dateErrorTooManyDaysInMonth),
//       DateTimeTestData('5-15-2 8,8', '2025-15-02 08:08', false, BricksLocalizations.of(context).dateErrorMonthOver12),
//       DateTimeTestData('00;2;5 8;8', '2000-02-05 08:08', false, BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack)),
//       DateTimeTestData('50-11-5 6;15', '2050-11-05 06:15', false, BricksLocalizations.of(context).dateErrorYearTooFarForward(yearMaxForward)),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('invalid time', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData('622 15x30', '2024-06-22 15x30', false, BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData('50808 3-', '2025-08-08 3-', false, BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData('50808 32', '2025-08-08 32', false, BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData('50808 22551', '2025-08-08 22551', false, BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData(' 1215 8:30-5', '2024-12-15 8:30-5', false, BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//       DateTimeTestData('1215  8:333', '2024-12-15 8:333', false, BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData('1215  182:4', '2024-12-15 182:4', false, BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData('22-3-3 18:66', '2022-03-03 18:66', false, BricksLocalizations.of(context).timeErrorTooBigMinute),
//       DateTimeTestData('22-3-3 25-15', '2022-03-03 25:15', false, BricksLocalizations.of(context).timeErrorTooBigHour),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('dateStringErrorBadChars', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData(
//           '5x-6 18)10', '5x-6 18)10', false, BricksLocalizations.of(context).dateStringErrorBadChars + '\n' + BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData(
//           '5x-6 11', '5x-6 11', false, BricksLocalizations.of(context).dateStringErrorBadChars + '\n' + BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData('5x-6 12335', '5x-6 12335', false,
//           BricksLocalizations.of(context).dateStringErrorBadChars + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData('5x-6 15:13:1', '5x-6 15:13:1', false,
//           BricksLocalizations.of(context).dateStringErrorBadChars + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//       DateTimeTestData('5x-6 15-309', '5x-6 15-309', false,
//           BricksLocalizations.of(context).dateStringErrorBadChars + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData('5x-6 122:9', '5x-6 122:9', false,
//           BricksLocalizations.of(context).dateStringErrorBadChars + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData(
//           '5x-6 9-81', '5x-6 09:81', false, BricksLocalizations.of(context).dateStringErrorBadChars + '\n' + BricksLocalizations.of(context).timeErrorTooBigMinute),
//       DateTimeTestData(
//           '5x-6 30/5', '5x-6 30:05', false, BricksLocalizations.of(context).dateStringErrorBadChars + '\n' + BricksLocalizations.of(context).timeErrorTooBigHour),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('dateStringErrorTooFewDigits', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData(
//           '18 9x8', '18 9x8', false, BricksLocalizations.of(context).dateStringErrorTooFewDigits + '\n' + BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData(
//           '18 -9', '18 -9', false, BricksLocalizations.of(context).dateStringErrorTooFewDigits + '\n' + BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData('18 12330', '18 12330', false,
//           BricksLocalizations.of(context).dateStringErrorTooFewDigits + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData('18 09-12-04', '18 09-12-04', false,
//           BricksLocalizations.of(context).dateStringErrorTooFewDigits + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//       DateTimeTestData('18 24;111', '18 24;111', false,
//           BricksLocalizations.of(context).dateStringErrorTooFewDigits + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData('18 180:19', '18 180:19', false,
//           BricksLocalizations.of(context).dateStringErrorTooFewDigits + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData(
//           '18 23:70', '18 23:70', false, BricksLocalizations.of(context).dateStringErrorTooFewDigits + '\n' + BricksLocalizations.of(context).timeErrorTooBigMinute),
//       DateTimeTestData(
//           '18 25-13', '18 25:13', false, BricksLocalizations.of(context).dateStringErrorTooFewDigits + '\n' + BricksLocalizations.of(context).timeErrorTooBigHour),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('dateStringErrorTooManyDigits', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData('222233555 9x8', '222233555 9x8', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigits + '\n' + BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData('222233555 8', '222233555 8', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigits + '\n' + BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData('222233555 55580', '222233555 55580', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigits + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData('222233555 5-5-5', '222233555 5-5-5', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigits + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//       DateTimeTestData('222233555 5-120', '222233555 5-120', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigits + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData('222233555 1220;08', '222233555 1220;08', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigits + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData('222233555 22:81', '222233555 22:81', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigits + '\n' + BricksLocalizations.of(context).timeErrorTooBigMinute),
//       DateTimeTestData('222233555 29:08', '222233555 29:08', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigits + '\n' + BricksLocalizations.of(context).timeErrorTooBigHour),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('dateStringErrorTooManyDelimiters', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData('24-12-3-05 9x8', '24-12-3-05 9x8', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDelimiters + '\n' + BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData('24-12-3-05 8', '24-12-3-05 8', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDelimiters + '\n' + BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData('24-12-3-05 55580', '24-12-3-05 55580', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDelimiters + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData('24-12-3-05 5-5-5', '24-12-3-05 5-5-5', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDelimiters + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//       DateTimeTestData('24-12-3-05 5-120', '24-12-3-05 5-120', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDelimiters + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData('24-12-3-05 1220;08', '24-12-3-05 1220;08', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDelimiters + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData('24-12-3-05 22:81', '24-12-3-05 22:81', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDelimiters + '\n' + BricksLocalizations.of(context).timeErrorTooBigMinute),
//       DateTimeTestData('24-12-3-05 29:08', '24-12-3-05 29:08', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDelimiters + '\n' + BricksLocalizations.of(context).timeErrorTooBigHour),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('dateStringErrorTooManyDigitsDay', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData('2/5;233 9x8', '2/5;233 9x8', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsDay + '\n' + BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData('2/5;233 8', '2/5;233 8', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsDay + '\n' + BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData('2/5;233 55580', '2/5;233 55580', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsDay + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData('2/5;233 5-5-5', '2/5;233 5-5-5', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsDay + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//       DateTimeTestData('2/5;233 5-120', '2/5;233 5-120', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsDay + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData('2/5;233 1220;08', '2/5;233 1220;08', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsDay + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData('2/5;233 22:81', '2/5;233 22:81', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsDay + '\n' + BricksLocalizations.of(context).timeErrorTooBigMinute),
//       DateTimeTestData('2/5;233 29:08', '2/5;233 29:08', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsDay + '\n' + BricksLocalizations.of(context).timeErrorTooBigHour),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('dateStringErrorTooManyDigitsMonth', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData('2025-120-9 9x8', '2025-120-9 9x8', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsMonth + '\n' + BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData('2025-120-9 8', '2025-120-9 8', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsMonth + '\n' + BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData('2025-120-9 55580', '2025-120-9 55580', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsMonth + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData('2025-120-9 5-5-5', '2025-120-9 5-5-5', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsMonth + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//       DateTimeTestData('2025-120-9 5-120', '2025-120-9 5-120', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsMonth + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData('2025-120-9 1220;08', '2025-120-9 1220;08', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsMonth + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData('2025-120-9 22:81', '2025-120-9 22:81', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsMonth + '\n' + BricksLocalizations.of(context).timeErrorTooBigMinute),
//       DateTimeTestData('2025-120-9 29:08', '2025-120-9 29:08', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsMonth + '\n' + BricksLocalizations.of(context).timeErrorTooBigHour),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('dateStringErrorTooManyDigitsYear', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData('21025-2-9 9x8', '21025-2-9 9x8', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsYear + '\n' + BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData('21025-2-9 8', '21025-2-9 8', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsYear + '\n' + BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData('21025-2-9 55580', '21025-2-9 55580', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsYear + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData('21025-2-9 5-5-5', '21025-2-9 5-5-5', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsYear + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//       DateTimeTestData('21025-2-9 5-120', '21025-2-9 5-120', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsYear + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData('21025-2-9 1220;08', '21025-2-9 1220;08', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsYear + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData('21025-2-9 22:81', '21025-2-9 22:81', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsYear + '\n' + BricksLocalizations.of(context).timeErrorTooBigMinute),
//       DateTimeTestData('21025-2-9 29:08', '21025-2-9 29:08', false,
//           BricksLocalizations.of(context).dateStringErrorTooManyDigitsYear + '\n' + BricksLocalizations.of(context).timeErrorTooBigHour),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('dateErrorDay0', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData(
//           '5/00 9x8', '2024-05-00 9x8', false, BricksLocalizations.of(context).dateErrorDay0 + '\n' + BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData(
//           '5/00 8', '2024-05-00 8', false, BricksLocalizations.of(context).dateErrorDay0 + '\n' + BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData(
//           '5/00 55580', '2024-05-00 55580', false, BricksLocalizations.of(context).dateErrorDay0 + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData('5/00 5-5-5', '2024-05-00 5-5-5', false,
//           BricksLocalizations.of(context).dateErrorDay0 + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//       DateTimeTestData('5/00 5-120', '2024-05-00 5-120', false,
//           BricksLocalizations.of(context).dateErrorDay0 + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData('5/00 1220;08', '2024-05-00 1220;08', false,
//           BricksLocalizations.of(context).dateErrorDay0 + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData(
//           '5/00 22:81', '2024-05-00 22:81', false, BricksLocalizations.of(context).dateErrorDay0 + '\n' + BricksLocalizations.of(context).timeErrorTooBigMinute),
//       DateTimeTestData(
//           '5/00 29:08', '2024-05-00 29:08', false, BricksLocalizations.of(context).dateErrorDay0 + '\n' + BricksLocalizations.of(context).timeErrorTooBigHour),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('dateErrorMonth0', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData(
//           '022/0/08 9x8', '2022-00-08 9x8', false, BricksLocalizations.of(context).dateErrorMonth0 + '\n' + BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData(
//           '022/0/08 8', '2022-00-08 8', false, BricksLocalizations.of(context).dateErrorMonth0 + '\n' + BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData('022/0/08 55580', '2022-00-08 55580', false,
//           BricksLocalizations.of(context).dateErrorMonth0 + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData('022/0/08 5-5-5', '2022-00-08 5-5-5', false,
//           BricksLocalizations.of(context).dateErrorMonth0 + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//       DateTimeTestData('022/0/08 5-120', '2022-00-08 5-120', false,
//           BricksLocalizations.of(context).dateErrorMonth0 + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData('022/0/08 1220;08', '2022-00-08 1220;08', false,
//           BricksLocalizations.of(context).dateErrorMonth0 + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData(
//           '022/0/08 22:81', '2022-00-08 22:81', false, BricksLocalizations.of(context).dateErrorMonth0 + '\n' + BricksLocalizations.of(context).timeErrorTooBigMinute),
//       DateTimeTestData(
//           '022/0/08 29:08', '2022-00-08 29:08', false, BricksLocalizations.of(context).dateErrorMonth0 + '\n' + BricksLocalizations.of(context).timeErrorTooBigHour),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('dateErrorTooManyDaysInMonth', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData('5-9-61 9x8', '2025-09-61 9x8', false,
//           BricksLocalizations.of(context).dateErrorTooManyDaysInMonth + '\n' + BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData('5-9-61 8', '2025-09-61 8', false,
//           BricksLocalizations.of(context).dateErrorTooManyDaysInMonth + '\n' + BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData('5-9-61 55580', '2025-09-61 55580', false,
//           BricksLocalizations.of(context).dateErrorTooManyDaysInMonth + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData('5-9-61 5-5-5', '2025-09-61 5-5-5', false,
//           BricksLocalizations.of(context).dateErrorTooManyDaysInMonth + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//       DateTimeTestData('5-9-61 5-120', '2025-09-61 5-120', false,
//           BricksLocalizations.of(context).dateErrorTooManyDaysInMonth + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData('5-9-61 1220;08', '2025-09-61 1220;08', false,
//           BricksLocalizations.of(context).dateErrorTooManyDaysInMonth + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData('5-9-61 22:81', '2025-09-61 22:81', false,
//           BricksLocalizations.of(context).dateErrorTooManyDaysInMonth + '\n' + BricksLocalizations.of(context).timeErrorTooBigMinute),
//       DateTimeTestData('5-9-61 29:08', '2025-09-61 29:08', false,
//           BricksLocalizations.of(context).dateErrorTooManyDaysInMonth + '\n' + BricksLocalizations.of(context).timeErrorTooBigHour),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('dateErrorMonthOver12', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData(
//           '1519 9x8', '2024-15-19 9x8', false, BricksLocalizations.of(context).dateErrorMonthOver12 + '\n' + BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData(
//           '1519 8', '2024-15-19 8', false, BricksLocalizations.of(context).dateErrorMonthOver12 + '\n' + BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData('1519 55580', '2024-15-19 55580', false,
//           BricksLocalizations.of(context).dateErrorMonthOver12 + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData('1519 5-5-5', '2024-15-19 5-5-5', false,
//           BricksLocalizations.of(context).dateErrorMonthOver12 + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//       DateTimeTestData('1519 5-120', '2024-15-19 5-120', false,
//           BricksLocalizations.of(context).dateErrorMonthOver12 + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData('1519 1220;08', '2024-15-19 1220;08', false,
//           BricksLocalizations.of(context).dateErrorMonthOver12 + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData(
//           '1519 22:81', '2024-15-19 22:81', false, BricksLocalizations.of(context).dateErrorMonthOver12 + '\n' + BricksLocalizations.of(context).timeErrorTooBigMinute),
//       DateTimeTestData(
//           '1519 29:08', '2024-15-19 29:08', false, BricksLocalizations.of(context).dateErrorMonthOver12 + '\n' + BricksLocalizations.of(context).timeErrorTooBigHour),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('dateErrorYearTooFarBack (dateErrorYearTooFarBack)', (WidgetTester tester) async {
//     var yearMaxBack = (mockCurrentDate
//         .getCurrentDate()
//         .year - AppParams.maxYearsBackInDate);
//
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData('006/10/13 9x8', '2006-10-13 9x8', false,
//           BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) + '\n' + BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData('006/10/13 8', '2006-10-13 8', false,
//           BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) + '\n' + BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData('006/10/13 55580', '2006-10-13 55580', false,
//           BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData('006/10/13 5-5-5', '2006-10-13 5-5-5', false,
//           BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//       DateTimeTestData('006/10/13 5-120', '2006-10-13 5-120', false,
//           BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData('006/10/13 1220;08', '2006-10-13 1220;08', false,
//           BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData('006/10/13 22:81', '2006-10-13 22:81', false,
//           BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) + '\n' + BricksLocalizations.of(context).timeErrorTooBigMinute),
//       DateTimeTestData('006/10/13 29:08', '2006-10-13 29:08', false,
//           BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) + '\n' + BricksLocalizations.of(context).timeErrorTooBigHour),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('dateErrorYearTooFarForward (dateErrorYearTooFarForward)', (WidgetTester tester) async {
//     var yearMaxForward = (mockCurrentDate
//         .getCurrentDate()
//         .year + AppParams.maxYearsForwardInDate);
//
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData('36/10/13 9x8', '2036-10-13 9x8', false,
//           BricksLocalizations.of(context).dateErrorYearTooFarForward(yearMaxForward) + '\n' + BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData('36/10/13 8', '2036-10-13 8', false,
//           BricksLocalizations.of(context).dateErrorYearTooFarForward(yearMaxForward) + '\n' + BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData('36/10/13 55580', '2036-10-13 55580', false,
//           BricksLocalizations.of(context).dateErrorYearTooFarForward(yearMaxForward) + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData('36/10/13 5-5-5', '2036-10-13 5-5-5', false,
//           BricksLocalizations.of(context).dateErrorYearTooFarForward(yearMaxForward) + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//       DateTimeTestData('36/10/13 5-120', '2036-10-13 5-120', false,
//           BricksLocalizations.of(context).dateErrorYearTooFarForward(yearMaxForward) + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData('36/10/13 1220;08', '2036-10-13 1220;08', false,
//           BricksLocalizations.of(context).dateErrorYearTooFarForward(yearMaxForward) + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData('36/10/13 22:81', '2036-10-13 22:81', false,
//           BricksLocalizations.of(context).dateErrorYearTooFarForward(yearMaxForward) + '\n' + BricksLocalizations.of(context).timeErrorTooBigMinute),
//       DateTimeTestData('36/10/13 29:08', '2036-10-13 29:08', false,
//           BricksLocalizations.of(context).dateErrorYearTooFarForward(yearMaxForward) + '\n' + BricksLocalizations.of(context).timeErrorTooBigHour),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('multiple errors date and time', (WidgetTester tester) async {
//     var yearMaxForward = (mockCurrentDate
//         .getCurrentDate()
//         .year + AppParams.maxYearsForwardInDate);
//
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData(
//           "39/18/00 000-111", "2039-18-00 000-111", false,
//           BricksLocalizations.of(context).dateErrorYearTooFarForward(yearMaxForward) + '\n' +
//               BricksLocalizations.of(context).dateErrorMonthOver12 + '\n' +
//               BricksLocalizations.of(context).dateErrorDay0 + '\n' +
//               BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours + '\n' +
//               BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes,
//       ),
//       DateTimeTestData(
//           "01-0-80 5x60", "2001-00-80 5x60", false,
//           BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) + '\n' +
//               BricksLocalizations.of(context).dateErrorMonth0 + '\n' +
//               BricksLocalizations.of(context).dateErrorTooManyDaysInMonth + '\n' +
//               BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData(
//           "  01-0-00 12561", "2001-00-00 12561", false,
//           BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) + '\n' +
//               BricksLocalizations.of(context).dateErrorMonth0 + '\n' +
//               BricksLocalizations.of(context).dateErrorDay0 + '\n' +
//               BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData(
//           "01-0-31 5  ", "2001-00-31 5", false,
//           BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) + '\n' +
//               BricksLocalizations.of(context).dateErrorMonth0 + '\n' +
//               BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData(
//           "268855   05;06-09", "2026-88-55 05;06-09", false,
//           BricksLocalizations.of(context).dateErrorMonthOver12 + '\n' +
//               BricksLocalizations.of(context).dateErrorTooManyDaysInMonth + '\n' +
//               BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//       DateTimeTestData("0000/0/0   156;5699 ", "0000-00-00 156;5699", false,
//           BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) + '\n' +
//               BricksLocalizations.of(context).dateErrorMonth0 + '\n' +
//               BricksLocalizations.of(context).dateErrorDay0 + '\n' +
//               BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours + '\n' +
//               BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData(
//           "5588 55  15615", "5588 55 15615", false, BricksLocalizations.of(context).datetimeStringErrorTooManySpaces),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
//
//
//   testWidgets('makes date-time from valid string', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData('615 000', '2024-06-15 00:00', true, ''),
//       DateTimeTestData('0615 0-0', '2024-06-15 00:00', true, ''),
//       DateTimeTestData('3;12;18   6-30', '2023-12-18 06:30', true, ''),
//       DateTimeTestData('20150530 0615', '2015-05-30 06:15', true, ''),
//       DateTimeTestData('  18///11;18  6-3 ', '2018-11-18 06:03', true, ''),
//       // DateTimeTestData('..', '..', true, ''),
//       // DateTimeTestData('..', '..', true, ''),
//       // DateTimeTestData('..', '..', true, ''),
//       // DateTimeTestData('..', '..', true, ''),
//       // DateTimeTestData('..', '..', true, ''),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateTimeFormatter);
//     expect(passedOk, true);
//   });
// }
