import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_payload.dart';

class DateTimeFormatterValidatorChain
    extends FormatterValidatorChainEarlyStop<String, DateTime, DateTimeFormatValidatePayload> {
  DateTimeFormatterValidatorChain(super.steps);
}

class DateTimeFormatValidatePayload extends FormatValidatePayload {
  final DateTimeLimits dateTimeLimits;
  DateTimeFormatValidatePayload(this.dateTimeLimits);
}
