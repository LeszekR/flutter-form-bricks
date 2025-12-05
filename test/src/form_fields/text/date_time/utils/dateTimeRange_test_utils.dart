import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_range_span.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/date_time_inputs.dart';
import 'package:flutter_form_bricks/src/form_fields/labelled_box/label_position.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../test_implementations/test_form_manager.dart';
import '../../../../../test_implementations/test_single_form.dart';
import '../../../../tools/test_utils.dart';
import 'dateTime_test_utils.dart';

class RangeTestData {
  final List<String> texts;
  final List<String?> expectedValues;
  final String? errorMessage;

  const RangeTestData(this.texts, this.expectedValues, this.errorMessage);
}

Future<TestSingleForm> prepDateTimeRangeTest(
  WidgetTester tester,
  String rangeId,
  DateTimeLimits dateTimeLimits,
  DateTimeRangeSpan dateTimeRangeSpan,
) async {
  // do not remove this - default Flutter test screen can be to narrow for default width of dateTimeRange
  await tester.binding.setSurfaceSize(Size(1000, 1000));

  var globalKey = GlobalKey<TestSingleFormState>();

  await prepareWidget(
    tester,
    (context) => TestSingleForm(
      widgetBuilder: (context, formManager) => Expanded(
        child: DateTimeInputs.dateTimeRange(
          localizations: BricksLocalizations.of(context),
          context: context,
          rangeId: rangeId,
          formManager: formManager,
          label: "Deadline range",
          labelPosition: LabelPosition.topLeft,
          currentDate: CurrentDate(),
          dateTimeLimits: dateTimeRangeSpan: dateTimeRangeSpan,
        ),
      ),
    ),
  );
  return find.byKey(globalKey).evaluate().first.widget as TestSingleForm;
}

Future<bool> testDateTimeRangeValidator(
  tester,
  TestSingleForm form,
  List<String> keyStrings,
  List<RangeTestData> testCases,
) async {
  String? errors;
  String input = '';
  String? actual, expected;
  bool passedOk = true;
  String dateStart, timeStart, dateEnd, timeEnd;
  final formState = tester.state<TestSingleFormState>(find.byType(TestSingleForm));
  final TestFormManager formManager = formState.formManager;
  final errorFieldFinder = find.byKey(Key(form.errorKeyString));
  Text errorField;

  for (var testCase in testCases) {
    errors = null;
    //
    // when
    // .......................................................................................
    dateStart = fillEmpty(testCase, 0, '----');
    timeStart = fillEmpty(testCase, 1, '--');
    dateEnd = fillEmpty(testCase, 2, '----');
    timeEnd = fillEmpty(testCase, 3, '--');
    input = ' $dateStart $timeStart / $dateEnd $timeEnd';

    int? errFieldIndex;
    for (int i = 0; i < 4; i++) {
      await tester.enterText(find.byKey(Key(keyStrings[i])), testCase.texts[i]);
      if (errFieldIndex == null && testCase.expectedValues[i] != null) {
        errFieldIndex = i;
        continue;
      }
    }

    // repeat fill and Enter in the incorrect field for the formManager to show errorMessage in the form err-text_formatter_validators
    if (errFieldIndex != null) {
      await tester.enterText(find.byKey(Key(keyStrings[errFieldIndex])), testCase.texts[errFieldIndex]);
      await tester.testTextInput.receiveAction(TextInputAction.done);
    }
    await tester.pump();

    // then
    // .......................................................................................
    for (int i = 0; i < 4; i++) {
      actual = formManager.getFieldError(keyStrings[i]);
      expected = testCase.expectedValues[i];
      errors = tryExpect('', actual, expected, errors, 'field ${i + 1}');
    }
    errorField = tester.firstWidget(errorFieldFinder);
    actual = errorField.data;
    expected = testCase.errorMessage ?? '';
    errors = tryExpect('', actual, expected, errors, 'Form error message');

    if (errors != null) debugPrint("test failed: input $input $errors");
    passedOk &= errors == null;
  }
  return passedOk;
}

String fillEmpty(RangeTestData testCase, int index, String fill) =>
    testCase.texts[index].isEmpty ? fill : testCase.texts[index];
