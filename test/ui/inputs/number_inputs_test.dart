import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/form_manager/form_state.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_data.dart';
import '../test_utils.dart';

void main() {
  const key = "key";

  setUp(() async {
    await loadGlobalConfigurationForTests();
  });

  group('Decimal input field will allow to put incorrect chars but validator will complain about it', () {
    final List<TestData> testParameters = [
      TestData("123w", "1 23w"),
      TestData("123,145", "123,145"),
    ];

    for (params in testParameters) {
      testWidgets('should complain about ${params.input}', (WidgetTester tester) async {
        final BuildContext context = await pumpAppGetContext(tester);

        //given
        var formManager = SingleFormManager();
        final input = await NumberInputs.textDouble(
          context: context,
          formManager: formManager,
          keyString: key,
          label: "label",
          labelPosition: LabelPosition.topLeft,
        );
        await prepareSimpleForm(tester, formManager, input);

        //when
        await tester.enterText(find.byKey(const Key(key)), params.input);
        await tester.pump();

        //then
        formManager.formKey.currentState!.saveAndValidate();
        final formState = formManager.checkStatus();
        final String? fieldValue = formManager.formKey.currentState!.fields[key]?.value;

        expect(params.expected, fieldValue);
        expect(find.text(params.expected), findsOneWidget);
        expect(FormStatus.invalid, formState);
      });
    }
  });

  testWidgets('ID input field does not allow editing', (WidgetTester tester) async {
    final BuildContext context = await pumpAppGetContext(tester);

    //given
    const idValue = 12;
    // final formManager.formKey = GlobalKey<FormBuilderState>();
    var formManager = SingleFormManager();
    final input = NumberInputs.id(
      context: context,
      keyString: key,
      label: "label",
      labelPosition: LabelPosition.topLeft,
      initialValue: idValue,
      formManager: SingleFormManager(),
    );

    await prepareSimpleForm(tester, formManager, input);

    //when
    await tester.enterText(find.byKey(const Key(key)), '21');
    await tester.pump();

    //then
    formManager.formKey.currentState!.save();
    final String? fieldValue = formManager.formKey.currentState!.fields[key]?.value;

    expect("12", fieldValue);
    expect(find.text("12"), findsOneWidget);
  });
}
