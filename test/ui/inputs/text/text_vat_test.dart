// import 'package:flutter/cupertino.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shipping_ui/ui/forms/form_manager/standalone_form_manager.dart';
// import 'package:shipping_ui/ui/inputs/base/e_input_name_position.dart';
// import 'package:shipping_ui/ui/inputs/text/text_inputs.dart';
//
// import '../../../test_data.dart';
// import '../../../test_utils.dart';
//
// void main() {
//   group("Should test vat number input", () {
//     List<TestData> testParams = [
//       TestData("PL1234567891", "PL1234567891"),
//       TestData("PLC", "PL"),
//       TestData("PL123456789123456", "PL1234567891"),
//       TestData("PL1234 567891", "PL1234")
//     ];
//     const String textVatFieldKey = "vat_standalone 1";
//
//     for (var param in testParams) {
//       testWidgets("should test proper input",
//           (WidgetTester tester) async {
//         await TestUtils.prepareWidget(tester, null);
    //    final BuildContext context = tester.element(find.byType(Scaffold));
//         final formManager = StandaloneFormManagerOLD();
//
//         final input = TextInputs.textVat(
//             keyString: textVatFieldKey,
//             labelPosition: LabelPosition.topLeft,
//             // textEditingController: controller,
//             // focusNode: focusNode,
//             formManager: formManager,
//             label: 'Vat input');
//
//         await TestUtils.prepareSimpleForm(tester, formManager, input);
//
//         await tester.enterText(
//             find.byKey(const Key(textVatFieldKey)), param.input);
//         await tester.pump();
//
//         final result = (find
//                 .byKey(const Key(textVatFieldKey))
//                 .evaluate()
//                 .first
//                 .widget as FormBuilderTextField)
//             .controller!
//             .text;
//         expect(result, param.expected);
//       });
//     }
//   });
// }
