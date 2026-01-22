import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';
import '../../../tools/date_time_test_data.dart';
import 'utils/dateTime_formatter_test_utils.dart';
import 'utils/dateTime_test_utils.dart';

void main() {
  var dateTimeUtils = DateTimeUtils();
  final dateTimeInputUtils = dateTimeUtils;
  final mockCurrentDate = MockCurrentDate();
  when(mockCurrentDate.getDateNow()).thenReturn(DateTime.parse('2024-02-01 22:11'));

  var dateTimeLimits = DateTimeLimits(
    fixedReferenceDateTime: mockCurrentDate.getDateNow(),
    maxMinutesBack: 570240,
    maxMinutesForward: 480960,
  );

  TestDateFormatter dateFormatter = TestDateFormatter(DateFormatterValidator(
    dateTimeInputUtils,
    mockCurrentDate,
  ));
  TestDateFormatter dateFormatterWithLimits =
      TestDateFormatter(DateFormatterValidator(dateTimeInputUtils, mockCurrentDate, dateTimeLimits));

  final String dateMaxBack = dateTimeUtils.formatDate(dateTimeLimits.minDateTime!, 'yyyy-MM-dd');
  final String dateMaxForward = dateTimeUtils.formatDate(dateTimeLimits.maxDateTime!, 'yyyy-MM-dd');

  testWidgets('refuses to format excel-style invalid input', (WidgetTester tester) async {
    final local = await getLocalizations();

    var testCases = [
      DateTimeTestCase('0', '0', false, local.dateStringErrorTooFewDigits),
      DateTimeTestCase('01', '01', false, local.dateStringErrorTooFewDigits),
      // --------------------------------------------
      DateTimeTestCase('2024-5', '2024-5', false, local.dateStringErrorTooManyDigitsMonth),
      DateTimeTestCase('3/132', '3/132', false, local.dateStringErrorTooManyDigitsDay),
      // --------------------------------------------
      DateTimeTestCase('112,312', '112,312', false,
          local.dateStringErrorTooManyDigitsDay + '\n' + local.dateStringErrorTooManyDigitsMonth),
      // --------------------------------------------
      DateTimeTestCase('000,12', '000,12', false, local.dateStringErrorTooManyDigitsMonth),
      DateTimeTestCase('112,12', '112,12', false, local.dateStringErrorTooManyDigitsMonth),
      // --------------------------------------------
      DateTimeTestCase('21000,12,9', '21000,12,9', false, local.dateStringErrorTooManyDigitsYear),
      DateTimeTestCase('21000,124,9', '21000,124,9', false,
          local.dateStringErrorTooManyDigitsMonth + '\n' + local.dateStringErrorTooManyDigitsYear),
      DateTimeTestCase(
          '21000,124,911',
          '21000,124,911',
          false,
          local.dateStringErrorTooManyDigitsDay +
              '\n' +
              local.dateStringErrorTooManyDigitsMonth +
              '\n' +
              local.dateStringErrorTooManyDigitsYear),
      // --------------------------------------------
      DateTimeTestCase('01-0', '2024-01-00', false, local.dateErrorDay0),
      DateTimeTestCase('0100', '2024-01-00', false, local.dateErrorDay0),
      DateTimeTestCase('01-00', '2024-01-00', false, local.dateErrorDay0),
      // --------------------------------------------
      DateTimeTestCase('001', '2024-00-01', false, local.dateErrorMonth0),
      DateTimeTestCase('012', '2024-00-12', false, local.dateErrorMonth0),
      DateTimeTestCase('0/1', '2024-00-01', false, local.dateErrorMonth0),
      DateTimeTestCase('0 12', '2024-00-12', false, local.dateErrorMonth0),
      // --------------------------------------------
      DateTimeTestCase('00- 01', '2024-00-01', false, local.dateErrorMonth0),
      // --------------------------------------------
      DateTimeTestCase('431', '2024-04-31', false, local.dateErrorTooManyDaysInMonth),
      DateTimeTestCase('532', '2024-05-32', false, local.dateErrorTooManyDaysInMonth),
      DateTimeTestCase('3-2-29', '2023-02-29', false, local.dateErrorTooManyDaysInMonth),
      DateTimeTestCase('40230', '2024-02-30', false, local.dateErrorTooManyDaysInMonth),
      // --------------------------------------------
      DateTimeTestCase('3123', '2024-31-23', false, local.dateErrorMonthOver12),
    ];
    var passedOk = runDateTimeFormatterTest<Date>(local, testCases, dateFormatter);
    expect(passedOk, true);
  });

  testWidgets('refuses to format date when forbidden chars', (WidgetTester tester) async {
    final local = await getLocalizations();

    var testCases = [
      DateTimeTestCase('00^12', '00^12', false, local.dateStringErrorBadChars),
      DateTimeTestCase('01\\12', '01\\12', false, local.dateStringErrorBadChars),
      DateTimeTestCase('01*2', '01*2', false, local.dateStringErrorBadChars),
      DateTimeTestCase('01+23', '01+23', false, local.dateStringErrorBadChars),
    ];
    var passedOk = runDateTimeFormatterTest<Date>(local, testCases, dateFormatter);
    expect(passedOk, true);
  });

  testWidgets('creates formatted date string from digits only', (WidgetTester tester) async {
    final local = await getLocalizations();

    var testCases = [
      DateTimeTestCase('123', '2024-01-23', true, null),
      DateTimeTestCase('0123', '2024-01-23', true, null),
      DateTimeTestCase('01231', '2020-12-31', true, null),
      DateTimeTestCase('31231', '2023-12-31', true, null),
      DateTimeTestCase('211231', '2021-12-31', true, null),
      DateTimeTestCase('0211231', '2021-12-31', true, null),
      DateTimeTestCase('20211231', '2021-12-31', true, null),
    ];
    var passedOk = runDateTimeFormatterTest<Date>(local, testCases, dateFormatter);
    expect(passedOk, true);
  });

  testWidgets('creates formatted date string from excel-style input', (WidgetTester tester) async {
    final local = await getLocalizations();

    var testCases = [
      DateTimeTestCase('2;2', '2024-02-02', true, null),
      DateTimeTestCase('4/01,23', '2024-01-23', true, null),
      DateTimeTestCase('24;1-23', '2024-01-23', true, null),
    ];
    var passedOk = runDateTimeFormatterTest<Date>(local, testCases, dateFormatter);
    expect(passedOk, true);
  });

  testWidgets('creates formatted date string with all possible delimiters', (WidgetTester tester) async {
    final local = await getLocalizations();

    var p = '=';
    var testCases = [
      DateTimeTestCase('2${p}2', '2024-02-02', true, null),
      DateTimeTestCase('04${p}8', '2024-04-08', true, null),
      DateTimeTestCase('1${p}12', '2024-01-12', true, null),
      DateTimeTestCase('01${p}12', '2024-01-12', true, null),
      DateTimeTestCase('01${p}2', '2024-01-02', true, null),
      DateTimeTestCase('01${p}23', '2024-01-23', true, null),
      DateTimeTestCase('4${p}01${p}23', '2024-01-23', true, null),
      DateTimeTestCase('24${p}1${p}23', '2024-01-23', true, null),
    ];
    var passedOk = runDateTimeFormatterTest<Date>(
      local,
      testCases,
      dateFormatter,
      delimitersPattern: dateFormatter.dateDelimiterPattern,
      placeholder: p,
    );
    expect(passedOk, true);
  });

  // testWidgets('copes with bad chars', (WidgetTester tester) async {
  //   await prepareLocalizations(tester);
  //  final BuildContext context = tester.element(find.byType(Scaffold));
  //   var p = '=';
  //   var testCases = [
  //     DateTimeTestCase('1=12', '2024-01-12', true, ''),
  //     DateTimeTestCase('% 22& 12=5', '2022-01-12', true, ''),
  //     DateTimeTestCase('0=12', '2024-00-12', false, BricksLocalizations.of(context).dateStringErrorBadChars),
  //     DateTimeTestCase('5+1=12', '2024-51-12', false, BricksLocalizations.of(context).dateErrorMonthOver12),
  //     DateTimeTestCase('5+11=12', '2025-05-11', false, BricksLocalizations.of(context).dateStringErrorBadChars),
  //     DateTimeTestCase(' 4=++30 *&', '2024-04-30', false, BricksLocalizations.of(context).dateErrorMonthOver12),
  //   ];
  //   var passedOk = testDateTimeFormatter(local,
  //     testCases,
  //     dateFormatterWithLimits,
  //     delimitersPattern: dateDelimiterPattern,
  //     placeholder: p,
  //   );
  //   expect(passedOk, true);
  // });

  testWidgets('date too early or too late', (WidgetTester tester) async {
    final local = await getLocalizations();

    var testCases = [
      DateTimeTestCase('0000,12,9', '0000-12-09', false, local.dateErrorTooFarBack(dateMaxBack)),
      DateTimeTestCase('001231', '2000-12-31', false, local.dateErrorTooFarBack(dateMaxBack)),
      DateTimeTestCase('301231', '2030-12-31', false, local.dateErrorTooFarForward(dateMaxForward)),
    ];
    var passedOk = runDateTimeFormatterTest<Date>(local, testCases, dateFormatterWithLimits);
    expect(passedOk, true);
  });

  testWidgets('date invalid', (WidgetTester tester) async {
    final local = await getLocalizations();

    var testCases = [
      DateTimeTestCase('26/08/0', '2026-08-00', false, local.dateErrorDay0),
      DateTimeTestCase('01-0', '2024-01-00', false, local.dateErrorDay0),
      DateTimeTestCase('0100', '2024-01-00', false, local.dateErrorDay0),
      DateTimeTestCase('01-00', '2024-01-00', false, local.dateErrorDay0),
      // --------------------------------------------
      DateTimeTestCase('24,00,9', '2024-00-09', false, local.dateErrorMonth0),
      DateTimeTestCase('001', '2024-00-01', false, local.dateErrorMonth0),
      DateTimeTestCase('012', '2024-00-12', false, local.dateErrorMonth0),
      DateTimeTestCase('0/1', '2024-00-01', false, local.dateErrorMonth0),
      DateTimeTestCase('0 12', '2024-00-12', false, local.dateErrorMonth0),
      // --------------------------------------------
      DateTimeTestCase('00- 01', '2024-00-01', false, local.dateErrorMonth0),
      // --------------------------------------------
      DateTimeTestCase('431', '2024-04-31', false, local.dateErrorTooManyDaysInMonth),
      DateTimeTestCase('532', '2024-05-32', false, local.dateErrorTooManyDaysInMonth),
      DateTimeTestCase('3-2-29', '2023-02-29', false, local.dateErrorTooManyDaysInMonth),
      DateTimeTestCase('40230', '2024-02-30', false, local.dateErrorTooManyDaysInMonth),
      // --------------------------------------------
      DateTimeTestCase('3123', '2024-31-23', false, local.dateErrorMonthOver12),
      // ---------------------------------------
      DateTimeTestCase('26/08/55', '2026-08-55', false, local.dateErrorTooManyDaysInMonth),
      DateTimeTestCase('24,13,9', '2024-13-09', false, local.dateErrorMonthOver12),
      DateTimeTestCase('268831', '2026-88-31', false, local.dateErrorMonthOver12),
      // ---------------------------------------
      DateTimeTestCase('19001216', '1900-12-16', false, local.dateErrorTooFarBack(dateMaxBack)),
      DateTimeTestCase('39001216', '3900-12-16', false, local.dateErrorTooFarForward(dateMaxForward)),
    ];
    var passedOk = runDateTimeFormatterTest<Date>(local, testCases, dateFormatterWithLimits);
    expect(passedOk, true);
  });

  testWidgets('multiple errors', (WidgetTester tester) async {
    final local = await getLocalizations();

    var testCases = [
      DateTimeTestCase(
        '39/18/00',
        '2039-18-00',
        false,
        local.dateErrorMonthOver12 + '\n' + local.dateErrorDay0,
      ),
      DateTimeTestCase(
        '01-0-80',
        '2001-00-80',
        false,
        local.dateErrorMonth0 + '\n' + local.dateErrorTooManyDaysInMonth,
      ),
      DateTimeTestCase(
        '01-0-00',
        '2001-00-00',
        false,
        local.dateErrorMonth0 + '\n' + local.dateErrorDay0,
      ),
      DateTimeTestCase(
        '01-0-31',
        '2001-00-31',
        false,
        local.dateErrorMonth0,
      ),
      DateTimeTestCase(
          '268855', '2026-88-55', false, local.dateErrorMonthOver12 + '\n' + local.dateErrorTooManyDaysInMonth),
      DateTimeTestCase('0000 0 0', '0000-00-00', false, local.dateErrorMonth0 + '\n' + local.dateErrorDay0),
      DateTimeTestCase(
        '558855',
        '2055-88-55',
        false,
        local.dateErrorMonthOver12 + '\n' + local.dateErrorTooManyDaysInMonth,
      ),
    ];
    var passedOk = runDateTimeFormatterTest<Date>(local, testCases, dateFormatterWithLimits);
    expect(passedOk, true);
  });
}
