// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shipping_ui/ui/forms/form_manager/standalone_form_manager.dart';
//
// import '../../../test_utils.dart';
// import 'constants.dart';
//
// void main() {
//
//   testWidgets("Should test triming spaces in textSimple",
//       (WidgetTester tester) async {
//     //given
//     const String keyString = "regular_input_standalone";
//     const String enteredText = "Space at the end ";
//
//     final formManager = StandaloneFormManagerOLD();
//     await TestUtils.prepareDataForTrimmingSpacesTests(tester, formManager, keyString);
//
//     //when
//     await TestUtils.enterTextAndUnfocusWidget(tester, formManager, keyString, enteredText);
//
//     // Then
//     final resultOne = (find
//             .byKey(const Key(keyString))
//             .evaluate()
//             .first
//             .widget as FormBuilderTextField)
//         .controller!
//         .text;
//     expect(resultOne, "Space at the end");
//   });
//
//   testWidgets(
//       'should stay in focus when clicked Enter for textSimple',
//       (WidgetTester tester) async {
//     //given
//     final formManager = StandaloneFormManagerOLD();
//     const String regularInputKey = "regular_input_standalone";
//
//     await TestUtils.prepareDataForFocusLosingTests(tester, formManager, regularInputKey);
//
//     await tester.pump();
//
//     final inputs = ConstantsText.getInputs(tester);
//
//     await TestUtils.performAndCheckInputActions(tester, formManager, regularInputKey, inputs);
//   });
// }
