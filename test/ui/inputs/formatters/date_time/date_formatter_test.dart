import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/components/date_time_utils.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/formatter_validators/date_formatter_validator.dart';
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
  ATestDateTimeFormatter dateFormatter = TestDateFormatter(DateFormatterValidator(dateTimeInputUtils, mockCurrentDate));

  testWidgets('refuses to format excel-style invalid input', (WidgetTester tester) async {
    final BuildContext context = await TestUtils.pumpAppGetContext(tester);
    var local = BricksLocalizations.of(context);
    var datTimLim = DateTimeLimits();

    var testCases = [
      DateTimeTestData(datTimLim, "0", "0", false, local.dateStringErrorTooFewDigits),
      DateTimeTestData(datTimLim, "01", "01", false, local.dateStringErrorTooFewDigits),
      // --------------------------------------------
      DateTimeTestData(datTimLim, "2024-5", "2024-5", false, local.dateStringErrorTooManyDigitsMonth),
      DateTimeTestData(datTimLim, "3/132", "3/132", false, local.dateStringErrorTooManyDigitsDay),
      // --------------------------------------------
      DateTimeTestData(datTimLim, "112,312", "112,312", false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.dateStringErrorTooManyDigitsMonth),
      // --------------------------------------------
      DateTimeTestData(datTimLim, "000,12", "000,12", false, local.dateStringErrorTooManyDigitsMonth),
      DateTimeTestData(datTimLim, "112,12", "112,12", false, local.dateStringErrorTooManyDigitsMonth),
      // --------------------------------------------
      DateTimeTestData(datTimLim, "21000,12,9", "21000,12,9", false, local.dateStringErrorTooManyDigitsYear),
      DateTimeTestData(datTimLim, "21000,124,9", "21000,124,9", false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.dateStringErrorTooManyDigitsYear),
      DateTimeTestData(
          datTimLim,
          "21000,124,911",
          "21000,124,911",
          false,
          local.dateStringErrorTooManyDigitsDay +
              '\n' +
              local.dateStringErrorTooManyDigitsMonth +
              '\n' +
              local.dateStringErrorTooManyDigitsYear),
      // --------------------------------------------
      DateTimeTestData(datTimLim, "01-0", "2024-01-00", false, local.dateErrorDay0),
      DateTimeTestData(datTimLim, "0100", "2024-01-00", false, local.dateErrorDay0),
      DateTimeTestData(datTimLim, "01-00", "2024-01-00", false, local.dateErrorDay0),
      // --------------------------------------------
      DateTimeTestData(datTimLim, "001", "2024-00-01", false, local.dateErrorMonth0),
      DateTimeTestData(datTimLim, "012", "2024-00-12", false, local.dateErrorMonth0),
      DateTimeTestData(datTimLim, "0/1", "2024-00-01", false, local.dateErrorMonth0),
      DateTimeTestData(datTimLim, "0 12", "2024-00-12", false, local.dateErrorMonth0),
      // --------------------------------------------
      DateTimeTestData(datTimLim, "00- 01", "2024-00-01", false, local.dateErrorMonth0),
      // --------------------------------------------
      DateTimeTestData(datTimLim, "431", "2024-04-31", false, local.dateErrorTooManyDaysInMonth),
      DateTimeTestData(datTimLim, "532", "2024-05-32", false, local.dateErrorTooManyDaysInMonth),
      DateTimeTestData(datTimLim, "3-2-29", "2023-02-29", false, local.dateErrorTooManyDaysInMonth),
      DateTimeTestData(datTimLim, "40230", "2024-02-30", false, local.dateErrorTooManyDaysInMonth),
      // --------------------------------------------
      DateTimeTestData(datTimLim, "3123", "2024-31-23", false, local.dateErrorMonthOver12),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateFormatter);
    expect(passedOk, true);
  });

  testWidgets('refuses to format date when forbidden chars', (WidgetTester tester) async {
    final BuildContext context = await TestUtils.pumpAppGetContext(tester);
    var local = BricksLocalizations.of(context);
    var datTimLim = DateTimeLimits();

    var testCases = [
      DateTimeTestData(datTimLim, "00=12", "00=12", false, BricksLocalizations.of(context).dateStringErrorBadChars),
      DateTimeTestData(datTimLim, "01\\12", "01\\12", false, BricksLocalizations.of(context).dateStringErrorBadChars),
      DateTimeTestData(datTimLim, "01*2", "01*2", false, BricksLocalizations.of(context).dateStringErrorBadChars),
      DateTimeTestData(datTimLim, "01+23", "01+23", false, BricksLocalizations.of(context).dateStringErrorBadChars),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateFormatter);
    expect(passedOk, true);
  });

  testWidgets('creates formatted date string from digits only', (WidgetTester tester) async {
    final BuildContext context = await TestUtils.pumpAppGetContext(tester);
    var local = BricksLocalizations.of(context);
    var datTimLim = DateTimeLimits(minDateTimeRequired: DateTime(2015));

    var testCases = [
      DateTimeTestData(datTimLim, "123", "2024-01-23", true, ''),
      DateTimeTestData(datTimLim, "0123", "2024-01-23", true, ''),
      DateTimeTestData(datTimLim, "01231", "2020-12-31", true, ''),
      DateTimeTestData(datTimLim, "31231", "2023-12-31", true, ''),
      DateTimeTestData(datTimLim, "211231", "2021-12-31", true, ''),
      DateTimeTestData(datTimLim, "0211231", "2021-12-31", true, ''),
      DateTimeTestData(datTimLim, "20211231", "2021-12-31", true, ''),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateFormatter);
    expect(passedOk, true);
  });

  testWidgets('creates formatted date string from excel-style input', (WidgetTester tester) async {
    final BuildContext context = await TestUtils.pumpAppGetContext(tester);
    var local = BricksLocalizations.of(context);
    var datTimLim = DateTimeLimits();

    var testCases = [
      DateTimeTestData(datTimLim, "2;2", "2024-02-02", true, ''),
      DateTimeTestData(datTimLim, "4/01,23", "2024-01-23", true, ''),
      DateTimeTestData(datTimLim, "24;1-23", "2024-01-23", true, ''),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateFormatter);
    expect(passedOk, true);
  });

  testWidgets('creates formatted date string with all possible delimiters', (WidgetTester tester) async {
    final BuildContext context = await TestUtils.pumpAppGetContext(tester);
    var local = BricksLocalizations.of(context);
    var datTimLim = DateTimeLimits();

    var p = '=';
    var testCases = [
      DateTimeTestData(datTimLim, "2${p}2", "2024-02-02", true, ''),
      DateTimeTestData(datTimLim, "04${p}8", "2024-04-08", true, ''),
      DateTimeTestData(datTimLim, "1${p}12", "2024-01-12", true, ''),
      DateTimeTestData(datTimLim, "01${p}12", "2024-01-12", true, ''),
      DateTimeTestData(datTimLim, "01${p}2", "2024-01-02", true, ''),
      DateTimeTestData(datTimLim, "01${p}23", "2024-01-23", true, ''),
      DateTimeTestData(datTimLim, "4${p}01${p}23", "2024-01-23", true, ''),
      DateTimeTestData(datTimLim, "24${p}1${p}23", "2024-01-23", true, ''),
    ];
    var passedOk = testDateTimeFormatter(
      local,
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
  //     DateTimeTestData(datTimLim, "1=12", "2024-01-12", true, ''),
  //     DateTimeTestData(datTimLim, "% 22& 12=5", "2022-01-12", true, ''),
  //     DateTimeTestData(datTimLim, "0=12", "2024-00-12", false, BricksLocalizations.of(context).dateStringErrorBadChars),
  //     DateTimeTestData(datTimLim, "5+1=12", "2024-51-12", false, BricksLocalizations.of(context).dateErrorMonthOver12),
  //     DateTimeTestData(datTimLim, "5+11=12", "2025-05-11", false, BricksLocalizations.of(context).dateStringErrorBadChars),
  //     DateTimeTestData(datTimLim, " 4=++30 *&", "2024-04-30", false, BricksLocalizations.of(context).dateErrorMonthOver12),
  //   ];
  //   var passedOk = testDateTimeFormatter(local,
  //     testCases,
  //     dateFormatter,
  //     delimitersPattern: DateFormatterValidator.dateDelimiterPattern,
  //     placeholder: p,
  //   );
  //   expect(passedOk, true);
  // });

  testWidgets('date too early or too late', (WidgetTester tester) async {
    final BuildContext context = await TestUtils.pumpAppGetContext(tester);
    var local = BricksLocalizations.of(context);

    var datTimLim = DateTimeLimits(
      minDateTimeRequired: DateTime(2023, 1, 1),
      maxDateTimeRequired: DateTime(2024, 12, 31),
    );
    var yearMaxBack = datTimLim.minDateTimeRequired!.year;
    var yearMaxForward = datTimLim.maxDateTimeRequired!.year;
    // var yearMaxBack = (mockCurrentDate.getDateNow().year - AppParams.maxYearsBackInDate);
    // var yearMaxForward = (mockCurrentDate.getDateNow().year + AppParams.maxYearsForwardInDate);

    var testCases = [
      DateTimeTestData(datTimLim, "0000,12,9", "0000-12-09", false, local.dateErrorYearTooFarBack(yearMaxBack)),
      DateTimeTestData(datTimLim, "001231", "2000-12-31", false, local.dateErrorYearTooFarBack(yearMaxBack)),
      DateTimeTestData(datTimLim, "301231", "2030-12-31", false, local.dateErrorYearTooFarForward(yearMaxForward)),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateFormatter);
    expect(passedOk, true);
  });

  testWidgets('date invalid', (WidgetTester tester) async {
    await TestUtils.prepareWidget(tester, null);
    final BuildContext context = tester.element(find.byType(Scaffold));
    var local = BricksLocalizations.of(context);

    var datTimLim = DateTimeLimits(
      minDateTimeRequired: DateTime(2023, 1, 1),
      maxDateTimeRequired: DateTime(2034, 12, 31),
    );
    var yearMaxBack = datTimLim.minDateTimeRequired!.year;
    var yearMaxForward = datTimLim.maxDateTimeRequired!.year;

    var testCases = [
      DateTimeTestData(datTimLim, "26/08/0", "2026-08-00", false, local.dateErrorDay0),
      DateTimeTestData(datTimLim, "01-0", "2024-01-00", false, local.dateErrorDay0),
      DateTimeTestData(datTimLim, "0100", "2024-01-00", false, local.dateErrorDay0),
      DateTimeTestData(datTimLim, "01-00", "2024-01-00", false, local.dateErrorDay0),
      // --------------------------------------------
      DateTimeTestData(datTimLim, "24,00,9", "2024-00-09", false, local.dateErrorMonth0),
      DateTimeTestData(datTimLim, "001", "2024-00-01", false, local.dateErrorMonth0),
      DateTimeTestData(datTimLim, "012", "2024-00-12", false, local.dateErrorMonth0),
      DateTimeTestData(datTimLim, "0/1", "2024-00-01", false, local.dateErrorMonth0),
      DateTimeTestData(datTimLim, "0 12", "2024-00-12", false, local.dateErrorMonth0),
      // --------------------------------------------
      DateTimeTestData(datTimLim, "00- 01", "2024-00-01", false, local.dateErrorMonth0),
      // --------------------------------------------
      DateTimeTestData(datTimLim, "431", "2024-04-31", false, local.dateErrorTooManyDaysInMonth),
      DateTimeTestData(datTimLim, "532", "2024-05-32", false, local.dateErrorTooManyDaysInMonth),
      DateTimeTestData(datTimLim, "3-2-29", "2023-02-29", false, local.dateErrorTooManyDaysInMonth),
      DateTimeTestData(datTimLim, "40230", "2024-02-30", false, local.dateErrorTooManyDaysInMonth),
      // --------------------------------------------
      DateTimeTestData(datTimLim, "3123", "2024-31-23", false, local.dateErrorMonthOver12),
      // ---------------------------------------
      DateTimeTestData(datTimLim, "26/08/55", "2026-08-55", false, local.dateErrorTooManyDaysInMonth),
      DateTimeTestData(datTimLim, "24,13,9", "2024-13-09", false, local.dateErrorMonthOver12),
      DateTimeTestData(datTimLim, "268831", "2026-88-31", false, local.dateErrorMonthOver12),
      // ---------------------------------------
      DateTimeTestData(datTimLim, "19001216", "1900-12-16", false, local.dateErrorYearTooFarBack(yearMaxBack)),
      DateTimeTestData(
          datTimLim, "39001216", "3900-12-16", false, local.dateErrorYearTooFarForward(yearMaxForward)),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateFormatter);
    expect(passedOk, true);
  });

  testWidgets('multiple errors', (WidgetTester tester) async {
    await TestUtils.prepareWidget(tester, null);
    final BuildContext context = tester.element(find.byType(Scaffold));
    var local = BricksLocalizations.of(context);

    var datTimLim = DateTimeLimits(
      minDateTimeRequired: DateTime(2013, 1, 1),
      maxDateTimeRequired: DateTime(2034, 12, 31),
    );
    var yearMaxBack = datTimLim.minDateTimeRequired!.year;
    var yearMaxForward = datTimLim.maxDateTimeRequired!.year;

    var testCases = [
      DateTimeTestData(
          datTimLim,
          "39/18/00",
          "2039-18-00",
          false,
          BricksLocalizations.of(context).dateErrorYearTooFarForward(yearMaxForward) +
              '\n' +
              BricksLocalizations.of(context).dateErrorMonthOver12 +
              '\n' +
              BricksLocalizations.of(context).dateErrorDay0),
      DateTimeTestData(
          datTimLim,
          "01-0-80",
          "2001-00-80",
          false,
          BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) +
              '\n' +
              BricksLocalizations.of(context).dateErrorMonth0 +
              '\n' +
              BricksLocalizations.of(context).dateErrorTooManyDaysInMonth),
      DateTimeTestData(
          datTimLim,
          "01-0-00",
          "2001-00-00",
          false,
          BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) +
              '\n' +
              BricksLocalizations.of(context).dateErrorMonth0 +
              '\n' +
              BricksLocalizations.of(context).dateErrorDay0),
      DateTimeTestData(
          datTimLim,
          "01-0-31",
          "2001-00-31",
          false,
          BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) +
              '\n' +
              BricksLocalizations.of(context).dateErrorMonth0),
      DateTimeTestData(
          datTimLim,
          "268855",
          "2026-88-55",
          false,
          BricksLocalizations.of(context).dateErrorMonthOver12 +
              '\n' +
              BricksLocalizations.of(context).dateErrorTooManyDaysInMonth),
      DateTimeTestData(
          datTimLim,
          "0000 0 0",
          "0000-00-00",
          false,
          BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack) +
              '\n' +
              BricksLocalizations.of(context).dateErrorMonth0 +
              '\n' +
              BricksLocalizations.of(context).dateErrorDay0),
      DateTimeTestData(
          datTimLim,
          "558855",
          "2055-88-55",
          false,
          BricksLocalizations.of(context).dateErrorYearTooFarForward(yearMaxForward) +
              '\n' +
              BricksLocalizations.of(context).dateErrorMonthOver12 +
              '\n' +
              BricksLocalizations.of(context).dateErrorTooManyDaysInMonth),
    ];
    var passedOk = testDateTimeFormatter(local, testCases, dateFormatter);
    expect(passedOk, true);
  });
}
