// part of 'dateTimeRange_validator_test.dart';
//
// //https://medium.com/swlh/3-tricks-to-test-your-widgets-with-flutter-more-comfortably-88fcae5616cc
//
// Future<bool> testDateTimeRangeValidator(
//     tester, TestStandaloneForm form, List<String> keyStrings, List<RangeTestData> testCases) async {
//   String? errors;
//   String input = '';
//   String? actual, expected;
//   bool passedOk = true;
//   String dateStart, timeStart, dateEnd, timeEnd;
//   var formManager = form.formManager as StandaloneFormManagerOLD;
//   var errorFieldFinder = find.byKey(Key(form.errorkeyString));
//   Text errorField;
//
//   for (var testCase in testCases) {
//     errors = null;
//     //
//     // when
//     // .......................................................................................
//     dateStart = fillEmpty(testCase, 0, '----');
//     timeStart = fillEmpty(testCase, 1, '--');
//     dateEnd = fillEmpty(testCase, 2, '----');
//     timeEnd = fillEmpty(testCase, 3, '--');
//     input = ' $dateStart $timeStart / $dateEnd $timeEnd';
//
//     int? errFieldIndex;
//     for (int i = 0; i < 4; i++) {
//       await tester.enterText(find.byKey(Key(keyStrings[i])), testCase.texts[i]);
//       if (errFieldIndex == null && testCase.expectedValues[i] != null) {
//         errFieldIndex = i;
//         continue;
//       }
//     }
//
//     // repeat fill and Enter in the incorrect field for the formManager to show errorMessage in the form err-text
//     if (errFieldIndex != null) {
//       await tester.enterText(find.byKey(Key(keyStrings[errFieldIndex])), testCase.texts[errFieldIndex]);
//       await tester.testTextInput.receiveAction(TextInputAction.done);
//     }
//     await tester.pump();
//
//     // then
//     // .......................................................................................
//     for (int i = 0; i < 4; i++) {
//       actual = formManager.getErrorMessage(keyStrings[i]);
//       expected = testCase.expectedValues[i];
//       errors = tryExpect('', actual, expected, errors, 'field ${i + 1}');
//     }
//     errorField = tester.firstWidget(errorFieldFinder);
//     actual = errorField.data;
//     expected = testCase.errorMessage ?? '';
//     errors = tryExpect('', actual, expected, errors, 'Form error message');
//
//     if (errors != null) debugPrint("test failed: input $input $errors");
//     passedOk &= errors == null;
//   }
//   return passedOk;
// }
//
// Future<TestStandaloneForm> prepDateTimeRangeTest(WidgetTester tester, String rangeId) async {
//   var form = TestStandaloneForm(
//     widgetMaker: (FormManager formManager) => DateTimeInputs.dateTimeRange(
//       rangeId: rangeId,
//       formManager: formManager,
//       labelPosition: LabelPosition.topLeft,
//       label: "Załadunek",
//     ),
//   );
//   await tester.pumpWidget(Provider<ApplicationState>(
//     create: (_) => ApplicationState(),
//     child: MaterialApp(
//       home: Scaffold(
//         body: FormBuilder(
//           key: GlobalKey(),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   height: 500,
//                   child: form,
//                 ),
//                 const Flexible(
//                   fit: FlexFit.loose,
//                   child: SizedBox(width: 1),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   ));
//   return form;
// }
//
// String fillEmpty(RangeTestData testCase, int index, String fill) =>
//     testCase.texts[index].isEmpty ? fill : testCase.texts[index];
//
// class RangeTestData {
//   final List<String> texts;
//   final List<String?> expectedValues;
//   final String? errorMessage;
//
//   const RangeTestData(this.texts, this.expectedValues, this.errorMessage);
// }
