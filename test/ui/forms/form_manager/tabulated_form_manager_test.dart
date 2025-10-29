import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/form_manager/form_state.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/tabbed_form/tabulated_form_manager.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_status.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_utils.dart';

void main() {
  const input1Tab1Key = "input1Tab1";
  const input2Tab1Key = "input2Tab1";
  const input1Tab2Key = "input1Tab2";
  const input2Tab2Key = "input2Tab2";

  const allKeys = [input1Tab1Key, input2Tab1Key, input1Tab2Key, input2Tab2Key];
  List<TabData> allTabs = [];

  GlobalKey<FormBuilderState> tabKey1 = GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> tabKey2 = GlobalKey<FormBuilderState>();
  TabulatedFormManager formManager;
  FormFieldValidator<String> validator;

  Future<void> prepareTabulatedTest(
    WidgetTester tester,
    TabulatedFormManager formManager,
    FormFieldValidator<String> validator,
  ) async {
    var context = await pumpAppGetContext(tester);
    allTabs = makeTabDataList(
      context,
      input1Tab1Key,
      input2Tab1Key,
      input1Tab2Key,
      input2Tab2Key,
      tabKey1,
      tabKey2,
      formManager,
      validator,
    );
    await prepareTabulatedForm(tester, formManager, allTabs);
  }

  testWidgets('Should have UNTOUCHED status if no input was changed', (WidgetTester tester) async {
    //given
    BuildContext context = await pumpAppGetContext(tester);

    formManager = TabulatedFormManager();
    validator = ValidatorProvider.compose(context: context, isRequired: true, minLength: 3);
    var allTabData = makeTabDataList(
      context,
      input1Tab1Key,
      input2Tab1Key,
      input1Tab2Key,
      input2Tab2Key,
      tabKey1,
      tabKey2,
      formManager,
      validator,
      input1Tab1InitValue: '1234',
      input2Tab1InitValue: '1234',
      input1Tab2InitValue: '1234',
      input2Tab2InitValue: '1234',
    );

    await prepareTabulatedForm(tester, formManager, allTabData);
    await tester.pump();
    final FormStatus result = formManager.checkState();
    await tester.pump();

    //then
    expect(result, FormStatus.noChange);
  });

  group('Should have INVALID status at least 1 input is invalid', () {
    for (keyThatWillBeInvalid in allKeys) {
      testWidgets('For this iteration $keyThatWillBeInvalid is invalid', (WidgetTester tester) async {
        //given
        BuildContext context = await pumpAppGetContext(tester);

        formManager = TabulatedFormManager();
        validator = ValidatorProvider.compose(context: context, isRequired: true, minLength: 3);
        await prepareTabulatedTest(tester, formManager, validator);

        for (var key in allKeys) {
          await tester.enterText(find.byKey(Key(key)), "12345");
        }
        await tester.enterText(find.byKey(Key(keyThatWillBeInvalid)), '');
        await tester.pump();

        //when
        final FormStatus result = formManager.checkState();

        //then
        expect(result, FormStatus.invalid);
        expect(formManager.errorMessageNotifier.value, BricksLocalizations.of(context).requiredField);
      });
    }
  });

  testWidgets('Should ignore inputs with "ignoreFieldKey" from check ', (WidgetTester tester) async {
    //given
    BuildContext context = await pumpAppGetContext(tester);
    formManager = TabulatedFormManager();
    validator = ValidatorProvider.compose(context: context, isRequired: true, minLength: 3);
    var allTabData = makeTabDataList(
      context,
      input1Tab1Key,
      input2Tab1Key,
      input1Tab2Key,
      input2Tab2Key,
      tabKey1,
      tabKey2,
      formManager,
      validator,
      input1Tab1InitValue: '1234',
      input2Tab1InitValue: '1234',
      input1Tab2InitValue: '1234',
      input2Tab2InitValue: '1234',
    );

    const ignoreFieldKey = "${FormManager.ignoreFieldKey}.tobeignored";
    final inputWithIgnorePrefix = TextInputs.textSimple(
        context: context,
        keyString: ignoreFieldKey,
        label: 'ingnoredTabInput',
        labelPosition: LabelPosition.topLeft,
        validator: validator,
        formManager: formManager,
        initialValue: '',
        inputWidth: 10);
    final testTabData = TabData(
      label: "Tab3",
      globalKey: GlobalKey<FormBuilderState>(),
      initialStatus: TabStatus.tabOk,
      makeTabContent: () => Row(children: [inputWithIgnorePrefix]),
    );

    allTabData.add(testTabData);
    formManager.addTabData(testTabData);
    await prepareTabulatedForm(tester, formManager, allTabData);
    await tester.pump();

    //when invalid on form create
    FormStatus result = formManager.checkState();

    //then
    expect(result, FormStatus.noChange);

    //when invalid after filled with incorrect input
    await tester.enterText(find.byKey(const Key(ignoreFieldKey)), "1");
    result = formManager.checkState();
    await tester.pump();

    //then
    expect(result, FormStatus.noChange);
  });

  testWidgets('Should have VALID status if all inputs are valid', (WidgetTester tester) async {
    //given
    BuildContext context = await pumpAppGetContext(tester);
    formManager = TabulatedFormManager();
    validator = ValidatorProvider.compose(context: context, isRequired: true, minLength: 3);
    await prepareTabulatedTest(tester, formManager, validator);

    for (var key in allKeys) {
      await tester.enterText(find.byKey(Key(key)), "12345");
    }
    await tester.pump();

    //when
    final FormStatus result = formManager.checkState();

    //then
    expect(result, FormStatus.valid);
  });

  testWidgets('Should clear all error messages once form is valid', (WidgetTester tester) async {
    //given
    BuildContext context = await pumpAppGetContext(tester);
    formManager = TabulatedFormManager();
    validator = ValidatorProvider.compose(context: context, isRequired: true, minLength: 3);
    await prepareTabulatedTest(tester, formManager, validator);

    for (var key in allKeys) {
      await tester.enterText(find.byKey(Key(key)), "1");
    }
    await tester.pump();

    expect(formManager.checkState(), FormStatus.invalid);
    allKeys.map((word) => expect(formManager.errorMessageNotifier.value, contains(word)));

    //when
    for (var key in allKeys) {
      await tester.enterText(find.byKey(Key(key)), "123");
    }
    await tester.pump();

    //then
    expect(formManager.checkState(), FormStatus.valid);
    expect(formManager.errorMessageNotifier.value, '');
  });

  testWidgets('Should reset form', (WidgetTester tester) async {
    //given
    BuildContext context = await pumpAppGetContext(tester);
    formManager = TabulatedFormManager();
    validator = ValidatorProvider.compose(context: context, isRequired: true, minLength: 3);
    // await prepareTabulatedTest(tester, formManager, validator);
    //
    // for (var key in allKeys) {
    //   await tester.enterText(find.byKey(Key(key)), "1");
    // }
    // await tester.pump();
    var allTabData = makeTabDataList(
      context,
      input1Tab1Key,
      input2Tab1Key,
      input1Tab2Key,
      input2Tab2Key,
      tabKey1,
      tabKey2,
      formManager,
      validator,
      input1Tab1InitValue: '1234',
      input2Tab1InitValue: '1234',
      input1Tab2InitValue: '1234',
      input2Tab2InitValue: '1234',
    );
    await prepareTabulatedForm(tester, formManager, allTabData);
    await tester.pump();
    formManager.checkState();
    await tester.pump();
    expect(find.text("1234"), findsExactly(allKeys.length));

    await tester.enterText(find.byKey(const Key(input2Tab2Key)), "1");
    expect(formManager.checkState(), FormStatus.invalid);
    expect(formManager.errorMessageNotifier.value.isNotEmpty, true);

    //when
    formManager.resetForm();

    await tester.pump();

    //then
    expect(formManager.checkState(), FormStatus.noChange);
    expect(formManager.errorMessageNotifier.value.isNotEmpty, false);
    expect(find.text("1"), findsNothing);
  });

  testWidgets('Should collect data from form and trim string values if needed', (WidgetTester tester) async {
    //given
    BuildContext context = await pumpAppGetContext(tester);
    formManager = TabulatedFormManager();
    validator = ValidatorProvider.compose(context: context, isRequired: true, minLength: 3);
    await prepareTabulatedTest(tester, formManager, validator);

    for (var key in allKeys) {
      await tester.enterText(find.byKey(Key(key)), "input with trailing space ");
    }
    await tester.pump();
    expect(find.text("input with trailing space "), findsExactly(allKeys.length));

    //when
    final FormStatus result = formManager.checkState();

    //then
    expect(result, FormStatus.valid);
    const expectedContent = "input with trailing space";

    final formData = formManager.collectInputData();
    allKeys.map((key) => expect(formData, containsPair(key, expectedContent)));
  });

  testWidgets('Should lock tab and disable validation for it', (WidgetTester tester) async {
    //given
    BuildContext context = await pumpAppGetContext(tester);
    formManager = TabulatedFormManager();
    validator = ValidatorProvider.compose(context: context, isRequired: true, minLength: 3);
    await prepareTabulatedTest(tester, formManager, validator);

    expect(formManager.isTabDisabled(tabKey1), false);
    expect(formManager.isTabDisabled(tabKey2), false);

    for (key in [input1Tab2Key, input2Tab2Key]) {
      await tester.enterText(find.byKey(Key(key)), "12345");
    }
    await tester.pump();

    expect(formManager.checkState(), FormStatus.invalid);

    //when
    formManager.setDisabled(tabKey1, true);

    //then
    expect(formManager.isTabDisabled(tabKey1), true);
    expect(formManager.isTabDisabled(tabKey2), false);
    expect(formManager.checkState(), FormStatus.valid);
  });
}

