import 'package:flutter_form_bricks/src/inputs/text/format_and_validate/formatter_validators/input_value_error.dart';

typedef FormatterValidator = InputValueError Function(InputValueError input);

abstract class FormatterValidatorChain<I, V extends InputValueError> {
  final List<FormatterValidator> steps;

  FormatterValidatorChain(this.steps);

  V run(I input);
}

class FormatterValidatorChainEarlyStop<I, V extends InputValueError> extends FormatterValidatorChain<I, V> {
  FormatterValidatorChainEarlyStop(super.steps);

  // TODO lock field types accepted as clients of each FormatterValidatorChain

  V run(I input) {
    V result = InputValueError<I, V>.transient(input) as V;

    for (FormatterValidator step in steps) {
      result = step(result);
      if (result.isValid != null && result.isValid!) {
        return result;
      }
    }
    return result;
  }

  @override
  String? getError(inputValue) {
    DateTimeValueAndError result = run(inputValue);
    return result.error;
  }
}

class FormatterValidatorChainFullRun extends FormatterValidatorChain<String, DateTimeValueAndError> {
  FormatterValidatorChainFullRun(super.steps);

  DateTimeValueAndError run(String inputString) {
    var result = DateTimeValueAndError.transient(inputString);
    for (FormatterValidator step in steps) {
      result = step(result);
      if (!result.isValid) break; // stop on first error
    }
    return result;
  }

  @override
  String? getError(String inputValue) {
    DateTimeValueAndError result = run(inputValue);
    return result.error;
  }
}
