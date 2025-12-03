import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/date_time_limits.dart';

class DateTimeTestData {
  final DateTimeLimits dateTimeLimits;
  final dynamic input;
  final dynamic expected;
  final bool isValid;
  final String errorMessage;

  DateTimeTestData(this.dateTimeLimits, this.input, this.expected, this.isValid, this.errorMessage);
}