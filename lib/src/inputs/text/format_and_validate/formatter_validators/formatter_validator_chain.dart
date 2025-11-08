import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';

typedef FormatterValidator = FieldContent Function(FieldContent input);

abstract class FormatterValidatorChain<I, V extends FieldContent> {
  final List<FormatterValidator> steps;

  FormatterValidatorChain(this.steps);

  V run(I input);
}

class FormatterValidatorChainEarlyStop<I, V extends FieldContent> extends FormatterValidatorChain<I, V> {
  FormatterValidatorChainEarlyStop(super.steps);

  // TODO lock field types accepted as clients of each FormatterValidatorChain

  V run(I input) {
    V result = FieldContent<I, V>.transient(input) as V;

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
    DateTimefieldContent result = run(inputValue);
    return result.error;
  }
}

class FormatterValidatorChainFullRun extends FormatterValidatorChain<String, DateTimefieldContent> {
  FormatterValidatorChainFullRun(super.steps);

  DateTimefieldContent run(String inputString) {
    var result = DateTimefieldContent.transient(inputString);
    for (FormatterValidator step in steps) {
      result = step(result);
      if (!result.isValid) break; // stop on first error
    }
    return result;
  }

  @override
  String? getError(String inputValue) {
    DateTimefieldContent result = run(inputValue);
    return result.error;
  }
}
