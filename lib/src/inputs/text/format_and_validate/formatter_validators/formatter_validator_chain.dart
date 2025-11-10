import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';

typedef FormatterValidator<I, V> = FieldContent<I, V> Function(FieldContent input);

abstract class FormatterValidatorChain<I, V> {
  final List<FormatterValidator<I, V>> steps;

  FormatterValidatorChain(this.steps);

  FieldContent<I, V> run(I input);
}

class FormatterValidatorChainEarlyStop<I, V> extends FormatterValidatorChain<I, V> {
  FormatterValidatorChainEarlyStop(super.steps);

  // TODO lock field types accepted as clients of each FormatterValidatorChain

  FieldContent<I, V> run(I input) {
    FieldContent<I, V> result = FieldContent<I, V>.transient(input);

    for (FormatterValidator<I, V> step in steps) {
      result = step(result);
      if (result.isValid != null && result.isValid!) {
        return result;
      }
    }
    return result;
  }
}

class FormatterValidatorChainFullRun<I, V> extends FormatterValidatorChain<I, V> {
  FormatterValidatorChainFullRun(super.steps);

  FieldContent<I, V> run(I inputString) {
    FieldContent<I, V> result = FieldContent<I, V>.transient(inputString);

    for (FormatterValidator<I, V> step in steps) {
      result = step(result);
    }
    return result;
  }
}
