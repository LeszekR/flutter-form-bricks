import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

import 'empty_form_manager.dart';

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return UiParams(
      data: UiParamsData(),
      child: MaterialApp(
        theme: UiParams.of(context).style.mainTheme(),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 200,
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFieldBrick(
                    keyString: 'text_1',
                    formManager: EmptyFormManager(),
                    colorMaker: StatesColorMaker(),
                    width: 150,
                  ),
                  UiParams.of(context).size.spacerBoxVerticalMedium,
                  TextFieldBrick(
                    keyString: 'text_2',
                    formManager: EmptyFormManager(),
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
