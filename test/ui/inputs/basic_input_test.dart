import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  const userText = 'New input';

  testWidgets('Readonly input should not accept input', (WidgetTester tester) async {
    //given
    await prepareWidget(
      tester,
      (context) => BasicTextInput.basicTextInput(
        context: context,
        keyString: 'testInput',
        label: 'Test Input',
        autovalidateMode: AutovalidateMode.onUserInteraction,
        labelPosition: LabelPosition.topLeft,
        formManager: SingleFormManager(),
        readonly: true,
      ),
    );
    final inputField = find.byType(FormBuilderTextField);

    //when
    await tester.enterText(inputField, userText);
    await tester.pump();

    //then
    expect(find.text(userText), findsNothing);
  });

  testWidgets('Editable input should  accept input', (WidgetTester tester) async {
    //given
    await prepareWidget(
      tester,
      (context) => BasicTextInput.basicTextInput(
        context: context,
        keyString: 'testInput',
        label: 'Test Input',
        autovalidateMode: AutovalidateMode.onUserInteraction,
        labelPosition: LabelPosition.topLeft,
        formManager: SingleFormManager(),
        readonly: false,
      ),
    );

    final inputField = find.byType(FormBuilderTextField);

    //when
    await tester.enterText(inputField, userText);
    await tester.pump();

    //then
    expect(find.text(userText), findsOne);
  });
}
