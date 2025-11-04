import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'empty_form_manager.dart';


class ExampleApp extends StatelessWidget {

  late final String plainTextKeyString1;
  late final String plainTextKeyString2;
  late final String plainTextKeyString3;
  late final FormData formStateData;
  late final EmptyFormManager emptyFormManager;
  late final UiParamsData uiParamsData;
  late final FormSchema schema;

  ExampleApp({super.key}) {
    plainTextKeyString1 = 'plainTextKeyString1';
    plainTextKeyString2 = 'plainTextKeyString2';
    plainTextKeyString3 = 'plainTextKeyString3';
    formStateData = ExampleFormStateData(focusedKeyString: plainTextKeyString1);
    schema = ExampleFormSchema([
      FormFieldDescriptor(plainTextKeyString1, null, null),
      FormFieldDescriptor(plainTextKeyString2, null, null),
      FormFieldDescriptor(plainTextKeyString1, null, null),
    ], plainTextKeyString1,);
    emptyFormManager = EmptyFormManager(stateData: formStateData, schema: schema);
    uiParamsData = UiParamsData();
  }


  @override
  Widget build(BuildContext context) {
    return UiParams(
      data: uiParamsData,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: uiParamsData.appTheme.themeData,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'),
          Locale('pl'),
        ],
        home: Scaffold(
          body: Center(
            child: SizedBox(
              // width: 200,
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PlainTextField(
                    keyString: plainTextKeyString1,
                    formManager: emptyFormManager,
                    colorMaker: StatesColorMaker(),
                    width: 150,
                  ),
                  uiParamsData.appSize.spacerBoxVerticalMedium,
                  PlainTextField(
                    keyString: plainTextKeyString1,
                    formManager: emptyFormManager,
                    colorMaker: StatesColorMaker(),
                    width: 150,
                    maxLines: 3,
                  ),
                  // BrickTheme.of(context).sizes.spacerBoxVerticalMedium,
                  // BrickTextField(
                  //   keyString: 'test_text_input_3',
                  //   formManager: EmptyFormManager(),
                  //   colorMaker: StatesColorMaker(),
                  //   width: 150,
                  //   buttonParams: IconButtonParams(
                  //     iconData: Icons.arrow_drop_down,
                  //     tooltip: 'podpowiedź niesłuszna',
                  //     onPressed: () {},
                  //     autofocus: false,
                  //   ),
                  // ),
                  // BrickTheme.of(context).sizes.spacerBoxVerticalMedium,
                  // BrickTextField(
                  //   keyString: 'test_text_input_4',
                  //   formManager: EmptyFormManager(),
                  //   colorMaker: StatesColorMaker(),
                  //   width: 150,
                  //   maxLines: 3,
                  //   buttonParams: IconButtonParams(
                  //     iconData: Icons.arrow_drop_down,
                  //     tooltip: 'podpowiedź słuszna',
                  //     onPressed: () {},
                  //     autofocus: false,
                  //   ),
                  // ),
                ],
              ), // test your widget here
            ),
          ),
        ),
      ),
    );
  }
}

