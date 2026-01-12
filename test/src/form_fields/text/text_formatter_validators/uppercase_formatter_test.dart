import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/text/uppercase_formatter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../tools/test_data.dart';
import '../../../tools/test_utils.dart';

void main() {
  const String keyString = "5 uppercase text_formatter_validators";

  group('Should format to lowercase', () {
    final List<TestData> testParameters = [
      TestData("AbCdE", "ABCDE"),
      TestData("123 abc", "123 ABC"),
    ];

    for (TestData param in testParameters) {
      testWidgets('Formatter should turn "${param.input}" into: "${param.expected}"', (WidgetTester tester) async {
        //given
        const TextEditingValue initial = TextEditingValue(text: "");
        final TextEditingValue newInput = TextEditingValue(text: param.input);

        //when
        final result = UppercaseFormatter().formatEditUpdate(initial, newInput);

        //then
        expect(result.text, param.expected);
      });
    }
  });

  testWidgets("Should test triming spaces in uppercase text_formatter_validators field", (WidgetTester tester) async {
    const String textEntered = "Space at the end ";
    BuildContext context = await pumpAppGetContext(tester);

    //given
    final formManager = SingleFormManager();
    await prepareDataForTrimmingSpacesTests(context, tester, formManager, keyString);

    //when
    await enterTextAndUnfocusWidget(tester, formManager, keyString, textEntered);

    // Then
    final resultOne =
        (find.byKey(const Key(keyString)).evaluate().first.widget as FormBuilderTextField).controller!.text;
    expect(resultOne, "Space at the end");
  });

  testWidgets('should stay in focus when clicked Enter in uppercase field', (WidgetTester tester) async {
    BuildContext context = await pumpAppGetContext(tester);

    //given
    final formManager = SingleFormManager();
    await prepareDataForFocusLosingTests(context, tester, formManager, keyString);
    await tester.pump();

    final inputs = getInputs(tester);

    await performAndCheckInputActions(tester, formManager, keyString, inputs);
  });
}
