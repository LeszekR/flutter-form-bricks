// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_bricks/src/awaiting_refactoring/misc/time_stamp.dart';
// import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/date_time_validators.dart';
// import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import '../../../test_utils.dart';
//
// void main() {
//   group('Date Input Validator Tests', () {
//
//     testWidgets('should return null for valid input', (WidgetTester tester) async {
//       await TestUtils.prepareWidget(tester, null);
//       final BuildContext context = tester.element(find.byType(Scaffold));
//     final FormFieldValidator<String> validator = DateTimeValidators.dateInputValidator();
//
//       //given
//       final correctDate = DateTime.now().add(const Duration(days: AppParams.maxYearsForwardInDate * 350));
//
//       // when
//       final result = validator(Date(correctDate).toString());
//
//       //then
//       expect(result, isNull);
//     });
//
//     // testWidgets('should return an error message for null input', (WidgetTester tester) async {
//     //   await TestUtils.prepareWidget(tester, null);
//     // final BuildContext context = tester.element(find.byType(Scaffold));
//     //   //given, when
//     //   final result = validator(null);
//     //
//     //   //then
//     //   expect(result, isNotNull);
//     //   expect(result, equals(BricksLocalizations.of(context).requiredField));
//     // });
//     //
//     // testWidgets('should return an error message for empty string', (WidgetTester tester) async {
//     //   await TestUtils.prepareWidget(tester, null);
//     // final BuildContext context = tester.element(find.byType(Scaffold));
//     //   //given, when
//     //   final result = validator('');
//     //
//     //   //then
//     //   expect(result, isNotNull);
//     //   expect(result, equals(BricksLocalizations.of(context).requiredField));
//     // });
//
//     testWidgets('should return an error message for invalid date format', (WidgetTester tester) async {
//       await TestUtils.prepareWidget(tester, null);
//       final BuildContext context = tester.element(find.byType(Scaffold));
//
//       //given, when
//       final result = validator('invalid-date-format');
//
//       //then
//       expect(result, isNotNull);
//       expect(result, equals(BricksLocalizations.of(context).dateStringErrorBadChars));
//     });
//
//     testWidgets('should return an error message for date before minimum date', (WidgetTester tester) async {
//       await TestUtils.prepareWidget(tester, null);
//       final BuildContext context = tester.element(find.byType(Scaffold));
//
//       //given
//       var dateTooFarBack = Date.dateFormat
//           .format(DateTime.now().subtract(const Duration(days: (AppParams.maxYearsBackInDate + 1) * 370)));
//
//       // when
//       final result = validator(dateTooFarBack);
//
//       //then
//       expect(result, isNotNull);
//       var yearMaxBack = DateTime.now().year - AppParams.maxYearsBackInDate;
//       expect(result, contains(BricksLocalizations.of(context).dateErrorYearTooFarBack(yearMaxBack)));
//     });
//
//     testWidgets('should return an error message for date after maximum date', (WidgetTester tester) async {
//       await TestUtils.prepareWidget(tester, null);
//       final BuildContext context = tester.element(find.byType(Scaffold));
//
//       //given
//       var dateTooFarForward =
//           Date.dateFormat.format(DateTime.now().add(const Duration(days: (AppParams.maxYearsForwardInDate + 1) * 370)));
//
//       // when
//       final result = validator(dateTooFarForward);
//       // final result = validator(Date(max.add(const Duration(days: 1))).toString());
//
//       //then
//       expect(result, isNotNull);
//       var yearMaxForward = DateTime.now().year + AppParams.maxYearsForwardInDate;
//       expect(result, contains(BricksLocalizations.of(context).dateErrorYearTooFarForward(yearMaxForward)));
//     });
//   });
// }
