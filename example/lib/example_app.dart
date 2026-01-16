import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks_example/forms/example_form/example_form.dart';

final ValueNotifier<Locale> _localeNotifier = ValueNotifier(const Locale('en'));

class ExampleApp extends StatelessWidget {
  final UiParamsData uiParamsData = UiParamsData();

  ExampleApp({super.key}) {}

  @override
  Widget build(BuildContext context) {
    return UiParams(
      data: uiParamsData,
      child: AnimatedBuilder(
          animation: _localeNotifier,
          builder: (_, __) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: uiParamsData.themeData,
              localizationsDelegates: BricksLocalizations.localizationsDelegates,
              locale: _localeNotifier.value,
              supportedLocales: [
                Locale('en'),
                Locale('pl'),
              ],
              home: Scaffold(
                body: ExampleForm(),
              ),
            );
          }),
    );
  }
}
