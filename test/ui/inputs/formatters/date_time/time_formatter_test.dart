// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:shipping_ui/config/string_assets/translation.dart';
// import 'package:shipping_ui/ui/inputs/date_time/current_date.dart';
// import 'package:shipping_ui/ui/inputs/date_time/date_time_utils.dart';
// import 'package:shipping_ui/ui/inputs/date_time/time_formatter_validator.dart';
//
// import '../../../../date_time_test_data.dart';
// import '../../../../test_utils.dart';
// import 'util_test_date_time.dart';
//
// @GenerateMocks([CurrentDate])
// void main() {
//   final dateTimeInputUtils = DateTimeUtils();
//   TestTimeFormatter timeFormatter = TestTimeFormatter(TimeFormatterValidator(dateTimeInputUtils));
//
//   testWidgets('refuses to format excel-style time when input with delimiters incorrect', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData(datTimLim,"4=8", "4=8", false, BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData(datTimLim,"15+2", "15+2", false, BricksLocalizations.of(context).timeStringErrorBadChars),
//       DateTimeTestData(datTimLim,"00)12", "00)12", false, BricksLocalizations.of(context).timeStringErrorBadChars),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(localizat, testCases, timeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('refuses to format excel-style time when input digits-only incorrect', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData(datTimLim,"0", "0", false, BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData(datTimLim,"01", "01", false, BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData(datTimLim,"/01", "/01", false, BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData(datTimLim,"01-", "01-", false, BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       DateTimeTestData(datTimLim,"01 ", "01 ", false, BricksLocalizations.of(context).timeStringErrorTooFewDigits),
//       // ---------------------------------------------
//       DateTimeTestData(datTimLim,"  000  12", "  000  12", false, BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       // ---------------------------------------------
//       DateTimeTestData(datTimLim,":01231", ":01231", false, BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData(datTimLim,"01231--", "01231--", false, BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData(datTimLim,"01231", "01231", false, BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData(datTimLim,"001231", "001231", false, BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData(datTimLim,"000001", "000001", false, BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData(datTimLim,"211231", "211231", false, BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData(datTimLim,"0211231", "0211231", false, BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       DateTimeTestData(datTimLim,"20211231", "20211231", false, BricksLocalizations.of(context).timeStringErrorTooManyDigits),
//       // ---------------------------------------------
//       DateTimeTestData(datTimLim,"1--;23:05", "1--;23:05", false, BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(localizat, testCases, timeFormatter);
//     expect(passedOk, true);
//   });
//
//   testWidgets('refuses to format excel-style time when too many element digits', (WidgetTester tester) async {
//     var p = '=';
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData(datTimLim,"1${p}235", "1${p}235", false, BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData(datTimLim,"1${p}66235", "1${p}66235", false, BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       // -------------------------------------------------
//       DateTimeTestData(datTimLim,"123${p}5", "123${p}5", false, BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData(datTimLim,"100${p}235", "100${p}235", false,
//           BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData(datTimLim,"123888${p}3335", "123888${p}3335", false,
//           BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       // -------------------------------------------------
//       DateTimeTestData(datTimLim,"1${p}61", "01:61", false, BricksLocalizations.of(context).timeErrorTooBigMinute),
//       DateTimeTestData(datTimLim,"25${p}5", "25:05", false, BricksLocalizations.of(context).timeErrorTooBigHour),
//       // -------------------------------------------------
//       DateTimeTestData(datTimLim,"0991${p}66235", "0991${p}66235", false,
//           BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours + '\n' + BricksLocalizations.of(context).timeStringErrorTooManyDigitsMinutes),
//       DateTimeTestData(datTimLim,"000${p}12", "000${p}12", false, BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData(datTimLim,"000${p}12 ", "000${p}12 ", false, BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData(datTimLim,"000 12 ", "000 12 ", false, BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//       DateTimeTestData(datTimLim," 000  12", " 000  12", false, BricksLocalizations.of(context).timeStringErrorTooManyDigitsHours),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(localizat, 
//       testCases,
//       timeFormatter,
//       delimitersPattern: TimeFormatterValidator.timeDelimiterPattern,
//       placeholder: p,
//     );
//     expect(passedOk, true);
//   });
//
//   testWidgets('refuses to format excel-style time when too many delimiters', (WidgetTester tester) async {
//     var p = '=';
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData(datTimLim,"1,23${p}5", "1,23${p}5", false, BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//       DateTimeTestData(datTimLim,"0-8${p}8:8", "0-8${p}8:8", false, BricksLocalizations.of(context).timeStringErrorTooManyDelimiters),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(localizat, 
//       testCases,
//       timeFormatter,
//       delimitersPattern: TimeFormatterValidator.timeDelimiterPattern,
//       placeholder: p,
//     );
//     expect(passedOk, true);
//   });
//
//   testWidgets('creates formatted time string from excel-style input', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData(datTimLim,"1-12", "01:12", true, ''),
//       DateTimeTestData(datTimLim,"01/12", "01:12", true, ''),
//       DateTimeTestData(datTimLim,"01:2", "01:02", true, ''),
//       DateTimeTestData(datTimLim,"01 23", "01:23", true, ''),
//       DateTimeTestData(datTimLim,"13/5", "13:05", true, ''),
//       DateTimeTestData(datTimLim,"00,00", "00:00", true, ''),
//       DateTimeTestData(datTimLim,"00- 01", "00:01", true, ''),
//       DateTimeTestData(datTimLim," 012", "00:12", true, ''),
//       DateTimeTestData(datTimLim,"0/1", "00:01", true, ''),
//       DateTimeTestData(datTimLim,"0  12  ", "00:12", true, ''),
//       DateTimeTestData(datTimLim,"00 , 00", "00:00", true, ''),
//       DateTimeTestData(datTimLim,"00-- 01", "00:01", true, ''),
//       DateTimeTestData(datTimLim," 012", "00:12", true, ''),
//       DateTimeTestData(datTimLim,"0////1", "00:01", true, ''),
//       DateTimeTestData(datTimLim,"0 12  ", "00:12", true, ''),
//     ];
//     UtilTestDateTime.testDateTimeFormatter(localizat, testCases, timeFormatter);
//   });
//
//   testWidgets('creates formatted time string from digits only input', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//     var testCases = [
//       DateTimeTestData(datTimLim,"001", "00:01", true, ''),
//       DateTimeTestData(datTimLim,"0201", "02:01", true, ''),
//       DateTimeTestData(datTimLim,"0000", "00:00", true, ''),
//       DateTimeTestData(datTimLim,"0201", "02:01", true, ''),
//       DateTimeTestData(datTimLim,"0000", "00:00", true, ''),
//     ];
//     UtilTestDateTime.testDateTimeFormatter(localizat, testCases, timeFormatter);
//   });
//
//   testWidgets('shows error on invalid time', (WidgetTester tester) async {
//     await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));

//     var testCases = [
//       DateTimeTestData(datTimLim,"1865", "18:65", false, BricksLocalizations.of(context).timeErrorTooBigMinute),
//       DateTimeTestData(datTimLim,"2500", "25:00", false, BricksLocalizations.of(context).timeErrorTooBigHour),
//     ];
//     var passedOk = UtilTestDateTime.testDateTimeFormatter(localizat, testCases, timeFormatter);
//     expect(passedOk, true);
//   });
// }
