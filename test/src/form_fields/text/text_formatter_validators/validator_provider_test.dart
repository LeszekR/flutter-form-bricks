// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/date_time_validators.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../tools/test_data.dart';
import '../../../tools/test_utils.dart';
import '../../../../ui/inputs/formatters/date_time/utils/dateTime_test_utils.dart';

void main() {
  const key = Key("key");

  group('Should respect readonly validation', () {
    final List<TestData> testParameters = [
      TestData(true, false),
      TestData(false, false),
    ];

    for (TestData param in testParameters) {
      testWidgets('If required is "${param.input}" then validation result should be: "${param.expected}"',
          (WidgetTester tester) async {
        BuildContext context = await pumpAppGetContext(tester);

        //given
        var formManager = SingleFormManager();
        FormFieldValidator<String> validatorMaker() => ValidatorProvider.compose(context: context, isRequired: true);
        await prepareTextSimpleInForm(tester, validatorMaker, formManager);

        //when
        await tester.pump();
        formManager.formKey.currentState!.save();
        final bool isValid = formManager.formKey.currentState!.validate();

        //then
        expect(isValid, param.expected);
      });
    }
  });

  group('Should respect max text_formatter_validators length validation', () {
    const inputText = "I am the input";

    final List<TestData> testParameters = [
      TestData(inputText.length + 1, true),
      TestData(inputText.length, true),
      TestData(inputText.length - 1, false),
    ];

    for (maxLength in testParameters) {
      testWidgets(
          'If max length is "${maxLength.inputString}" and user input length is "${inputText.length}" then validation result should be: "${maxLength.expectedValue}"',
          (WidgetTester tester) async {
        BuildContext context = await pumpAppGetContext(tester);

        //given
        var formManager = SingleFormManager();
        validatorMaker() => ValidatorProvider.compose(context: context, maxLength: maxLength.inputString as int);
        await prepareTextSimpleInForm(tester, validatorMaker, formManager);

        //when
        await tester.enterText(find.byKey(key), inputText);
        await tester.pump();
        formManager.formKey.currentState!.save();
        final bool isValid = formManager.formKey.currentState!.validate();

        //then
        expect(isValid, maxLength.expectedValue);
      });
    }
  });

  group('Should respect min text_formatter_validators length validation', () {
    const inputText = "I am the input";

    final List<TestData> testParameters = [
      TestData(inputText.length + 1, false),
      TestData(inputText.length, true),
      TestData(inputText.length - 1, true),
    ];

    for (minLength in testParameters) {
      testWidgets(
          'If min length is "${minLength.inputString}" and user input length is "${inputText.length}" then validation result should be: "${minLength.expectedValue}"',
          (WidgetTester tester) async {
        BuildContext context = await pumpAppGetContext(tester);

        //given
        var formManager = SingleFormManager();
        validatorMaker() => ValidatorProvider.compose(context: context, minLength: minLength.inputString as int);
        await prepareTextSimpleInForm(tester, validatorMaker, formManager);

        //when
        await tester.enterText(find.byKey(key), inputText);
        await tester.pump();
        formManager.formKey.currentState!.save();
        final bool isValid = formManager.formKey.currentState!.validate();

        //then
        expect(isValid, minLength.expectedValue);
      });
    }
  });

  group('Should respect max value validation', () {
    const inputContent = 5;

    final List<TestData> testParameters = [
      TestData(inputContent + 1, true),
      TestData(inputContent, true),
      TestData(inputContent - 1, false),
    ];

    for (validationValue in testParameters) {
      testWidgets(
          'If max value is "${validationValue.inputString}" and user input is "$inputContent" then validation result should be: "${validationValue.expectedValue}"',
          (WidgetTester tester) async {
        BuildContext context = await pumpAppGetContext(tester);

        //given
        var formManager = SingleFormManager();
        validatorMaker() => ValidatorProvider.compose(context: context, maxIntValue: validationValue.inputString as int);
        await prepareIntegerFieldInForm(tester, validatorMaker, formManager);

        //when
        await tester.enterText(find.byKey(key), inputContent.toString());
        await tester.pump();
        formManager.formKey.currentState!.save();
        final bool isValid = formManager.formKey.currentState!.validate();

        //then
        expect(isValid, validationValue.expectedValue);
      });
    }
  });

  group('Should respect min value validation', () {
    const inputContent = 5;

    final List<TestData> testParameters = [
      TestData(inputContent + 1, false),
      TestData(inputContent, true),
      TestData(inputContent - 1, true),
    ];

    for (validationValue in testParameters) {
      testWidgets(
          'If min value is "${validationValue.inputString}" and user input is "$inputContent" then validation result should be: "${validationValue.expectedValue}"',
          (WidgetTester tester) async {
        BuildContext context = await pumpAppGetContext(tester);

        //given
        var formManager = SingleFormManager();
        validatorMaker() => ValidatorProvider.compose(context: context, minIntValue: validationValue.inputString as int);
        await prepareIntegerFieldInForm(tester, validatorMaker, formManager);

        //when
        await tester.enterText(find.byKey(key), inputContent.toString());
        await tester.pump();
        formManager.formKey.currentState!.save();
        final bool isValid = formManager.formKey.currentState!.validate();

        //then
        expect(isValid, validationValue.expectedValue);
      });
    }
  });

  group('Should respect regex validation', () {
    final List<TestData> testParameters = [
      TestData("maciej@wp.pl", true),
      TestData("some@email.com", true),
      TestData("so@me@email.com", false),
      TestData("some@@email.com", false),
      TestData("some@email..com", false),
      TestData("some@email", false),
      TestData("some.email.pl", false),
    ];

    for (testParam in testParameters) {
      testWidgets(
          'If user input is "${testParam.inputString}" then email regex validation result should be: "${testParam.expectedValue}"',
          (WidgetTester tester) async {
        BuildContext context = await pumpAppGetContext(tester);
        BricksLocalizations localizations = await getLocalizations();

        //given
        var formManager = SingleFormManager();
        var validatorMaker = () => ValidatorProvider.validatorEmail(localizations);
        await prepareTextSimpleInForm(tester, validatorMaker, formManager);

        //when
        await tester.enterText(find.byKey(key), testParam.inputString);
        await tester.pump();
        formManager.formKey.currentState!.save();
        final bool isValid = formManager.formKey.currentState!.validate();

        //then
        expect(isValid, testParam.expectedValue);
      });
    }
  });
}

Future<void> prepareIntegerFieldInForm(WidgetTester tester, FormFieldValidator<String> Function() validatorMaker,
    SingleFormManager formManager) async {
  await prepareLocalizations(tester);
  final BuildContext context = tester.element(find.byType(Scaffold));
  final validator = validatorMaker();
  final input = NumberInputs.textInteger(
      context: context,
      keyString: "key",
      label: "label",
      labelPosition: LabelPosition.topLeft,
      validator: validator,
      formManager: formManager);
  await prepareSimpleForm(tester, input);
}

Future<void> prepareTextSimpleInForm(WidgetTester tester, FormFieldValidator<String> Function() validatorMaker,
    SingleFormManager formManager) async {
  await prepareLocalizations(tester);
  final BuildContext context = tester.element(find.byType(Scaffold));

  final validator = validatorMaker();
  final input = TextInputs.textSimple(
      context: context,
      keyString: "key",
      label: "label",
      labelPosition: LabelPosition.topLeft,
      validator: validator,
      formManager: formManager);
  await prepareSimpleForm(tester, input);
}
