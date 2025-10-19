// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shipping_ui/ui/inputs/text/first_upper_then_lower_case_formatter.dart';
// import 'package:shipping_ui/ui/forms/form_manager/standalone_form_manager.dart';
//
// import '../../../test_data.dart';
// import '../../../test_utils.dart';
// import 'constants.dart';
//
// void main() {
//   const String keyString = "first_uppercase_text_standalone 2";
//
//   group('Should always format first uppercase', () {
//     final List<TestData> testParameters = [
//       TestData("Adam Test", "Adam Test"),
//       TestData("adam test", "Adam Test"),
//       TestData("adam-test", "Adam-Test"),
//       TestData("a b cd", "A B Cd"),
//     ];
//
//     for (final param in testParameters) {
//       testWidgets('Formatter should turn "${param.input}" into: "${param.expected}"', (WidgetTester tester) async {
//         //given
//         const TextEditingValue initial = TextEditingValue(text: "");
//         final TextEditingValue newInput = TextEditingValue(text: param.input);
//
//         //when
//         final result = FirstUpperThenLowerCaseFormatter().formatEditUpdate(initial, newInput);
//
//         //then
//         expect(result.text, param.expected);
//       });
//     }
//   });
//
//   testWidgets("Should test triming spaces in first upper then lower field", (WidgetTester tester) async {
//         //given
//         const String enteredText = "Space at the end ";
//
//         final formManager = StandaloneFormManagerOLD();
//         await TestUtils.prepareDataForTrimmingSpacesTests(tester, formManager, keyString);
//
//         //when
//         await TestUtils.enterTextAndUnfocusWidget(tester, formManager, keyString, enteredText);
//
//         // Then
//         final resultOne = (find
//             .byKey(const Key(keyString))
//             .evaluate()
//             .first
//             .widget as FormBuilderTextField)
//             .controller!
//             .text;
//         expect(resultOne, "Space at the end");
//       });
//
//   testWidgets(
//       'should stay in focus when clicked Enter for firstUpperThenLowerCase',
//           (WidgetTester tester) async {
//         //given
//         final formManager = StandaloneFormManagerOLD();
//
//         await TestUtils.prepareDataForFocusLosingTests(tester, formManager, keyString);
//
//         await tester.pump();
//
//         final inputs = ConstantsText.getInputs(tester);
//
//         await TestUtils.performAndCheckInputActions(tester, formManager, keyString, inputs);
//       });
// }
