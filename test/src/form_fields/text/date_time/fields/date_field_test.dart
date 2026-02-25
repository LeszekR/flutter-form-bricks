import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../test_implementations/test_form_manager.dart';
import '../../../../../test_implementations/test_form_schema.dart';
import '../../../../../tools/test_utils.dart';
import '../../text_formatter_validators/utils.dart';
import '../tools/test_constants.dart';

void main() {
  testWidgets('does not format on input change, formats on Enter', (WidgetTester tester) async {
    // with
    var keyString = fieldKeyString1;
    await _prepareDateField(tester, keyString);
    var fieldFinder = find.byKey(ValueKey(keyString));
    expect(fieldFinder, findsOneWidget);

    // when - only entered text, no Enter
    var text = '26-2//2';
    await tester.enterText(fieldFinder, text);
    await tester.pump();

    // then - does not format on change only
    TextEditingController controller = await getTextEditingController(tester, keyString);
    expect(controller.text, text);

    // when - Enter clicked
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // then - does format on Enter
    expect(controller.text, '2026-02-02');
  });

  testWidgets('shows incorrect input unchanged, shows correct input formatted to date', (WidgetTester tester) async {
    // with
    var keyString = fieldKeyString1;
    await _prepareDateField(tester, keyString);
    var fieldFinder = find.byKey(ValueKey(keyString));
    expect(fieldFinder, findsOneWidget);

    // when - only entered text, no Enter
    var text = '26-2//2x';
    await tester.enterText(fieldFinder, text);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // then - does not format on change only
    TextEditingController controller = await getTextEditingController(tester, keyString);
    expect(controller.text, text);

    // when - Enter clicked
    text = '26-2//2';
    await tester.enterText(fieldFinder, text);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // then - does format on Enter
    expect(controller.text, '2026-02-02');
  });
}

Future<void> _prepareDateField(WidgetTester tester, String keyString) async {
  var schema = TestFormSchema.fromDescriptors(
      initiallyFocusedKeyString: keyString, fieldDescriptors: [DateFieldDescriptor(keyString: keyString)]);
  var widgetMaker =
      (BuildContext context) => DateField(keyString: keyString, formManager: TestFormManager(schema: schema));
  await prepareWidget(tester, widgetMaker);
}
