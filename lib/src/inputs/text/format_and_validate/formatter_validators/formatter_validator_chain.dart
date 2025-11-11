import 'package:flutter_form_bricks/src/inputs/state/field_content.dart';

abstract class FormatterValidator<I, V> {
  FieldContent<I, V> call(
    FieldContent<I, V> input, [
    String? keyString,
    FormatValidatePayload? payload,
  ]);
}

abstract class FormatterValidatorChain<I, V> {
  final List<FormatterValidator<I, V>> steps;

  FormatterValidatorChain(this.steps);

  FieldContent<I, V> call(I input, String keyString, [FormatValidatePayload? payload]);
}

// TODO lock field types accepted as clients of each FormatterValidatorChain

class FormatterValidatorChainEarlyStop<I, V> extends FormatterValidatorChain<I, V> {
  FormatterValidatorChainEarlyStop(super.steps);

  FieldContent<I, V> call(I inputString, String keyString, [FormatValidatePayload? payload]) {
    FieldContent<I, V> result = FieldContent<I, V>.transient(inputString);

    for (FormatterValidator<I, V> step in steps) {
      result = step.call(result, keyString, payload);
      if (result.isValid != null && result.isValid!) {
        return result;
      }
    }
    return result;
  }
}

class FormatterValidatorChainFullRun<I, V> extends FormatterValidatorChain<I, V> {
  FormatterValidatorChainFullRun(super.steps);

  FieldContent<I, V> call(I inputString, String keyString, [FormatValidatePayload? payload]) {
    FieldContent<I, V> result = FieldContent<I, V>.transient(inputString);

    for (FormatterValidator<I, V> step in steps) {
      result = step(result, keyString, payload);
    }
    return result;
  }
}

typedef DateTimeFormatterValidatorChain = FormatterValidatorChainEarlyStop<String, DateTime>;

abstract class FormatValidatePayload {}
