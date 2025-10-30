import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/string_parse_result.dart';

typedef FormatterValidator = StringParseResult Function(StringParseResult input);

abstract class FormatterValidatorChain<T, K> {
  final List<FormatterValidator> steps;

  FormatterValidatorChain(this.steps);

  K run(T inputValue);

  String? getError(T inputValue);
}

class FormatterValidatorChainEarlyStop extends FormatterValidatorChain<String, StringParseResult> {
  FormatterValidatorChainEarlyStop(super.steps);

  StringParseResult run(String inputString) {
    StringParseResult result = StringParseResult.transient('');

    for (FormatterValidator step in steps) {
      result = step(result);
      if (!result.isStringValid) {
        return result;
      }
    }
    return result;
  }

  @override
  String? getError(inputValue) {
    StringParseResult result = run(inputValue);
    return result.errorMessage;
  }
}

class FormatterValidatorChainFullRun extends FormatterValidatorChain<String, StringParseResult> {
  FormatterValidatorChainFullRun(super.steps);

  StringParseResult run(String inputString) {
    var result = StringParseResult.transient(inputString);
    for (FormatterValidator step in steps) {
      result = step(result);
      if (!result.isStringValid) break; // stop on first error
    }
    return result;
  }

  @override
  String? getError(String inputValue) {
    StringParseResult result = run(inputValue);
    return result.errorMessage;
  }
}
