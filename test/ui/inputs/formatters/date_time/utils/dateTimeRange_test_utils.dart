import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/standalone_form_manager.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/date_time_inputs.dart';
import 'package:flutter_form_bricks/src/inputs/labelled_box/label_position.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_standalone_form.dart';
import '../../../../test_utils.dart';
import 'dateTime_test_utils.dart';

class RangeTestData {
  final List<String> texts;
  final List<String?> expectedValues;
  final String? errorMessage;

  const RangeTestData(this.texts, this.expectedValues, this.errorMessage);
}

Future<TestStandaloneForm> prepDateTimeRangeTest(
  WidgetTester tester,
  String rangeId,
  DateTimeLimits dateTimeLimits,
  int maxRangeSpanDays,
  int minRangeSpanMinutes,
) async {
  // do not remove this - default Flutter test screen can be to narrow for default width of dateTimeRange
  await tester.binding.setSurfaceSize(Size(1000, 1000));

  var globalKey = GlobalKey<TestStandaloneFormState>();

  await prepareWidget(
    tester,
    TestStandaloneForm(
      key: globalKey,
      widgetMaker: (BuildContext context, FormManagerOLD formManager) => Expanded(child: DateTimeInputs.dateTimeRange(
        context: context,
        rangeId: rangeId,
        label: "Deadline range",
        labelPosition: LabelPosition.topLeft,
        currentDate: CurrentDate(),
        dateTimeLimits: dateTimeLimits,
        formManager: formManager,
        maxRangeSpanDays: maxRangeSpanDays,
        minRangeSpanMinutes: minRangeSpanMinutes,
      ),)
    ),
  );
  return find.byKey(globalKey).evaluate().first.widget as TestStandaloneForm;
}

Future<bool> testDateTimeRangeValidator(
  tester,
  TestStandaloneForm form,
  List<String> keyStrings,
  List<RangeTestData> testCases,
) async {
  String? errors;
  String input = '';
  String? actual, expected;
  bool passedOk = true;
  String dateStart, timeStart, dateEnd, timeEnd;
  var formManager = form.formManager as StandaloneFormManagerOLD;
  var errorFieldFinder = find.byKey(Key(form.errorKeyString));
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

    // repeat fill and Enter in the incorrect field for the formManager to show errorMessage in the form err-text
    if (errFieldIndex != null) {
      await tester.enterText(find.byKey(Key(keyStrings[errFieldIndex])), testCase.texts[errFieldIndex]);
      await tester.testTextInput.receiveAction(TextInputAction.done);
    }
    await tester.pump();

    // then
    // .......................................................................................
    for (int i = 0; i < 4; i++) {
      actual = formManager.getErrorMessage(keyStrings[i]);
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
