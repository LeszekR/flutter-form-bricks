import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks_example/forms/example_form/example_form_manager.dart';

part 'example_form_schema.dart';

final GlobalKey<ExampleFormState> formKey1 = GlobalKey();
final String dateKeyString1 = 'dateKeyString1';
final String dateKeyString2 = 'dateKeyString2';
final String dateKeyString3 = 'dateKeyString3';
final String dateKeyString4 = 'dateKeyString4';
final String dateKeyString5 = 'dateKeyString5';
final String timeKeyString1 = 'timeKeyString1';
final String plainTextKeyString1 = 'plainKeyString1';
final String plainTextKeyString2 = 'plainKeyString2';
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
        width: 500 * appSize.zoom,
        height: 500 * appSize.zoom,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // SizedBox(height: appSize.spacerVerticalMedium),
            // PlainTextField(
            //   keyString: plainTextKeyString1,
            //   formManager: formManager,
            //   validateMode: ValidateModeBrick.noValidator,
            //   errorPosition: ErrorPosition.fixedSpaceBelowField,
            //   buttonConfig: TextFieldButtonConfig(distanceFromTextField: 4),
            //   // borderType: TextFieldBorderType.other,
            //   outerLabelConfig: OuterLabelConfig(
            //     labelText: 'outer label',
            //     side: Side.top,
            //     height: 20,
            //   ),
            //   errorBuilder: (context, _) => Text('error text try'),
            //   // TU PRZERWAŁEM - bottom space changes height on reload - and check how many times LabelledBox builds
            //   inputDecoration: InputDecoration(
            //     // helperText: 'helper text\njeszcze\ni tu tez\ni teraz\ni tu tez',
            //     helperMaxLines: 6,
            //     // helperText: 'helper text\nsecond line\nthird line',
            //     // labelText: 'data 2',
            //     border: UnderlineInputBorder(),
            //     // visualDensity: VisualDensity(vertical: 3),
            //   ),
            // ),
            //
            // SizedBox(
            //   width: 300,
            //   height: 3,
            //   child: DecoratedBox(decoration: BoxDecoration(color: Colors.orange)),
            // ),
            //
            // SizedBox(height: appSize.spacerVerticalMedium),
            // TextField(
            //   controller: TextEditingController(text: 'Ay'),
            //   decoration: InputDecoration(
            //     visualDensity: VisualDensity(vertical: -2),
            //     border: UnderlineInputBorder(),
            //     // labelText: 'data',
            //     label: DecoratedBox(
            //         decoration: BoxDecoration(color: Colors.yellow),
            //         child: SizedBox(height: 35, child: Text('Smoczydło'))),
            //     error: DecoratedBox(
            //         decoration: BoxDecoration(color: Colors.yellow),
            //         child: SizedBox(height: 35, child: Text('Smoczydło'))),
            //   ),
            // ),

            SizedBox(height: appSize.spacerVerticalMedium),
            DateField(
              keyString: dateKeyString1,
              formManager: formManager,
              width: 160,
              withDatePicker: true,
              buttonConfig: TextFieldButtonConfig(
                syncStyleWithTextField: true,
                // distanceFromTextField: 3,
                // transparentBackground: false,
                // buttonStyle: ButtonStyle(
                //   side: const WidgetStatePropertyAll(BorderSide.none),
                //   backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                //   overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                //   shadowColor: const WidgetStatePropertyAll(Colors.transparent),
                //   surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
                //   elevation: const WidgetStatePropertyAll(0),
                iconData: Icons.calendar_month,
                tooltipMaker: (context) => 'Kalendarz',
              ),
              errorPosition: ErrorPosition.fixedSpaceBelowField,
              // errorBuilder: (context, errorText) => Text('Ay'),
              inputDecoration: InputDecoration(
                labelText: 'Data',
                helperText: 'helper text\nsecond line\nthird line\nfourth line\nfifth line\nsixth line',
                helperMaxLines: 3,
                errorMaxLines: 6,
              ),
              // outerLabelConfig: OuterLabelConfig(
              //   labelText: 'Data',
              //   align: Alignment.bottomLeft,
              //   side: Side.left,
              //   width: 60,
              // ),
              // inputDecoration: InputDecoration(labelText: 'data'),
            ),

            SizedBox(
              width: 300,
              height: 3,
              child: DecoratedBox(decoration: BoxDecoration(color: Colors.orange)),
            ),

            SizedBox(height: appSize.spacerVerticalMedium),
            DateField(
              keyString: dateKeyString2,
              formManager: formManager,
              width: 160,
              withDatePicker: false,
              // buttonConfig: TextFieldButtonConfig(
              //   tooltipMaker: (context) => 'Kalendarz',
              //   buttonStyle: ButtonStyle(
              //     shape: WidgetStatePropertyAll(
              //       BeveledRectangleBorder(
              //         side: BorderSide(
              //           width: 0.3,
              //           color: Colors.red,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              errorPosition: ErrorPosition.never,
              inputDecoration: InputDecoration(
                labelText: 'data 2',
                border: OutlineInputBorder(),
              ),
            ),

            // ==================================================================
            // SizedBox(height: appSize.spacerVerticalMedium),
            // DateField(
            //   keyString: dateKeyString4,
            //   formManager: formManager,
            //   width: 160,
            //   buttonConfig: TextFieldButtonConfig(
            //     tooltipMaker: (context) => 'Kalendarz 4',
            //     distanceFromTextField: 10,
            //     syncStyleWithTextField: false,
            //   ),
            //   errorPosition: ErrorPosition.fixedSpaceBelowField,
            //   errorBuilder: (context, errorText) => DecoratedBox(
            //     decoration: BoxDecoration(color: Colors.orange),
            //     child: SizedBox(
            //       width: errorText.trim().isEmpty ? 0 : null,
            //       height: 35,
            //       child: Text(errorText),
            //     ),
            //   ),
            //   borderType: TextFieldBorderType.underline,
            //   inputDecoration: InputDecoration(
            //     // visualDensity: VisualDensity(vertical:-4),
            //     labelText: 'data 4 fixedSpace',
            //     filled: true,
            //     helper: SizedBox(height: 45, child: Text('Burba bum bum TRACH!')),
            //   ),
            // ),
            //
            // SizedBox(height: appSize.spacerVerticalMedium),
            // DateField(
            //   keyString: dateKeyString3,
            //   formManager: formManager,
            //   width: 250,
            //   buttonConfig: TextFieldButtonConfig(
            //     tooltipMaker: (context) => 'Kalendarz',
            //     distanceFromTextField: 4,
            //     // buttonStyle: ButtonStyle(shape: WidgetStatePropertyAll(BeveledRectangleBorder(side: BorderSide()))),
            //   ),
            //   errorPosition: ErrorPosition.fixedSpaceBelowField,
            //   borderType: TextFieldBorderType.outline,
            //   inputDecoration: InputDecoration(
            //     labelText: 'data 3 fixedSpace',
            //     // border: OutlineInputBorder(),
            //     // label: DecoratedBox(decoration: BoxDecoration(color: Colors.yellow), child: SizedBox(height: 35, child: Text('Smoczydło'))),
            //     // helper: DecoratedBox(
            //     //     decoration: BoxDecoration(color: Colors.yellow),
            //     //     child: SizedBox(height: 35, child: Text('Smoczydło'))),
            //     // counter: DecoratedBox(
            //     //     decoration: BoxDecoration(color: Colors.yellow),
            //     //     child: SizedBox(height: 45, child: Text('liczyk...'))),
            //     // counterText: 'liczyk 2...',
            //   ),
            // ),
            //
            // SizedBox(height: appSize.spacerVerticalMedium),
            // DateField(
            //   keyString: dateKeyString5,
            //   formManager: formManager,
            //   width: 250,
            //   buttonConfig: TextFieldButtonConfig(
            //     tooltipMaker: (context) => 'Kalendarz',
            //     distanceFromTextField: 4,
            //     // buttonStyle: ButtonStyle(shape: WidgetStatePropertyAll(BeveledRectangleBorder(side: BorderSide()))),
            //   ),
            //   errorPosition: ErrorPosition.fixedSpaceBelowField,
            //   borderType: TextFieldBorderType.outline,
            //   inputDecoration: InputDecoration(
            //     labelText: 'data 5 fixedSpace',
            //     // border: OutlineInputBorder(),
            //     // label: DecoratedBox(decoration: BoxDecoration(color: Colors.yellow), child: SizedBox(height: 35, child: Text('Smoczydło'))),
            //     // helper: DecoratedBox(
            //     //     decoration: BoxDecoration(color: Colors.yellow),
            //     //     child: SizedBox(height: 35, child: Text('Smoczydło'))),
            //     // counter: DecoratedBox(
            //     //     decoration: BoxDecoration(color: Colors.yellow),
            //     //     child: SizedBox(height: 45, child: Text('liczyk...'))),
            //     // counterText: 'liczyk 2...',
            //   ),
            // ),

            // SizedBox(height: appSize.spacerVerticalMedium),
            // DateTimeSeparatedField(
            //   keyString: dateTimeSeparatedKeyString1,
            //   formManager: formManager,
            //   errorPosition: ErrorPosition.never,
            //   // dateWidth: 150,
            //   pickerButtonConfig: TextFieldButtonConfig(width: 25),
            //   dateOuterLabelConfig: OuterLabelConfig(
            //     labelText: 'Data',
            //     side: Side.top,
            //     height: 22,
            //     padding: EdgeInsetsGeometry.only(bottom: 4),
            //   ),
            //   timeOuterLabelConfig: OuterLabelConfig(
            //     labelText: 'Godzina',
            //     side: Side.top,
            //     height: 16,
            //   ),
            //   outerLabelConfig: OuterLabelConfig(
            //     labelText: 'Data i czas',
            //     side: Side.left,
            //     // height: 46 * appSize.zoom,
            //     width: 80,
            //     align: Alignment.centerRight,
            //     padding: EdgeInsetsGeometry.only(right: 10),
            //   ),
            //   dateInputDecoration: InputDecoration(helperText: 'Gucio'),
            //   timeInputDecoration: InputDecoration(helperText: 'Misia'),
            // ),

            // SizedBox(height: appSize.spacerVerticalMedium),
            // TimeField(
            //   keyString: timeKeyString1,
            //   formManager: formManager,
            //   width: 130,
            //   withTimePicker: true,
            //   outerLabelConfig: OuterLabelConfig(
            //     labelText: 'Godzina',
            //     align: Alignment.bottomLeft,
            //     side: Side.left,
            //     width: 60,
            //     // height: 22,
            //   ),
            //   errorPosition: ErrorPosition.dynamicSpaceBelowField,
            //   borderType: TextFieldBorderType.underline,
            //   // inputDecoration: InputDecoration(labelText: 'data'),
            // ),

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
