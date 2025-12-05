import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/date_time_inputs.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_range_span.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/dateTimeRange_formatter_validator.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import '../../../../test_implementations/test_form_manager.dart';
import '../../../../test_implementations/test_single_form.dart';
import '../../../tools/test_utils.dart';
import 'utils/dateTimeRange_test_utils.dart';

void main() {
  var rangeId = "rng";
  
  var dummyDatTimRngFormatValid = DateTimeRangeFormatterValidator(
    'f',
    TestFormManager.testDefault(),
    DateTimeUtils(),
    CurrentDate(),
    DateTimeRangeLimits(DateTimeLimits(), DateTimeLimits(), 1, 1),
  );
  var keyStrings = [
    (dummyDatTimRngFormatValid.rangeDateStartKeyString(rangeId)),
    (dummyDatTimRngFormatValid.rangeTimeStartKeyString(rangeId)),
    (dummyDatTimRngFormatValid.rangeDateEndKeyString(rangeId)),
    (dummyDatTimRngFormatValid.rangeTimeEndKeyString(rangeId)),
  ];

  final dateTimeLimits = DateTimeLimits(minDateTime: DateTime(2014), maxDateTime: DateTime(2026));
  final dateTimeRangeSpan = DateTimeRangeSpan(minDateTimeSpanMinutes: 15, maxDateTimeSpanMinutes:10080);

  testWidgets('correct input', (WidgetTester tester) async {
    String? errMsg = null;
    var expectedValues = [errMsg, errMsg, errMsg, errMsg];
    var testCases = [
      // date-start
      RangeTestData(['2024-05-11', '', '', ''], expectedValues, errMsg),
      // date-start time-start
      RangeTestData(['2024-05-11', '18:03', '', ''], expectedValues, errMsg),
      // date-start time-start time-end
      RangeTestData(['2024-05-11', '18:03', '', '19:15'], expectedValues, errMsg),
      // date-start time-start date-end
      RangeTestData(['2024-05-11', '18:03', '2024-05-12', ''], expectedValues, errMsg),
      // date-start time-start date-end time-end
      RangeTestData(['2024-05-11', '18:03', '2024-05-12', '19:15'], expectedValues, errMsg),
      // date-start date-end
      RangeTestData(['2024-05-11', '', '2024-05-12', ''], expectedValues, errMsg),
      // date-start date-end time-end
      RangeTestData(['2024-05-11', '', '2024-05-12', '19:15'], expectedValues, errMsg),
    ];
    TestSingleForm form = await prepDateTimeRangeTest(tester, rangeId, dateTimeLimits, dateTimeRangeSpan);
    bool passedOk = await testDateTimeRangeValidator(tester, form, keyStrings, testCases);
    expect(passedOk, true);
  });

  testWidgets('start-date absent', (WidgetTester tester) async {
    var context = await pumpAppGetContext(tester);
    String? errMsg = BricksLocalizations.of(context).requiredField;
    var expectedValues = [errMsg, null, null, null];
    var testCases = [
      // no-date-start
      RangeTestData(['', '', '', ''], expectedValues, errMsg),
      // no-date-start time-start
      RangeTestData(['', '18:03', '', ''], expectedValues, errMsg),
      // no-date-start time-start time-end
      RangeTestData(['', '18:03', '', '19:15'], expectedValues, errMsg),
      // no-date-start time-start date-end
      RangeTestData(['', '18:03', '2024-05-12', ''], expectedValues, errMsg),
      // no-date-start time-start date-end time-end
      RangeTestData(['', '18:03', '2024-05-12', '19:15'], expectedValues, errMsg),
      // no-date-start date-end
      RangeTestData(['', '', '2024-05-12', ''], expectedValues, errMsg),
      // no-date-start date-end time-end
      RangeTestData(['', '', '2024-05-12', '19:15'], expectedValues, errMsg),
    ];
    TestSingleForm form = await prepDateTimeRangeTest(tester, rangeId, dateTimeLimits, dateTimeRangeSpan);
    bool passedOk = await testDateTimeRangeValidator(tester, form, keyStrings, testCases);
    expect(passedOk, true);
  });

  testWidgets('start-time absent & end-date absent & end-time present', (WidgetTester tester) async {
    var context = await pumpAppGetContext(tester);
    String? errMsg = BricksLocalizations.of(context).rangeDateEndRequiredOrRemoveTimeEnd;
    var testCases = [
      RangeTestData(['2024-05-11', '', '', '17:15'], [null, errMsg, errMsg, errMsg], errMsg),
    ];
    TestSingleForm form = await prepDateTimeRangeTest(tester, rangeId, dateTimeLimits, dateTimeRangeSpan);
    bool passedOk = await testDateTimeRangeValidator(tester, form, keyStrings, testCases);
    expect(passedOk, true);
  });

  testWidgets('start-date after end-date', (WidgetTester tester) async {
    var context = await pumpAppGetContext(tester);
    String? errMsg = BricksLocalizations.of(context).rangeDateStartAfterEnd;
    var expectedValues = [errMsg, null, errMsg, null];
    var testCases = [
      // date-start time-start date-end
      RangeTestData(['2024-05-11', '18:03', '2024-05-10', ''], expectedValues, errMsg),
      // date-start time-start date-end time-end (date too early)
      RangeTestData(['2024-05-11', '18:03', '2024-04-02', '19:15'], expectedValues, errMsg),
      // date-start date-end
      RangeTestData(['2024-05-11', '', '2024-01-12', ''], expectedValues, errMsg),
      // date-start date-end time-end
      RangeTestData(['2024-05-11', '', '2024-03-12', '19:15'], expectedValues, errMsg),
    ];
    TestSingleForm form = await prepDateTimeRangeTest(tester, rangeId, dateTimeLimits, dateTimeRangeSpan);
    bool passedOk = await testDateTimeRangeValidator(tester, form, keyStrings, testCases);
    expect(passedOk, true);
  });

  testWidgets('end-date too far from start-date', (WidgetTester tester) async {
    var context = await pumpAppGetContext(tester);

    final DateTime startDate = DateTime.parse('2024-05-11');
    final int maxDaysSpan = (dateTimeRangeSpan.maxDateTimeSpanMinutes! / 24 / 60).toInt();
    final DateTime endDate = startDate.add(Duration(days: maxDaysSpan + 1));

    final DateFormat format = DateFormat("yyyy-MM-dd");
    var startDateTx = format.format(startDate);
    var endDateTx = format.format(endDate);

    String? errMsg = BricksLocalizations.of(context).rangeDatesTooFarApart(maxDaysSpan.toString());
    var expectedValues = [errMsg, null, errMsg, null];

    var testCases = [
      RangeTestData([startDateTx, '', endDateTx, ''], expectedValues, errMsg),
      RangeTestData([startDateTx, '17:15', endDateTx, ''], expectedValues, errMsg),
      RangeTestData([startDateTx, '', endDateTx, '17:15'], expectedValues, errMsg),
      RangeTestData([startDateTx, '00:00', endDateTx, '00:10'], expectedValues, errMsg),
    ];
    TestSingleForm form = await prepDateTimeRangeTest(tester, rangeId, dateTimeLimits, dateTimeRangeSpan);
    bool passedOk = await testDateTimeRangeValidator(tester, form, keyStrings, testCases);
    expect(passedOk, true);
  });

  testWidgets('identical start and end', (WidgetTester tester) async {
    var context = await pumpAppGetContext(tester);

    var dateTx = '2024-12-31';
    var timeTx = '00:55';

    String? errMsg = BricksLocalizations.of(context).rangeStartSameAsEnd;
    var expectedValues = [errMsg, errMsg, errMsg, errMsg];

    var testCases = [
      RangeTestData([dateTx, timeTx, dateTx, timeTx], expectedValues, errMsg),
    ];
    TestSingleForm form = await prepDateTimeRangeTest(tester, rangeId, dateTimeLimits, dateTimeRangeSpan);
    bool passedOk = await testDateTimeRangeValidator(tester, form, keyStrings, testCases);
    expect(passedOk, true);
  });

  testWidgets('end-date absent => start-time after end-time', (WidgetTester tester) async {
    var context = await pumpAppGetContext(tester);
    String? errMsg = BricksLocalizations.of(context).rangeTimeStartAfterEndOrAddDateEnd;
    var testCases = [
      // date-start time-start time-end
      RangeTestData(['2024-05-11', '18:03', '', '17:15'], [null, errMsg, errMsg, errMsg], errMsg),
    ];
    TestSingleForm form = await prepDateTimeRangeTest(tester, rangeId, dateTimeLimits, dateTimeRangeSpan);
    bool passedOk = await testDateTimeRangeValidator(tester, form, keyStrings, testCases);
    expect(passedOk, true);
  });

  testWidgets('start-date = end-date => start-time after end-time', (WidgetTester tester) async {
    var context = await pumpAppGetContext(tester);
    String? errMsg = BricksLocalizations.of(context).rangeTimeStartAfterEnd;
    var testCases = [
      // date-start time-start date-end time-end (date-start = date-end)
      RangeTestData(['2024-05-11', '18:03', '2024-05-11', '17:15'], [null, errMsg, null, errMsg], errMsg),
    ];
    TestSingleForm form = await prepDateTimeRangeTest(tester, rangeId, dateTimeLimits, dateTimeRangeSpan);
    bool passedOk = await testDateTimeRangeValidator(tester, form, keyStrings, testCases);
    expect(passedOk, true);
  });

  testWidgets('end-date absent => start-time less than minimum before end-time', (WidgetTester tester) async {
    var context = await pumpAppGetContext(tester);

    final DateFormat format = DateFormat("HH:mm");
    final String dateTx = '2024-12-31';
    final DateTime startTime = DateTime.parse('$dateTx 00:10');
    final int minMinutesSpan = dateTimeRangeSpan.minDateTimeSpanMinutes!;
    final DateTime endTime = startTime.add(Duration(minutes: minMinutesSpan - 1));

    String? errMsg = BricksLocalizations.of(context).rangeTimeStartEndTooCloseOrAddDateEnd(minMinutesSpan);
// String? errMsg = '';

    var startTimeTx = format.format(startTime);
    var endTimeTx = format.format(endTime);
    var testCases = [
      RangeTestData([dateTx, startTimeTx, '', endTimeTx], [null, errMsg, errMsg, errMsg], errMsg),
    ];
    TestSingleForm form = await prepDateTimeRangeTest(tester, rangeId, dateTimeLimits, dateTimeRangeSpan);
    bool passedOk = await testDateTimeRangeValidator(tester, form, keyStrings, testCases);
    expect(passedOk, true);
  });

  testWidgets('start-date = end-date => start-time less than minimum before end-time', (WidgetTester tester) async {
    final context = await pumpAppGetContext(tester);

    final DateFormat format = DateFormat("HH:mm");
    final String dateTx = '2024-12-31';
    final DateTime startTime = DateTime.parse('$dateTx 00:10');
    final int minMinutesSpan = dateTimeRangeSpan.minDateTimeSpanMinutes!;
    final DateTime endTime = startTime.add(Duration(minutes: minMinutesSpan - 1));

    String? errMsg = BricksLocalizations.of(context).rangeTimeStartEndTooCloseSameDate(minMinutesSpan);

    var startTimeTx = format.format(startTime);
    var endTimeTx = format.format(endTime);
    var testCases = [
      RangeTestData([dateTx, startTimeTx, dateTx, endTimeTx], [null, errMsg, null, errMsg], errMsg),
    ];
    TestSingleForm form = await prepDateTimeRangeTest(tester, rangeId, dateTimeLimits, dateTimeRangeSpan);
    bool passedOk = await testDateTimeRangeValidator(tester, form, keyStrings, testCases);
    expect(passedOk, true);
  });

// TODO make date-time tests where user randomly writes, deletes chars
}
