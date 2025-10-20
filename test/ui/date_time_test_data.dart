import 'package:flutter_form_bricks/shelf.dart';

class DateTimeTestData {
  final DateTimeLimits dateTimeLimits;
  final dynamic input;
  final dynamic expected;
  final bool isValid;
  final String errorMessage;

  DateTimeTestData(this.dateTimeLimits, this.input, this.expected, this.isValid, this.errorMessage);
}