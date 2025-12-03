import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_utils.dart';
import '../../../tools/constants.dart';

void main() {
  testWidgets("Should test triming spaces in textSimple", (WidgetTester tester) async {
    BuildContext context = await pumpAppGetContext(tester);

    //given
    const String keyString = "regular_input_single";
    const String enteredText = "Space at the end ";

    final formManager = SingleFormManager();
    await prepareDataForTrimmingSpacesTests(context, tester, formManager, keyString);

    //when
    await enterTextAndUnfocusWidget(tester, formManager, keyString, enteredText);

    // Then
    final resultOne =
        (find.byKey(const Key(keyString)).evaluate().first.widget as FormBuilderTextField).controller!.text;
    expect(resultOne, "Space at the end");
  });

  testWidgets('should stay in focus when clicked Enter for textSimple', (WidgetTester tester) async {
    BuildContext context = await pumpAppGetContext(tester);

    //given
    final formManager = SingleFormManager();
    const String regularInputKey = "regular_input_single";

    await prepareDataForFocusLosingTests(context, tester, formManager, regularInputKey);

    await tester.pump();

    final inputs = getInputs(tester);

    await performAndCheckInputActions(tester, formManager, regularInputKey, inputs);
  });
}
