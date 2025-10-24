import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_data.dart';
import '../../test_utils.dart';

void main() {
  group("Should test vat number input", () {
    List<TestData> testParams = [
      TestData("PL1234567891", "PL1234567891"),
      TestData("PLC", "PL"),
      TestData("PL123456789123456", "PL1234567891"),
      TestData("PL1234 567891", "PL1234")
    ];
    const String textVatFieldKey = "vat_single 1";

    for (var param in testParams) {
      testWidgets("should test proper input", (WidgetTester tester) async {
        BuildContext context = await pumpAppGetContext(tester);
        final formManager = SingleFormManager();

        final input = TextInputs.textVat(
            context: context,
            keyString: textVatFieldKey,
            labelPosition: LabelPosition.topLeft,
            // textEditingController: controller,
            // focusNode: focusNode,
            formManager: formManager,
            label: 'Vat input');

        await prepareSimpleForm(tester, formManager, input);

        await tester.enterText(find.byKey(const Key(textVatFieldKey)), param.input);
        await tester.pump();

        final result =
            (find.byKey(const Key(textVatFieldKey)).evaluate().first.widget as FormBuilderTextField).controller!.text;
        expect(result, param.expected);
      });
    }
  });
}
