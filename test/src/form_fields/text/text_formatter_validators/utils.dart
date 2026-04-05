import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/input_validator_provider.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/text/text_inputs.dart';
import 'package:flutter_form_bricks/src/form_fields/components/base/form_field_brick.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/label_position.dart';
import 'package:flutter_form_bricks/src/form_fields/components/states_controller/formatter_helper.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_brick.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../tools/test_utils.dart';
import '../date_time/tools/test_constants.dart';

Future<void> prepareDataForTrimmingSpacesTests(
  BuildContext context,
  WidgetTester tester,
  SingleFormManager formManager,
  String keyString,
) async {
  await prepareLocalizations(tester);
  final BuildContext context = tester.element(find.byType(Scaffold));

  final controller = await getTextEditingController(tester, keyString);
  final focusNode = await getFocusNode(tester, keyString);

  focusNode.addListener(() {
    if (!focusNode.hasFocus) {
      FormatterHelper.onSubmittedTrimming(controller.text, controller);
    }
  });

  final input = TextInputs.textMultiline(
      context: context,
      keyString: keyString,
      labelPosition: LabelPosition.topLeft,
      validator: ValidatorProvider.compose(context: context, isRequired: true),
      withTextEditingController: true,
      formManager: formManager,
      label: 'Bulk text_formatter_validators');

  await prepareTestSingleForm(tester, (context, formManager) => input);
}

Future<void> enterTextAndUnfocusWidget(
  WidgetTester tester,
  FormManager formManager,
  String keyString,
  String enteredText,
) async {
  await tester.enterText(find.byKey(Key(keyString)), enteredText);
  (await tester.state(find.byKey(ValueKey(keyString))) as FormFieldStateBrick).focusNode.unfocus();
  await tester.pump();
}

Future<void> prepareDataForFocusLosingTests(
  BuildContext context,
  WidgetTester tester,
  SingleFormManager formManager,
  String keyString,
) async {
  await prepareLocalizations(tester);
  final BuildContext context = tester.element(find.byType(Scaffold));
  await prepareTestSingleForm(
      tester,
      (context, manager) => Column(
            children: [
              buildTextInputForTest(context, keyString, formManager),
              const SizedBox(key: Key("Sized box"), height: 30),
              Container(
                width: double.infinity,
                height: 50,
                color: Colors.transparent,
                key: const Key('outside_click_area'),
              ),
              ElevatedButton(key: const Key("Dummy button"), onPressed: () {}, child: const Text('Dummy button'))
            ],
          ));
}

Widget buildTextInputForTest(BuildContext context, String keyString, SingleFormManager formManager) {
  switch (keyString) {
    case TEXT_SIMPLE_FIELD_KEY:
      return TextInputs.textSimple(
          context: context,
          keyString: keyString,
          labelPosition: LabelPosition.topLeft,
          validator: ValidatorProvider.compose(context: context, isRequired: true),
          withTextEditingController: true,
          formManager: formManager,
          label: 'example text_formatter_validators');
    case TEXT_MULTILINE_FIELD_KEY:
      return TextInputs.textMultiline(
          context: context,
          keyString: keyString,
          labelPosition: LabelPosition.topLeft,
          validator: ValidatorProvider.compose(context: context, isRequired: true),
          withTextEditingController: true,
          formManager: formManager,
          label: 'Bulk text_formatter_validators');
    case TEXT_UPPERCASE_FIELD_KEY:
      return TextInputs.textUppercase(
          context: context,
          keyString: keyString,
          labelPosition: LabelPosition.topLeft,
          validator: ValidatorProvider.compose(context: context, isRequired: true),
          withTextEditingController: true,
          formManager: formManager,
          label: 'BULK TEXT');
    case TEXT_LOWERCASE_FIELD_KEY:
      return TextInputs.textLowercase(
          context: context,
          keyString: keyString,
          labelPosition: LabelPosition.topLeft,
          validator: ValidatorProvider.compose(context: context, isRequired: true),
          withTextEditingController: true,
          formManager: formManager,
          label: 'example text_formatter_validators');
    case TEXT_UPPER_LOWER_FIELD_KEY:
      return TextInputs.textFirstUppercaseThenLowercase(
          context: context,
          keyString: keyString,
          labelPosition: LabelPosition.topLeft,
          validator: ValidatorProvider.compose(context: context, isRequired: true),
          withTextEditingController: true,
          formManager: formManager,
          label: 'Example text_formatter_validators');
    default:
      return Container();
  }
}

Future<void> performAndCheckInputActions(
    WidgetTester tester, SingleFormManager formManager, String keyString, Map<String, Function> inputs) async {
  for (var method in inputs.entries) {
    final focusNode = await getFocusNode(tester, keyString);
    final controller = await getTextEditingController(tester, keyString);
    controller.clear();
    await tester.pump();

    await tester.enterText(find.byKey(Key(keyString)), "text_formatter_validators example");
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
}

Future<FocusNode> getFocusNode(WidgetTester tester, String keyString) async {
  return (await tester.state(find.byKey(ValueKey(keyString))) as FormFieldStateBrick).focusNode;
}

Future<TextEditingController> getTextEditingController(WidgetTester tester, String keyString) async {
  return (await tester.state(find.byKey(ValueKey(keyString))) as TextFieldStateBrick).controller;
}

Map<String, Future<void> Function()> getInputs(WidgetTester tester) {
  return {
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
}

class TestData {
  final dynamic input;
  final dynamic expected;

  TestData(this.input, this.expected);
}
