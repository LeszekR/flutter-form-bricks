import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

final GlobalKey<ExampleFormState> formKey1 = GlobalKey();
final String plainTextKeyString1 = 'plainTextKeyString1';
final String plainTextKeyString2 = 'plainTextKeyString2';
final String plainTextKeyString3 = 'plainTextKeyString3';

@AutoFormSchema()
class ExampleForm extends FormBrick {
  ExampleForm({required super.formManager});

  @override
  FormStateBrick<FormBrick> createState() => ExampleFormState();
}

class ExampleFormState extends FormStateBrick {
  @override
  Widget buildBody(BuildContext context) {
    var appSize = UiParams.of(context).appSize;
    var statesColorMaker = StatesColorMaker();
    var dateTimeUtils = DateTimeUtils();
    var currentDate = CurrentDate();

    return Center(
      child: SizedBox(
        // width: 200,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PlainTextField(
              keyString: plainTextKeyString1,
              formManager: formManager,
              colorMaker: statesColorMaker,
              width: 150,
              initialInput: 'Krokodyl',
              formatterValidatorChain:
                  DateTimeFormatterValidatorChain([DateFormatterValidator(dateTimeUtils, currentDate)]),
            ),
            appSize.spacerBoxVerticalMedium,
            PlainTextField(
              keyString: plainTextKeyString2,
              formManager: formManager,
              colorMaker: statesColorMaker,
              initialInput: 'Zenon',
              isFocusedOnInit: true,
              width: 200,
              maxLines: 3,
            ),
            // appSize.spacerBoxVerticalMedium,
            // BrickTextField(
            //   keyString: 'test_text_input_3',
            //   formManager: formManager,
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
  void deleteEntity() {
    // TODO: implement deleteEntity
  }

  @override
  // TODO: implement isValid
  bool get isValid => throw UnimplementedError();

  @override
  String provideLabel() {
    // TODO: implement provideLabel
    throw UnimplementedError();
  }

  @override
  void submitData() {
    // TODO: implement submitData
  }
}
