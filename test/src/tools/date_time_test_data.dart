import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_limits.dart';

class DateTimeTestData {
  final dynamic input;
  final dynamic expectedValue;
  final bool expectedIsValid;
  final String expectedErrorMessage;

  DateTimeTestData(this.input, this.expectedValue, this.expectedIsValid, this.expectedErrorMessage);
}