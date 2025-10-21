import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/shelf.dart' show FormatterHelper, BricksLocalizations;
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/form_manager/form_state.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/standalone_form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/text/text_inputs.dart';
import 'package:flutter_form_bricks/src/inputs/labelled_box/label_position.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/input_validator_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_utils.dart';

void main() {
  const labelRequired = labelRequired;
  const key3Chars = key3Chars;
  const label3Chars = label3Chars;

  testWidgets("Should test trimming spaces in only lowercase text field", (WidgetTester tester) async {
    //given
    await prepareWidget(tester, null);
    final BuildContext context = tester.element(find.byType(Scaffold));

    const String LOWERCASE_KEY = "2 lowercase text";

    final formManager = StandaloneFormManagerOLD();
    final focusNode = formManager.getFocusNode(LOWERCASE_KEY);
    final controller = formManager.getTextEditingController(LOWERCASE_KEY);

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        FormatterHelper.onSubmittedTrimming(controller.text, controller);
      }
    });

    final regularInput = TextInputs.textMultiline(
        context: context,
        keyString: LOWERCASE_KEY,
        labelPosition: LabelPosition.topLeft,
        validator: ValidatorProvider.compose(context: context,  isRequired: true),
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
    await prepareWidget(tester, null);
    final BuildContext context = tester.element(find.byType(Scaffold));

    const String MULTILINE_TEXT_KEY = "4 bulkText";
    final formManager = StandaloneFormManagerOLD();
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
        validator: ValidatorProvider.compose(context: context,  isRequired: true),
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

  testWidgets("Should test triming spaces in regular input standalone", (WidgetTester tester) async {
    //given
    await prepareWidget(tester, null);
    final BuildContext context = tester.element(find.byType(Scaffold));

    const String REGULAR_INPUT_KEY = "regular_input_standalone";
    final formManager = StandaloneFormManagerOLD();
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
        validator: ValidatorProvider.compose(context: context,  isRequired: true),
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

  testWidgets('should stay in focus when clicked Enter for regular input standalone', (WidgetTester tester) async {
    //given
    await prepareWidget(tester, null);
    final BuildContext context = tester.element(find.byType(Scaffold));

    const String REGULAR_INPUT_KEY = "regular_input_standalone";
    StandaloneFormManagerOLD formManager = StandaloneFormManagerOLD();
    final focusNode = formManager.getFocusNode(REGULAR_INPUT_KEY);
    final controller = formManager.getTextEditingController(REGULAR_INPUT_KEY);
    final input = makeRequired(context, keyRequired, labelRequired, formManager);
    await prepareSimpleForm(tester, formManager, input);

    final regularInput = TextInputs.textSimple(
        context: context,
        keyString: REGULAR_INPUT_KEY,
        labelPosition: LabelPosition.topLeft,
        validator: ValidatorProvider.compose(context: context,  isRequired: true),
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
    StandaloneFormManagerOLD formManager = StandaloneFormManagerOLD();
    await prepareWidget(tester, null);
    final BuildContext context = tester.element(find.byType(Scaffold));

    final input = makeRequired(context, keyRequired, labelRequired, formManager, initialValue: '5');
    await prepareSimpleForm(tester, formManager, input);

    //when
    final FormStatus result = formManager.checkState();

    //then
    await tester.pump();
    expect(result, FormStatus.noChange);
  });

  testWidgets('Should have INVALID status if input is invalid', (WidgetTester tester) async {
    //given
    StandaloneFormManagerOLD formManager = StandaloneFormManagerOLD();
    await prepareWidget(tester, null);
        final BuildContext context = tester.element(find.byType(Scaffold));

    var inputThatRequires3Chars = makeRequiredMin3Chars(context, key3Chars, label3Chars, formManager);
    await prepareSimpleForm(tester, formManager, inputThatRequires3Chars);

    final inputField = find.byKey(const Key(key3Chars));
    await tester.enterText(inputField, "1");

    //when
    final FormStatus result = formManager.checkState();

    //then
    await tester.pump();
    expect(result, FormStatus.invalid);
  });

  testWidgets('Should ignore inputs with "ignoreFieldKey" from check ', (WidgetTester tester) async {
    //given
    StandaloneFormManagerOLD formManager = StandaloneFormManagerOLD();
    const ignoreFieldKey = "${FormManagerOLD.ignoreFieldKey}.${keyRequired}";

    await prepareWidget(tester, null);
        final BuildContext context = tester.element(find.byType(Scaffold));

    final inputWithIgnorePrefix = makeRequired(context, ignoreFieldKey, labelRequired, formManager);
    await prepareSimpleForm(tester, formManager, inputWithIgnorePrefix);

    await tester.enterText(find.byKey(const Key(ignoreFieldKey)), "");
    await tester.pump();

    //when
    final FormStatus result = formManager.checkState();

    //then
    expect(result, FormStatus.noChange);
  });

  testWidgets('Should have VALID status if input is valid', (WidgetTester tester) async {
    //given
    StandaloneFormManagerOLD formManager = StandaloneFormManagerOLD();
    await prepareWidget(tester, null);
        final BuildContext context = tester.element(find.byType(Scaffold));

    var inputThatRequires3Chars = makeRequiredMin3Chars(context, key3Chars, label3Chars, formManager);
    await prepareSimpleForm(tester, formManager, inputThatRequires3Chars);

    final inputField = find.byKey(const Key(key3Chars));
    await tester.enterText(inputField, "123");

    //when
    final FormStatus result = formManager.checkState();

    //then
    await tester.pump();
    expect(result, FormStatus.valid);
  });

  testWidgets('Should show error message for invalid inputs only', (WidgetTester tester) async {
    //given
    StandaloneFormManagerOLD formManager = StandaloneFormManagerOLD();
    const keyInputInvalid = "inputThatWillBeInvalid";
    const keyInputValid = "inputThatWillBeValid";
    await prepareWidget(tester, null);
        final BuildContext context = tester.element(find.byType(Scaffold));

    var inputThatWillBeInvalid = makeRequiredMin3Chars(context, keyInputInvalid, label3Chars, formManager,
        withTextEditingController: true);
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
    final FormStatus result = formManager.checkState();

    //then
    await tester.pump();
    expect(result, FormStatus.invalid);
    expect(formManager.errorMessageNotifier.value, BricksLocalizations.of(context).requiredField);
  });

  // testWidgets('Should clear all error messages once form is valid', (WidgetTester tester) async {
  //   //given
  //   StandaloneFormManagerOLD formManager = StandaloneFormManagerOLD();
  //   await prepareWidget(tester, null);
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
    StandaloneFormManagerOLD formManager = StandaloneFormManagerOLD();
    await prepareWidget(tester, null);
        final BuildContext context = tester.element(find.byType(Scaffold));

    var inputThatRequires3Chars =
        makeRequiredMin3Chars(context, key3Chars, label3Chars, formManager, initialValue: '333');
    await prepareSimpleForm(tester, formManager, inputThatRequires3Chars);

    final inputField = find.byKey(const Key(key3Chars));
    await tester.enterText(inputField, "1");
    await tester.pump();

    expect(find.text("1"), findsOne);
    expect(formManager.checkState(), FormStatus.invalid);
    expect(formManager.errorMessageNotifier.value, BricksLocalizations.of(context).minNChars(3));

    //when
    formManager.resetForm();

    await tester.pump();

    //then
    expect(formManager.checkState(), FormStatus.noChange);
    expect(formManager.errorMessageNotifier.value, '');
    expect(find.text("1"), findsNothing);
  });

  testWidgets('Should collect data from form and trim string values if needed', (WidgetTester tester) async {
    //given
    StandaloneFormManagerOLD formManager = StandaloneFormManagerOLD();
    await prepareWidget(tester, null);
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
    final FormStatus result = formManager.checkState();

    //then
    expect(result, FormStatus.valid);

    final formData = formManager.collectInputData();

    expect(formData, containsPair(key3Chars, 'valueForInputOneThat has trailing spaces'));
    expect(formData, containsPair(keyRequired, "valueForInputTwo"));
  });

  // testWidgets('Should transform nested data from form', (WidgetTester tester) async {
  //   //given
  //   StandaloneFormManagerOLD formManager = StandaloneFormManagerOLD();
  //   await prepareWidget(tester, null);
  //   final BuildContext context = tester.element(find.byType(Scaffold));
  //   const label = 'label';
  //
  //   final regular = TextInputs.textSimple(
  //       keyString: "regular",
  //       label: label,
  //       labelPosition: LabelPosition.topLeft,
  //       initialValue: "reg",
  //       validator: ValidatorProvider.compose(context: context, isRequired: true),
  //       formManager: formManager);
  //   final nestedOne = TextInputs.textSimple(
  //       keyString: "topChild.one",
  //       label: label,
  //       labelPosition: LabelPosition.topLeft,
  //       initialValue: "A",
  //       validator: ValidatorProvider.compose(context: context, isRequired: true),
  //       formManager: formManager);
  //   final nestedTwoOne = TextInputs.textSimple(
  //       keyString: "topChild.nestedChild.one",
  //       label: label,
  //       labelPosition: LabelPosition.topLeft,
  //       initialValue: "B",
  //       validator: ValidatorProvider.compose(context: context, isRequired: true),
  //       formManager: formManager);
  //   final nestedTwoTwo = NumberInputs.textInteger(
  //       keyString: "topChild.nestedChild.two",
  //       label: label,
  //       labelPosition: LabelPosition.topLeft,
  //       initialValue: 3,
  //       validator: ValidatorProvider.compose(context: context, isRequired: true),
  //       formManager: formManager);
  //
  //   final Row inputRow = Row(
  //     mainAxisSize: MainAxisSize.max,
  //     children: <Widget>[regular, nestedOne, nestedTwoOne, nestedTwoTwo],
  //   );
  //   await prepareSimpleForm(tester, formManager, inputRow);
  //   expect(formManager.errorMessageNotifier.value, "");
  //
  //   //when
  //   formManager.checkState();
  //   final transformed = formManager.collectInputData();
  //
  //   //then
  //   expect(transformed.length, 2);
  //   expect(transformed, containsPair("regular", "reg"));
  //
  //   final topChild = transformed["topChild"];
  //   expect(topChild.length, 2);
  //   expect(topChild, containsPair("one", "A"));
  //
  //   final nestedChild = topChild["nestedChild"];
  //   expect(nestedChild, containsPair("one", "B"));
  //   expect(nestedChild, containsPair("two", 3));
  // });
}
