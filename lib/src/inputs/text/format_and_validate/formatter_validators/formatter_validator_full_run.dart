import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/string_parse_result.dart';

import 'formatter_validator.dart';
import 'formatter_validator_chain.dart';

class FormatterValidatorChainFullRun extends FormatterValidatorChain<String> {
  FormatterValidatorChainFullRun(super.steps);

  StringParseResult run(String inputString) {
    var result = StringParseResult.ok(inputString);
    for (FormatterValidator step in steps) {
      result = step(result);
      if (!result.isStringValid) break; // stop on first error
    }
    return result;
  }
}
