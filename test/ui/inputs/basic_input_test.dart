// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shipping_ui/ui/inputs/base/e_input_name_position.dart';
// import 'package:shipping_ui/ui/forms/form_manager/standalone_form_manager.dart';
// import 'package:shipping_ui/ui/inputs/text/text_inputs_base/basic_text_input.dart';
//
// void main() {
//   const userText = 'New input';
//
//   testWidgets('Readonly input should not accept input', (WidgetTester tester) async {
//     //given
//     await tester.pumpWidget(MaterialApp(
//       home: Scaffold(
//         body: BasicTextInput.basicTextInput(
//           keyString: 'testInput',
//           label: 'Test Input',
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           labelPosition: LabelPosition.topLeft,
//           formManager: StandaloneFormManagerOLD(),
//           readonly: true,
//         ),
//       ),
//     ));
//
//     final inputField = find.byType(FormBuilderTextField);
//
//     //when
//     await tester.enterText(inputField, userText);
//
//     //then
//     await tester.pump();
//     expect(find.text(userText), findsNothing);
//   });
//
//   testWidgets('Editable input should  accept input', (WidgetTester tester) async {
//     //given
//     await tester.pumpWidget(MaterialApp(
//       home: Scaffold(
//         body: BasicTextInput.basicTextInput(
//           keyString: 'testInput',
//           label: 'Test Input',
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           labelPosition: LabelPosition.topLeft,
//           formManager: StandaloneFormManagerOLD(),
//           readonly: false,
//         ),
//       ),
//     ));
//
//     final inputField = find.byType(FormBuilderTextField);
//
//     //when
//     await tester.enterText(inputField, userText);
//
//     //then
//     await tester.pump();
//     expect(find.text(userText), findsOne);
//   });
// }
