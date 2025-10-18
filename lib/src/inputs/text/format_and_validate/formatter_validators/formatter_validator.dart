import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/string_parse_result.dart';

abstract class FormatterValidator {
  StringParseResult call(StringParseResult input);
}