List<TabData> makeTabDataList(
  BuildContext context,
  String input1Tab1Key,
  String input2Tab1Key,
  String input1Tab2Key,
  String input2Tab2Key,
  GlobalKey<FormBuilderState> tabKey1,
  GlobalKey<FormBuilderState> tabKey2,
  TabulatedFormManager formManager,
  FormFieldValidator<String> validator, {
  String? input1Tab1InitValue,
  String? input2Tab1InitValue,
  String? input1Tab2InitValue,
  String? input2Tab2InitValue,
}) {
  Widget input1Tab1 = TextInputs.textSimple(
      context: context,
      keyString: input1Tab1Key,
      label: input1Tab1Key,
      labelPosition: LabelPosition.topLeft,
      initialValue: input1Tab1InitValue,
      validator: validator,
      formManager: formManager,
      inputWidth: 50);
  Widget input2Tab1 = TextInputs.textSimple(
      context: context,
      keyString: input2Tab1Key,
      label: input2Tab1Key,
      labelPosition: LabelPosition.topLeft,
      initialValue: input2Tab1InitValue,
      validator: validator,
      formManager: formManager,
      inputWidth: 50);
  TabData tab1 = TabData(
    label: "tab1Label",
    globalKey: tabKey1,
    initialStatus: TabStatus.tabOk,
    makeTabContent: () => Row(children: [input1Tab1, input2Tab1]),
  );

  Widget input1Tab2 = TextInputs.textSimple(
      context: context,
      keyString: input1Tab2Key,
      label: input1Tab2Key,
      labelPosition: LabelPosition.topLeft,
      initialValue: input1Tab2InitValue,
      validator: validator,
      formManager: formManager);
  Widget input2Tab2 = TextInputs.textSimple(
      context: context,
      keyString: input2Tab2Key,
      label: input2Tab2Key,
      labelPosition: LabelPosition.topLeft,
      initialValue: input2Tab2InitValue,
      validator: validator,
      formManager: formManager);
  TabData tab2 = TabData(
    label: "tab2label",
    globalKey: tabKey2,
    initialStatus: TabStatus.tabOk,
    makeTabContent: () => Row(children: [input1Tab2, input2Tab2]),
  );

  List<TabData> allTabs = [tab1, tab2];

  for (var element in allTabs) {
    formManager.addTabData(element);
  }
  return allTabs;
}
