import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

import 'empty_form_manager.dart';

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BrickTheme (
      data: BrickThemeData(),
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 200,
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BrickTextField(
                    keyString: 'test_text_input',
                    formManager: EmptyFormManager(),
                    colorMaker: StatesColorMaker(),
                    width: 150,
                  ),
                ],
              ), // test your widget here
            ),
          ),
        ),
      ),
    );
  }
}

FormFieldValidator<String> _validator2Chars = (text) => text!.length > 1 ? '' : 'error';
