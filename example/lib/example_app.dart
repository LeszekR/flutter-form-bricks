import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks_example/forms/example_form/example_form.dart';
import 'package:flutter_form_bricks_example/forms/example_form/example_form_data.dart';
import 'package:flutter_form_bricks_example/forms/example_form/example_form_manager.dart';
import 'package:flutter_form_bricks_example/forms/example_form/example_form_schema.g.dart';

class ExampleApp extends StatelessWidget {
  final UiParamsData uiParamsData = UiParamsData();

  ExampleApp({super.key}) {}

  @override
  Widget build(BuildContext context) {
    var formData = ExampleFormData();
    var formSchema = ExampleFormSchema();
    var formManager = ExampleFormManager(formData: formData, formSchema: formSchema);
    return UiParams(
      data: uiParamsData,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: uiParamsData.appTheme.themeData,
        localizationsDelegates: BricksLocalizations.localizationsDelegates,
        // localizationsDelegates: [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        // ],
        supportedLocales: [
          Locale('en'),
          Locale('pl'),
        ],
        home: Scaffold(
          body: ExampleForm(formManager: formManager),
        ),
      ),
    );
  }
}
