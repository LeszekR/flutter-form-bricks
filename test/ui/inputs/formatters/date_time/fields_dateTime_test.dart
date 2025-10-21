// import 'package:flutter/material.dart';
// import 'package:flutter_form_bricks/src/awaiting_refactoring/misc/time_stamp.dart';
// import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/form_manager/form_manager.dart';
// import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/standalone_form_manager.dart';
// import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/date_time_inputs.dart';
// import 'package:flutter_form_bricks/src/inputs/labelled_box/label_position.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
//
// void main() {
//   const dateName = 'date_input_test';
//   const timeName = 'time_input_test';
//
//   const rangeId = "range";
//   var rangeStartDateKey = DateTimeInputs.rangeDateStartKeyString(rangeId);
//   var rangeStartTimeKey = DateTimeInputs.rangeTimeStartKeyString(rangeId);
//   var rangeEndDateKey = DateTimeInputs.rangeDateEndKeyString(rangeId);
//   var rangeEndTimeKey = DateTimeInputs.rangeTimeEndKeyString(rangeId);
//
//   final today = DateTime.now();
//   final todayAsString = Date.dateFormat.format(today);
//
//   FormManagerOLD formManager = StandaloneFormManagerOLD();
//
//   var timeInput;
//   var rangeInput;
//
//   // with start-date only => ok
//   // with start-date + end-time + no start-time => ERROR
//   // with start-date + end-date => ok
//   // with start-date + end-date-time + start-end-duration too short  => ERROR
//   // with start-date + end-date-time + start-end-duration ok  => ok
//
//   // with start-time only => ERROR
//   // with start-time + end-date => ERROR
//   // with start-time + end-date-time  => ERROR
//
//   // with start-date-time only => ok
//   // with start-date-time + end-date + start-end-duration too short => ERROR
//   // with start-date-time + end-date + start-end-duration ok => ok
//   // with start-date-time + end-date-time + start-end-duration too short  => ERROR
//   // with start-date-time + end-date-time + start-end-duration ok  => ok
//   // with start-date-time + end-time + no start-time => ERROR
//
// //   group(
// //       'RANGE - When only start date is provided then both times need to be provided too and both need to be at least ${AppParams.minimumRangeDiffMinutes} minutes apart',
// //       () {
// //     final referenceStartTime = timeFormatMinutePrecision.format(today);
// //
// //     final List<TestData> testParameters = [
// //       TestData(timeFormatMinutePrecision.format(today.subtract(const Duration(minutes: 15))), false),
// //       TestData(timeFormatMinutePrecision.format(today.subtract(const Duration(minutes: 10))), false),
// //       TestData(timeFormatMinutePrecision.format(today.subtract(const Duration(minutes: 1))), false),
// //       TestData(timeFormatMinutePrecision.format(today), false),
// //       TestData(timeFormatMinutePrecision.format(today.subtract(const Duration(minutes: 1))), false),
// //       TestData(timeFormatMinutePrecision.format(today.subtract(const Duration(minutes: 5))), false),
// //       TestData(timeFormatMinutePrecision.format(today.subtract(const Duration(minutes: 10))), false),
// //       TestData(timeFormatMinutePrecision.format(today.add(const Duration(minutes: 15))), true),
// //       TestData(timeFormatMinutePrecision.format(today.add(const Duration(minutes: 16))), true),
// //     ];
// //
// //     for (final param in testParameters) {
// //       testWidgets(
// //           'If start date is $todayAsString and start time $referenceStartTime, then for end time ${param.input} validation result should be: ${param.expected}',
// //           (WidgetTester tester) async {
// //         //given
// //         await prepareSimpleForm(tester, formKey, rangeInput);
// //
// //         //when
// //         await tester.enterText(find.byKey(const Key(rangeStartDateKey)), todayAsString);
// //         await tester.enterText(find.byKey(const Key(rangeStartTimeKey)), referenceStartTime);
// //
// //         await tester.enterText(find.byKey(const Key(rangeEndTimeKey)), param.input);
// //         await tester.pump();
// //
// //         //then
// //         formKey.currentState!.save();
// //         final bool isValid = formKey.currentState!.validate();
// //         expect(isValid, param.expected);
// //       });
// //     }
// //   });
// //
// //   group('RANGE - Start date is mandatory', () {
// //     final List<TestData> testParameters = [
// //       TestData(todayAsString, true),
// //       TestData("", false),
// //     ];
// //
// //     for (final param in testParameters) {
// //       testWidgets('If start date is "${param.input}" validation result should be: ${param.expected}',
// //           (WidgetTester tester) async {
// //         //given
// //         await prepareSimpleForm(tester, formKey, rangeInput);
// //
// //         //when
// //         await tester.enterText(find.byKey(const Key(rangeStartDateKey)), param.input);
// //         await tester.enterText(
// //             find.byKey(const Key(rangeEndDateKey)), Date.dateFormat.format(today.add(const Duration(days: 1))));
// //         await tester.pump();
// //
// //         //then
// //         formKey.currentState!.save();
// //         final bool isValid = formKey.currentState!.validate();
// //         expect(isValid, param.expected);
// //       });
// //     }
// //   });
//
//   Widget makeTextFieldDate(String dateName, FormManagerOLD formManager) {
//     return rangeInput = DateTimeInputs.dateTimeRange(
//       rangeId: rangeId,
//       label: "range",
//       labelPosition: LabelPosition.topLeft,
//       formManager: formManager,
//     );
//   }
// }
