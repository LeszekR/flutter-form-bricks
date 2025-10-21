import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_standalone_form.dart';
import 'utils/dateTimeRange_test_utils.dart';

void main() {
  var rangeId = "rng";
  var keyStrings = [
    (DateTimeInputs.rangeDateStartKeyString(rangeId)),
    (DateTimeInputs.rangeTimeStartKeyString(rangeId)),
    (DateTimeInputs.rangeDateEndKeyString(rangeId)),
    (DateTimeInputs.rangeTimeEndKeyString(rangeId)),
  ];

  var dateTimeLimits = DateTimeLimits(minDateTimeRequired: DateTime(2014), maxDateTimeRequired: DateTime(2026));
  int maxRangeSpanDays = 7;
  int minRangeSpanMinutes = 15;


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
    TestStandaloneForm form = await prepDateTimeRangeTest(
      tester,
      rangeId,
      dateTimeLimits,
      maxRangeSpanDays,
      minRangeSpanMinutes,
    );
    bool passedOk = await testDateTimeRangeValidator(tester, form, keyStrings, testCases);
    expect(passedOk, true);
  });

//   testWidgets('start-date absent', (WidgetTester tester) async {
//     await prepareWidget(tester, null);
//     final BuildContext context = tester.element(find.byType(Scaffold));
//     String? errMsg = BricksLocalizations.of(context).requiredField;
//     var expectedValues = [errMsg, null, null, null];
//     var testCases = [
// // no-date-start
//       RangeTestData(['', '', '', ''], expectedValues, errMsg),
// // no-date-start time-start
//       RangeTestData(['', '18:03', '', ''], expectedValues, errMsg),
// // no-date-start time-start time-end
//       RangeTestData(['', '18:03', '', '19:15'], expectedValues, errMsg),
// // no-date-start time-start date-end
//       RangeTestData(['', '18:03', '2024-05-12', ''], expectedValues, errMsg),
// // no-date-start time-start date-end time-end
//       RangeTestData(['', '18:03', '2024-05-12', '19:15'], expectedValues, errMsg),
// // no-date-start date-end
//       RangeTestData(['', '', '2024-05-12', ''], expectedValues, errMsg),
// // no-date-start date-end time-end
//       RangeTestData(['', '', '2024-05-12', '19:15'], expectedValues, errMsg),
//     ];
//     await prepDateTimeRangeTest(tester, rangeId).then((form) async {
//       await testDateTimeRangeValidator(tester, form, keyStrings, testCases).then((passedOk) => expect(passedOk, true));
//     });
//   });
//
//   testWidgets('start-time absent & end-date absent & end-time present', (WidgetTester tester) async {
//     await prepareWidget(tester, null);
//     final BuildContext context = tester.element(find.byType(Scaffold));
//     String? errMsg = BricksLocalizations.of(context).rangeDateEndRequiredOrRemoveTimeEnd;
//     var testCases = [
//       RangeTestData(['2024-05-11', '', '', '17:15'], [null, errMsg, errMsg, errMsg], errMsg),
//     ];
//     await prepDateTimeRangeTest(tester, rangeId).then((form) async {
//       await testDateTimeRangeValidator(tester, form, keyStrings, testCases).then((passedOk) => expect(passedOk, true));
//     });
//   });
//
//   testWidgets('start-date after end-date', (WidgetTester tester) async {
//     await prepareWidget(tester, null);
//     final BuildContext context = tester.element(find.byType(Scaffold));
//     String? errMsg = BricksLocalizations.of(context).rangeDateStartAfterEnd;
//     var expectedValues = [errMsg, null, errMsg, null];
//     var testCases = [
// // date-start time-start date-end
//       RangeTestData(['2024-05-11', '18:03', '2024-05-10', ''], expectedValues, errMsg),
// // date-start time-start date-end time-end (date too early)
//       RangeTestData(['2024-05-11', '18:03', '2024-04-02', '19:15'], expectedValues, errMsg),
// // date-start date-end
//       RangeTestData(['2024-05-11', '', '2024-01-12', ''], expectedValues, errMsg),
// // date-start date-end time-end
//       RangeTestData(['2024-05-11', '', '2024-03-12', '19:15'], expectedValues, errMsg),
//     ];
//     await prepDateTimeRangeTest(tester, rangeId).then((form) async {
//       await testDateTimeRangeValidator(tester, form, keyStrings, testCases).then((passedOk) => expect(passedOk, true));
//     });
//   });
//
//   testWidgets('end-date too far from start-date', (WidgetTester tester) async {
//     await prepareWidget(tester, null);
//     final BuildContext context = tester.element(find.byType(Scaffold));
//
//     var maxRangeSpanDays = AppParams.maxRangeSpanDays;
//     var startDate = DateTime.parse('2024-05-11');
//     var endDate = startDate.add(Duration(days: maxRangeSpanDays + 1));
//
//     final DateFormat format = DateFormat("yyyy-MM-dd");
//     var startDateTx = format.format(startDate);
//     var endDateTx = format.format(endDate);
//
//     String? errMsg = BricksLocalizations.of(context).rangeDatesTooFarApart(maxRangeSpanDays);
//     var expectedValues = [errMsg, null, errMsg, null];
//
//     var testCases = [
//       RangeTestData([startDateTx, '', endDateTx, ''], expectedValues, errMsg),
//       RangeTestData([startDateTx, '17:15', endDateTx, ''], expectedValues, errMsg),
//       RangeTestData([startDateTx, '', endDateTx, '17:15'], expectedValues, errMsg),
//       RangeTestData([startDateTx, '00:00', endDateTx, '00:10'], expectedValues, errMsg),
//     ];
//     await prepDateTimeRangeTest(tester, rangeId).then((form) async {
//       await testDateTimeRangeValidator(tester, form, keyStrings, testCases).then((passedOk) => expect(passedOk, true));
//     });
//   });
//
//   testWidgets('identical start and end', (WidgetTester tester) async {
//     await prepareWidget(tester, null);
//     final BuildContext context = tester.element(find.byType(Scaffold));
//
//     var dateTx = '2024-12-31';
//     var timeTx = '00:55';
//
//     String? errMsg = BricksLocalizations.of(context).rangeStartSameAsEnd;
//     var expectedValues = [errMsg, errMsg, errMsg, errMsg];
//
//     var testCases = [
//       RangeTestData([dateTx, timeTx, dateTx, timeTx], expectedValues, errMsg),
//     ];
//     await prepDateTimeRangeTest(tester, rangeId).then((form) async {
//       await testDateTimeRangeValidator(tester, form, keyStrings, testCases).then((passedOk) => expect(passedOk, true));
//     });
//   });
//
//   testWidgets('end-date absent => start-time after end-time', (WidgetTester tester) async {
//     await prepareWidget(tester, null);
//     final BuildContext context = tester.element(find.byType(Scaffold));
//     String? errMsg = BricksLocalizations.of(context).rangeTimeStartAfterEndOrAddDateEnd;
//     var testCases = [
// // date-start time-start time-end
//       RangeTestData(['2024-05-11', '18:03', '', '17:15'], [null, errMsg, errMsg, errMsg], errMsg),
//     ];
//     await prepDateTimeRangeTest(tester, rangeId).then((form) async {
//       await testDateTimeRangeValidator(tester, form, keyStrings, testCases).then((passedOk) => expect(passedOk, true));
//     });
//   });
//
//   testWidgets('start-date = end-date => start-time after end-time', (WidgetTester tester) async {
//     await prepareWidget(tester, null);
//     final BuildContext context = tester.element(find.byType(Scaffold));
//     String? errMsg = BricksLocalizations.of(context).rangeTimeStartAfterEnd;
//     var testCases = [
// // date-start time-start date-end time-end (date-start = date-end)
//       RangeTestData(['2024-05-11', '18:03', '2024-05-11', '17:15'], [null, errMsg, null, errMsg], errMsg),
//     ];
//     await prepDateTimeRangeTest(tester, rangeId).then((form) async {
//       await testDateTimeRangeValidator(tester, form, keyStrings, testCases).then((passedOk) => expect(passedOk, true));
//     });
//   });
//
//   testWidgets('end-date absent => start-time less than minimum before end-time', (WidgetTester tester) async {
//     await prepareWidget(tester, null);
//     final BuildContext context = tester.element(find.byType(Scaffold));
//
//     var minRangeSpanMinutes = AppParams.minRangeSpanMinutes;
//     final DateFormat format = DateFormat("HH:mm");
//     var dateTx = '2024-12-31';
//     var startTime = DateTime.parse('$dateTx 00:10');
//     var endTime = startTime.add(Duration(minutes: minRangeSpanMinutes - 1));
//
//     String? errMsg = BricksLocalizations.of(context).rangeTimeStartEndTooCloseOrAddDateEnd(minRangeSpanMinutes);
// // String? errMsg = '';
//
//     var startTimeTx = format.format(startTime);
//     var endTimeTx = format.format(endTime);
//     var testCases = [
//       RangeTestData([dateTx, startTimeTx, '', endTimeTx], [null, errMsg, errMsg, errMsg], errMsg),
//     ];
//     await prepDateTimeRangeTest(tester, rangeId).then((form) async {
//       await testDateTimeRangeValidator(tester, form, keyStrings, testCases).then((passedOk) => expect(passedOk, true));
//     });
//   });
//
//   testWidgets('start-date = end-date => start-time less than minimum before end-time', (WidgetTester tester) async {
//     await prepareWidget(tester, null);
//     final BuildContext context = tester.element(find.byType(Scaffold));
//
//     var minRangeSpanMinutes = AppParams.minRangeSpanMinutes;
//     final DateFormat format = DateFormat("HH:mm");
//     var dateTx = '2024-12-31';
//     var startTime = DateTime.parse('$dateTx 00:10');
//     var endTime = startTime.add(Duration(minutes: minRangeSpanMinutes - 1));
//
//     String? errMsg = BricksLocalizations.of(context).rangeTimeStartEndTooCloseSameDate(minRangeSpanMinutes);
//
//     var startTimeTx = format.format(startTime);
//     var endTimeTx = format.format(endTime);
//     var testCases = [
//       RangeTestData([dateTx, startTimeTx, dateTx, endTimeTx], [null, errMsg, null, errMsg], errMsg),
//     ];
//     await prepDateTimeRangeTest(tester, rangeId).then((form) async {
//       await testDateTimeRangeValidator(tester, form, keyStrings, testCases).then((passedOk) => expect(passedOk, true));
//     });
//   });
//
// // TODO make date-time tests where user randomly writes, deletes chars
}
