import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/tabbed_form/tabulated_form_manager.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_implementations/test_form_manager.dart';
import '../test_implementations/test_single_form.dart';
import 'inputs/text/constants.dart';

const String keyRequired = "key_required";
const String labelRequired = "label_required";
const String label3Chars = 'Input with min. 3 chars';
const String key3Chars = 'input_3_chars';

void loadGlobalConfigurationForTests() async {
  WidgetsFlutterBinding.ensureInitialized();
}

Future<void> prepareWidget(
  WidgetTester tester, [
  Widget? Function(BuildContext)? widgetMaker,
  String language = "pl",
]) async {
  await tester.pumpWidget(
    UiParams(
      data: UiParamsData(),
      child: MaterialApp(
        theme: UiParamsData().appTheme.themeData,
        localizationsDelegates: BricksLocalizations.localizationsDelegates,
        supportedLocales: BricksLocalizations.supportedLocales,
        locale: Locale(language),
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(body: widgetMaker == null ? null : widgetMaker(context));
          },
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

Future<BricksLocalizations> prepareLocalizations(WidgetTester tester) async {
  BricksLocalizations? localizations;
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: BricksLocalizations.localizationsDelegates,
      supportedLocales: BricksLocalizations.supportedLocales,
      locale: Locale('pl'),
      home: Builder(
        builder: (BuildContext context) {
          localizations = BricksLocalizations.of(context);
          return SizedBox();
        },
      ),
    ),
  );
  await tester.pump();
  return localizations!;
}

Future<BuildContext> pumpAppGetContext(WidgetTester tester) async {
  await prepareLocalizations(tester);
  final BuildContext context = tester.element(find.byType(Scaffold));
  return context;
}

prepareSimpleForm(WidgetTester tester, Widget input) async {
  Widget widgetToTest = TestSingleForm(widgetBuilder: (context) => input);
  await prepareWidget(tester, (context) => widgetToTest);
  // formManager.fillInitialInputValuesMap();
}

prepareTabulatedForm(WidgetTester tester, TabulatedFormManager formManager, List<TabData> tabsData) async {
  final List<FormBuilder> tabs = tabsData
      .map((tabData) => FormBuilder(
            key: tabData.globalKey,
            child: tabData.makeTabContent(),
          ))
      .toList();
  await prepareWidget(tester, (context) => Row(children: tabs));
}

Widget makeRequiredTextField(
  BuildContext context,
  String keyString,
  String label,
  TestFormManager formManager, {
  bool? withTextEditingController,
  String? initialValue,
}) {
  return TextInputs.textSimple(
    context: context,
    keyString: keyString,
    label: label,
    labelPosition: LabelPosition.topLeft,
    validator: ValidatorProvider.compose(context: context, isRequired: true),
    formManager: formManager,
    withTextEditingController: withTextEditingController,
    initialValue: initialValue,
  );
}

Widget makeRequiredMin3CharsTextField(
  BuildContext context,
  String keyString,
  String label,
  TestFormManager  formManager, {
  bool? withTextEditingController,
  String? initialValue,
}) {
  return TextInputs.textSimple(
    context: context,
    keyString: keyString,
    label: label,
    labelPosition: LabelPosition.topLeft,
    validator: ValidatorProvider.compose(context: context, isRequired: true, minLength: 3),
    formManager: formManager,
    withTextEditingController: withTextEditingController,
    initialValue: initialValue,
  );
}

prepareDataForTrimmingSpacesTests(
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
      label: 'Bulk text');

  await prepareSimpleForm(tester, input);
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

prepareDataForFocusLosingTests(
  BuildContext context,
  WidgetTester tester,
  SingleFormManager formManager,
  String keyString,
) async {
  await prepareLocalizations(tester);
  final BuildContext context = tester.element(find.byType(Scaffold));
  await prepareSimpleForm(
      tester,
      Column(
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
    case ConstantsText.TEXT_SIMPLE_FIELD_KEY:
      return TextInputs.textSimple(
          context: context,
          keyString: keyString,
          labelPosition: LabelPosition.topLeft,
          validator: ValidatorProvider.compose(context: context, isRequired: true),
          withTextEditingController: true,
          formManager: formManager,
          label: 'example text');
    case ConstantsText.TEXT_MULTILINE_FIELD_KEY:
      return TextInputs.textMultiline(
          context: context,
          keyString: keyString,
          labelPosition: LabelPosition.topLeft,
          validator: ValidatorProvider.compose(context: context, isRequired: true),
          withTextEditingController: true,
          formManager: formManager,
          label: 'Bulk text');
    case ConstantsText.TEXT_UPPERCASE_FIELD_KEY:
      return TextInputs.textUppercase(
          context: context,
          keyString: keyString,
          labelPosition: LabelPosition.topLeft,
          validator: ValidatorProvider.compose(context: context, isRequired: true),
          withTextEditingController: true,
          formManager: formManager,
          label: 'BULK TEXT');
    case ConstantsText.TEXT_LOWERCASE_FIELD_KEY:
      return TextInputs.textLowercase(
          context: context,
          keyString: keyString,
          labelPosition: LabelPosition.topLeft,
          validator: ValidatorProvider.compose(context: context, isRequired: true),
          withTextEditingController: true,
          formManager: formManager,
          label: 'example text');
    case ConstantsText.TEXT_UPPER_LOWER_FIELD_KEY:
      return TextInputs.textFirstUppercaseThenLowercase(
          context: context,
          keyString: keyString,
          labelPosition: LabelPosition.topLeft,
          validator: ValidatorProvider.compose(context: context, isRequired: true),
          withTextEditingController: true,
          formManager: formManager,
          label: 'Example text');
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

    await tester.enterText(find.byKey(Key(keyString)), "text example");
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

// class TestTabulatedForm extends TabulatedForm {
//   final List<TabData> _tabsData;
//
//   get tabsData => _tabsData;
//
//   TestTabulatedForm(List<TabData> tabsData, {super.key}) : _tabsData = tabsData;
//
//   @override
//   TestTabulatedFormState createState() => TestTabulatedFormState();
// }
//
// class TestTabulatedFormState extends TabulatedFormState<TestTabulatedForm> {
//   @override
//   List<TabData> makeTabsData() {
//     return (widget as TestTabulatedForm).tabsData;
//   }
//
//   @override
//   Entity? getEntity() => null; //TODO implement
//
//   @override
//   String provideLabel() => "Przykład Tabulated Form";
//
//   @override
//   void deleteEntity() => debugPrint("delete triggered.");
//
//   @override
//   EntityService<Entity> getService() => throw UnimplementedError();
//
//   @override
//   void removeEntityFromState() {}
//
//   @override
//   void upsertEntityInState(Map<String, dynamic> responseBody) {}
//
//   @override
//   void submitData() {
//     final Map<String, dynamic> formData = formManager.collectInputData();
//     debugPrint("save triggered. Data: $formData");
//   }
// }
