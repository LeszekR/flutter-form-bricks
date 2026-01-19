import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/components/time_stamp.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/format_and_validate/date_time/date_time_utils.dart';

class DateTimeFormatterValidatorChain extends FormatterValidatorChainFullRun<TextEditingValue, Date> {
  DateTimeFormatterValidatorChain() : super([DateFormatterValidator(DateTimeUtils(), CurrentDate())]);
}

// class DateFormatterValidatorPayload extends FormatterValidatorPayload {
//   final DateLimits dateLimits;
//   DateFormatterValidatorPayload(this.dateLimits);
// }
//
// class TimeFormatterValidatorPayload extends FormatterValidatorPayload {
//   final TimeLimits timeLimits;
//   TimeFormatterValidatorPayload(this.timeLimits);
// }
//
// class DateTimeFormatterValidatorPayload extends FormatterValidatorPayload {
//   final DateTimeLimits dateTimeLimits;
//   DateTimeFormatterValidatorPayload(this.dateTimeLimits);
// }
