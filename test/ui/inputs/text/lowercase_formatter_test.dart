import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatters/lowercase_formatter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_data.dart';
import '../../test_utils.dart';
import 'constants.dart';

void main() {
  const String keyString = "2 lowercase text";

  group('Should format to uppercase', () {
    final List<TestData> testParameters = [
      TestData("AbCdE", "abcde"),
      TestData("123 ABC", "123 abc"),
    ];

    for (final param in testParameters) {
      testWidgets('Formatter should turn "${param.input}" into: "${param.expected}"', (WidgetTester tester) async {
        //given
        const TextEditingValue initial = TextEditingValue(text: "");
        final TextEditingValue newInput = TextEditingValue(text: param.input);

        //when
        final result = LowercaseFormatter().formatEditUpdate(initial, newInput);

        //then
        expect(result.text, param.expected);
      });
    }
  });

  testWidgets("Should test trimming spaces in lowercase text field", (WidgetTester tester) async {
    const String keyString = "2 lowercase text";
    const String enteredText = "Lower case space test ";
    BuildContext context = await pumpAppGetContext(tester);

    //given
    final SingleFormManager formManager = SingleFormManager();
    await prepareDataForTrimmingSpacesTests(context, tester, formManager, keyString);

    //when
    await enterTextAndUnfocusWidget(tester, formManager, keyString, enteredText);

    // Then
    final resultOne =
        (find.byKey(const Key(keyString)).evaluate().first.widget as FormBuilderTextField).controller!.text;
    expect(resultOne, "Lower case space test");
  });

  testWidgets('should stay in focus when clicked Enter in lowercase text field', (WidgetTester tester) async {
    BuildContext context = await pumpAppGetContext(tester);
    //given
    final formManager = SingleFormManager();

    await prepareDataForFocusLosingTests(context, tester, formManager, keyString);

    await tester.pump();

    final inputs = ConstantsText.getInputs(tester);

    await performAndCheckInputActions(tester, formManager, keyString, inputs);
  });
}
