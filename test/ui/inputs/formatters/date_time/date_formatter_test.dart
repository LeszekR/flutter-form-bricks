import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/components/date_time_utils.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../date_time_test_data.dart';
import '../../../test_utils.dart';
import 'a_test_date_time_formatter.dart';
import 'dateTime_format_random_test.mocks.dart';
import 'util_test_date_time.dart';

@GenerateMocks([CurrentDate])
void main() {
  final dateTimeInputUtils = DateTimeUtils();
  final mockCurrentDate = MockCurrentDate();
  when(mockCurrentDate.getCurrentDate()).thenReturn(DateTime.parse('2024-02-01 22:11'));
  ATestDateTimeFormatter dateFormatter = TestDateFormatter(DateFormatterValidator(dateTimeInputUtils, mockCurrentDate));

  testWidgets('refuses to format excel-style invalid input', (WidgetTester tester) async {
    await TestUtils.prepareWidget(tester, null);
    final BuildContext context = tester.element(find.byType(Scaffold));

    var testCases = [
      DateTimeTestData("0", "0", false, BricksLocalizations.of(context).dateStringErrorTooFewDigits),
      DateTimeTestData("01", "01", false, BricksLocalizations.of(context).dateStringErrorTooFewDigits),
      // --------------------------------------------
      DateTimeTestData("2024-5", "2024-5", false, BricksLocalizations.of(context).dateStringErrorTooManyDigitsMonth),
      DateTimeTestData("3/132", "3/132", false, BricksLocalizations.of(context).dateStringErrorTooManyDigitsDay),
      // --------------------------------------------
      DateTimeTestData(
          "112,312",
          "112,312",
          false,
          BricksLocalizations.of(context).dateStringErrorTooManyDigitsDay +
              '\n' +
              BricksLocalizations.of(context).dateStringErrorTooManyDigitsMonth),
      // --------------------------------------------
      DateTimeTestData("000,12", "000,12", false, BricksLocalizations.of(context).dateStringErrorTooManyDigitsMonth),
      DateTimeTestData("112,12", "112,12", false, BricksLocalizations.of(context).dateStringErrorTooManyDigitsMonth),
      // --------------------------------------------
      DateTimeTestData(
          "21000,12,9", "21000,12,9", false, BricksLocalizations.of(context).dateStringErrorTooManyDigitsYear),
      DateTimeTestData(
          "21000,124,9",
          "21000,124,9",
          false,
          BricksLocalizations.of(context).dateStringErrorTooManyDigitsMonth +
              '\n' +
              BricksLocalizations.of(context).dateStringErrorTooManyDigitsYear),
      DateTimeTestData(
          "21000,124,911",
          "21000,124,911",
          false,
          BricksLocalizations.of(context).dateStringErrorTooManyDigitsDay +
              '\n' +
              BricksLocalizations.of(context).dateStringErrorTooManyDigitsMonth +
              '\n' +
              BricksLocalizations.of(context).dateStringErrorTooManyDigitsYear),
      // --------------------------------------------
      DateTimeTestData("01-0", "2024-01-00", false, BricksLocalizations.of(context).dateErrorDay0),
      DateTimeTestData("0100", "2024-01-00", false, BricksLocalizations.of(context).dateErrorDay0),
      DateTimeTestData("01-00", "2024-01-00", false, BricksLocalizations.of(context).dateErrorDay0),
      // --------------------------------------------
      DateTimeTestData("001", "2024-00-01", false, BricksLocalizations.of(context).dateErrorMonth0),
      DateTimeTestData("012", "2024-00-12", false, BricksLocalizations.of(context).dateErrorMonth0),
      DateTimeTestData("0/1", "2024-00-01", false, BricksLocalizations.of(context).dateErrorMonth0),
      DateTimeTestData("0 12", "2024-00-12", false, BricksLocalizations.of(context).dateErrorMonth0),
      // --------------------------------------------
      DateTimeTestData("00- 01", "2024-00-01", false, BricksLocalizations.of(context).dateErrorMonth0),
      // --------------------------------------------
      DateTimeTestData("431", "2024-04-31", false, BricksLocalizations.of(context).dateErrorTooManyDaysInMonth),
      DateTimeTestData("532", "2024-05-32", false, BricksLocalizations.of(context).dateErrorTooManyDaysInMonth),
      DateTimeTestData("3-2-29", "2023-02-29", false, BricksLocalizations.of(context).dateErrorTooManyDaysInMonth),
      DateTimeTestData("40230", "2024-02-30", false, BricksLocalizations.of(context).dateErrorTooManyDaysInMonth),
      // --------------------------------------------
      DateTimeTestData("3123", "2024-31-23", false, BricksLocalizations.of(context).dateErrorMonthOver12),
    ];
    var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateFormatter);
    expect(passedOk, true);
  });

  testWidgets('refuses to format date when forbidden chars', (WidgetTester tester) async {
    await TestUtils.prepareWidget(tester, null);
    final BuildContext context = tester.element(find.byType(Scaffold));
    var testCases = [
      DateTimeTestData("00=12", "00=12", false, BricksLocalizations.of(context).dateStringErrorBadChars),
      DateTimeTestData("01\\12", "01\\12", false, BricksLocalizations.of(context).dateStringErrorBadChars),
      DateTimeTestData("01*2", "01*2", false, BricksLocalizations.of(context).dateStringErrorBadChars),
      DateTimeTestData("01+23", "01+23", false, BricksLocalizations.of(context).dateStringErrorBadChars),
    ];
    var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateFormatter);
    expect(passedOk, true);
  });

  testWidgets('creates formatted date string from digits only', (WidgetTester tester) async {
    await TestUtils.prepareWidget(tester, null);
    final BuildContext context = tester.element(find.byType(Scaffold));
    var testCases = [
      DateTimeTestData("123", "2024-01-23", true, ''),
      DateTimeTestData("0123", "2024-01-23", true, ''),
      DateTimeTestData("01231", "2020-12-31", true, ''),
      DateTimeTestData("31231", "2023-12-31", true, ''),
      DateTimeTestData("211231", "2021-12-31", true, ''),
      DateTimeTestData("0211231", "2021-12-31", true, ''),
      DateTimeTestData("20211231", "2021-12-31", true, ''),
    ];
    var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateFormatter);
    expect(passedOk, true);
  });

  testWidgets('creates formatted date string from excel-style input', (WidgetTester tester) async {
    await TestUtils.prepareWidget(tester, null);
    final BuildContext context = tester.element(find.byType(Scaffold));
    var testCases = [
      DateTimeTestData("2;2", "2024-02-02", true, ''),
      DateTimeTestData("4/01,23", "2024-01-23", true, ''),
      DateTimeTestData("24;1-23", "2024-01-23", true, ''),
    ];
    var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateFormatter);
    expect(passedOk, true);
  });

  testWidgets('creates formatted date string with all possible delimiters', (WidgetTester tester) async {
    await TestUtils.prepareWidget(tester, null);
    final BuildContext context = tester.element(find.byType(Scaffold));
    var p = '=';
    var testCases = [
      DateTimeTestData("2${p}2", "2024-02-02", true, ''),
      DateTimeTestData("04${p}8", "2024-04-08", true, ''),
      DateTimeTestData("1${p}12", "2024-01-12", true, ''),
      DateTimeTestData("01${p}12", "2024-01-12", true, ''),
      DateTimeTestData("01${p}2", "2024-01-02", true, ''),
      DateTimeTestData("01${p}23", "2024-01-23", true, ''),
      DateTimeTestData("4${p}01${p}23", "2024-01-23", true, ''),
      DateTimeTestData("24${p}1${p}23", "2024-01-23", true, ''),
    ];
    var passedOk = UtilTestDateTime.testDateTimeFormatter(
      testCases,
      dateFormatter,
      delimitersPattern: DateFormatterValidator.dateDelimiterPattern,
      placeholder: p,
    );
    expect(passedOk, true);
  });

  // testWidgets('copes with bad chars', (WidgetTester tester) async {
  //   await TestUtils.prepareWidget(tester, null);
  //  final BuildContext context = tester.element(find.byType(Scaffold));
  //   var p = '=';
  //   var testCases = [
  //     DateTimeTestData("1=12", "2024-01-12", true, ''),
  //     DateTimeTestData("% 22& 12=5", "2022-01-12", true, ''),
  //     DateTimeTestData("0=12", "2024-00-12", false, BricksLocalizations.of(context).dateStringErrorBadChars),
  //     DateTimeTestData("5+1=12", "2024-51-12", false, BricksLocalizations.of(context).dateErrorMonthOver12),
  //     DateTimeTestData("5+11=12", "2025-05-11", false, BricksLocalizations.of(context).dateStringErrorBadChars),
  //     DateTimeTestData(" 4=++30 *&", "2024-04-30", false, BricksLocalizations.of(context).dateErrorMonthOver12),
  //   ];
  //   var passedOk = UtilTestDateTime.testDateTimeFormatter(
  //     testCases,
  //     dateFormatter,
  //     delimitersPattern: DateFormatterValidator.dateDelimiterPattern,
  //     placeholder: p,
  //   );
  //   expect(passedOk, true);
  // });

  testWidgets('date too early or too late', (WidgetTester tester) async {
    await TestUtils.prepareWidget(tester, null);
    final BuildContext context = tester.element(find.byType(Scaffold));
    final localizations = BricksLocalizations.of(context);

    var yearMaxBack = (mockCurrentDate.getCurrentDate().year - AppParams.maxYearsBackInDate);
    var yearMaxForward = (mockCurrentDate.getCurrentDate().year + AppParams.maxYearsForwardInDate);

    var testCases = [
      DateTimeTestData("0000,12,9", "0000-12-09", false, localizations.dateErrorYearTooFarBack(yearMaxBack)),
      DateTimeTestData("001231", "2000-12-31", false, localizations.dateErrorYearTooFarBack(yearMaxBack)),
      DateTimeTestData("301231", "2030-12-31", false, localizations.dateErrorYearTooFarForward(yearMaxForward)),
    ];
    var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateFormatter);
    expect(passedOk, true);
  });

  testWidgets('date invalid', (WidgetTester tester) async {
    await TestUtils.prepareWidget(tester, null);
    final BuildContext context = tester.element(find.byType(Scaffold));
    var localizations = BricksLocalizations.of(context);

    var yearMaxBack = (mockCurrentDate.getCurrentDate().year - AppParams.maxYearsBackInDate);
    var yearMaxForward = (mockCurrentDate.getCurrentDate().year + AppParams.maxYearsForwardInDate);

    var testCases = [
      DateTimeTestData("26/08/0", "2026-08-00", false, localizations.dateErrorDay0),
      DateTimeTestData("01-0", "2024-01-00", false, localizations.dateErrorDay0),
      DateTimeTestData("0100", "2024-01-00", false, localizations.dateErrorDay0),
      DateTimeTestData("01-00", "2024-01-00", false, localizations.dateErrorDay0),
      // --------------------------------------------
      DateTimeTestData("24,00,9", "2024-00-09", false, localizations.dateErrorMonth0),
      DateTimeTestData("001", "2024-00-01", false, localizations.dateErrorMonth0),
      DateTimeTestData("012", "2024-00-12", false, localizations.dateErrorMonth0),
      DateTimeTestData("0/1", "2024-00-01", false, localizations.dateErrorMonth0),
      DateTimeTestData("0 12", "2024-00-12", false, localizations.dateErrorMonth0),
      // --------------------------------------------
      DateTimeTestData("00- 01", "2024-00-01", false, localizations.dateErrorMonth0),
      // --------------------------------------------
      DateTimeTestData("431", "2024-04-31", false, localizations.dateErrorTooManyDaysInMonth),
      DateTimeTestData("532", "2024-05-32", false, localizations.dateErrorTooManyDaysInMonth),
      DateTimeTestData("3-2-29", "2023-02-29", false, localizations.dateErrorTooManyDaysInMonth),
      DateTimeTestData("40230", "2024-02-30", false, localizations.dateErrorTooManyDaysInMonth),
      // --------------------------------------------
      DateTimeTestData("3123", "2024-31-23", false, localizations.dateErrorMonthOver12),
      // ---------------------------------------
      DateTimeTestData("26/08/55", "2026-08-55", false, localizations.dateErrorTooManyDaysInMonth),
      DateTimeTestData("24,13,9", "2024-13-09", false, localizations.dateErrorMonthOver12),
      DateTimeTestData("268831", "2026-88-31", false, localizations.dateErrorMonthOver12),
      // ---------------------------------------
      DateTimeTestData(
          "19001216", "1900-12-16", false, localizations.dateErrorYearTooFarBack(yearMaxBack)),
      DateTimeTestData(
          "39001216", "3900-12-16", false, localizations.dateErrorYearTooFarForward(yearMaxForward)),
    ];
    var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateFormatter);
    expect(passedOk, true);
  });

  testWidgets('multiple errors', (WidgetTester tester) async {
    await TestUtils.prepareWidget(tester, null);
    final BuildContext context = tester.element(find.byType(Scaffold));

    var yearMaxBack = (mockCurrentDate.getCurrentDate().year - AppParams.maxYearsBackInDate);
    var yearMaxForward = (mockCurrentDate.getCurrentDate().year + AppParams.maxYearsForwardInDate);
    var testCases = [
      DateTimeTestData(
          "39/18/00",
          "2039-18-00",
          false,
          BricksLocalizations.of(context).dateErrorYearTooFarForward(yearMaxForward) +
              '\n' +
              BricksLocalizations.of(context).dateErrorMonthOver12 +
              '\n' +
              BricksLocalizations.of(context).dateErrorDay0),
      DateTimeTestData(
          "01-0-80",
          "2001-00-80",
          false,
          BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) +
              '\n' +
              BricksLocalizations.of(context).dateErrorMonth0 +
              '\n' +
              BricksLocalizations.of(context).dateErrorTooManyDaysInMonth),
      DateTimeTestData(
          "01-0-00",
          "2001-00-00",
          false,
          BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) +
              '\n' +
              BricksLocalizations.of(context).dateErrorMonth0 +
              '\n' +
              BricksLocalizations.of(context).dateErrorDay0),
      DateTimeTestData(
          "01-0-31",
          "2001-00-31",
          false,
          BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) +
              '\n' +
              BricksLocalizations.of(context).dateErrorMonth0),
      DateTimeTestData(
          "268855",
          "2026-88-55",
          false,
          BricksLocalizations.of(context).dateErrorMonthOver12 +
              '\n' +
              BricksLocalizations.of(context).dateErrorTooManyDaysInMonth),
      DateTimeTestData(
          "0000 0 0",
          "0000-00-00",
          false,
          BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) +
              '\n' +
              BricksLocalizations.of(context).dateErrorMonth0 +
              '\n' +
              BricksLocalizations.of(context).dateErrorDay0),
      DateTimeTestData(
          "558855",
          "2055-88-55",
          false,
          BricksLocalizations.of(context).dateErrorYearTooFarForward(yearMaxForward) +
              '\n' +
              BricksLocalizations.of(context).dateErrorMonthOver12 +
              '\n' +
              BricksLocalizations.of(context).dateErrorTooManyDaysInMonth),
    ];
    var passedOk = UtilTestDateTime.testDateTimeFormatter(testCases, dateFormatter);
    expect(passedOk, true);
  });
}
