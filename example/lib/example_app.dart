import 'package:flutter/material.dart';
import 'package:flutter_desktop_bricks/shelf.dart';

import 'empty_form_manager.dart';

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 200,
            height: 300,
            child: Column(
              children: [
                TextFieldColored(
                  keyString: 'test_text_input',
                  formManager: EmptyFormManager(),
                  colorMaker: StatesColorMaker(),
                  width: 150,
                  height: 30,
                  maxLines: 1,
                  autoValidateMode: AutovalidateMode.always,
                  inputHeightMultiplier: 1,
                  initialValue: 'hallo',
                  expands: false,
                  readonly: false,
                  obscureText: false,
                  keyboardType: null,
                  withTextEditingController: true,
                  validator: null,
                  inputFormatters: null,
                  valueTransformer: null,
                  onChanged: null,
                  onEditingComplete: dynamic,
                  onSubmitted: null,
                  textInputAction: null,
                ),
              ],
            ), // test your widget here
          ),
        ),
      ),
    );
  }
}
