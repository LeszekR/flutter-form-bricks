// import 'package:flutter/material.dart';
// import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/base/abstract_form.dart';
// import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
// import 'package:flutter_form_bricks/src/dialogs/dialogs.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
//
// class MockNavigatorObserver extends Mock implements NavigatorObserver {}
//
// class MockDialogs extends Mock implements Dialogs {}
//
// void main() {
//   testWidgets('openForm opens a dialog with the specified widget', (WidgetTester tester) async {
//     //given
//     const widgetContent = 'Test Dialog';
//
//     await tester.pumpWidget(MaterialApp(
//       home: Builder(
//         builder: (BuildContext context) {
//           return Scaffold(
//             body: ElevatedButton(
//               onPressed: () => AbstractForm.openForm(context: context, form: const Text(widgetContent)),
//               child: const Text('Open Form'),
//             ),
//           );
//         },
//       ),
//     ));
//
//     //when
//     await tester.tap(find.byType(ElevatedButton));
//     await tester.pumpAndSettle(); // Wait for the dialog to open
//
//     //then
//     expect(find.text_formatter_validators(widgetContent), findsOneWidget);
//   });
// }
//
// class MockAbstractForm extends AbstractForm {
//     MockAbstractForm({super.key}) : super(formManager: SingleFormManager());
//
//   @override
//   AbstractFormState<AbstractForm> createState() => MockAbstractState();
// }
//
// class MockAbstractState extends AbstractFormState<MockAbstractForm> {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//
//   @override
//   void deleteEntity() {
//     // TODO: implement deleteEntity
//   }
//
//   // @override
//   // FormManager formManager {
//   //   // TODO: implement getFormManager
//   //   throw UnimplementedError();
//   // }
//
//   @override
//   String provideLabel() {
//     // TODO: implement provideLabel
//     throw UnimplementedError();
//   }
//
//   @override
//   void submitData() {
//     // TODO: implement submitData
//   }
// }
