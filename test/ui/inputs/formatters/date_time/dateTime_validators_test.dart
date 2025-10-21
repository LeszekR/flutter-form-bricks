import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/date_time_validators.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/dateTime_test_utils.dart';

void main() {
  group('Date Input Validator Tests', () {
    testWidgets('should return null for date within limits, error outside limits', (WidgetTester tester) async {
      final localizations = await getLocalizations();

      final dateNow = DateTime(2024, 6, 1);
      final oneYearDays = 365;
      final halfYear = Duration(days: (oneYearDays / 2).toInt());
      final fullYear = Duration(days: oneYearDays);

      DateTime earliestDate = dateNow.subtract(Duration(days: oneYearDays));
      DateTime latestDate = dateNow.add(Duration(days: oneYearDays));
      final dateTimeLimits = DateTimeLimits(minDateTimeRequired: earliestDate, maxDateTimeRequired: latestDate);
      final FormFieldValidator<String> validator = DateTimeValidators.dateInputValidator(localizations, dateTimeLimits);

      // border cases
      expect(validator(Date(earliestDate).toString()), isEmpty);
      expect(validator(Date(latestDate).toString()), isEmpty);

      // date inside limits
      DateTime midEarlyDate = earliestDate.add(halfYear);
      DateTime midLateDate = latestDate.subtract(halfYear);
      expect(validator(Date(midEarlyDate).toString()), isEmpty);
      expect(validator(Date(midLateDate).toString()), isEmpty);

      // date outside limits
      DateTime tooEarlyDate = earliestDate.subtract(fullYear);
      DateTime tooLateDate = latestDate.add(fullYear);
      expect(validator(Date(tooEarlyDate).toString()), isNotEmpty);
      expect(validator(Date(tooLateDate).toString()), isNotEmpty);
    });
  });
}
