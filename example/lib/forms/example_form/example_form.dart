import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks_example/forms/example_form/example_form_manager.dart';

part 'example_form.g.dart';

final GlobalKey<ExampleFormState> formKey1 = GlobalKey();
final String dateKeyString1 = 'plainTextKeyString1';
final String plainTextKeyString2 = 'plainTextKeyString2';
final String lowerCaseKeyString3 = 'plainTextKeyString3';

@AutoFormSchema()
class ExampleForm extends FormBrick {
  ExampleForm() : super(formManager: ExampleFormManager());

  @override
  FormStateBrick<FormBrick> createState() => ExampleFormState();
}

class ExampleFormState extends FormStateBrick {
  @override
  Widget buildBody(BuildContext context) {
    var appSize = UiParams.of(context).appSize;

    return Center(
      child: SizedBox(
        width: 400,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DateField(
              keyString: dateKeyString1,
              formManager: formManager,
              width: 150,
              initialInput: 'Krokodyl',
              // defaultFormatterValidatorListMaker: null,
            ),
            appSize.spacerBoxVerticalMedium,
            PlainTextField(
              keyString: plainTextKeyString2,
              formManager: formManager,
              initialInput: 'Zenon',
              isFocusedOnStart: true,
              width: 200,
              maxLines: 3,
            ),
            appSize.spacerBoxVerticalMedium,
            LowerCaseTextField(
              keyString: lowerCaseKeyString3,
              formManager: formManager,
              width: 250,
            ),
            // BrickTheme.of(context).sizes.spacerBoxVerticalMedium,
            // BrickTextField(
            //   keyString: 'test_text_input_4',
            //   formManager: formManager,
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
    );
  }

  @override
  void submitData() {
    // TODO: implement submitData
  }
}
