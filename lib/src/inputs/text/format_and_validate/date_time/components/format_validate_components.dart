import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator_payload.dart';

class DateTimeFormatterValidatorChain
    extends FormatterValidatorChainEarlyStop<String, DateTime, DateTimeFormatterValidatorPayload> {
  DateTimeFormatterValidatorChain(super.steps);
}

class DateTimeFormatterValidatorPayload extends FormatterValidatorPayload {
  final DateTimeLimits dateTimeLimits;

  DateTimeFormatterValidatorPayload(this.dateTimeLimits);
}
