import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/string_parse_result.dart';

import 'formatter_validator.dart';
import 'formatter_validator_chain.dart';

class FormatterValidatorChainEarlyStop extends FormatterValidatorChain {
  final List<FormatterValidator> steps;

  FormatterValidatorChainEarlyStop(this.steps);

  StringParseResult run(String input) {
    var result = StringParseResult.ok(input);

    for (final step in steps) {
      result = step(result);
      if (!result.isStringValid) {
        return result;
      }
    }
    return result;
  }
}
