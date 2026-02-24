import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/tabbed_form/tabulated_form_manager.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_implementations/test_single_form.dart';

const String keyRequired = "key_required";
const String labelRequired = "label_required";
const String label3Chars = 'Input with min. 3 chars';
const String key3Chars = 'input_3_chars';

void loadGlobalConfigurationForTests() async {
  WidgetsFlutterBinding.ensureInitialized();
}

Future<Widget?> prepareWidget(
  WidgetTester tester,
  Widget Function(BuildContext) widgetMaker, [
  String language = "pl",
]) async {
  Widget? widget;
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
            widget = widgetMaker(context);
            return Scaffold(body: widget);
          },
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return widget;
}

Future<BricksLocalizations> prepareLocalizations(WidgetTester tester) async {
  BricksLocalizations? localizations;
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: BricksLocalizations.localizationsDelegates,
      supportedLocales: BricksLocalizations.supportedLocales,
      locale: Locale('pl'),
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            localizations = BricksLocalizations.of(context);
            return SizedBox();
          },
        ),
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

Future<void> prepareTestSingleForm(WidgetTester tester, TestWidgetBuilder inputBuilder) async {
  Widget widgetToTest = TestSingleForm(widgetBuilder: inputBuilder);
  await prepareWidget(tester, (context) => widgetToTest);
}

Future<void> prepareTabulatedForm(WidgetTester tester, TabulatedFormManager formManager, List<TabData> tabsData) async {
  final List<FormBuilder> tabs = tabsData
      .map((tabData) => FormBuilder(
            key: tabData.globalKey,
            child: tabData.makeTabContent(),
          ))
      .toList();
  await prepareWidget(tester, (context) => Row(children: tabs));
}
