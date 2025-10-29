import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/string_parse_result.dart';

import 'formatter_validator.dart';
import 'formatter_validator_chain.dart';

class FormatterValidatorChainEarlyStop extends FormatterValidatorChain<String> {
  FormatterValidatorChainEarlyStop(super.steps);

  StringParseResult run(String inputString) {
    var result = StringParseResult.ok(inputString);

    for (FormatterValidator step in steps) {
      result = step(result);
      if (!result.isStringValid) {
        return result;
      }
    }
    return result;
  }
}
