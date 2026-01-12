import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../tools/test_utils.dart';

void main() {
  const String keyString = "4 bulkText";
  const String enteredText = "Space at the \n end with multilines \n the space ";

  testWidgets("Should test trimming spaces in multiline text_formatter_validators field", (WidgetTester tester) async {
    BuildContext context = await pumpAppGetContext(tester);

    //given
    final SingleFormManager formManager = SingleFormManager();
    await prepareDataForTrimmingSpacesTests(context, tester, formManager, keyString);

    //when
    await enterTextAndUnfocusWidget(tester, formManager, keyString, enteredText);

    // Then
    final resultOne =
        (find.byKey(const Key(keyString)).evaluate().first.widget as FormBuilderTextField).controller!.text;
    expect(resultOne, "Space at the \n end with multilines \n the space");
  });

  testWidgets('should stay in focus when clicked Enter in multiline text_formatter_validators field', (WidgetTester tester) async {
    BuildContext context = await pumpAppGetContext(tester);

    //given
    final SingleFormManager formManager = SingleFormManager();
    await prepareDataForFocusLosingTests(context, tester, formManager, keyString);

    await tester.pump();

    final inputs = getInputs(tester);

    await performAndCheckInputActions(tester, formManager, keyString, inputs);
  });
}
