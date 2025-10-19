// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shipping_ui/ui/inputs/base/e_input_name_position.dart';
// import 'package:shipping_ui/ui/inputs/number/number_inputs.dart';
// import 'package:shipping_ui/ui/forms/form_manager/form_state.dart';
// import 'package:shipping_ui/ui/forms/form_manager/standalone_form_manager.dart';
//
// import '../../test_data.dart';
// import '../../test_utils.dart';
//
// void main() {
//   const key = "key";
//
//   setUp(() async {
//     await TestUtils.loadGlobalConfigurationForTests();
//   });
//
//   group('Decimal input field will allow to put incorrect chars but validator will complain about it', () {
//     final List<TestData> testParameters = [
//       TestData("123w", "1 23w"),
//       TestData("123,145", "123,145"),
//     ];
//
//     for (final params in testParameters) {
//       testWidgets('should complain about ${params.input}', (WidgetTester tester) async {
//         //given
//         await TestUtils.prepareWidget(tester, null);
//    final BuildContext context = tester.element(find.byType(Scaffold));
//
//         var formManager = StandaloneFormManagerOLD();
//         final input = await NumberInputs.textDouble(
//           formManager: formManager,
//           keyString: key,
//           label: "label",
//           labelPosition: LabelPosition.topLeft,
//         );
//         await TestUtils.prepareSimpleForm(tester, formManager, input);
//
//         //when
//         await tester.enterText(find.byKey(const Key(key)), params.input);
//         await tester.pump();
//
//         //then
//         formManager.formKey.currentState!.saveAndValidate();
//         final formState = formManager.checkState();
//         final String? fieldValue = formManager.formKey.currentState!.fields[key]?.value;
//
//         expect(params.expected, fieldValue);
//         expect(find.text(params.expected), findsOneWidget);
//         expect(FormStatus.invalid, formState);
//       });
//     }
//   });
//
//   testWidgets('ID input field does not allow editing', (WidgetTester tester) async {
//     //given
//     const idValue = 12;
//     // final formManager.formKey = GlobalKey<FormBuilderState>();
//     var formManager = StandaloneFormManagerOLD();
//     final input = NumberInputs.id(
//       keyString: key,
//       label: "label",
//       labelPosition: LabelPosition.topLeft,
//       initialValue: idValue,
//       formManager: StandaloneFormManagerOLD(),
//     );
//
//     await TestUtils.prepareSimpleForm(tester, formManager, input);
//
//     //when
//     await tester.enterText(find.byKey(const Key(key)), '21');
//     await tester.pump();
//
//     //then
//     formManager.formKey.currentState!.save();
//     final String? fieldValue = formManager.formKey.currentState!.fields[key]?.value;
//
//     expect("12", fieldValue);
//     expect(find.text("12"), findsOneWidget);
//   });
// }
