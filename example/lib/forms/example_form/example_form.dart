import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks_example/forms/example_form/example_form_manager.dart';

part 'example_form_schema.dart';

final GlobalKey<ExampleFormState> formKey1 = GlobalKey();
final String dateKeyString1 = 'dateKeyString1';
final String dateKeyString2 = 'dateKeyString2';
final String timeKeyString1 = 'timeKeyString1';
final String plainTextKeyString2 = 'plainKeyString1';
final String lowerCaseKeyString3 = 'lowerCaseKeyString1';
final String dateTimeSeparatedKeyString1 = 'dateTimeSeparatedKeString1';

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
        width: 400 * appSize.zoom,
        height: 500 * appSize.zoom,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // DateField(
            //   keyString: dateKeyString1,
            //   formManager: formManager,
            //   width: 160,
            //   withDatePicker: true,
            //   buttonConfig: TextFieldButtonConfig(
            //     syncStyleWithTextField: true,
            //     // distanceFromTextField: 3,
            //     // transparentBackground: false,
            //     // buttonStyle: ButtonStyle(
            //     //   side: const WidgetStatePropertyAll(BorderSide.none),
            //     //   backgroundColor: WidgetStatePropertyAll(Colors.transparent),
            //     //   overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            //     //   shadowColor: const WidgetStatePropertyAll(Colors.transparent),
            //     //   surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
            //     //   elevation: const WidgetStatePropertyAll(0),
            //     // ),
            //     iconData: Icons.calendar_month,
            //     tooltipMaker: (context) => 'Kalendarz',
            //   ),
            //   inputDecoration: InputDecoration(labelText: 'Data'),
            //   // outerLabelConfig: OuterLabelConfig(
            //   //   labelText: 'Data',
            //   //   align: Alignment.bottomLeft,
            //   //   side: Side.left,
            //   //   width: 60,
            //   // ),
            //   errorPosition: ErrorPosition.dynamicSpaceBelowField,
            //   textFieldBorderType: TextFieldBorderType.underline,
            //   // inputDecoration: InputDecoration(labelText: 'data'),
            // ),
            // //
            // SizedBox(height: appSize.spacerVerticalMedium),
            // DateField(
            //   keyString: dateKeyString2,
            //   formManager: formManager,
            //   width: 160,
            //   withDatePicker: true,
            //   buttonConfig: TextFieldButtonConfig(
            //     tooltipMaker: (context) => 'Kalendarz',
            //   ),
            //   // outerLabelConfig: OuterLabelConfig(
            //   //   labelText: 'Data',
            //   //   align: Alignment.bottomLeft,
            //   //   side: Side.left,
            //   //   width: 50,
            //   //   height: 26,
            //   // ),
            //   errorPosition: ErrorPosition.dynamicSpaceBelowField,
            //   textFieldBorderType: TextFieldBorderType.outline,
            //   // TU PRZERWAŁEM - when textFieldBorderType is declared - override the InputDecoration passed as param
            //   //  and make the border as declared in textFieldBorderType
            //   inputDecoration: InputDecoration(labelText: 'data'),
            // ),

              SizedBox(height: appSize.spacerVerticalMedium),
              DateTimeSeparatedField(
                keyString: dateTimeSeparatedKeyString1,
                formManager: formManager,
                dateWidth: 150,
                pickerButtonConfig: TextFieldButtonConfig(width: 20),
                dateOuterLabelConfig: OuterLabelConfig(
                  labelText: 'Data',
                  side: Side.top,
                  height: 16,
                ),
                timeOuterLabelConfig: OuterLabelConfig(
                  labelText: 'Godzina',
                  side: Side.top,
                  height: 16,
                ),
                outerLabelConfig: OuterLabelConfig(
                  labelText: 'Data i czas',
                  side: Side.left,
                  // height: 46 * appSize.zoom,
                  width: 80,
                  align: Alignment.bottomLeft,
                ),
              ),
            //
            // SizedBox(height: appSize.spacerVerticalMedium),
            //  TimeField(
            //    keyString: timeKeyString1,
            //    formManager: formManager,
            //    width: 130,
            //    withTimePicker: true,
            //    outerLabelConfig: OuterLabelConfig(
            //      labelText: 'Godzina',
            //      align: Alignment.bottomLeft,
            //      side: Side.left,
            //      width: 60,
            //      height: 22,
            //    ),
            //    errorPosition: ErrorPosition.dynamicSpaceBelowField,
            //    textFieldBorderType: TextFieldBorderType.underline,
            //    // inputDecoration: InputDecoration(labelText: 'data'),
            //  ),
             //
             // SizedBox(height: appSize.spacerVerticalMedium),
             // PlainTextField(
             //   keyString: plainTextKeyString2,
             //   formManager: formManager,
             //   width: 200,
             //   maxLines: 3,
             //   validateMode: ValidateModeBrick.noValidator,
             // ),
             // //
             // SizedBox(height: appSize.spacerVerticalMedium),
             // LowerCaseField(
             //   keyString: lowerCaseKeyString3,
             //   formManager: formManager,
             //   width: 250,
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
