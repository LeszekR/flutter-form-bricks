import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/text/first_upper_then_lower_case_formatter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_implementations/test_form_schema.dart';
import '../../../../test_implementations/test_form_state_data.dart';
import '../../../tools/test_data.dart';
import '../../../tools/test_utils.dart';

void main() {
  const String keyString = "first_uppercase_text_single 2";

  // TU PRZERWAŁEM - refactor all text fields to Bricks and then fix the tests here
  group('Should always format first uppercase', () {
    final List<TestData> testParameters = [
      TestData("Adam Test", "Adam Test"),
      TestData("adam test", "Adam Test"),
      TestData("adam-test", "Adam-Test"),
      TestData("a b cd", "A B Cd"),
    ];

    for (TestData param in testParameters) {
      testWidgets('Formatter should turn "${param.input}" into: "${param.expected}"', (WidgetTester tester) async {
        //given
        const TextEditingValue initial = TextEditingValue(text: "");
        final TextEditingValue newInput = TextEditingValue(text: param.input);

        //when
        final result = FirstUpperThenLowerCaseFormatter().formatEditUpdate(initial, newInput);

        //then
        expect(result.text, param.expected);
      });
    }
  });

  testWidgets("Should test triming spaces in first upper then lower field", (WidgetTester tester) async {
    BuildContext context = await pumpAppGetContext(tester);
    //given
    const String enteredText = "Space at the end ";

    final formManager = SingleFormManager(formData: TestFormData(), formSchema: TestFormSchema.withSingleTextField(fieldKeyString: te);
    await prepareDataForTrimmingSpacesTests(context, tester, formManager, keyString);

    //when
    await enterTextAndUnfocusWidget(tester, formManager, keyString, enteredText);

    // Then
    final resultOne =
        (find.byKey(const Key(keyString)).evaluate().first.widget as FormBuilderTextField).controller!.text;
    expect(resultOne, "Space at the end");
  });

  testWidgets('should stay in focus when clicked Enter for firstUpperThenLowerCase', (WidgetTester tester) async {
    BuildContext context = await pumpAppGetContext(tester);

    //given
    final formManager = SingleFormManager();

    await prepareDataForFocusLosingTests(context, tester, formManager, keyString);

    await tester.pump();

    final inputs = getInputs(tester);

    await performAndCheckInputActions(tester, formManager, keyString, inputs);
  });
}
