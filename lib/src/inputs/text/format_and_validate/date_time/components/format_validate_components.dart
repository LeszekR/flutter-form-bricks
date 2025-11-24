import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';

class DateTimeFormatterValidatorChain extends FormatterValidatorChainFullRun<String, DateTime> {
  DateTimeFormatterValidatorChain(super.steps);
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
