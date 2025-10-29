import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/formatter_validator.dart';
import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/string_parse_result.dart';

abstract class FormatterValidatorChain<T, K> {
  final List<FormatterValidator> steps;

  FormatterValidatorChain(this.steps);

  K run(T inputValue);

  String? getError(T inputValue);
}
