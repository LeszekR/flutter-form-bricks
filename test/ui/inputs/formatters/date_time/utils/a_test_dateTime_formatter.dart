import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/string_parse_result.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

abstract class ATestDateTimeFormatter {
  StringParseResult makeDateTime(BricksLocalizations localizations, String inputString, DateTimeLimits dateLimits);
}
