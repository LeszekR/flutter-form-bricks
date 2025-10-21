// import 'package:flutter/cupertino.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shipping_ui/ui/forms/form_manager/standalone_form_manager.dart';
//
// import '../../../test_utils.dart';
// import 'constants.dart';
//
// void main() {
//   const String keyString = "4 bulkText";
//   const String enteredText =
//       "Space at the \n end with multilines \n the space ";
//
//   testWidgets("Should test trimming spaces in multiline text field",
//       (WidgetTester tester) async {
//     //given
//     final StandaloneFormManagerOLD formManager = StandaloneFormManagerOLD();
//     await prepareDataForTrimmingSpacesTests(tester, formManager, keyString);
//
//     //when
//     await enterTextAndUnfocusWidget(tester, formManager, keyString,enteredText);
//
//     // Then
//     final resultOne = (find
//             .byKey(const Key(keyString))
//             .evaluate()
//             .first
//             .widget as FormBuilderTextField)
//         .controller!
//         .text;
//     expect(resultOne, "Space at the \n end with multilines \n the space");
//   });
//
//   testWidgets('should stay in focus when clicked Enter in multiline text field',
//       (WidgetTester tester) async {
//     //given
//     final StandaloneFormManagerOLD formManager = StandaloneFormManagerOLD();
//     await prepareDataForFocusLosingTests(tester, formManager, keyString);
//
//     await tester.pump();
//
//     final inputs = ConstantsText.getInputs(tester);
//
//     await performAndCheckInputActions(tester, formManager, keyString, inputs);
//   });
// }
