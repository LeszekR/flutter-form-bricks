import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/string_parse_result.dart';

import 'formatter_validator.dart';
import 'formatter_validator_chain.dart';

class FormatterValidatorChainFullRun extends FormatterValidatorChain {
  final List<FormatterValidator> steps;

  FormatterValidatorChainFullRun(this.steps);

  StringParseResult run(String raw) {
    var result = StringParseResult.ok(raw);
    for (final step in steps) {
      result = step(result);
      if (!result.isStringValid) break; // stop on first error
    }
    return result;
  }
}
