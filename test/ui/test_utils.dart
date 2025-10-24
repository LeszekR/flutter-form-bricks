import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/tabbed_form/tabulated_form_manager.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_form_bricks/src/forms/state/single_form_state_data.dart';

import 'inputs/text/constants.dart';

const String keyRequired = "key_required";
const String labelRequired = "label_required";
const String label3Chars = 'Input with min. 3 chars';
const String key3Chars = 'input_3_chars';

loadGlobalConfigurationForTests() async {
  WidgetsFlutterBinding.ensureInitialized();
}

prepareWidget(WidgetTester tester, [Widget? Function(BuildContext)? widgetMaker, String language = "pl"]) async {
  var uiParamsData = UiParamsData();
  await tester.pumpWidget(
    UiParams(
      data: uiParamsData,
      child: MaterialApp(
        theme: uiParamsData.appTheme.themeData,
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

Future<BuildContext> pumpAppGetContext(WidgetTester tester) async {
  await prepareWidget(tester);
  final BuildContext context = tester.element(find.byType(Scaffold));
  return context;
}

prepareSimpleForm(WidgetTester tester, SingleFormManager formManager, Widget input) async {
  Widget widgetToTest = Scaffold(body: FormBuilder(key: formManager.formKey, child: input));
  await prepareWidget(tester, (context) => widgetToTest);
  formManager.fillInitialInputValuesMap();
}

prepareTabulatedForm(final WidgetTester tester, TabulatedFormManager formManager, List<TabData> tabsData) async {
  final List<FormBuilder> tabs = tabsData
      .map((tabData) => FormBuilder(
            key: tabData.globalKey,
            child: tabData.makeTabContent(),
          ))
      .toList();
  await prepareWidget(tester, (context) => Row(children: tabs));
  formManager.fillInitialInputValuesMap();
}

Widget makeRequired(
  BuildContext context,
  String keyString,
  String label,
  SingleFormManager formManager, {
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

Widget makeRequiredMin3Chars(
  BuildContext context,
  String keyString,
  String label,
  SingleFormManager formManager, {
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
  await prepareWidget(tester);
  final BuildContext context = tester.element(find.byType(Scaffold));

  final controller = formManager.getTextEditingController(keyString, defaultValue: null);
  var focusNode = formManager.getFocusNode(keyString);

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

  await prepareSimpleForm(tester, formManager, input);
}

Future<void> enterTextAndUnfocusWidget(
  WidgetTester tester,
  FormManager formManager,
  String keyString,
  String enteredText,
) async {
  await tester.enterText(find.byKey(Key(keyString)), enteredText);
  formManager.getFocusNode(keyString).unfocus();
  await tester.pump();
}

prepareDataForFocusLosingTests(
  BuildContext context,
  WidgetTester tester,
  SingleFormManager formManager,
  String keyString,
) async {
  await prepareWidget(tester);
  final BuildContext context = tester.element(find.byType(Scaffold));
  await prepareSimpleForm(
      tester,
      formManager,
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
    formManager.getTextEditingController(keyString).clear();
    await tester.pump();

    await tester.enterText(find.byKey(Key(keyString)), "text example");
    await tester.pump();

    var focusNode = formManager.getFocusNode(keyString);
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

SingleFormManager makeSingleFormManager() {
  var stateData = SingleFormStateData();

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
