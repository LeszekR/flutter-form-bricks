// // ignore_for_file: prefer_typing_uninitialized_variables
//
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shipping_ui/config/objects/model/time_stamp.dart';
// import 'package:shipping_ui/ui/inputs/date_time/date_time_inputs.dart';
// import 'package:shipping_ui/ui/inputs/base/e_input_name_position.dart';
// import 'package:shipping_ui/ui/forms/form_manager/form_manager.dart';
// import 'package:shipping_ui/ui/forms/form_manager/standalone_form_manager.dart';
//
// import '../../../../date_time_test_data.dart';
// import 'util_test_date_time.dart';
//
// void main() {
//   const dateName = 'date_input_test';
//
//   final today = DateTime.now();
//   final todayAsString = Date.dateFormat.format(today);
//
//
//   testWidgets('DATE - refuses to parse with invalid characters', (WidgetTester tester) async {
//     final List<DateTimeTestData> testCases = [
//       DateTimeTestData("01 01", "${today.year}-01-01", true, ''),
//       DateTimeTestData("20/20", "${today.year}-20-20", true, ''),
//       DateTimeTestData("20-20", "${today.year}-20-20", true, ''),
//       DateTimeTestData("20", "20", true, ''),
//       DateTimeTestData("20ABCD", "20ABCD", true, ''),
//       DateTimeTestData("20-a", "20-a", true, ''),
//       DateTimeTestData("20-@", "20-@", true, ''),
//       // -----------------------
//       DateTimeTestData(todayAsString.replaceAll("-", " "), todayAsString, true, ''),
//       DateTimeTestData(todayAsString, todayAsString, true, ''),
//       // -----------------------
//       DateTimeTestData("20ABCD", "20", false, ''),
//       DateTimeTestData("20-a", "20-", false, ''),
//       DateTimeTestData("20-@", "20-", false, ''),
//     ];
//     var formManager = StandaloneFormManagerOLD();
//     testAction<String>(String text) => formManager.formKey.currentState!.fields[dateName]?.value;
//     makeWidgetFunction() => makeTextFieldDate(dateName, formManager);
//     await UtilTestDateTime.testAllCasesInTextField(tester, makeWidgetFunction, formManager, testCases, testAction);
//   });
//
//   testWidgets('DATE - Should validate dates', (WidgetTester tester) async {
//     final List<DateTimeTestData> testCases = [
//       DateTimeTestData("01 01", "${today.year}-01-01", true, ''),
//       DateTimeTestData("20/20", "${today.year}-20-20", false, ''),
//       DateTimeTestData("20-20", "${today.year}-20-20", false, ''),
//       DateTimeTestData("20", "20", false, ''),
//       DateTimeTestData("20ABCD", "20ABCD", false, ''),
//       DateTimeTestData("20-a", "20-a", false, ''),
//       DateTimeTestData("20-@", "20-@", false, ''),
//     ];
//     var formManager = StandaloneFormManagerOLD();
//     testAction<String>(text) => verifyDate(formManager.formKey.currentState!.fields[dateName]?.value);
//     makeWidgetFunction() => makeTextFieldDate(dateName, formManager);
//     await UtilTestDateTime.testAllCasesInTextField(tester, makeWidgetFunction, formManager, testCases, testAction);
//   });
//
//   testWidgets('DATE - Should perform quick date formatting', (WidgetTester tester) async {
//     final List<DateTimeTestData> testCases = [
//       DateTimeTestData("01 01", "${today.year}-01-01", true, ''),
//       DateTimeTestData("1 1", "${today.year}-01-01", true, ''),
//       DateTimeTestData("1/15", "${today.year}-01-15", true, ''),
//       DateTimeTestData("${today.year} 01 01", "${today.year}-01-01", true, ''),
//       DateTimeTestData("${today.year}-5-05", "${today.year}-05-05", true, ''),
//       DateTimeTestData("30/12-4", "2030-12-04", true, ''),
//       DateTimeTestData("0101", "${today.year}-01-01", true, ''),
//     ];
//     var formManager = StandaloneFormManagerOLD();
//     testAction<String>(String text) => formManager.formKey.currentState!.fields[dateName]?.value;
//     makeWidgetFunction() => makeTextFieldDate(dateName, formManager);
//     await UtilTestDateTime.testAllCasesInTextField(tester, makeWidgetFunction, formManager, testCases, testAction);
//   });
// }
//
// Widget makeTextFieldDate(String dateName, FormManager formManager) {
//   return DateTimeInputs.date(
//       keyString: dateName,
//       label: dateName,
//       labelPosition: LabelPosition.topLeft,
//       formManager: formManager);
// }
//
// String verifyDate(String text) {
//   try {
//     return DateTime.parse(text).toString().split(' ')[0];
//   } catch (e) {
//     return "invalid date";
//   }
// }
