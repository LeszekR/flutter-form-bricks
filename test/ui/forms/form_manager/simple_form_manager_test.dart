import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/shelf.dart' show FormatterHelper, BricksLocalizations;
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/text/text_inputs.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_status.dart';
import 'package:flutter_form_bricks/src/forms/state/field_and_validator.dart';
import 'package:flutter_form_bricks/src/forms/state/single_form_state_data.dart';
import 'package:flutter_form_bricks/src/form_fields/labelled_box/label_position.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/input_validator_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_utils.dart';

void main() {
  var formStateData = SingleFormStateData(formKeyString,_schema );

  testWidgets("Should test trimming spaces in only lowercase text field", (WidgetTester tester) async {
    //given
    final BuildContext context = await pumpAppGetContext(tester);

    const String LOWERCASE_KEY = "2 lowercase text";

    final formManager = SingleFormManager();
    final focusNode = formManager.getFocusNode(LOWERCASE_KEY);
    final controller = formManager.getTextEditingController(LOWERCASE_KEY);

    // focusNode.addListener(() {
    //   if (!focusNode.hasFocus) {
    //     FormatterHelper.onSubmittedTrimming(controller.text, controller);
    //   }
    // });

    final regularInput = TextInputs.textMultiline(
        context: context,
        keyString: LOWERCASE_KEY,
        labelPosition: LabelPosition.topLeft,
        validator: ValidatorProvider.compose(context: context, isRequired: true),
        withTextEditingController: true,
        formManager: formManager,
        label: 'Bulk text');

    await prepareSimpleForm(tester, formManager, regularInput);

    //when
    await tester.enterText(find.byKey(const Key(LOWERCASE_KEY)), "Lower case space test ");
    focusNode.unfocus();
    await tester.pump();

    // Then
    final resultOne =
        (find.byKey(const Key(LOWERCASE_KEY)).evaluate().first.widget as FormBuilderTextField).controller!.text;
    expect(resultOne, "Lower case space test");
  });

  testWidgets("Should test trimming spaces in multiline text field", (WidgetTester tester) async {
    //given
    final BuildContext context = await pumpAppGetContext(tester);

    const String MULTILINE_TEXT_KEY = "4 bulkText";
    final formManager = SingleFormManager();
    final focusNode = formManager.getFocusNode(MULTILINE_TEXT_KEY);
    final controller = formManager.getTextEditingController(MULTILINE_TEXT_KEY);

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        FormatterHelper.onSubmittedTrimming(controller.text, controller);
      }
    });

    final regularInput = TextInputs.textMultiline(
        context: context,
        keyString: MULTILINE_TEXT_KEY,
        labelPosition: LabelPosition.topLeft,
        validator: ValidatorProvider.compose(context: context, isRequired: true),
        withTextEditingController: true,
        formManager: formManager,
        label: 'Bulk text');

    await prepareSimpleForm(tester, formManager, regularInput);

    //when
    await tester.enterText(
        find.byKey(const Key(MULTILINE_TEXT_KEY)), "Space at the \n end with multilines \n the space ");
    focusNode.unfocus();
    await tester.pump();

    // Then
    final resultOne =
        (find.byKey(const Key(MULTILINE_TEXT_KEY)).evaluate().first.widget as FormBuilderTextField).controller!.text;
    expect(resultOne, "Space at the \n end with multilines \n the space");
  });

  testWidgets("Should test triming spaces in regular input single", (WidgetTester tester) async {
    //given
    final BuildContext context = await pumpAppGetContext(tester);

    const String REGULAR_INPUT_KEY = "regular_input_single";
    final formManager = SingleFormManager();
    final focusNode = formManager.getFocusNode(REGULAR_INPUT_KEY);
    final controller = formManager.getTextEditingController(REGULAR_INPUT_KEY);

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        FormatterHelper.onSubmittedTrimming(controller.text, controller);
      }
    });

    final regularInput = TextInputs.textSimple(
        context: context,
        keyString: REGULAR_INPUT_KEY,
        labelPosition: LabelPosition.topLeft,
        validator: ValidatorProvider.compose(context: context, isRequired: true),
        withTextEditingController: true,
        formManager: formManager,
        label: 'Prosty text input');

    await prepareSimpleForm(tester, formManager, regularInput);

    //when
    await tester.enterText(find.byKey(const Key(REGULAR_INPUT_KEY)), "Space at the end ");
    focusNode.unfocus();
    await tester.pump();

    // Then
    final resultOne =
        (find.byKey(const Key(REGULAR_INPUT_KEY)).evaluate().first.widget as FormBuilderTextField).controller!.text;
    expect(resultOne, "Space at the end");
  });

  testWidgets('should stay in focus when clicked Enter for regular input single', (WidgetTester tester) async {
    //given
    final BuildContext context = await pumpAppGetContext(tester);

    const String REGULAR_INPUT_KEY = "regular_input_single";
    SingleFormManager formManager = SingleFormManager();
    final focusNode = formManager.getFocusNode(REGULAR_INPUT_KEY);
    final controller = formManager.getTextEditingController(REGULAR_INPUT_KEY);
    final input = makeRequired(context, keyRequired, labelRequired, formManager);
    await prepareSimpleForm(tester, formManager, input);

    final regularInput = TextInputs.textSimple(
        context: context,
        keyString: REGULAR_INPUT_KEY,
        labelPosition: LabelPosition.topLeft,
        validator: ValidatorProvider.compose(context: context, isRequired: true),
        withTextEditingController: true,
        formManager: formManager,
        label: 'Prosty text input');

    // TODO LR: create reularInput here with its Column and pass to the method described in line 30
    await prepareSimpleForm(
        tester,
        formManager,
        Column(
          children: [
            regularInput,
            const SizedBox(key: Key("Sized box"), height: 30),
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.transparent,
              // Empty area to click outside the TextField
              key: const Key('outside_click_area'),
            ),
            ElevatedButton(
                key: const Key("Dummy button"),
                onPressed: () {},
                child: const Text('Dummy button')), // Another focusable widget
          ],
        ));

    await tester.pump();

    final inputs = {
      'Enter': () async {
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      },
      'Tab': () async {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      },
      'Mouse': () async {
        TestPointer testPointer = TestPointer(1, PointerDeviceKind.mouse);
        await tester.sendEventToBinding(testPointer.down(const Offset(0, 100)));

        await tester.sendEventToBinding(testPointer.up());
        await tester.pump();
      }
    };

    //when
    for (var method in inputs.entries) {
      controller.clear();
      await tester.pump();

      await tester.enterText(find.byKey(const Key(REGULAR_INPUT_KEY)), "text example");
      await tester.pump();

      expect(focusNode.hasFocus, true);

      await method.value();
      await tester.pump();

      if (method.key == "Mouse" || method.key == "Tab") {
        expect(focusNode.hasFocus, false, reason: "${method.key} failed to loose focus");
      } else {
        expect(focusNode.hasFocus, true, reason: "${method.key} failed to retain focus");
      }
    }
  });

  testWidgets('Should have UNTOUCHED status if no input was changed', (WidgetTester tester) async {
    //given
    SingleFormManager formManager = SingleFormManager();
    final BuildContext context = await pumpAppGetContext(tester);

    final input = makeRequired(context, keyRequired, labelRequired, formManager, initialValue: '5');
    await prepareSimpleForm(tester, formManager, input);

    //when
    final FormStatus result = formManager.checkStatus();

    //then
    await tester.pump();
    expect(result, FormStatus.noChange);
  });

  testWidgets('Should have INVALID status if input is invalid', (WidgetTester tester) async {
    //given
    SingleFormManager formManager = SingleFormManager();
    await prepareWidget(tester);
    final BuildContext context = tester.element(find.byType(Scaffold));

    var inputThatRequires3Chars = makeRequiredMin3Chars(context, key3Chars, label3Chars, formManager);
    await prepareSimpleForm(tester, formManager, inputThatRequires3Chars);

    final inputField = find.byKey(const Key(key3Chars));
    await tester.enterText(inputField, "1");

    //when
    final FormStatus result = formManager.checkStatus();

    //then
    await tester.pump();
    expect(result, FormStatus.invalid);
  });

  testWidgets('Should have VALID status if input is valid', (WidgetTester tester) async {
    //given
    SingleFormManager formManager = SingleFormManager();
    await prepareWidget(tester);
    final BuildContext context = tester.element(find.byType(Scaffold));

    var inputThatRequires3Chars = makeRequiredMin3Chars(context, key3Chars, label3Chars, formManager);
    await prepareSimpleForm(tester, formManager, inputThatRequires3Chars);

    final inputField = find.byKey(const Key(key3Chars));
    await tester.enterText(inputField, "123");

    //when
    final FormStatus result = formManager.checkStatus();

    //then
    await tester.pump();
    expect(result, FormStatus.valid);
  });

  testWidgets('Should show error message for invalid form_fields only', (WidgetTester tester) async {
    //given
    SingleFormManager formManager = SingleFormManager();
    const keyInputInvalid = "inputThatWillBeInvalid";
    const keyInputValid = "inputThatWillBeValid";
    await prepareWidget(tester);
    final BuildContext context = tester.element(find.byType(Scaffold));

    var inputThatWillBeInvalid =
        makeRequiredMin3Chars(context, keyInputInvalid, label3Chars, formManager, withTextEditingController: true);
    var inputThatWillBeValid =
        makeRequired(context, keyInputValid, labelRequired, formManager, withTextEditingController: true);
    final Row inputRow = Row(
      children: [inputThatWillBeInvalid, inputThatWillBeValid],
    );

    await prepareSimpleForm(tester, formManager, inputRow);
    expect(formManager.errorMessageNotifier.value, "");

    await tester.enterText(find.byKey(const Key(keyInputValid)), "12345");
    await tester.enterText(find.byKey(const Key(keyInputInvalid)), "klm");
    await tester.enterText(find.byKey(const Key(keyInputInvalid)), "");

    //when
    final FormStatus result = formManager.checkStatus();

    //then
    await tester.pump();
    expect(result, FormStatus.invalid);
    expect(formManager.errorMessageNotifier.value, BricksLocalizations.of(context).requiredField);
  });

  // testWidgets('Should clear all error messages once form is valid', (WidgetTester tester) async {
  //   //given
  //   SingleFormManager formManager = SingleFormManager();
  //   await prepareWidget(tester);
  //  final BuildContext context = tester.element(find.byType(Scaffold));
  //   var inputThatRequires3Chars = makeRequiredMin3Chars(key3Chars, label3Chars, formManager);
  //   await prepareSimpleForm(tester, formManager, inputThatRequires3Chars);
  //   final inputField = find.byKey(const Key(key3Chars));
  //
  //   await tester.enterText(inputField, "1");
  //   await tester.pump();
  //
  //   expect(formManager.checkState(), FormStatus.invalid);
  //   expect(formManager.errorMessageNotifier.value, BricksLocalizations.of(context).minNChars(3));
  //
  //   //when
  //   await tester.enterText(inputField, "123");
  //   await tester.pump();
  //
  //   //then
  //   expect(formManager.checkState(), FormStatus.valid);
  //   expect(formManager.errorMessageNotifier.value, '');
  // });

  testWidgets('Should reset form', (WidgetTester tester) async {
    //given
    SingleFormManager formManager = SingleFormManager();
    await prepareWidget(tester);
    final BuildContext context = tester.element(find.byType(Scaffold));

    var inputThatRequires3Chars =
        makeRequiredMin3Chars(context, key3Chars, label3Chars, formManager, initialValue: '333');
    await prepareSimpleForm(tester, formManager, inputThatRequires3Chars);

    final inputField = find.byKey(const Key(key3Chars));
    await tester.enterText(inputField, "1");
    await tester.pump();

    expect(find.text("1"), findsOne);
    expect(formManager.checkStatus(), FormStatus.invalid);
    expect(formManager.errorMessageNotifier.value, BricksLocalizations.of(context).minNChars(3));

    //when
    formManager.resetForm();

    await tester.pump();

    //then
    expect(formManager.checkStatus(), FormStatus.noChange);
    expect(formManager.errorMessageNotifier.value, '');
    expect(find.text("1"), findsNothing);
  });

  testWidgets('Should collect data from form and trim string values if needed', (WidgetTester tester) async {
    //given
    SingleFormManager formManager = SingleFormManager();
    await prepareWidget(tester);
    final BuildContext context = tester.element(find.byType(Scaffold));

    var inputThatRequires3Chars = makeRequiredMin3Chars(context, key3Chars, label3Chars, formManager);
    var anotherInput = makeRequired(context, keyRequired, labelRequired, formManager);
    final Row inputRow = Row(children: [inputThatRequires3Chars, anotherInput]);

    await prepareSimpleForm(tester, formManager, inputRow);
    expect(formManager.errorMessageNotifier.value, "");

    await tester.enterText(find.byKey(const Key(key3Chars)), "valueForInputOneThat has trailing spaces  ");
    await tester.enterText(find.byKey(const Key(keyRequired)), "valueForInputTwo");
    await tester.enterText(find.byKey(const Key(key3Chars)), "valueForInputOneThat has trailing spaces  ");
    await tester.enterText(find.byKey(const Key(keyRequired)), "valueForInputTwo");
    await tester.pump();

    //when
    final FormStatus result = formManager.checkStatus();

    //then
    expect(result, FormStatus.valid);

    final formData = formManager.collectInputData();

    expect(formData, containsPair(key3Chars, 'valueForInputOneThat has trailing spaces'));
    expect(formData, containsPair(keyRequired, "valueForInputTwo"));
  });
}
