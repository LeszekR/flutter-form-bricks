// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/date_time_validators.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_data.dart';
import '../../test_utils.dart';
import '../formatters/date_time/utils/dateTime_test_utils.dart';

void main() {
  const key = Key("key");

  group('Should respect readonly validation', () {
    final List<TestData> testParameters = [
      TestData(true, false),
      TestData(false, false),
    ];

    for (final param in testParameters) {
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

  group('Should respect max text length validation', () {
    const inputText = "I am the input";

    final List<TestData> testParameters = [
      TestData(inputText.length + 1, true),
      TestData(inputText.length, true),
      TestData(inputText.length - 1, false),
    ];

    for (final maxLength in testParameters) {
      testWidgets(
          'If max length is "${maxLength.input}" and user input length is "${inputText.length}" then validation result should be: "${maxLength.expected}"',
          (WidgetTester tester) async {
        BuildContext context = await pumpAppGetContext(tester);

        //given
        var formManager = SingleFormManager();
        validatorMaker() => ValidatorProvider.compose(context: context, maxLength: maxLength.input as int);
        await prepareTextSimpleInForm(tester, validatorMaker, formManager);

        //when
        await tester.enterText(find.byKey(key), inputText);
        await tester.pump();
        formManager.formKey.currentState!.save();
        final bool isValid = formManager.formKey.currentState!.validate();

        //then
        expect(isValid, maxLength.expected);
      });
    }
  });

  group('Should respect min text length validation', () {
    const inputText = "I am the input";

    final List<TestData> testParameters = [
      TestData(inputText.length + 1, false),
      TestData(inputText.length, true),
      TestData(inputText.length - 1, true),
    ];

    for (final minLength in testParameters) {
      testWidgets(
          'If min length is "${minLength.input}" and user input length is "${inputText.length}" then validation result should be: "${minLength.expected}"',
          (WidgetTester tester) async {
        BuildContext context = await pumpAppGetContext(tester);

        //given
        var formManager = SingleFormManager();
        validatorMaker() => ValidatorProvider.compose(context: context, minLength: minLength.input as int);
        await prepareTextSimpleInForm(tester, validatorMaker, formManager);

        //when
        await tester.enterText(find.byKey(key), inputText);
        await tester.pump();
        formManager.formKey.currentState!.save();
        final bool isValid = formManager.formKey.currentState!.validate();

        //then
        expect(isValid, minLength.expected);
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

    for (final validationValue in testParameters) {
      testWidgets(
          'If max value is "${validationValue.input}" and user input is "$inputContent" then validation result should be: "${validationValue.expected}"',
          (WidgetTester tester) async {
        BuildContext context = await pumpAppGetContext(tester);

        //given
        var formManager = SingleFormManager();
        validatorMaker() => ValidatorProvider.compose(context: context, maxIntValue: validationValue.input as int);
        await prepareIntegerFieldInForm(tester, validatorMaker, formManager);

        //when
        await tester.enterText(find.byKey(key), inputContent.toString());
        await tester.pump();
        formManager.formKey.currentState!.save();
        final bool isValid = formManager.formKey.currentState!.validate();

        //then
        expect(isValid, validationValue.expected);
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

    for (final validationValue in testParameters) {
      testWidgets(
          'If min value is "${validationValue.input}" and user input is "$inputContent" then validation result should be: "${validationValue.expected}"',
          (WidgetTester tester) async {
        BuildContext context = await pumpAppGetContext(tester);

        //given
        var formManager = SingleFormManager();
        validatorMaker() => ValidatorProvider.compose(context: context, minIntValue: validationValue.input as int);
        await prepareIntegerFieldInForm(tester, validatorMaker, formManager);

        //when
        await tester.enterText(find.byKey(key), inputContent.toString());
        await tester.pump();
        formManager.formKey.currentState!.save();
        final bool isValid = formManager.formKey.currentState!.validate();

        //then
        expect(isValid, validationValue.expected);
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

    for (final testParam in testParameters) {
      testWidgets(
          'If user input is "${testParam.input}" then email regex validation result should be: "${testParam.expected}"',
          (WidgetTester tester) async {
        BuildContext context = await pumpAppGetContext(tester);
        BricksLocalizations localizations = await getLocalizations();

        //given
        var formManager = SingleFormManager();
        var validatorMaker = () => ValidatorProvider.validatorEmail(localizations);
        await prepareTextSimpleInForm(tester, validatorMaker, formManager);

        //when
        await tester.enterText(find.byKey(key), testParam.input);
        await tester.pump();
        formManager.formKey.currentState!.save();
        final bool isValid = formManager.formKey.currentState!.validate();

        //then
        expect(isValid, testParam.expected);
      });
    }
  });
}

Future<void> prepareIntegerFieldInForm(WidgetTester tester, FormFieldValidator<String> Function() validatorMaker,
    SingleFormManager formManager) async {
  await prepareWidget(tester);
  final BuildContext context = tester.element(find.byType(Scaffold));
  final validator = validatorMaker();
  final input = NumberInputs.textInteger(
      context: context,
      keyString: "key",
      label: "label",
      labelPosition: LabelPosition.topLeft,
      validator: validator,
      formManager: formManager);
  await prepareSimpleForm(tester, formManager, input);
}

Future<void> prepareTextSimpleInForm(WidgetTester tester, FormFieldValidator<String> Function() validatorMaker,
    SingleFormManager formManager) async {
  await prepareWidget(tester);
  final BuildContext context = tester.element(find.byType(Scaffold));

  final validator = validatorMaker();
  final input = TextInputs.textSimple(
      context: context,
      keyString: "key",
      label: "label",
      labelPosition: LabelPosition.topLeft,
      validator: validator,
      formManager: formManager);
  await prepareSimpleForm(tester, formManager, input);
}
