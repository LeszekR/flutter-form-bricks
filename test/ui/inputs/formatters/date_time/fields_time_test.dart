// // ignore_for_file: prefer_typing_uninitialized_variables
//
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:intl/intl.dart';
// import 'package:shipping_ui/ui/inputs/date_time/date_time_inputs.dart';
// import 'package:shipping_ui/ui/inputs/base/e_input_name_position.dart';
// import 'package:shipping_ui/ui/forms/form_manager/form_manager.dart';
// import 'package:shipping_ui/ui/forms/form_manager/standalone_form_manager.dart';
//
// import '../../../../date_time_test_data.dart';
// import 'dateTime_test_utils.dart';
//
// void main() {
//   const timeName = 'time_input_test';
//
//   testWidgets('TIME - should refuse to parse when bad character', (WidgetTester tester) async {
//     final List<DateTimeTestData> testCases = [
//       DateTimeTestData(datTimLim,"01*01", "01*01", false, ''),
//       DateTimeTestData(datTimLim,"20+", "20+", false, ''),
//       DateTimeTestData(datTimLim,"20ABCD", "20ABCD", false, ''),
//       DateTimeTestData(datTimLim,"20>20", "20>20", false, ''),
//       DateTimeTestData(datTimLim,"20_20", "20_20", false, ''),
//       DateTimeTestData(datTimLim,"20-a", "20-a", false, ''),
//       DateTimeTestData(datTimLim,"20-@", "20-@", false, ''),
//     ];
//     var formManager = StandaloneFormManagerOLD();
//     testAction<String>(String text) => verifyTime(formManager.formKey.currentState!.fields[timeName]?.value);
//     makeWidgetFunction() => makeTextFieldTime(timeName, formManager);
//     await testAllCasesInTextField(
//         tester, makeWidgetFunction, formManager, testCases, testAction);
//   });
//
//   testWidgets('TIME - Should refuse to parse when bad string', (WidgetTester tester) async {
//     final List<DateTimeTestData> testCases = [
//       DateTimeTestData(datTimLim,"25:14", "25:14", false, ''),
//       DateTimeTestData(datTimLim,"00:70", "00:70", false, ''),
//       DateTimeTestData(datTimLim,"23:539", "23:539", false, ''),
//       DateTimeTestData(datTimLim,"225:14", "25:14 ", false, ''),
//       DateTimeTestData(datTimLim," 03330:70", "00:70", false, ''),
//       DateTimeTestData(datTimLim,"2315 :539", "23:539", false, ''),
//     ];
//     var formManager = StandaloneFormManagerOLD();
//     testAction<String>(String text) => verifyTime(formManager.formKey.currentState!.fields[timeName]?.value);
//     makeWidgetFunction() => makeTextFieldTime(timeName, formManager);
//     await testAllCasesInTextField(
//         tester, makeWidgetFunction, formManager, testCases, testAction);
//   });
//
//   testWidgets('TIME - Should validate time', (WidgetTester tester) async {
//     final List<DateTimeTestData> testCases = [
//       DateTimeTestData(datTimLim,"01 01", "01:01", true, ''),
//       DateTimeTestData(datTimLim,"21:14", "21:14", true, ''),
//       DateTimeTestData(datTimLim,"00:00", "00:00", true, ''),
//       DateTimeTestData(datTimLim,"23:59", "23:59", true, ''),
//       // --------------------------------------------
//       DateTimeTestData(datTimLim,"1:14", "01:14", true, ''),
//       DateTimeTestData(datTimLim,"0/0", "00:00", true, ''),
//       DateTimeTestData(datTimLim,"2359", "23:59", true, ''),
//     ];
//     var formManager = StandaloneFormManagerOLD();
//     testAction<String>(String text) => verifyTime(formManager.formKey.currentState!.fields[timeName]?.value);
//     makeWidgetFunction() => makeTextFieldTime(timeName, formManager);
//     await testAllCasesInTextField(
//         tester, makeWidgetFunction, formManager, testCases, testAction);
//   });
// }
//
// Widget makeTextFieldTime(String timeName, FormManager formManager) {
//   return DateTimeInputs.time(
//       keyString: timeName,
//       label: timeName,
//       labelPosition: LabelPosition.topLeft,
//       formManager: formManager);
// }
//
// String verifyTime(String text) {
//   try {
//     var dateTime = DateTime.parse('2024-01-01 $text');
//     return DateFormat.Hm().format(dateTime);
//   } catch (e) {
//     return "invalid time";
//   }
// }
