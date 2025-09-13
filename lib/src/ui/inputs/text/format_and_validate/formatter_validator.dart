import 'string_parse_result.dart';

abstract class FormatterValidator {
  StringParseResult call(StringParseResult input);
}
