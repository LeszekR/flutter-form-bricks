// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
// import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/form_fields/text_formatter_validators/text_fields.dart';
// import 'package:flutter_form_bricks/src/form_fields/labelled_box/label_position.dart';
// import 'package:flutter_form_bricks/src/form_fields/states_controller/formatter_helper.dart';
// import 'package:flutter_form_bricks/src/form_fields/text_formatter_validators/format_and_validate/input_validator_provider.dart';
// import 'package:flutter_form_bricks/src/forms/form_manager/form_status.dart';
// import 'package:flutter_form_bricks/src/forms/state/form_data.dart';
// import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import '../../../test_implementations/test_form_manager.dart';
// import '../../../test_implementations/test_form_schema.dart';
// import '../../../test_implementations/test_form_state_data.dart';
// import '../../test_utils.dart';
//
// void main() {
//   FormData formStateData = TestFormStateData();
//
//   testWidgets("Should test trimming spaces in only lowercase text_formatter_validators field", (WidgetTester tester) async {
//     //given
//     final BuildContext context = await pumpAppGetContext(tester);
//
//     const String lowercaseKey = "2 lowercase text_formatter_validators";
//
//     final formManager = TestFormManager(schema: TestFormSchema());
//     final focusNode = await getFocusNode(tester, lowercaseKey);
//
//     // focusNode.addListener(() {
//     //   if (!focusNode.hasFocus) {
//     //     FormatterHelper.onSubmittedTrimming(controller.text_formatter_validators, controller);
//     //   }
//     // });
//
//     final regularInput = TextInputs.textMultiline(
//         context: context,
//         keyString: lowercaseKey,
//         labelPosition: LabelPosition.topLeft,
//         validator: ValidatorProvider.compose(context: context, isRequired: true),
//         withTextEditingController: true,
//         formManager: formManager,
//         label: 'Bulk text_formatter_validators');
//
//     await prepareSimpleForm(tester, regularInput);
//
//     //when
//     await tester.enterText(find.byKey(const Key(lowercaseKey)), "Lower case space test ");
//     focusNode.unfocus();
//     await tester.pump();
//
//     // Then
//     final resultOne =
//         (find.byKey(const Key(lowercaseKey)).evaluate().first.widget as FormBuilderTextField).controller!.text_formatter_validators;
//     expect(resultOne, "Lower case space test");
//   });
//
//   testWidgets("Should test trimming spaces in multiline text_formatter_validators field", (WidgetTester tester) async {
//     //given
//     final BuildContext context = await pumpAppGetContext(tester);
//
//     const String multilineTextKey = "4 bulkText";
//     final formManager = TestFormManager.testDefault();
//     final focusNode = await getFocusNode(tester, multilineTextKey);
//     final controller = await getTextEditingController(tester, multilineTextKey);
//
//     focusNode.addListener(() {
//       if (!focusNode.hasFocus) {
//         FormatterHelper.onSubmittedTrimming(controller.text_formatter_validators, controller);
//       }
//     });
//
//     final regularInput = TextInputs.textMultiline(
//         context: context,
//         keyString: multilineTextKey,
//         labelPosition: LabelPosition.topLeft,
//         validator: ValidatorProvider.compose(context: context, isRequired: true),
//         withTextEditingController: true,
//         formManager: formManager,
//         label: 'Bulk text_formatter_validators');
//
//     await prepareSimpleForm(tester, regularInput);
//
//     //when
//     await tester.enterText(
//         find.byKey(const Key(multilineTextKey)), "Space at the \n end with multilines \n the space ");
//     focusNode.unfocus();
//     await tester.pump();
//
//     // Then
//     final resultOne =
//         (find.byKey(const Key(multilineTextKey)).evaluate().first.widget as FormBuilderTextField).controller!.text_formatter_validators;
//     expect(resultOne, "Space at the \n end with multilines \n the space");
//   });
//
//   testWidgets("Should test trimming spaces in regular input single", (WidgetTester tester) async {
//     //given
//     final BuildContext context = await pumpAppGetContext(tester);
//
//     const String regularInputKeyString = "regular_input_single";
//     final formManager = TestFormManager.testDefault();
//     final focusNode = await getFocusNode(tester, regularInputKeyString);
//     final controller = await getTextEditingController(tester, regularInputKeyString);
//
//     focusNode.addListener(() {
//       if (!focusNode.hasFocus) {
//         FormatterHelper.onSubmittedTrimming(controller.text_formatter_validators, controller);
//       }
//     });
//
//     final regularInput = TextInputs.textSimple(
//         context: context,
//         keyString: regularInputKeyString,
//         labelPosition: LabelPosition.topLeft,
//         validator: ValidatorProvider.compose(context: context, isRequired: true),
//         withTextEditingController: true,
//         formManager: formManager,
//         label: 'Prosty text_formatter_validators input');
//
//     await prepareSimpleForm(tester, regularInput);
//
//     //when
//     await tester.enterText(find.byKey(const Key(regularInputKeyString)), "Space at the end ");
//     focusNode.unfocus();
//     await tester.pump();
//
//     // Then
//     final resultOne =
//         (find.byKey(const Key(regularInputKeyString)).evaluate().first.widget as FormBuilderTextField).controller!.text_formatter_validators;
//     expect(resultOne, "Space at the end");
//   });
//
//   testWidgets('should stay in focus when clicked Enter for regular input single', (WidgetTester tester) async {
//     //given
//     final BuildContext context = await pumpAppGetContext(tester);
//
//     const String regularInputKeyString = "regular_input_single";
//     TestFormManager formManager = TestFormManager.testDefault();
//     final focusNode = await getFocusNode(tester, regularInputKeyString);
//     final controller = await getTextEditingController(tester, regularInputKeyString);
//     final input = makeRequiredTextField(context, keyRequired, labelRequired, formManager);
//     await prepareSimpleForm(tester, input);
//
//     final regularInput = TextInputs.textSimple(
//         context: context,
//         keyString: regularInputKeyString,
//         labelPosition: LabelPosition.topLeft,
//         validator: ValidatorProvider.compose(context: context, isRequired: true),
//         withTextEditingController: true,
//         formManager: formManager,
//         label: 'Prosty text_formatter_validators input');
//
//     // TODO LR: create reularInput here with its Column and pass to the method described in line 30
//     await prepareSimpleForm(
//         tester,
//         Column(
//           children: [
//             regularInput,
//             const SizedBox(key: Key("Sized box"), height: 30),
//             Container(
//               width: double.infinity,
//               height: 50,
//               color: Colors.transparent,
//               // Empty area to click outside the TextField
//               key: const Key('outside_click_area'),
//             ),
//             ElevatedButton(
//                 key: const Key("Dummy button"),
//                 onPressed: () {},
//                 child: const Text('Dummy button')), // Another focusable widget
//           ],
//         ));
//
//     await tester.pump();
//
//     final form_fields = {
//       'Enter': () async {
//         await tester.sendKeyEvent(LogicalKeyboardKey.enter);
//       },
//       'Tab': () async {
//         await tester.sendKeyEvent(LogicalKeyboardKey.tab);
//       },
//       'Mouse': () async {
//         TestPointer testPointer = TestPointer(1, PointerDeviceKind.mouse);
//         await tester.sendEventToBinding(testPointer.down(const Offset(0, 100)));
//
//         await tester.sendEventToBinding(testPointer.up());
//         await tester.pump();
//       }
//     };
//
//     //when
//     for (var method in form_fields.entries) {
//       controller.clear();
//       await tester.pump();
//
//       await tester.enterText(find.byKey(const Key(regularInputKeyString)), "text_formatter_validators example");
//       await tester.pump();
//
//       expect(focusNode.hasFocus, true);
//
//       await method.value();
//       await tester.pump();
//
//       if (method.key == "Mouse" || method.key == "Tab") {
//         expect(focusNode.hasFocus, false, reason: "${method.key} failed to loose focus");
//       } else {
//         expect(focusNode.hasFocus, true, reason: "${method.key} failed to retain focus");
//       }
//     }
//   });
//
//   testWidgets('Should have UNTOUCHED status if no input was changed', (WidgetTester tester) async {
//     //given
//     TestFormManager formManager = TestFormManager.testDefault();
//     final BuildContext context = await pumpAppGetContext(tester);
//
//     final input = makeRequiredTextField(context, keyRequired, labelRequired, formManager, initialValue: '5');
//     await prepareSimpleForm(tester, input);
//
//     //when
//     final FormStatus result = formManager.checkStatus();
//
//     //then
//     await tester.pump();
//     expect(result, FormStatus.noChange);
//   });
//
//   testWidgets('Should have INVALID status if input is invalid', (WidgetTester tester) async {
//     //given
//     TestFormManager formManager = TestFormManager.testDefault();
//     await prepareLocalizations(tester);
//     final BuildContext context = tester.element(find.byType(Scaffold));
//
//     var inputThatRequires3Chars = makeRequiredMin3CharsTextField(context, key3Chars, label3Chars, formManager);
//     await prepareSimpleForm(tester, inputThatRequires3Chars);
//
//     final inputField = find.byKey(const Key(key3Chars));
//     await tester.enterText(inputField, "1");
//
//     //when
//     final FormStatus result = formManager.checkStatus();
//
//     //then
//     await tester.pump();
//     expect(result, FormStatus.invalid);
//   });
//
//   testWidgets('Should have VALID status if input is valid', (WidgetTester tester) async {
//     //given
//     TestFormManager formManager = TestFormManager.testDefault();
//     await prepareLocalizations(tester);
//     final BuildContext context = tester.element(find.byType(Scaffold));
//
//     var inputThatRequires3Chars = makeRequiredMin3CharsTextField(context, key3Chars, label3Chars, formManager);
//     await prepareSimpleForm(tester, inputThatRequires3Chars);
//
//     final inputField = find.byKey(const Key(key3Chars));
//     await tester.enterText(inputField, "123");
//
//     //when
//     final FormStatus result = formManager.checkStatus();
//
//     //then
//     await tester.pump();
//     expect(result, FormStatus.valid);
//   });
//
//   testWidgets('Should show error message for invalid form_fields only', (WidgetTester tester) async {
//     //given
//     TestFormManager formManager = TestFormManager.testDefault();
//     const keyInputInvalid = "inputThatWillBeInvalid";
//     const keyInputValid = "inputThatWillBeValid";
//     await prepareLocalizations(tester);
//     final BuildContext context = tester.element(find.byType(Scaffold));
//
//     var inputThatWillBeInvalid =
//         makeRequiredMin3CharsTextField(context, keyInputInvalid, label3Chars, formManager, withTextEditingController: true);
//     var inputThatWillBeValid =
//         makeRequiredTextField(context, keyInputValid, labelRequired, formManager, withTextEditingController: true);
//     final Row inputRow = Row(
//       children: [inputThatWillBeInvalid, inputThatWillBeValid],
//     );
//
//     await prepareSimpleForm(tester, inputRow);
//     expect(formManager.errorMessageNotifier.value, "");
//
//     await tester.enterText(find.byKey(const Key(keyInputValid)), "12345");
//     await tester.enterText(find.byKey(const Key(keyInputInvalid)), "klm");
//     await tester.enterText(find.byKey(const Key(keyInputInvalid)), "");
//
//     //when
//     final FormStatus result = formManager.checkStatus();
//
//     //then
//     await tester.pump();
//     expect(result, FormStatus.invalid);
//     expect(formManager.errorMessageNotifier.value, BricksLocalizations.of(context).requiredField);
//   });
//
//   // testWidgets('Should clear all error messages once form is valid', (WidgetTester tester) async {
//   //   //given
//   //   SingleFormManager formManager = SingleFormManager();
//   //   await prepareLocalizations(tester);
//   //  final BuildContext context = tester.element(find.byType(Scaffold));
//   //   var inputThatRequires3Chars = makeRequiredMin3Chars(key3Chars, label3Chars, formManager);
//   //   await prepareSimpleForm(tester, inputThatRequires3Chars);
//   //   final inputField = find.byKey(const Key(key3Chars));
//   //
//   //   await tester.enterText(inputField, "1");
//   //   await tester.pump();
//   //
//   //   expect(formManager.checkState(), FormStatus.invalid);
//   //   expect(formManager.errorMessageNotifier.value, BricksLocalizations.of(context).minNChars(3));
//   //
//   //   //when
//   //   await tester.enterText(inputField, "123");
//   //   await tester.pump();
//   //
//   //   //then
//   //   expect(formManager.checkState(), FormStatus.valid);
//   //   expect(formManager.errorMessageNotifier.value, '');
//   // });
//
//   testWidgets('Should reset form', (WidgetTester tester) async {
//     //given
//     TestFormManager formManager = TestFormManager.testDefault();
//     await prepareLocalizations(tester);
//     final BuildContext context = tester.element(find.byType(Scaffold));
//
//     var inputThatRequires3Chars =
//         makeRequiredMin3CharsTextField(context, key3Chars, label3Chars, formManager, initialValue: '333');
//     await prepareSimpleForm(tester, inputThatRequires3Chars);
//
//     final inputField = find.byKey(const Key(key3Chars));
//     await tester.enterText(inputField, "1");
//     await tester.pump();
//
//     expect(find.text_formatter_validators("1"), findsOne);
//     expect(formManager.checkStatus(), FormStatus.invalid);
//     expect(formManager.errorMessageNotifier.value, BricksLocalizations.of(context).minNChars(3));
//
//     //when
//     formManager.resetForm();
//
//     await tester.pump();
//
//     //then
//     expect(formManager.checkStatus(), FormStatus.noChange);
//     expect(formManager.errorMessageNotifier.value, '');
//     expect(find.text_formatter_validators("1"), findsNothing);
//   });
//
//   testWidgets('Should collect data from form and trim string values if needed', (WidgetTester tester) async {
//     //given
//     TestFormManager formManager = TestFormManager.testDefault();
//     await prepareLocalizations(tester);
//     final BuildContext context = tester.element(find.byType(Scaffold));
//
//     var inputThatRequires3Chars = makeRequiredMin3CharsTextField(context, key3Chars, label3Chars, formManager);
//     var anotherInput = makeRequiredTextField(context, keyRequired, labelRequired, formManager);
//     final Row inputRow = Row(children: [inputThatRequires3Chars, anotherInput]);
//
//     await prepareSimpleForm(tester, inputRow);
//     expect(formManager.errorMessageNotifier.value, "");
//
//     await tester.enterText(find.byKey(const Key(key3Chars)), "valueForInputOneThat has trailing spaces  ");
//     await tester.enterText(find.byKey(const Key(keyRequired)), "valueForInputTwo");
//     await tester.enterText(find.byKey(const Key(key3Chars)), "valueForInputOneThat has trailing spaces  ");
//     await tester.enterText(find.byKey(const Key(keyRequired)), "valueForInputTwo");
//     await tester.pump();
//
//     //when
//     final FormStatus result = formManager.checkStatus();
//
//     //then
//     expect(result, FormStatus.valid);
//
//     final formData = formManager.collectInputData();
//
//     expect(formData, containsPair(key3Chars, 'valueForInputOneThat has trailing spaces'));
//     expect(formData, containsPair(keyRequired, "valueForInputTwo"));
//   });
// }
