import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/string_parse_result.dart';

// class FormatValidateResult<T> {
//   final T? parsedValue;
//   final String? error;
//   FormatValidateResult({required this.parsedValue, required this.error});
// }

typedef FormatterValidator = DateTimeValueAndError Function(DateTimeValueAndError input);

abstract class FormatterValidatorChain<V> {
  final List<FormatterValidator> steps;

  FormatterValidatorChain(this.steps);

  ValueAndError run(V value);

  String? getError(V value);
}

class FormatterValidatorChainEarlyStop extends FormatterValidatorChain<String, DateTimeValueAndError> {
  FormatterValidatorChainEarlyStop(super.steps);

  // TODO lock field types accepted as clients of each FormatterValidatorChain

  DateTimeValueAndError run(String inputString) {
    DateTimeValueAndError result = DateTimeValueAndError.transient('');

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
    DateTimeValueAndError result = run(inputValue);
    return result.errorMessage;
  }
}

class FormatterValidatorChainFullRun extends FormatterValidatorChain<String, DateTimeValueAndError> {
  FormatterValidatorChainFullRun(super.steps);

  DateTimeValueAndError run(String inputString) {
    var result = DateTimeValueAndError.transient(inputString);
    for (FormatterValidator step in steps) {
      result = step(result);
      if (!result.isStringValid) break; // stop on first error
    }
    return result;
  }

  @override
  String? getError(String inputValue) {
    DateTimeValueAndError result = run(inputValue);
    return result.errorMessage;
  }
}
