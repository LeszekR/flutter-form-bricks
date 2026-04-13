import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks_example/forms/example_form/example_form_manager.dart';

part 'example_form_schema.dart';

final GlobalKey<ExampleFormState> formKey1 = GlobalKey();
final String dateKeyString1 = 'dateKeyString1';
final String timeKeyString1 = 'timeKeyString1';
final String plainTextKeyString2 = 'plainKeyString1';
final String lowerCaseKeyString3 = 'lowerCaseKeyString1';
final String dateTimeSeparatedKeString1 = 'dateTimeSeparatedKeString1';

// @AutoFormSchema()
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
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              // controller: TextEditingController(text: 'Test text Field'),
              selectAllOnFocus: false,
              decoration: InputDecoration(
                // isDense: true,
                // isCollapsed: true,
                labelText: 'Label text',
                // hintText: ' ',
                // errorText: 'Error text',
                error: SizedBox(),
                // suffixIconConstraints: const BoxConstraints( maxHeight: double.infinity),
                // suffixIconConstraints: const BoxConstraints(maxWidth: 100),
                // contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity(vertical: -4),
                border: OutlineInputBorder(),
                suffixIconConstraints: BoxConstraints(maxWidth: 50, maxHeight: 50),
                suffixIcon: SizedBox(
                  width: 20,
                  height: 32,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            title: Text('Title'),
                            content: Text('Dialog content'),
                          ),
                        );
                      },
                      child: const Center(
                        child: Icon(Icons.arrow_drop_down),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: appSize.spacerVerticalMedium),
            DateField(
              keyString: dateKeyString1,
              formManager: formManager,
              width: 150,
              outerLabelConfig: OuterLabelConfig(
                labelText: 'Data',
                side: Side.left,
                align: Alignment.center,
              ),
              errorConfig: const ErrorConfig(
                position: ErrorPosition.withTextField,
                behaviour: ErrorBehaviour.dynamicSpaceBelowField,
              ),
            ),
            SizedBox(height: appSize.spacerVerticalMedium),
            TimeField(
              keyString: timeKeyString1,
              formManager: formManager,
              width: 100,
            ),
            SizedBox(height: appSize.spacerVerticalMedium),
            PlainTextField(
              keyString: plainTextKeyString2,
              formManager: formManager,
              width: 200,
              maxLines: 3,
              validateMode: ValidateModeBrick.noValidator,
            ),
            SizedBox(height: appSize.spacerVerticalMedium),
            LowerCaseField(
              keyString: lowerCaseKeyString3,
              formManager: formManager,
              width: 250,
            ),
            SizedBox(height: appSize.spacerVerticalMedium),
            DateTimeSeparatedField(
              keyString: dateTimeSeparatedKeString1,
              formManager: formManager,
              outerLabelConfig: OuterLabelConfig(
                labelText: 'Data i czas',
                side: Side.right,
                align: Alignment.bottomLeft,
              ),
            ),
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
